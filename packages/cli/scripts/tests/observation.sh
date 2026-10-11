#!/bin/sh
set -eu
. "$(dirname "$0")/lifecycle-fixture.sh"
fixture_init
trap fixture_cleanup EXIT HUP INT TERM

# A named kind context must be compared with kind's actual cluster identity.
jq '.clusters[0].cluster."certificate-authority-data" = "dW5yZWxhdGVkLWNh"' "$fixture_state/kubeconfig.json" >"$fixture_area/changed.json"
mv "$fixture_area/changed.json" "$fixture_state/kubeconfig.json"
if fixture_ex inspect >"$fixture_area/inspect.out" 2>"$fixture_area/inspect.err"; then
  fixture_fail 'a matching context name with an unrelated CA passed local proof'
fi
cat "$fixture_area/inspect.out" "$fixture_area/inspect.err" >"$fixture_area/combined.out"
grep -Fq 'server and CA do not match' "$fixture_area/combined.out" || { cat "$fixture_area/combined.out"; fixture_fail 'context identity failure was not explained'; }
if grep -Eq '^terraform .* (init|apply|destroy)|^kubectl .* (apply|delete)|^kind load' "$fixture_state/calls"; then
  fixture_fail 'failed local proof mutated infrastructure'
fi
printf 'Observation contract: a context name cannot stand in for local cluster identity.\n'

fixture_cleanup
fixture_init
mkdir -p "$fixture_project/apps/worker" "$fixture_runtime/units/worker/kubernetes/nested"
cp "$fixture_runtime/units/website/kubernetes/website.json" "$fixture_runtime/units/worker/kubernetes/nested/worker.json"
jq '.units.worker = {component:"apps/worker",kubernetes:{manifests:"units/worker/kubernetes"}}' "$fixture_runtime/schema.json" >"$fixture_area/changed.json"
mv "$fixture_area/changed.json" "$fixture_runtime/schema.json"
if fixture_ex inspect >"$fixture_area/inspect.out" 2>"$fixture_area/inspect.err"; then
  fixture_fail 'two selected units with the same native identity passed inventory'
fi
cat "$fixture_area/inspect.out" "$fixture_area/inspect.err" >"$fixture_area/combined.out"
grep -Fq 'Identities must be unique across units' "$fixture_area/combined.out" || { cat "$fixture_area/combined.out"; fixture_fail 'duplicate resource identities were not explained'; }
printf 'Observation contract: nested files from every selected unit participate in identity checks.\n'

jq '.items |= map(.metadata.name = "worker" | if .kind == "Deployment" then .spec.selector.matchLabels.app = "worker" | .spec.template.metadata.labels.app = "worker" else .spec.selector.app = "worker" end)' "$fixture_runtime/units/worker/kubernetes/nested/worker.json" >"$fixture_area/changed.json"
mv "$fixture_area/changed.json" "$fixture_runtime/units/worker/kubernetes/nested/worker.json"
native_before=$(cksum "$fixture_runtime/units/worker/kubernetes/nested/worker.json")
fixture_ex inspect >"$fixture_area/inspect.out" 2>"$fixture_area/inspect.err" || { cat "$fixture_area/inspect.err"; fixture_fail 'valid nested composition could not be inspected'; }
jq -e '.observations.configured | any(.unit == "worker" and .kind == "Deployment" and .containers[0].resources.requests.cpu == "100m")' "$fixture_area/inspect.out" >/dev/null || fixture_fail 'configured resource limits are absent before the first deployment'
[ "$(cksum "$fixture_runtime/units/worker/kubernetes/nested/worker.json")" = "$native_before" ] || fixture_fail 'inspection rewrote native consumer configuration'
jq -e '(.units | map(.unit) | sort) == ["website","worker"] and (.observations.resources | all(.state == "absent")) and .observations.usage.state == "unavailable"' "$fixture_area/inspect.out" >/dev/null || fixture_fail 'absent workloads or unavailable metrics were not represented truthfully'
printf 'Observation contract: configured limits and all selected absent workloads remain visible before deployment.\n'

jq '.items[0].spec.template.spec.containers[0].env = [{name:"PRIVATE_TOKEN",value:"never-publish-this-fixture-secret"}]' "$fixture_runtime/units/website/kubernetes/website.json" >"$fixture_area/changed.json"
mv "$fixture_area/changed.json" "$fixture_runtime/units/website/kubernetes/website.json"
fixture_ex inspect >"$fixture_area/inspect.out" 2>"$fixture_area/inspect.err" || { cat "$fixture_area/inspect.err"; fixture_fail 'inspection of native environment values failed'; }
if grep -Rq 'never-publish-this-fixture-secret' "$fixture_project/.audits/evidence/runs"; then
  fixture_fail 'native environment values leaked into published observation evidence'
fi
if EX_FIXTURE_KUBECTL_FAIL='get pods' fixture_ex inspect >"$fixture_area/inspect.out" 2>"$fixture_area/inspect.err"; then
  fixture_fail 'failed required pod observation was reported as passed'
fi
jq -e '.outcome == "inconclusive" and .observations.pods.state == "unavailable"' "$fixture_area/inspect.out" >/dev/null || fixture_fail 'a required observation gap did not remain explicit'
printf 'Observation contract: sensitive input stays private and failed required observation stays inconclusive.\n'
