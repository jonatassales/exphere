#!/bin/sh
set -eu
. "$(dirname "$0")/lifecycle-fixture.sh"
fixture_init
trap fixture_cleanup EXIT HUP INT TERM
mkdir "$fixture_runtime/hooks"
cat >"$fixture_runtime/hooks/examine.sh" <<'HOOK'
#!/bin/sh
printf '%s\n' "$EX_RUNTIME_ID" "$PWD" "$EX_PROJECT_ROOT" "$EX_KUBERNETES_CONTEXT" "$EX_KUBERNETES_NAMESPACE" "$EX_HOOK_EFFECTS" "$1" 'private-hook-output'
HOOK
jq '.hooks = {examine:"hooks/examine.sh"}' "$fixture_runtime/schema.json" >"$fixture_area/schema.json"
mv "$fixture_area/schema.json" "$fixture_runtime/schema.json"
fixture_ex run --timeout 15 examine --effects none -- 'a spaced argument' >"$fixture_area/hook.out" 2>"$fixture_area/hook.err" || { cat "$fixture_area/hook.err"; fixture_fail 'explicit declared hook did not run'; }
printf 'demo\n%s\n%s\nkind-pilot\ndemo\nnone\na spaced argument\nprivate-hook-output\n' "$(CDPATH= cd -P "$fixture_runtime" && pwd)" "$(CDPATH= cd -P "$fixture_project" && pwd)" >"$fixture_area/hook.expected"
cmp -s "$fixture_area/hook.out" "$fixture_area/hook.expected" || { diff -u "$fixture_area/hook.expected" "$fixture_area/hook.out"; fixture_fail 'hook context or explicit arguments changed'; }
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/hook.err")
[ -f "$record" ] || fixture_fail 'hook outcome has no operation record'
jq -e '.operation=="run" and .outcome=="passed" and .access.hook=="examine" and .access.effects=="none" and .access.exitCode==0 and .access.argumentCount==1' "$record" >/dev/null || fixture_fail 'hook evidence lost its attributable result'
if grep -R -q 'private-hook-output\|a spaced argument' "$fixture_project/.audits/evidence/runs"; then fixture_fail 'hook output or arguments leaked into retained evidence'; fi
printf 'Access contract: explicit hooks preserve context and arguments without retaining output content.\n'
cat >"$fixture_runtime/hooks/examine.sh" <<'HOOK'
#!/bin/sh
printf 'invoked\n' >"$EX_RUNTIME_DIR/hook-invoked"
exit 7
HOOK
for mode in omitted terraform; do
  if [ "$mode" = omitted ]; then
    if fixture_ex run examine >"$fixture_area/unsupported.out" 2>"$fixture_area/unsupported.err"; then fixture_fail 'a v2 hook ran without a declared effects contract'; fi
  else
    if fixture_ex run examine --effects terraform >"$fixture_area/unsupported.out" 2>"$fixture_area/unsupported.err"; then fixture_fail 'unsupported Terraform hook effects were accepted'; fi
  fi
  [ ! -f "$fixture_runtime/hook-invoked" ] || fixture_fail 'an unsupported hook contract was invoked before rejection'
done
hook_status=0
fixture_ex run examine --effects none >"$fixture_area/failure.out" 2>"$fixture_area/failure.err" || hook_status=$?
[ "$hook_status" -eq 7 ] || fixture_fail 'hook native nonzero exit status was lost'
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/failure.err")
jq -e '.outcome=="failed" and .access.exitCode==7' "$record" >/dev/null || fixture_fail 'hook failure became successful evidence'
cat >"$fixture_runtime/hooks/examine.sh" <<'HOOK'
#!/bin/sh
sleep 10
HOOK
hook_status=0
fixture_ex run --timeout 5 examine --effects none >"$fixture_area/timeout.out" 2>"$fixture_area/timeout.err" || hook_status=$?
[ "$hook_status" -eq 124 ] || fixture_fail 'hook timeout lost its bounded exit status'
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/timeout.err")
jq -e '.outcome=="failed" and .access.timedOut==true' "$record" >/dev/null || fixture_fail 'hook timeout was not recorded'
printf 'Access contract: unsupported effects, native failure and bounded timeout remain explicit.\n'

fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err" || { cat "$fixture_area/up.err"; cat "$fixture_area/up.out"; fixture_fail 'access fixture could not establish owned workloads'; }
# A foreign Pod shares both application and copied owner labels, but its
# ReplicaSet is controlled by another Deployment. A label-based logs request
# can select it; exact verified Pod requests must never return its content.
mv "$fixture_tools/kubectl" "$fixture_tools/kubectl-access-base"
cat >"$fixture_tools/kubectl" <<'TOOL'
#!/bin/sh
fixture_access_base="$(dirname "$0")/kubectl-access-base"
case "$*" in
  *' auth '*) exec "$fixture_access_base" "$@" ;;
  *' get replicasets '*)
    "$fixture_access_base" "$@" | jq '.items += [(.items[0] | .metadata.name="foreign-rs" | .metadata.uid="foreign-rs-uid" | .metadata.ownerReferences=[{kind:"Deployment",uid:"foreign-deployment-uid",controller:true}])]'
    exit $?
    ;;
  *' get pods '*)
    "$fixture_access_base" "$@" | jq '.items += [(.items[0] | .metadata.name="foreign-pod" | .metadata.uid="foreign-pod-uid" | .metadata.ownerReferences=[{kind:"ReplicaSet",uid:"foreign-rs-uid",controller:true}])]'
    exit $?
    ;;
  *' get pod website-pod '*)
    "$fixture_access_base" get pods --output=json >"$EX_FIXTURE_STATE/log-pods.json"
    jq '.items[] | select(.metadata.name=="website-pod")' "$EX_FIXTURE_STATE/log-pods.json" >"$EX_FIXTURE_STATE/log-pod.json"
    if [ -f "$EX_FIXTURE_STATE/replace-pod-before-log" ] || [ -f "$EX_FIXTURE_STATE/log-pod-replaced" ]; then
      jq '.metadata.uid="replacement-pod-uid"' "$EX_FIXTURE_STATE/log-pod.json"
    else
      cat "$EX_FIXTURE_STATE/log-pod.json"
    fi
    exit 0
    ;;
  *' logs '*)
    printf '%s\n' "$*" >>"$EX_FIXTURE_STATE/log-requests"
    case "$*" in
      *' logs pod/website-pod '*)
        if [ -f "$EX_FIXTURE_STATE/replace-pod-during-log" ]; then
          : >"$EX_FIXTURE_STATE/log-pod-replaced"
          printf 'FOREIGN-POD-LOG\n'
        else
          "$fixture_access_base" "$@"
        fi
        ;;
      *) printf 'FOREIGN-POD-LOG\n' ;;
    esac
    exit 0
    ;;
