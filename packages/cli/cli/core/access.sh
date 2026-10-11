#!/bin/sh

ex_access_failure() {
  ex_event access failed "$1" || return 1
  ex_record_update '.outcome="failed"' || return 1
  printf 'ex: %s\n' "$1" >&2
  return 2
}

ex_access_output() {
  ex_access_stdout_bytes=$(wc -c <"$EX_OPERATION_DIR/.private/access.out" | tr -d ' ')
  ex_access_stderr_bytes=$(wc -c <"$EX_OPERATION_DIR/.private/access.err" | tr -d ' ')
  ex_record_update '.access += {exitCode:$status,timedOut:$timeout,stdoutBytes:((.access.stdoutBytes//0)+$stdout),stderrBytes:((.access.stderrBytes//0)+$stderr),output:"content-not-retained",displayLimitBytes:65536}' \
    --argjson status "$ex_access_status" --argjson timeout "$EX_LAST_TIMED_OUT" --argjson stdout "$ex_access_stdout_bytes" --argjson stderr "$ex_access_stderr_bytes" || return 1
  head -c 65536 "$EX_OPERATION_DIR/.private/access.out"
  head -c 65536 "$EX_OPERATION_DIR/.private/access.err" >&2
}

ex_hook_execute() (
  cd "$EX_RUNTIME_DIR" || exit 1
  KUBECONFIG=$EX_KUBECONFIG
  export KUBECONFIG EX_HOOK_EFFECTS
  sh "$@"
)

ex_access_hook() {
  [ "$#" -ge 3 ] || { ex_access_failure 'Usage: run HOOK --effects none|runtime [-- arguments...]'; return 2; }
  ex_access_hook_name=$1
  shift
  ex_valid_id "$ex_access_hook_name" || { ex_access_failure 'Hook name must use lowercase letters, numbers and hyphens.'; return 2; }
  [ "$1" = --effects ] || { ex_access_failure 'Explicit hook effects are required: --effects none or --effects runtime.'; return 2; }
  EX_HOOK_EFFECTS=$2
  shift 2
  case "$EX_HOOK_EFFECTS" in none|runtime) ;; *) ex_access_failure 'Unsupported hook effects. Use none for no resource effects, or runtime for declared owned Deployment/Service effects; Terraform changes are unsupported.'; return 2 ;; esac
  [ "${1:-}" != -- ] || shift
  ex_access_hook_relative=$(jq -er --arg name "$ex_access_hook_name" '.hooks[$name] // empty' "$EX_RUNTIME_SCHEMA") || { ex_access_failure 'The selected hook is not declared in schema.json.'; return 2; }
  ex_access_hook_path=$(ex_resolve_path "$EX_RUNTIME_DIR" "$ex_access_hook_relative") || return 2
  [ -f "$ex_access_hook_path" ] && [ -r "$ex_access_hook_path" ] || { ex_access_failure 'The declared hook must be a readable .sh file.'; return 2; }
  ex_access_hook_hash=$(ex_hash "$ex_access_hook_path") || return 1
  ex_record_update '.access={hook:$hook,hookSha256:$digest,effects:$effects,argumentCount:$arguments,permissions:"trusted-consumer-process; not-sandboxed",effectScope:(if $effects=="runtime" then "declared-owned-Deployment-and-Service-only" else "caller-declared-no-Kubernetes-or-Terraform-effects" end)}' \
    --arg hook "$ex_access_hook_name" --arg digest "$ex_access_hook_hash" --arg effects "$EX_HOOK_EFFECTS" --argjson arguments "$#" || return 1
  if [ "$EX_HOOK_EFFECTS" = runtime ]; then ex_access_runtime_begin || return 1; fi
  ex_event hook started 'Explicit consumer hook invocation; output and argument values are excluded from retained evidence.' || return 1
  : >"$EX_OPERATION_DIR/.private/access.out" || return 1
  : >"$EX_OPERATION_DIR/.private/access.err" || return 1
  EX_CAPTURE_LIMIT=65536
  if ex_bounded "$EX_TIMEOUT" "$EX_OPERATION_DIR/.private/access.out" "$EX_OPERATION_DIR/.private/access.err" ex_hook_execute "$ex_access_hook_path" "$@"; then
    ex_access_status=0
  else
    ex_access_status=$EX_LAST_STATUS
  fi
  EX_CAPTURE_LIMIT=4194304
  ex_access_output || return 1
  ex_access_original_status=$ex_access_status
  if [ "$EX_HOOK_EFFECTS" = runtime ]; then
    if ! ex_access_runtime_finish; then
      [ "$ex_access_original_status" -ne 0 ] || ex_access_original_status=1
    fi
  fi
  if [ "$ex_access_original_status" -eq 0 ]; then
    ex_event hook passed 'Explicit hook completed within its bound; this result does not establish runtime readiness.' || return 1
    ex_record_update '.outcome="passed"' || return 1
  else
    ex_event hook failed 'Explicit hook failed, timed out, or had unsupported/unresolved effects; no automatic rollback was attempted.' || return 1
    ex_record_update '.outcome="failed"' || return 1
  fi
  return "$ex_access_original_status"
}

