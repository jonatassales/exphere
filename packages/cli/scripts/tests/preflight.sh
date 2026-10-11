#!/bin/sh
set -eu
. "$(dirname "$0")/lifecycle-fixture.sh"
fixture_init
trap fixture_cleanup EXIT HUP INT TERM
fixture_ex inspect >"$fixture_area/inspect.out" 2>"$fixture_area/inspect.err" || {
  cat "$fixture_area/inspect.err"
  fixture_fail 'supported versions and read access cannot be inspected'
}
jq -e '.tools.terraform.observed == "1.16.5" and .tools.kind.observed == "0.33.0" and .tools.kubectl.observed == "1.37.0" and .tools.kubernetes.observed == "1.37.0" and .tools.kubernetesProvider.observed == null' "$fixture_area/inspect.out" >/dev/null ||
  fixture_fail 'inspection does not distinguish observed tool versions from the uninitialized provider'
if grep -E 'terraform .* (init|plan|apply) ' "$fixture_state/calls" >/dev/null; then fixture_fail 'inspection initialized or changed infrastructure'; fi
fixture_cleanup
fixture_init
export EX_FIXTURE_TERRAFORM_VERSION=1.17.0
if fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then fixture_fail 'unsupported Terraform version was allowed to mutate'; fi
unset EX_FIXTURE_TERRAFORM_VERSION
jq -e '.tools.terraform.observed == "1.17.0" and .outcome != "passed"' "$fixture_area/up.out" >/dev/null || fixture_fail 'unsupported observed version was not recorded'
if grep -E 'terraform .* (init|plan|apply) ' "$fixture_state/calls" >/dev/null; then fixture_fail 'unsupported version reached preparation'; fi

fixture_cleanup
fixture_init
export EX_FIXTURE_KUBECTL_FAIL='auth can-i create deployments.apps'
if fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then fixture_fail 'startup ignored denied workload creation access'; fi
unset EX_FIXTURE_KUBECTL_FAIL
jq -e 'any(.stages[]; .stage == "access" and .status == "failed") and .outcome != "passed"' "$fixture_area/up.out" >/dev/null || fixture_fail 'denied access was not recorded'
if grep -E 'terraform .* (init|plan|apply) ' "$fixture_state/calls" >/dev/null; then fixture_fail 'denied access reached preparation'; fi
printf 'Preflight contract: observed versions, read-only inspection, unsupported version, and denied access passed.\n'

fixture_cleanup
fixture_init
jq '.users[0].name="restricted" | .contexts[0].context.user="restricted"' "$fixture_state/kubeconfig.json" >"$fixture_area/restricted.json"
mv "$fixture_area/restricted.json" "$fixture_state/kubeconfig.json"
mv "$fixture_tools/kubectl" "$fixture_tools/kubectl-native"
cat >"$fixture_tools/kubectl" <<'TOOL'
#!/bin/sh
selected=
for argument do case "$argument" in --kubeconfig=*) selected=${argument#--kubeconfig=} ;; esac; done
case "$*" in
  *' auth can-i '*)
    if [ -n "$selected" ] && jq -e '.users[0].name=="restricted"' "$selected" >/dev/null 2>&1; then exit 1; fi ;;
esac
exec "$(dirname "$0")/kubectl-native" "$@"
TOOL
chmod +x "$fixture_tools/kubectl"
if fixture_ex up >"$fixture_area/restricted.out" 2>"$fixture_area/restricted.err"; then fixture_fail 'local proof replaced restricted context credentials with kind admin'; fi
jq -e '.outcome=="failed" and any(.stages[]; .stage=="access" and .status=="failed")' "$fixture_area/restricted.out" >/dev/null || fixture_fail 'selected-credential denial missing from evidence'
[ ! -f "$fixture_state/namespace.json" ] || fixture_fail 'restricted caller mutated infrastructure'
printf 'Preflight contract: local identity proof preserves selected credentials and access denial.\n'

fixture_cleanup
fixture_init
mv "$fixture_tools/docker" "$fixture_tools/docker-native"
cat >"$fixture_tools/docker" <<'TOOL'
#!/bin/sh
case "$*" in exec*images*) printf '{"images":[]}\n'; exit 0 ;; esac
exec "$(dirname "$0")/docker-native" "$@"
TOOL
chmod +x "$fixture_tools/docker"
if fixture_ex inspect >"$fixture_area/images.out" 2>"$fixture_area/images.err"; then fixture_fail 'inspection missed an unavailable preloaded image'; fi
jq -e '.outcome=="failed" and .observations!=null and any(.stages[]; .stage=="images" and .status=="failed")' "$fixture_area/images.out" >/dev/null || fixture_fail 'missing image erased inspection or its failed prerequisite'
fixture_cleanup
fixture_init
printf '{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"demo","uid":"foreign-namespace"}}\n' >"$fixture_state/namespace.json"
if fixture_ex inspect >"$fixture_area/foreign.out" 2>"$fixture_area/foreign.err"; then fixture_fail 'inspection accepted a foreign namespace'; fi
jq -e '.outcome=="failed" and .observations!=null and any(.stages[]; .stage=="ownership" and .status=="failed")' "$fixture_area/foreign.out" >/dev/null || fixture_fail 'namespace ownership conflict missing from inspection'
printf 'Preflight contract: inspection reports missing images and foreign namespaces while preserving observations.\n'