esac
exec "$fixture_access_base" "$@"
TOOL
chmod +x "$fixture_tools/kubectl"
fixture_ex logs website >"$fixture_area/logs.out" 2>"$fixture_area/logs.err" || { cat "$fixture_area/logs.err"; fixture_fail 'owned unit logs were not accessible'; }
grep -Fq 'website fixture ready' "$fixture_area/logs.out" || fixture_fail 'explicit logs omitted native output'
if grep -Fq 'FOREIGN-POD-LOG' "$fixture_area/logs.out"; then fixture_fail 'a foreign Pod sharing application labels was logged'; fi
grep -Fq ' logs pod/website-pod ' "$fixture_state/log-requests" || fixture_fail 'logs did not target an exact verified owned Pod'
if grep -Eq ' logs (deployment/|pod/foreign-pod)' "$fixture_state/log-requests"; then fixture_fail 'logs selected a workload indirectly or selected a foreign Pod'; fi
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/logs.err")
jq -e '.operation=="logs" and .outcome=="passed" and .access.unit=="website" and .access.output=="content-not-retained"' "$record" >/dev/null || fixture_fail 'explicit log access lacks safe evidence'
if grep -R -q 'website fixture ready' "$fixture_project/.audits/evidence/runs"; then fixture_fail 'native log content leaked into retained evidence'; fi
printf 'Access contract: exact owned-Pod logs exclude foreign selector matches and retained records omit native content.\n'
before_log_count=$(wc -l <"$fixture_state/log-requests" | tr -d ' ')
: >"$fixture_state/replace-pod-before-log"
if fixture_ex logs website >"$fixture_area/replaced-pod.out" 2>"$fixture_area/replaced-pod.err"; then fixture_fail 'a Pod replaced after discovery was logged'; fi
[ "$(wc -l <"$fixture_state/log-requests" | tr -d ' ')" -eq "$before_log_count" ] || fixture_fail 'a failed Pod UID recheck still requested logs'
rm "$fixture_state/replace-pod-before-log"
: >"$fixture_state/replace-pod-during-log"
if fixture_ex logs website >"$fixture_area/raced-pod.out" 2>"$fixture_area/raced-pod.err"; then fixture_fail 'a Pod replaced during log collection became successful evidence'; fi
if grep -Fq 'FOREIGN-POD-LOG' "$fixture_area/raced-pod.out"; then fixture_fail 'logs collected during a Pod replacement were emitted before final identity verification'; fi
rm "$fixture_state/replace-pod-during-log" "$fixture_state/log-pod-replaced"
mv "$fixture_tools/kubectl-access-base" "$fixture_tools/kubectl"
printf 'Access contract: Pod UID rechecks prevent requests or output when the selected identity changes.\n'
fixture_ex connect --timeout 10 website 8080 80 >"$fixture_area/connect.out" 2>"$fixture_area/connect.err" || { cat "$fixture_area/connect.err"; fixture_fail 'owned service forwarding was not available'; }
grep -Fq 'port-forward service/website 8080:80 --address=127.0.0.1' "$fixture_state/calls" || fixture_fail 'forwarding did not bind only localhost at the selected service port'
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/connect.err")
jq -e '.operation=="connect" and .outcome=="passed" and .access.address=="127.0.0.1" and .access.localPort==8080 and .access.servicePort==80' "$record" >/dev/null || fixture_fail 'forwarding evidence omitted its explicit endpoint'
before_forward=$(grep -c 'port-forward' "$fixture_state/calls")
if fixture_ex connect website 8080 81 >"$fixture_area/invalid-port.out" 2>"$fixture_area/invalid-port.err"; then fixture_fail 'an undeclared Service port was forwarded'; fi
jq '.metadata.uid="foreign-replacement"' "$fixture_state/service-website.json" >"$fixture_area/replaced.json"
mv "$fixture_area/replaced.json" "$fixture_state/service-website.json"
if fixture_ex connect website 8080 80 >"$fixture_area/foreign.out" 2>"$fixture_area/foreign.err"; then fixture_fail 'a foreign replacement Service was forwarded'; fi
[ "$(grep -c 'port-forward' "$fixture_state/calls")" -eq "$before_forward" ] || fixture_fail 'a refused connection still invoked port forwarding'
jq '.metadata.uid="fixture-service-website"' "$fixture_state/service-website.json" >"$fixture_area/restored.json"
mv "$fixture_area/restored.json" "$fixture_state/service-website.json"
printf 'Access contract: forwarding requires an owned UID and declared port and binds only localhost.\n'
cat >"$fixture_runtime/hooks/examine.sh" <<'HOOK'
#!/bin/sh
set -eu
jq --arg owner "$EX_OWNER_TOKEN" --arg ns "$EX_KUBERNETES_NAMESPACE" '.items[0] | .metadata.namespace=$ns | .metadata.labels["exphere.dev/owner"]=$owner | .spec.template.metadata.labels["exphere.dev/owner"]=$owner | .spec.replicas=2' "$EX_RUNTIME_DIR/units/website/kubernetes/website.json" >"$EX_OPERATION_DIR/.private/hook-workload.json"
kubectl --kubeconfig="$EX_KUBECONFIG" --context="$EX_KUBERNETES_CONTEXT" --namespace="$EX_KUBERNETES_NAMESPACE" apply --filename "$EX_OPERATION_DIR/.private/hook-workload.json"
HOOK
fixture_ex run examine --effects runtime >"$fixture_area/effects.out" 2>"$fixture_area/effects.err" || { cat "$fixture_area/effects.err"; fixture_fail 'a declared owned workload effect was not supported'; }
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/effects.err")
jq -e '.outcome=="passed" and .access.effects=="runtime" and .access.effectAccounting=="reconciled" and (.observations.resources | any(.kind=="Deployment" and .configured.replicas==2))' "$record" >/dev/null || fixture_fail 'owned hook effects were not inspected and correlated'
jq -e '.pending==[] and (.resources | any(.kind=="Deployment" and .uid=="fixture-deployment-website"))' "$fixture_project/.exphere/state/runtimes/demo/ledger.json" >/dev/null || fixture_fail 'hook effects lost recorded identity or left unresolved intents'
fixture_ex down >"$fixture_area/down.out" 2>"$fixture_area/down.err" || { cat "$fixture_area/down.err"; fixture_fail 'owned hook effects could not be explicitly cleaned up'; }
[ ! -f "$fixture_state/deployment-website.json" ] && [ ! -f "$fixture_state/namespace.json" ] || fixture_fail 'hook-owned resources survived explicit cleanup'
printf 'Access contract: declared workload effects retain ownership, inspection and explicit cleanup.\n'
cat >"$fixture_runtime/hooks/examine.sh" <<'HOOK'
#!/bin/sh
head -c 70000 /dev/zero
HOOK
hook_status=0
fixture_ex run examine --effects none >"$fixture_area/noisy.out" 2>"$fixture_area/noisy.err" || hook_status=$?
[ "$hook_status" -eq 125 ] || fixture_fail 'excess hook output was not rejected at its capture boundary'
[ "$(wc -c <"$fixture_area/noisy.out" | tr -d ' ')" -eq 65536 ] || fixture_fail 'hook output exceeded the documented display bound'
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/noisy.err")
jq -e '.outcome=="failed" and .access.stdoutBytes==65536 and .access.exitCode==125' "$record" >/dev/null || fixture_fail 'hook output overflow was not attributable in evidence'
cat >"$fixture_runtime/hooks/examine.sh" <<'HOOK'
#!/bin/sh
head -c 70000 /dev/zero >"$EX_RUNTIME_DIR/consumer-owned-output"
printf 'complete\n'
HOOK
fixture_ex run examine --effects none >"$fixture_area/file-write.out" 2>"$fixture_area/file-write.err" || fixture_fail 'output capture limit incorrectly constrained trusted consumer file writes'
[ "$(wc -c <"$fixture_runtime/consumer-owned-output" | tr -d ' ')" -eq 70000 ] || fixture_fail 'trusted consumer file output was truncated'
printf 'Access contract: captured hook output is bounded without imposing an implicit filesystem sandbox.\n'