ex_access_operation() {
  ex_access_operation_name=$1
  shift
  EX_STREAM_OUTPUT=true
  case "$ex_access_operation_name" in
    run) ex_access_hook "$@" ;;
    logs) ex_access_logs "$@" ;;
    connect) ex_access_connect "$@" ;;
    *) ex_access_failure 'Unsupported access operation.' ;;
  esac
}

ex_access_ownership() {
  [ -f "$EX_STATE_DIR/ledger.json" ] || { ex_access_failure 'No owned runtime ledger is available. Complete explicit startup before accessing live resources.'; return 1; }
  ex_previous_evidence && ex_target_matches_ledger || { ex_access_failure 'The recorded target or required startup evidence does not match this runtime.'; return 1; }
  if [ -d "$EX_STATE_DIR/lock" ] && [ "${EX_LOCK_HELD:-false}" != true ]; then
    ex_access_failure 'A runtime mutation is active or unresolved. Inspect it before accessing live resources.'
    return 1
  fi
  ex_check_existing_namespace && [ -s "$EX_OPERATION_DIR/.private/namespace.json" ] || { ex_access_failure 'The recorded owned namespace could not be verified.'; return 1; }
}

ex_access_known_object() {
  ex_access_kind=$1
  ex_access_name=$2
  ex_access_expected_uid=$(jq -er --arg kind "$ex_access_kind" --arg name "$ex_access_name" '[.resources[]|select(.kind==$kind and .name==$name)|.uid] | if length==1 then .[0] else empty end' "$EX_STATE_DIR/ledger.json") || {
    ex_access_failure 'The selected resource has no unambiguous recorded ownership identity.'; return 1;
  }
  ex_query "$EX_OPERATION_DIR/.private/access-current.json" get "$ex_access_kind" "$ex_access_name" --ignore-not-found --output=json || return 1
  [ -s "$EX_OPERATION_DIR/.private/access-current.json" ] && ex_identity_owned "$EX_OPERATION_DIR/.private/access-current.json" "$ex_access_expected_uid" || {
    ex_access_failure 'The selected resource is absent or its ownership/UID changed. Access was refused.'; return 1;
  }
}

ex_access_unit() {
  ex_access_unit=$1
  ex_valid_id "$ex_access_unit" && jq -e --arg unit "$ex_access_unit" '.units|has($unit)' "$EX_RUNTIME_SCHEMA" >/dev/null || {
    ex_access_failure 'Select an existing unit from this runtime descriptor.'; return 2;
  }
}

