#!/bin/sh
set -eu
. "$(dirname "$0")/lifecycle-fixture.sh"
fixture_init
trap fixture_cleanup EXIT HUP INT TERM
fixture_ex up >"$fixture_area/up.json" 2>"$fixture_area/up.err" || fixture_fail 'recovery setup failed'
runtime_state="$fixture_project/.exphere/state/runtimes/demo"
# The external apply succeeded before its caller recorded the resulting UID.
jq --arg run "$(jq -r '.runId' "$fixture_area/up.json")" '.pending=[.resources[]|select(.kind=="Service")|del(.uid)|.run=$run] | .resources |= map(select(.kind!="Service"))' "$runtime_state/ledger.json" >"$fixture_area/ledger.json"
mv "$fixture_area/ledger.json" "$runtime_state/ledger.json"
if fixture_ex down >"$fixture_area/refuse.json" 2>"$fixture_area/refuse.err"; then fixture_fail 'unconfirmed interrupted cleanup ran'; fi
[ -f "$fixture_state/namespace.json" ] || fixture_fail 'refused recovery removed namespace'
fixture_ex down --recover >"$fixture_area/recover.json" 2>"$fixture_area/recover.err" || { cat "$fixture_area/recover.err"; cat "$fixture_area/recover.json"; fixture_fail 'owned interrupted apply could not be recovered'; }
jq -e '.cleanup.complete and .recovery.requested' "$fixture_area/recover.json" >/dev/null || fixture_fail 'recovery evidence absent'
fixture_ex up >"$fixture_area/second.json" 2>"$fixture_area/second.err" || fixture_fail 'next lifecycle failed'
# Rename declarations; cleanup must still see and remove the previous identities.
jq '.items |= map(.metadata.name="renamed")' "$fixture_runtime/units/website/kubernetes/website.json" >"$fixture_area/renamed.json"
mv "$fixture_area/renamed.json" "$fixture_runtime/units/website/kubernetes/website.json"
fixture_ex inspect >"$fixture_area/inspect.json" 2>"$fixture_area/inspect.err" || { cat "$fixture_area/inspect.err"; fixture_fail 'inspection lost previous configuration'; }
jq -e 'any(.observations.resources[]; .name=="website" and .state=="present")' "$fixture_area/inspect.json" >/dev/null || fixture_fail 'old resources absent from inspection'
mkdir "$runtime_state/lock"
printf '%s\n' "$$" >"$runtime_state/lock/pid"
printf '1\n' >"$runtime_state/lock/deadline"
if fixture_ex down --recover >"$fixture_area/locked.json" 2>"$fixture_area/locked.err"; then fixture_fail 'live mutation lock was released'; fi
[ -d "$runtime_state/lock" ] || fixture_fail 'live lock changed'
printf '99999999\n' >"$runtime_state/lock/pid"
fixture_ex down --recover >"$fixture_area/stale.json" 2>"$fixture_area/stale.err" || { cat "$fixture_area/stale.err"; fixture_fail 'expired dead lock could not be recovered'; }
[ ! -f "$fixture_state/namespace.json" ] || fixture_fail 'old resources retained after recovery'

fixture_cleanup
fixture_init
runtime_state="$fixture_project/.exphere/state/runtimes/demo"
export EX_FIXTURE_TERRAFORM_PARTIAL=1
if fixture_ex up >"$fixture_area/partial.json" 2>"$fixture_area/partial.err"; then fixture_fail 'partial preparation was reported as complete'; fi
unset EX_FIXTURE_TERRAFORM_PARTIAL
# Interruption after native state persistence can precede the ledger UID write.
jq '.namespace.uid=null | .baseline=[]' "$runtime_state/ledger.json" >"$fixture_area/ledger.json"
mv "$fixture_area/ledger.json" "$runtime_state/ledger.json"
if fixture_ex down >"$fixture_area/unconfirmed.json" 2>"$fixture_area/unconfirmed.err"; then fixture_fail 'unconfirmed preparation recovery ran'; fi
cp "$runtime_state/terraform.tfstate" "$fixture_area/retained.tfstate"
jq '.resources[0].instances[0].attributes.metadata[0].uid="different-namespace"' "$runtime_state/terraform.tfstate" >"$fixture_area/mismatch.tfstate"
mv "$fixture_area/mismatch.tfstate" "$runtime_state/terraform.tfstate"
if fixture_ex down --recover >"$fixture_area/mismatch.json" 2>"$fixture_area/mismatch.err"; then fixture_fail 'namespace was adopted without a matching native UID'; fi
[ -f "$fixture_state/namespace.json" ] || fixture_fail 'mismatched namespace identity was removed'
cp "$fixture_area/retained.tfstate" "$runtime_state/terraform.tfstate"
jq -n '{items:[{apiVersion:"v1",kind:"ConfigMap",metadata:{name:"kube-root-ca.crt",namespace:"demo",uid:"foreign-ca"},data:{"ca.crt":"foreign data"}}]}' >"$fixture_state/foreign.json"
if fixture_ex down --recover >"$fixture_area/foreign-baseline.json" 2>"$fixture_area/foreign-baseline.err"; then fixture_fail 'default resource name adopted foreign baseline data'; fi
[ -f "$fixture_state/namespace.json" ] || fixture_fail 'foreign baseline data was deleted'
rm "$fixture_state/foreign.json"
printf '{"items":[{"apiVersion":"v1","kind":"ConfigMap","metadata":{"name":"kube-root-ca.crt","namespace":"demo","uid":"default-ca"},"data":{"ca.crt":"fixture-ca"}}]}\n' >"$fixture_state/foreign.json"
# Retry the missing-record boundary with an actual default CA value.
jq '.namespace.uid=null | .baseline=[]' "$runtime_state/ledger.json" >"$fixture_area/ledger.json"
mv "$fixture_area/ledger.json" "$runtime_state/ledger.json"
fixture_ex down --recover >"$fixture_area/preparation.json" 2>"$fixture_area/preparation.err" || { cat "$fixture_area/preparation.err"; fixture_fail 'retained native namespace UID could not recover interrupted preparation'; }
jq -e '.cleanup.complete and .recovery.requested' "$fixture_area/preparation.json" >/dev/null || fixture_fail 'preparation recovery evidence absent'
[ ! -f "$fixture_state/namespace.json" ] || fixture_fail 'recovered preparation namespace remains'