cat >"$fixture_runtime/hooks/examine.sh" <<'HOOK'
#!/bin/sh
printf '%s\n' "$$" >"$EX_RUNTIME_DIR/hook-child-pid"
sleep 30
HOOK
env PATH="$fixture_tools:$PATH" KUBECONFIG="$fixture_state/kubeconfig.json" sh "$fixture_entry" --root "$fixture_project" runtime demo run --timeout 20 examine --effects none >"$fixture_area/canceled.out" 2>"$fixture_area/canceled.err" &
access_pid=$!
access_attempt=0
while [ ! -f "$fixture_runtime/hook-child-pid" ] && [ "$access_attempt" -lt 10 ]; do
  access_attempt=$((access_attempt+1))
  sleep 1
done
[ -f "$fixture_runtime/hook-child-pid" ] || { kill -TERM "$access_pid" 2>/dev/null || true; fixture_fail 'cancellation fixture never entered the hook'; }
kill -TERM "$access_pid"
hook_status=0
wait "$access_pid" || hook_status=$?
[ "$hook_status" -eq 130 ] || fixture_fail 'canceled hook did not report interruption'
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/canceled.err")
jq -e '.outcome!="passed" and any(.stages[]; .stage=="cancellation" and .status=="failed")' "$record" >/dev/null || fixture_fail 'cancellation became successful or unattributed evidence'
hook_process_state=$(ps -p "$(cat "$fixture_runtime/hook-child-pid")" -o stat= 2>/dev/null | tr -d ' ' || true)
case "$hook_process_state" in ''|Z*) ;; *) fixture_fail "the harmless owned hook process survived cancellation ($hook_process_state)" ;; esac
printf 'Access contract: cancellation records interruption and stops the owned harmless hook process.\n'