ex_access_log_pod_matches() {
  ex_query "$EX_OPERATION_DIR/.private/access-pod.json" get pod "$ex_access_pod_name" --ignore-not-found --output=json || return 1
  [ -s "$EX_OPERATION_DIR/.private/access-pod.json" ] && jq -e --arg name "$ex_access_pod_name" --arg uid "$ex_access_pod_uid" --arg replica "$ex_access_pod_controller" --arg owner "$EX_OWNER_TOKEN" --arg namespace "$EX_KUBERNETES_NAMESPACE" '
    .apiVersion=="v1" and .kind=="Pod" and .metadata.name==$name and .metadata.uid==$uid
    and .metadata.namespace==$namespace and .metadata.labels["exphere.dev/owner"]==$owner
    and ([.metadata.ownerReferences[]? | select(.controller==true)] | length==1 and .[0].kind=="ReplicaSet" and .[0].uid==$replica)
  ' "$EX_OPERATION_DIR/.private/access-pod.json" >/dev/null || {
    ex_access_failure 'The selected Pod ownership, controller or UID changed. Log output was withheld.'; return 1;
  }
}

ex_access_logs() {
  [ "$#" -eq 1 ] || { ex_access_failure 'Usage: logs UNIT'; return 2; }
  ex_access_unit "$1" && ex_access_ownership || return 1
  ex_record_update '.access={unit:$unit,output:"content-not-retained",tailLines:100,limitBytesPerPod:65536}' --arg unit "$ex_access_unit" || return 1
  jq -r --arg unit "$ex_access_unit" '.[]|select(.unit==$unit and .kind=="Deployment")|.name' "$EX_OPERATION_DIR/.private/desired.json" >"$EX_OPERATION_DIR/.private/access-deployments" || return 1
  [ -s "$EX_OPERATION_DIR/.private/access-deployments" ] || { ex_access_failure 'The selected unit has no supported Deployment.'; return 2; }
  while IFS= read -r ex_access_deployment; do
    ex_access_known_object Deployment "$ex_access_deployment" || return 1
    ex_query "$EX_OPERATION_DIR/.private/access-replicasets.json" get replicasets --selector="exphere.dev/owner=$EX_OWNER_TOKEN" --output=json || return 1
    ex_query "$EX_OPERATION_DIR/.private/access-pods.json" get pods --selector="exphere.dev/owner=$EX_OWNER_TOKEN" --output=json || return 1
    jq -c --arg deployment "$ex_access_expected_uid" --arg owner "$EX_OWNER_TOKEN" --arg namespace "$EX_KUBERNETES_NAMESPACE" --slurpfile replicasets "$EX_OPERATION_DIR/.private/access-replicasets.json" '
      [$replicasets[0].items[]
        | select(.kind=="ReplicaSet" and .metadata.labels["exphere.dev/owner"]==$owner)
        | select([.metadata.ownerReferences[]? | select(.controller==true)] | length==1 and .[0].kind=="Deployment" and .[0].uid==$deployment)
        | .metadata.uid | select(type=="string" and length>0)] as $replicas
      | .items[] | select(.apiVersion=="v1" and .kind=="Pod" and .metadata.namespace==$namespace and .metadata.labels["exphere.dev/owner"]==$owner)
      | [.metadata.ownerReferences[]? | select(.controller==true)] as $controllers
      | select(($controllers | length)==1 and $controllers[0].kind=="ReplicaSet" and ($controllers[0].uid as $uid | $replicas | index($uid)))
      | {name:.metadata.name,uid:.metadata.uid,controller:$controllers[0].uid}
      | select((.name | type=="string" and test("^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$")) and (.uid | type=="string" and length>0))
    ' "$EX_OPERATION_DIR/.private/access-pods.json" >"$EX_OPERATION_DIR/.private/access-owned-pods" || return 1
    [ -s "$EX_OPERATION_DIR/.private/access-owned-pods" ] || { ex_access_failure 'No Pod has a verified controller chain to the recorded owned Deployment.'; return 1; }
    while IFS= read -r ex_access_pod; do
      ex_access_pod_name=$(printf '%s\n' "$ex_access_pod" | jq -r '.name') || return 1
      ex_access_pod_uid=$(printf '%s\n' "$ex_access_pod" | jq -r '.uid') || return 1
      ex_access_pod_controller=$(printf '%s\n' "$ex_access_pod" | jq -r '.controller') || return 1
      ex_access_log_pod_matches || return 1
      : >"$EX_OPERATION_DIR/.private/access.out" || return 1
      : >"$EX_OPERATION_DIR/.private/access.err" || return 1
      EX_CAPTURE_LIMIT=65536
      if ex_bounded "$EX_TIMEOUT" "$EX_OPERATION_DIR/.private/access.out" "$EX_OPERATION_DIR/.private/access.err" ex_kubectl logs "pod/$ex_access_pod_name" --all-containers=true --tail=100 --limit-bytes=65536 --prefix=true --timestamps=true; then
        ex_access_status=0
      else
        ex_access_status=$EX_LAST_STATUS
      fi
      EX_CAPTURE_LIMIT=4194304
      ex_access_log_timed_out=$EX_LAST_TIMED_OUT
      # Log requests address Pod names. Withhold buffered content if that name
      # was replaced while the request was running.
      ex_access_log_pod_matches || return 1
      EX_LAST_TIMED_OUT=$ex_access_log_timed_out
      ex_access_output || return 1
      if [ "$ex_access_status" -ne 0 ]; then
        ex_event logs failed 'Owned Pod logs could not be collected within the operation bound.' || return 1
        ex_record_update '.outcome="failed"' || return 1
        return "$ex_access_status"
      fi
    done <"$EX_OPERATION_DIR/.private/access-owned-pods"
  done <"$EX_OPERATION_DIR/.private/access-deployments"
  ex_event logs passed 'Bounded owned-unit logs were returned to the caller; native content was not retained.' || return 1
  ex_record_update '.outcome="passed"'
}

