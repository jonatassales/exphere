#!/bin/sh
set -eu
. "$(dirname "$0")/lifecycle-fixture.sh"

composition_fixture() {
  fixture_init
  mkdir -p "$fixture_project/apps/worker" "$fixture_runtime/units/worker/kubernetes/nested"
  jq '.items |= map(.metadata.name = "worker" | if .kind == "Deployment" then .spec.selector.matchLabels.app = "worker" | .spec.template.metadata.labels.app = "worker" else .spec.selector.app = "worker" end)' "$fixture_runtime/units/website/kubernetes/website.json" >"$fixture_runtime/units/worker/kubernetes/nested/worker.json"
  jq '.units.worker = {component:"apps/worker",kubernetes:{manifests:"units/worker/kubernetes"}}' "$fixture_runtime/schema.json" >"$fixture_area/changed.json"
  mv "$fixture_area/changed.json" "$fixture_runtime/schema.json"
}

composition_fixture
trap fixture_cleanup EXIT HUP INT TERM
fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err" || { cat "$fixture_area/up.err"; cat "$fixture_area/up.out"; fixture_fail 'the two-unit nested composition did not start'; }
jq -e '.outcome == "passed" and (.units | length == 2 and all(.status == "ready")) and (.observations.resources | length == 4 and all(.state == "present" and .ownership == "owned"))' "$fixture_area/up.out" >/dev/null || fixture_fail 'successful startup did not account for both units and all four resources'
printf 'Composition contract: two selected units and nested native resources become ready.\n'

fixture_cleanup
composition_fixture
jq '.items[1].spec.selector.app = "website"' "$fixture_runtime/units/worker/kubernetes/nested/worker.json" >"$fixture_area/changed.json"
mv "$fixture_area/changed.json" "$fixture_runtime/units/worker/kubernetes/nested/worker.json"
if fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then fixture_fail 'a Service selector crossing unit ownership was applied'; fi
grep -Fq 'Services must select Deployments in their own unit' "$fixture_area/up.err" || { cat "$fixture_area/up.err"; fixture_fail 'cross-unit Service selection was not explained'; }
if grep -Eq '^terraform .* (init|apply|destroy)|^kubectl .* (apply|delete)' "$fixture_state/calls"; then fixture_fail 'invalid cross-unit selection reached a mutating tool'; fi
printf 'Composition contract: cross-unit selectors are rejected before preparation.\n'

fixture_cleanup
composition_fixture
if EX_FIXTURE_KUBECTL_FAIL='apply --filename' fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then fixture_fail 'failed first-unit application passed startup'; fi
unset EX_FIXTURE_KUBECTL_FAIL
jq -e '.outcome == "failed" and (.units | any(.unit == "website" and .status == "failed")) and (.units | any(.unit == "worker" and .status == "not-attempted"))' "$fixture_area/up.out" >/dev/null || { cat "$fixture_area/up.out"; fixture_fail 'application failure did not preserve failed and not-attempted unit states'; }
printf 'Composition contract: the first application failure stops later units and preserves their disposition.\n'

fixture_cleanup
composition_fixture
printf '%s\n' '{"items":[{"type":"Warning","reason":"FailedCreate","count":1,"message":"pods forbidden: exceeded quota: runtime; sensitive-fixture-token","involvedObject":{"kind":"ReplicaSet","name":"website-rs","uid":"rs-fixture-deployment-website"}}]}' >"$fixture_state/events.json"
if EX_FIXTURE_READY_FAIL=1 fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err"; then fixture_fail 'a native readiness failure passed startup'; fi
unset EX_FIXTURE_READY_FAIL
jq -e '.outcome == "failed" and (.stages | any(.stage == "readiness" and .status == "failed")) and (.observations.events.items | any(.reason == "FailedCreate" and .quotaMentioned == true and .object.kind == "ReplicaSet"))' "$fixture_area/up.out" >/dev/null || { jq '{stages,events:.observations.events}' "$fixture_area/up.out"; fixture_fail 'the quota-related ReplicaSet event disappeared behind the native readiness failure'; }
if grep -Rq 'sensitive-fixture-token' "$fixture_project/.audits/evidence/runs"; then fixture_fail 'quota event observation exposed its raw message'; fi
printf 'Composition contract: quota-related controller events accompany native readiness failures without publishing event messages.\n'