fixture_cleanup
fixture_init
runtime_state="$fixture_project/.exphere/state/runtimes/demo"
export EX_FIXTURE_TERRAFORM_FAIL=plan
if fixture_ex up >"$fixture_area/failed-plan.json" 2>"$fixture_area/failed-plan.err"; then fixture_fail 'failed plan was reported as complete'; fi
unset EX_FIXTURE_TERRAFORM_FAIL
[ ! -f "$runtime_state/terraform.tfstate" ] || fixture_fail 'plan failure unexpectedly created native state'
cp "$fixture_state/calls" "$fixture_area/before-cleanup.calls"
fixture_ex down >"$fixture_area/no-state.json" 2>"$fixture_area/no-state.err" || fixture_fail 'absent namespace with no native state could not be cleaned up'
jq -e '.cleanup.complete' "$fixture_area/no-state.json" >/dev/null || fixture_fail 'no-state cleanup evidence absent'
[ ! -f "$runtime_state/ledger.json" ] && [ ! -f "$runtime_state/terraform-root/main.tf.json" ] && [ ! -f "$runtime_state/terraform-target.json" ] || fixture_fail 'completed no-state cleanup kept preparation frozen'
[ "$(grep -Ec 'terraform .* (init|plan|apply) ' "$fixture_area/before-cleanup.calls")" = "$(grep -Ec 'terraform .* (init|plan|apply) ' "$fixture_state/calls")" ] || fixture_fail 'no-state cleanup invoked native preparation effects'
jq '.resource.kubernetes_resource_quota_v1.runtime.spec.hard.pods="7"' "$fixture_runtime/terraform/main.tf.json" >"$fixture_area/changed-root.json"
mv "$fixture_area/changed-root.json" "$fixture_runtime/terraform/main.tf.json"
fixture_ex up >"$fixture_area/reconfigured.json" 2>"$fixture_area/reconfigured.err" || fixture_fail 'cleaned failed plan prevented preparation of edited configuration'
# External namespace deletion leaves native state stale. Corruption must still
# stop cleanup before a native plan or any ownership evidence is discarded.
cp "$runtime_state/terraform.tfstate" "$runtime_state/terraform.tfstate.backup"
cp "$runtime_state/terraform.tfstate" "$fixture_area/preserved.tfstate"
rm -f "$fixture_state/namespace.json" "$fixture_state/quota.json" "$fixture_state/deployment-website.json" "$fixture_state/service-website.json"
printf '{corrupt-state\n' >"$runtime_state/terraform.tfstate"
cp "$fixture_state/calls" "$fixture_area/before-corruption.calls"
if fixture_ex down >"$fixture_area/corrupt.json" 2>"$fixture_area/corrupt.err"; then fixture_fail 'corrupt native state was treated as completed cleanup'; fi
[ -f "$runtime_state/ledger.json" ] && [ -f "$runtime_state/terraform-root/main.tf.json" ] || fixture_fail 'corrupt-state refusal discarded preparation evidence'
[ "$(grep -Ec 'terraform .* (init|plan|apply) ' "$fixture_area/before-corruption.calls")" = "$(grep -Ec 'terraform .* (init|plan|apply) ' "$fixture_state/calls")" ] || fixture_fail 'corrupt state reached native preparation effects'
cp "$fixture_area/preserved.tfstate" "$runtime_state/terraform.tfstate"
fixture_ex down >"$fixture_area/absent.json" 2>"$fixture_area/absent.err" || { cat "$fixture_area/absent.err"; fixture_fail 'absent namespace left native preparation state unreconciled'; }
jq -e '.cleanup.complete and any(.stages[]; .stage=="terraform-apply" and .status=="passed")' "$fixture_area/absent.json" >/dev/null || fixture_fail 'absent namespace did not reconcile its retained native state'
jq -e '.resources|length==0' "$runtime_state/terraform.tfstate" >/dev/null || fixture_fail 'completed cleanup left stale native state'
cmp -s "$fixture_area/preserved.tfstate" "$runtime_state/terraform.tfstate.backup" || fixture_fail 'cleanup changed a retained native state backup'
[ ! -f "$runtime_state/ledger.json" ] && [ ! -f "$runtime_state/terraform-root/main.tf.json" ] && [ ! -f "$runtime_state/terraform-target.json" ] || fixture_fail 'absent-namespace cleanup kept preparation frozen'
completed_ledger="$runtime_state/completed-ledger-$(jq -r '.runId' "$fixture_area/absent.json").json"
jq -e --arg run "$(jq -r '.runId' "$fixture_area/reconfigured.json")" '.createdByRun==$run and .namespace.uid=="fixture-namespace" and (.resources|length)==2 and .cleanup.complete' "$completed_ledger" >/dev/null || fixture_fail 'completed ledger did not preserve its original resource identities'
printf 'Lifecycle recovery: interrupted apply/preparation, native UID proof, failed-plan reconfiguration, absent namespace reconciliation, corrupt-state refusal, retained history, changed declarations, and lock recovery passed.\n'