ex_access_connect() {
  [ "$#" -eq 3 ] || { ex_access_failure 'Usage: connect UNIT LOCAL_PORT SERVICE_PORT'; return 2; }
  ex_access_unit "$1" && ex_access_ownership || return 1
  ex_access_local_port=$2
  ex_access_service_port=$3
  for ex_access_port in "$ex_access_local_port" "$ex_access_service_port"; do
    case "$ex_access_port" in ''|0*|*[!0-9]*) ex_access_failure 'Ports must be decimal integers from 1 through 65535.'; return 2 ;; esac
    [ "$ex_access_port" -ge 1 ] && [ "$ex_access_port" -le 65535 ] || { ex_access_failure 'Ports must be integers from 1 through 65535.'; return 2; }
  done
  jq --arg unit "$ex_access_unit" --argjson port "$ex_access_service_port" '[.[]|select(.unit==$unit and .kind=="Service" and any(.manifest.spec.ports[]; .port==$port and (.protocol//"TCP")=="TCP"))]' "$EX_OPERATION_DIR/.private/desired.json" >"$EX_OPERATION_DIR/.private/access-services.json" || return 1
  jq -e 'length==1' "$EX_OPERATION_DIR/.private/access-services.json" >/dev/null || {
    ex_access_failure 'Select a declared TCP Service port that identifies exactly one Service in this unit.'; return 2;
  }
  ex_access_service=$(jq -r '.[0].name' "$EX_OPERATION_DIR/.private/access-services.json")
  ex_access_known_object Service "$ex_access_service" || return 1
  jq -e --arg owner "$EX_OWNER_TOKEN" --argjson port "$ex_access_service_port" --slurpfile desired "$EX_OPERATION_DIR/.private/access-services.json" '
    .spec.selector==$desired[0][0].manifest.spec.selector and .spec.selector["exphere.dev/owner"]==$owner
    and any(.spec.ports[]; .port==$port and (.protocol//"TCP")=="TCP")
  ' "$EX_OPERATION_DIR/.private/access-current.json" >/dev/null || {
    ex_access_failure 'The live Service selector or port differs from the declared owned endpoint.'; return 1;
  }
  ex_record_update '.access={unit:$unit,service:$service,address:"127.0.0.1",localPort:$local,servicePort:$port,output:"streamed-to-caller; content-not-retained",outputBytes:"not-measured"}' \
    --arg unit "$ex_access_unit" --arg service "$ex_access_service" --argjson local "$ex_access_local_port" --argjson port "$ex_access_service_port" || return 1
  ex_event connect started 'Bounded forwarding of a recorded owned Service to the explicit localhost port.' || return 1
  exec 3>&1 4>&2
  if ex_bounded "$EX_TIMEOUT" "$EX_OPERATION_DIR/.private/connect.out" "$EX_OPERATION_DIR/.private/connect.err" ex_access_forward port-forward "service/$ex_access_service" "$ex_access_local_port:$ex_access_service_port" --address=127.0.0.1; then
    ex_access_status=0
  else
    ex_access_status=$EX_LAST_STATUS
  fi
  exec 3>&- 4>&-
  ex_record_update '.access += {exitCode:$status,timedOut:$timeout} | .outcome=(if $status==0 then "passed" else "failed" end)' --argjson status "$ex_access_status" --argjson timeout "$EX_LAST_TIMED_OUT" || return 1
  if [ "$ex_access_status" -eq 0 ]; then
    ex_event connect passed 'The foreground forwarding process ended successfully; no background connection was retained.' || return 1
  else
    ex_event connect failed 'Forwarding failed or reached its bound; no background connection is claimed.' || return 1
  fi
  return "$ex_access_status"
}