fixture_cleanup
composition_fixture
fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err" || { cat "$fixture_area/up.err"; fixture_fail 'foreign-resource cleanup setup failed'; }
printf '%s\n' '{"items":[{"apiVersion":"v1","kind":"ConfigMap","metadata":{"name":"another-team","namespace":"demo","uid":"foreign-configmap"},"data":{"value":"preserve"}}]}' >"$fixture_state/foreign.json"
if fixture_ex down >"$fixture_area/down.out" 2>"$fixture_area/down.err"; then fixture_fail 'cleanup deleted a namespace with a foreign resource'; fi
jq -e '.outcome == "failed" and .cleanup.complete == false and (.cleanup.remaining | any(.name == "another-team"))' "$fixture_area/down.out" >/dev/null || { jq '{outcome,cleanup,stages}' "$fixture_area/down.out"; fixture_fail 'foreign-resource retention is absent from cleanup inventory'; }
if grep -Eq '^terraform .* -destroy' "$fixture_state/calls"; then fixture_fail 'foreign-resource detection still attempted Terraform destruction'; fi
printf 'Composition contract: a foreign resource prevents destructive namespace fallback.\n'

fixture_cleanup
composition_fixture
fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err" || { cat "$fixture_area/up.err"; fixture_fail 'failed-deletion cleanup setup failed'; }
if EX_FIXTURE_DELETE_FAIL=1 fixture_ex down >"$fixture_area/down.out" 2>"$fixture_area/down.err"; then fixture_fail 'failed workload deletion passed cleanup'; fi
unset EX_FIXTURE_DELETE_FAIL
jq -e '.outcome == "failed" and .cleanup.complete == false and (.cleanup.remaining | length == 4)' "$fixture_area/down.out" >/dev/null || { jq '{outcome,cleanup,stages}' "$fixture_area/down.out"; fixture_fail 'failed workload deletions lack a complete remaining-resource inventory'; }
if grep -Eq '^terraform .* -destroy' "$fixture_state/calls"; then fixture_fail 'failed workload deletion cascaded into namespace destruction'; fi
printf 'Composition contract: failed deletion retains preparation and reports every remaining workload.\n'

fixture_cleanup
composition_fixture
fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err" || { cat "$fixture_area/up.err"; fixture_fail 'replaced-identity cleanup setup failed'; }
jq '.metadata.uid = "replacement-deployment-uid"' "$fixture_state/deployment-website.json" >"$fixture_area/changed.json"
mv "$fixture_area/changed.json" "$fixture_state/deployment-website.json"
if fixture_ex down >"$fixture_area/down.out" 2>"$fixture_area/down.err"; then fixture_fail 'a replaced live UID passed cleanup'; fi
jq -e '.outcome == "failed" and .cleanup.complete == false and (.cleanup.remaining | any(.kind == "Deployment" and .name == "website"))' "$fixture_area/down.out" >/dev/null || { jq '{outcome,cleanup,stages}' "$fixture_area/down.out"; fixture_fail 'the replaced identity was not retained in cleanup inventory'; }
if grep -Fq 'delete --raw=/apis/apps/v1/namespaces/demo/deployments/website' "$fixture_state/calls"; then fixture_fail 'cleanup attempted to delete the replacement deployment'; fi
if grep -Eq '^terraform .* -destroy' "$fixture_state/calls"; then fixture_fail 'replaced workload identity cascaded into namespace destruction'; fi
printf 'Composition contract: ownership labels do not authorize deletion of a replaced UID.\n'