rm "$fixture_runtime/hook-child-pid"
mv "$fixture_project/.audits" "$fixture_area/audits-preserved"
mkdir "$fixture_area/foreign-evidence"
ln -s "$fixture_area/foreign-evidence" "$fixture_project/.audits"
if fixture_ex run examine --effects none >"$fixture_area/evidence.out" 2>"$fixture_area/evidence.err"; then fixture_fail 'hook execution proceeded without a safe mandatory evidence destination'; fi
[ ! -f "$fixture_runtime/hook-child-pid" ] || fixture_fail 'the hook ran before its evidence prerequisite passed'
rm "$fixture_project/.audits"
mv "$fixture_area/audits-preserved" "$fixture_project/.audits"
printf 'Access contract: unavailable mandatory evidence prevents hook invocation.\n'
fixture_ex up >"$fixture_area/effects-up.out" 2>"$fixture_area/effects-up.err" || fixture_fail 'unsupported-effect fixture could not establish owned workloads'
mv "$fixture_tools/kubectl" "$fixture_tools/kubectl-original"
cat >"$fixture_tools/kubectl" <<'TOOL'
#!/bin/sh
case "$*" in
  *' get configmaps '*)
    if [ -f "$EX_FIXTURE_STATE/configmap-unexpected.json" ]; then
      jq '{apiVersion:"v1",kind:"List",items:[.]}' "$EX_FIXTURE_STATE/configmap-unexpected.json"
      exit 0
    fi
    ;;
esac
exec "$(dirname "$0")/kubectl-original" "$@"
TOOL
chmod +x "$fixture_tools/kubectl"
cat >"$fixture_runtime/hooks/examine.sh" <<'HOOK'
#!/bin/sh
set -eu
jq -n --arg owner "$EX_OWNER_TOKEN" --arg ns "$EX_KUBERNETES_NAMESPACE" '{apiVersion:"v1",kind:"ConfigMap",metadata:{name:"unexpected",namespace:$ns,labels:{"exphere.dev/owner":$owner}},data:{value:"fixture"}}' >"$EX_OPERATION_DIR/.private/unsupported-effect.json"
kubectl --kubeconfig="$EX_KUBECONFIG" --context="$EX_KUBERNETES_CONTEXT" --namespace="$EX_KUBERNETES_NAMESPACE" apply --filename "$EX_OPERATION_DIR/.private/unsupported-effect.json"
HOOK
if fixture_ex run examine --effects runtime >"$fixture_area/unsupported-effect.out" 2>"$fixture_area/unsupported-effect.err"; then fixture_fail 'an out-of-contract hook resource effect became successful evidence'; fi
record=$(sed -n 's/^ex: operation record: //p' "$fixture_area/unsupported-effect.err")
jq -e '.outcome=="failed" and .access.effectAccounting=="incomplete-or-unsupported" and any(.access.remaining[]; .kind=="ConfigMap" and .name=="unexpected" and .disposition=="retained-unsupported-or-foreign")' "$record" >/dev/null || fixture_fail 'unsupported hook resource effects were not identified and retained'
if fixture_ex down >"$fixture_area/retained.out" 2>"$fixture_area/retained.err"; then fixture_fail 'cleanup erased an unsupported resource through namespace destruction'; fi
[ -f "$fixture_state/namespace.json" ] && [ -f "$fixture_state/configmap-unexpected.json" ] || fixture_fail 'unsupported hook resources were destroyed implicitly'
printf 'Access contract: unsupported namespace effects fail accounting and remain protected from implicit cleanup.\n'