ex_access_forward() {
  ex_kubectl "$@" >&3 2>&4
}

ex_access_runtime_begin() {
  ex_access_ownership || return 1
  ex_lock_runtime || return 1
  ex_access_ownership || return 1
  ex_reconcile_pending || { ex_access_failure 'Previous resource mutation intents could not be reconciled before the hook.'; return 1; }
  jq -c '.[]|del(.manifest)' "$EX_OPERATION_DIR/.private/desired.json" >"$EX_OPERATION_DIR/.private/hook-intents" || return 1
  while IFS= read -r ex_hook_intent; do
    ex_hook_kind=$(printf '%s\n' "$ex_hook_intent" | jq -r '.kind')
    ex_hook_name=$(printf '%s\n' "$ex_hook_intent" | jq -r '.name')
    ex_query "$EX_OPERATION_DIR/.private/hook-current.json" get "$ex_hook_kind" "$ex_hook_name" --ignore-not-found --output=json || return 1
    ex_hook_previous_uid=$(jq -r --arg kind "$ex_hook_kind" --arg name "$ex_hook_name" '[.resources[]|select(.kind==$kind and .name==$name)|.uid][0]//empty' "$EX_STATE_DIR/ledger.json") || return 1
    if [ -s "$EX_OPERATION_DIR/.private/hook-current.json" ]; then
      [ -n "$ex_hook_previous_uid" ] && ex_identity_owned "$EX_OPERATION_DIR/.private/hook-current.json" "$ex_hook_previous_uid" || {
        ex_access_failure 'A declared workload has no matching recorded UID; hooks cannot adopt or replace it.'; return 1;
      }
    elif [ -n "$ex_hook_previous_uid" ]; then
      ex_access_failure 'A recorded workload is absent. Inspect and explicitly clean up its stale identity before running a mutating hook.'
      return 1
    fi
  done <"$EX_OPERATION_DIR/.private/hook-intents"
  ex_access_namespace_effects || return 1
  ex_ledger_update '.pending = ((.pending + [$desired[0][]|del(.manifest)|.run=$run]) | unique_by([.kind,.name]))' --slurpfile desired "$EX_OPERATION_DIR/.private/desired.json" --arg run "$EX_RUN_ID" || return 1
  ex_event hook-effects prepared 'Intent for the declared Deployment/Service set was recorded before trusted hook execution; Terraform and arbitrary resource effects remain unsupported.'
}

