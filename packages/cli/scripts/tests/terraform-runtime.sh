#!/bin/sh
set -eu
. "$(dirname "$0")/lifecycle-fixture.sh"

fixture_init
trap fixture_cleanup EXIT HUP INT TERM
fixture_ex up --timeout 20 >"$fixture_area/up.out" 2>"$fixture_area/up.err" || {
  cat "$fixture_area/up.err"
  jq '{outcome,stages}' "$fixture_area/up.out" 2>/dev/null || true
  fixture_fail 'supported Terraform preparation cannot complete through startup'
}
jq -e '.operation == "up" and .outcome == "passed"' "$fixture_area/up.out" >/dev/null ||
  fixture_fail 'startup does not expose successful preparation'
[ -f "$fixture_state/namespace.json" ] && [ -f "$fixture_state/quota.json" ] ||
  fixture_fail 'native preparation did not create namespace and quota'

fixture_cleanup
fixture_init
export EX_FIXTURE_EXPECT_CLEAN_ENV=1
export TF_CLI_ARGS='-state=/tmp/foreign-state' TF_CLI_ARGS_init='-backend=false' TF_CLI_ARGS_plan='-destroy' TF_CLI_ARGS_apply='-target=foreign'
export TF_WORKSPACE=foreign TF_DATA_DIR="$fixture_area/foreign-data" TF_VAR_ex_namespace=foreign
export KUBE_HOST=https://foreign.invalid KUBE_TOKEN=fixture-private-token KUBE_CONFIG_PATHS=/tmp/foreign-config
fixture_ex up --timeout 20 >"$fixture_area/up.out" 2>"$fixture_area/up.err" || {
  cat "$fixture_area/up.err"
  fixture_fail 'ambient Terraform/provider options changed the selected runtime'
}
unset EX_FIXTURE_EXPECT_CLEAN_ENV TF_CLI_ARGS TF_CLI_ARGS_init TF_CLI_ARGS_plan TF_CLI_ARGS_apply TF_WORKSPACE TF_DATA_DIR TF_VAR_ex_namespace KUBE_HOST KUBE_TOKEN KUBE_CONFIG_PATHS
jq -e '.outcome == "passed"' "$fixture_area/up.out" >/dev/null || fixture_fail 'sanitized preparation did not succeed'
[ ! -e "$fixture_area/foreign-data" ] || fixture_fail 'ambient state location was used'

fixture_cleanup
fixture_init
export EX_FIXTURE_TERRAFORM_FOREIGN_PLAN=1
if fixture_ex up --timeout 20 >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then
  fixture_fail 'a foreign namespace in the native plan was applied'
fi
unset EX_FIXTURE_TERRAFORM_FOREIGN_PLAN
[ ! -f "$fixture_state/namespace.json" ] || fixture_fail 'rejected plan changed infrastructure'
if grep -E 'terraform .* apply ' "$fixture_state/calls" >/dev/null; then fixture_fail 'rejected plan reached native apply'; fi

fixture_cleanup
fixture_init
export EX_FIXTURE_TERRAFORM_FAIL=plan EX_FIXTURE_TERRAFORM_EXIT=17
if fixture_ex up --timeout 20 >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then
  fixture_fail 'native plan failure was reported as success'
fi
unset EX_FIXTURE_TERRAFORM_FAIL EX_FIXTURE_TERRAFORM_EXIT
jq -e 'any(.stages[]; .stage == "terraform-plan" and .status == "failed" and (.detail | contains("17")))' "$fixture_area/up.out" >/dev/null ||
  fixture_fail 'native plan failure lost its status'
if grep -F 'fixture-private-diagnostic-value' "$fixture_area/up.out" "$fixture_area/up.err" >/dev/null; then fixture_fail 'private native output leaked to the CLI'; fi
[ ! -f "$fixture_state/namespace.json" ] || fixture_fail 'failed plan was applied'

fixture_cleanup
fixture_init
export EX_FIXTURE_TERRAFORM_PARTIAL=1
if fixture_ex up --timeout 20 >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then
  fixture_fail 'partial native apply was reported as complete'
fi
unset EX_FIXTURE_TERRAFORM_PARTIAL
[ -f "$fixture_state/namespace.json" ] && [ ! -f "$fixture_state/quota.json" ] || fixture_fail 'partial infrastructure outcome was not preserved'
[ -s "$fixture_project/.exphere/state/runtimes/demo/terraform.tfstate" ] || fixture_fail 'partial native state was discarded'
if grep -E 'kubectl .* apply ' "$fixture_state/calls" >/dev/null; then fixture_fail 'workloads followed failed preparation'; fi

fixture_cleanup
fixture_init
export EX_FIXTURE_PROVIDER_VERSION=9.9.9
if fixture_ex up --timeout 20 >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then fixture_fail 'an unexpected initialized provider was allowed to mutate'; fi
unset EX_FIXTURE_PROVIDER_VERSION
jq -e 'any(.stages[]; .stage == "terraform-provider" and .status == "failed")' "$fixture_area/up.out" >/dev/null || fixture_fail 'provider version mismatch was not recorded'
if grep -E 'terraform .* (plan|apply) ' "$fixture_state/calls" >/dev/null; then fixture_fail 'provider mismatch reached planning or application'; fi
printf 'Terraform runtime contract: preparation, environment isolation, plan scope, native failure privacy, partial state, and provider selection passed.\n'