ex_access_namespace_effects() {
  ex_namespace_inventory || { ex_access_failure 'Namespace effects could not be fully inventoried; resources are retained.'; return 1; }
  jq --arg owner "$EX_OWNER_TOKEN" --slurpfile ledger "$EX_STATE_DIR/ledger.json" '
    . as $all
    | [$ledger[0].resources[] | select(.kind=="Deployment") | .uid] as $deployments
    | [$all[] | select(.kind=="ReplicaSet" and .metadata.labels["exphere.dev/owner"]==$owner)
        | select(any(.metadata.ownerReferences[]?; .controller==true and .kind=="Deployment" and (.uid as $uid | $deployments | index($uid)))) | .metadata.uid] as $replicasets
    | [$all[] | select(.kind=="Pod" and .metadata.labels["exphere.dev/owner"]==$owner)
        | select(any(.metadata.ownerReferences[]?; .controller==true and .kind=="ReplicaSet" and (.uid as $uid | $replicasets | index($uid)))) | .metadata.uid] as $pods
    | (($ledger[0].observedUids//[]) + [$ledger[0].resources[].uid,$ledger[0].baseline[].uid,$ledger[0].namespace.uid] + $replicasets + $pods | map(select(.!=null)) | unique) as $eventUids
    | [.[] | . as $resource
        | select((any($ledger[0].baseline[]; .uid==$resource.metadata.uid and .kind==$resource.kind and .name==$resource.metadata.name and .body==($resource|del(.metadata.resourceVersion,.metadata.managedFields,.status)))) | not)
        | select((any($ledger[0].resources[]; .uid==$resource.metadata.uid and .kind==$resource.kind and .name==$resource.metadata.name) and .metadata.labels["exphere.dev/owner"]==$owner) | not)
        | select((.kind=="ReplicaSet" and (.metadata.uid as $uid | $replicasets | index($uid))) | not)
        | select((.kind=="Pod" and .metadata.labels["exphere.dev/owner"]==$owner and any(.metadata.ownerReferences[]?; .controller==true and .kind=="ReplicaSet" and (.uid as $uid | $replicasets | index($uid)))) | not)
        | select((.kind=="Event" and ((.involvedObject.uid//.regarding.uid) as $uid | $eventUids | index($uid))) | not)
        | {kind,name:.metadata.name,uid:.metadata.uid,disposition:"retained-unsupported-or-foreign"}]
  ' "$EX_OPERATION_DIR/.private/namespace-all.json" >"$EX_OPERATION_DIR/.private/hook-remaining.json" || return 1
  ex_record_update '.access.remaining=$remaining[0]' --slurpfile remaining "$EX_OPERATION_DIR/.private/hook-remaining.json" || return 1
  if ! jq -e 'length==0' "$EX_OPERATION_DIR/.private/hook-remaining.json" >/dev/null; then
    ex_access_failure 'Unexpected, changed preparation, or foreign namespace resources are retained; hook effects are outside the supported workload set.'
    return 1
  fi
}

ex_access_runtime_finish() {
  ex_hook_accounting_status=0
  if ! ex_reconcile_pending; then
    ex_hook_accounting_status=1
    ex_event hook-effects failed 'Declared hook effects remain pending or a recorded UID changed; retain resources for explicit inspection and cleanup.' || return 1
  fi
  if ! ex_access_namespace_effects; then ex_hook_accounting_status=1; fi
  if ex_observe_inventory "$EX_OPERATION_DIR/.private/desired.json" "$EX_OPERATION_DIR/observations.json"; then
    ex_record_update '.observations=$observations[0]' --slurpfile observations "$EX_OPERATION_DIR/observations.json" || return 1
    ex_ledger_update '.observedUids=((.observedUids//[])+[$observations[0].resources[].uid,$observations[0].pods.items[].uid]|map(select(.!=null))|unique)' --slurpfile observations "$EX_OPERATION_DIR/observations.json" || return 1
  else
    ex_hook_accounting_status=1
    [ ! -f "$EX_OPERATION_DIR/observations.json" ] || ex_record_update '.observations=$observations[0]' --slurpfile observations "$EX_OPERATION_DIR/observations.json" || return 1
  fi
  if [ "$ex_hook_accounting_status" -eq 0 ]; then
    ex_record_update '.access.effectAccounting="reconciled"' || return 1
    ex_event hook-effects passed 'Declared workload effects were reconciled and inspected; only recorded owned identities are eligible for later explicit cleanup.' || return 1
  else
    ex_record_update '.access.effectAccounting="incomplete-or-unsupported"' || return 1
  fi
  return "$ex_hook_accounting_status"
}
