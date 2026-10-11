#!/bin/sh
ex_resource_status() {
  ex_resource_unit=$1; ex_resource_state=$2
  ex_record_update '.units |= map(if .unit==$unit then .status=$status else . end)' --arg unit "$ex_resource_unit" --arg status "$ex_resource_state"
}
ex_ledger_update() {
  ex_ledger_filter=$1; shift
  jq "$@" "$ex_ledger_filter" "$EX_STATE_DIR/ledger.json" >"$EX_STATE_DIR/ledger.next" && mv "$EX_STATE_DIR/ledger.next" "$EX_STATE_DIR/ledger.json"
}
ex_identity_owned() {
  ex_identity_file=$1; ex_identity_uid=${2:-}
  jq -e --arg owner "$EX_OWNER_TOKEN" --arg uid "$ex_identity_uid" '.metadata.labels["exphere.dev/owner"]==$owner and (.metadata.uid | type=="string" and length>0) and ($uid=="" or .metadata.uid==$uid)' "$ex_identity_file" >/dev/null 2>&1
}
ex_current_namespace() { ex_query "$EX_OPERATION_DIR/.private/namespace.json" get namespace "$EX_KUBERNETES_NAMESPACE" --ignore-not-found --output=json; }
ex_check_existing_namespace() {
  ex_current_namespace || return 1
  if [ ! -s "$EX_OPERATION_DIR/.private/namespace.json" ]; then return 0; fi
  [ -f "$EX_STATE_DIR/ledger.json" ] || { ex_event ownership failed 'Namespace already exists without this runtime ownership record.'; return 1; }
  ex_expected_namespace_uid=$(jq -r '.namespace.uid // empty' "$EX_STATE_DIR/ledger.json")
  [ -n "$ex_expected_namespace_uid" ] && ex_identity_owned "$EX_OPERATION_DIR/.private/namespace.json" "$ex_expected_namespace_uid" || { ex_event ownership failed 'Namespace identity or ownership changed; adoption is not automatic.'; return 1; }
}
ex_target_matches_ledger() {
  [ ! -f "$EX_STATE_DIR/ledger.json" ] || jq -en --slurpfile ledger "$EX_STATE_DIR/ledger.json" --slurpfile target "$EX_OPERATION_DIR/target.json" --arg ns "$EX_KUBERNETES_NAMESPACE" '$ledger[0].target==$target[0] and $ledger[0].namespace.name==$ns' >/dev/null
}
ex_start_ledger() {
  if [ ! -f "$EX_STATE_DIR/ledger.json" ]; then
    jq -n --slurpfile target "$EX_OPERATION_DIR/target.json" --arg ns "$EX_KUBERNETES_NAMESPACE" --arg run "$EX_RUN_ID" '{target:$target[0],createdByRun:$run,namespace:{name:$ns,uid:null},resources:[],baseline:[],pending:[]}' >"$EX_STATE_DIR/ledger.json"
  fi
}
ex_capture_preparation() {
  ex_current_namespace && [ -s "$EX_OPERATION_DIR/.private/namespace.json" ] && ex_identity_owned "$EX_OPERATION_DIR/.private/namespace.json" || return 1
  ex_namespace_uid=$(jq -r '.metadata.uid' "$EX_OPERATION_DIR/.private/namespace.json")
  ex_ledger_update '.namespace.uid=$uid' --arg uid "$ex_namespace_uid" || return 1
  : >"$EX_OPERATION_DIR/.private/baseline.ndjson"
  for ex_baseline_resource in serviceaccounts configmaps resourcequotas; do
    ex_query "$EX_OPERATION_DIR/.private/baseline.json" get "$ex_baseline_resource" --output=json || return 1
    jq -c '.items[]?' "$EX_OPERATION_DIR/.private/baseline.json" >>"$EX_OPERATION_DIR/.private/baseline.ndjson"
  done
  jq -s --arg owner "$EX_OWNER_TOKEN" '[.[] | select((.kind=="ServiceAccount" and .metadata.name=="default" and ((.secrets//[])|length)==0 and ((.imagePullSecrets//[])|length)==0) or (.kind=="ConfigMap" and .metadata.name=="kube-root-ca.crt" and (.data|keys)==["ca.crt"]) or (.kind=="ResourceQuota" and .metadata.labels["exphere.dev/owner"]==$owner)) | {kind,name:.metadata.name,uid:.metadata.uid,body:(del(.metadata.resourceVersion,.metadata.managedFields,.status))}]' "$EX_OPERATION_DIR/.private/baseline.ndjson" >"$EX_OPERATION_DIR/.private/baseline-array.json" || return 1
  ex_ledger_update 'if (.baseline|length)==0 then .baseline=$baseline[0] else . end' --slurpfile baseline "$EX_OPERATION_DIR/.private/baseline-array.json"
}
ex_images_available() {
  ex_bounded 15 "$EX_OPERATION_DIR/.private/nodes" "$EX_OPERATION_DIR/.private/image.err" env KIND_EXPERIMENTAL_PROVIDER=docker kind get nodes --name "$EX_KIND_CLUSTER" || return 1
  [ -s "$EX_OPERATION_DIR/.private/nodes" ] || return 1
  jq -r '[.[]|select(.kind=="Deployment")|(.manifest.spec.template.spec.containers[],.manifest.spec.template.spec.initContainers[]?)|.image]|unique[]' "$EX_OPERATION_DIR/.private/desired.json" >"$EX_OPERATION_DIR/.private/images"
  while IFS= read -r ex_image_node; do
    ex_bounded 15 "$EX_OPERATION_DIR/.private/images.json" "$EX_OPERATION_DIR/.private/image.err" docker exec "$ex_image_node" crictl images --output json || return 1
    while IFS= read -r ex_image; do
      jq -e --arg image "$ex_image" '
        def canonical:
          (if (split("/")|length)==1 then "docker.io/library/"+.
           elif (split("/")[0]|test("[.:]") or .=="localhost") then . else "docker.io/"+. end)
          | if (contains("@") or (split("/")[-1]|contains(":"))) then . else .+":latest" end;
        ($image|canonical) as $wanted | any(.images[]?; any((.repoTags[]?,.repoDigests[]?); canonical==$wanted))
      ' "$EX_OPERATION_DIR/.private/images.json" >/dev/null || { ex_event images failed 'A prebuilt image is not loaded on every selected kind node. Load it explicitly with kind before startup.'; return 1; }
    done <"$EX_OPERATION_DIR/.private/images"
  done <"$EX_OPERATION_DIR/.private/nodes"
  ex_event images passed 'Every declared image was found on all selected kind nodes.'
}
ex_prepare_workload() {
  ex_workload_item=$1
  printf '%s\n' "$ex_workload_item" >"$EX_OPERATION_DIR/.private/item.json"
  ex_workload_kind=$(jq -r '.kind' "$EX_OPERATION_DIR/.private/item.json")
  ex_workload_name=$(jq -r '.name' "$EX_OPERATION_DIR/.private/item.json")
  ex_workload_unit=$(jq -r '.unit' "$EX_OPERATION_DIR/.private/item.json")
  ex_resource_status "$ex_workload_unit" applying
  ex_query "$EX_OPERATION_DIR/.private/current.json" get "$ex_workload_kind" "$ex_workload_name" --ignore-not-found --output=json || return 1
  if [ -s "$EX_OPERATION_DIR/.private/current.json" ]; then
    ex_workload_uid=$(jq -r --arg kind "$ex_workload_kind" --arg name "$ex_workload_name" '[.resources[]|select(.kind==$kind and .name==$name)|.uid][0] // empty' "$EX_STATE_DIR/ledger.json")
    [ -n "$ex_workload_uid" ] && ex_identity_owned "$EX_OPERATION_DIR/.private/current.json" "$ex_workload_uid" || { ex_event ownership failed 'An existing workload cannot be adopted or replaced without recorded ownership.'; return 1; }
  fi
  ex_event apply pending "Recorded mutation intent for $ex_workload_kind/$ex_workload_name in unit $ex_workload_unit." || return 1
  ex_ledger_update '.pending += [$item[0] | del(.manifest) | .run=$run] | .pending |= unique_by([.kind,.name])' --arg run "$EX_RUN_ID" --slurpfile item "$EX_OPERATION_DIR/.private/item.json" || return 1
  jq '.manifest' "$EX_OPERATION_DIR/.private/item.json" >"$EX_OPERATION_DIR/.private/apply.json"
  if ! ex_query "$EX_OPERATION_DIR/.private/apply.out" apply --filename "$EX_OPERATION_DIR/.private/apply.json"; then
    ex_resource_status "$ex_workload_unit" failed
    ex_event apply failed 'Workload application failed; mutation intent was retained for inspection and cleanup.'
    return 1
  fi
  ex_query "$EX_OPERATION_DIR/.private/current.json" get "$ex_workload_kind" "$ex_workload_name" --ignore-not-found --output=json || return 1
  ex_identity_owned "$EX_OPERATION_DIR/.private/current.json" || return 1
  ex_workload_uid=$(jq -r '.metadata.uid' "$EX_OPERATION_DIR/.private/current.json")
  ex_ledger_update '.resources = ([.resources[]|select(.kind!=$kind or .name!=$name)] + [$item[0] | del(.manifest) | .uid=$uid | .generation=$current[0].metadata.generation]) | .observedUids=((.observedUids//[])+[$uid]|unique) | .pending |= map(select(.kind!=$kind or .name!=$name))' --arg kind "$ex_workload_kind" --arg name "$ex_workload_name" --arg uid "$ex_workload_uid" --slurpfile item "$EX_OPERATION_DIR/.private/item.json" --slurpfile current "$EX_OPERATION_DIR/.private/current.json"
}
ex_workloads_up() {
  ex_target_matches_ledger || { ex_event ownership failed 'Recorded target differs from the current local target; automatic retargeting is unsupported.'; return 1; }
  ex_check_existing_namespace || return 1
  ex_images_available || return 1
  ex_start_ledger || return 1
  cp "$EX_OPERATION_DIR/.private/desired.json" "$EX_STATE_DIR/desired.json"
  if ! ex_terraform_prepare; then
    ex_capture_preparation || true
    ex_event prepare failed 'Terraform preparation failed; workloads were not applied and partial state was retained.'
    return 1
  fi
  ex_capture_preparation || { ex_event prepare failed 'Cannot record prepared namespace identity and baseline resources.'; return 1; }
  ex_event prepare passed 'Runtime namespace and quotas prepared; identities captured.'
  jq -c 'sort_by(.unit, (if .kind=="Deployment" then 0 else 1 end),.name)[]' "$EX_OPERATION_DIR/.private/desired.json" >"$EX_OPERATION_DIR/.private/apply-items"
  while IFS= read -r ex_up_item; do
    ex_prepare_workload "$ex_up_item" || return 1
    ex_resource_status "$(printf '%s' "$ex_up_item" | jq -r '.unit')" applied
  done <"$EX_OPERATION_DIR/.private/apply-items"
  jq -r '.[]|select(.kind=="Deployment")|[.unit,.name]|@tsv' "$EX_OPERATION_DIR/.private/desired.json" >"$EX_OPERATION_DIR/.private/deployments"
  while IFS="$(printf '\t')" read -r ex_ready_unit ex_ready_name; do
    if ! ex_query "$EX_OPERATION_DIR/.private/readiness.out" rollout status "deployment/$ex_ready_name" "--timeout=${EX_TIMEOUT}s"; then
      ex_resource_status "$ex_ready_unit" failed
      ex_event readiness failed 'Deployment did not finish its native rollout within the operation bound.'
      return 1
    fi
    if ! ex_query "$EX_OPERATION_DIR/.private/ready-current.json" get deployment "$ex_ready_name" --output=json || ! jq -e --slurpfile ledger "$EX_STATE_DIR/ledger.json" --arg name "$ex_ready_name" --arg owner "$EX_OWNER_TOKEN" '. as $current | any($ledger[0].resources[]; .kind=="Deployment" and .name==$name and .uid==$current.metadata.uid and .generation==$current.metadata.generation) and .metadata.labels["exphere.dev/owner"]==$owner and .status.observedGeneration>=.metadata.generation and .status.readyReplicas==.spec.replicas and .status.updatedReplicas==.spec.replicas' "$EX_OPERATION_DIR/.private/ready-current.json" >/dev/null; then
      ex_resource_status "$ex_ready_unit" failed
      ex_event readiness failed 'Deployment identity, generation, or ready replica count changed during rollout.'
      return 1
    fi
    ex_resource_status "$ex_ready_unit" ready
  done <"$EX_OPERATION_DIR/.private/deployments"
  ex_event readiness passed 'All selected Deployment rollouts completed; inspection still verifies actual identities and images.'
}
ex_cleanup_remaining() {
  : >"$EX_OPERATION_DIR/.private/cleanup.ndjson"
  if [ -f "$EX_STATE_DIR/ledger.json" ]; then
    jq -c '[.resources[],.pending[]]|unique_by([.kind,.name])[]' "$EX_STATE_DIR/ledger.json" >"$EX_OPERATION_DIR/.private/cleanup-items" || return 1
    while IFS= read -r ex_remaining; do
      ex_remaining_kind=$(printf '%s' "$ex_remaining" | jq -r '.kind')
      ex_remaining_name=$(printf '%s' "$ex_remaining" | jq -r '.name')
      if ex_query "$EX_OPERATION_DIR/.private/remaining-current.json" get "$ex_remaining_kind" "$ex_remaining_name" --ignore-not-found --output=json; then
        if [ ! -s "$EX_OPERATION_DIR/.private/remaining-current.json" ]; then continue; fi
        ex_remaining_disposition=retained
      else ex_remaining_disposition=unobservable; fi
      printf '%s' "$ex_remaining" | jq -c --arg disposition "$ex_remaining_disposition" '. + {disposition:$disposition}' >>"$EX_OPERATION_DIR/.private/cleanup.ndjson"
    done <"$EX_OPERATION_DIR/.private/cleanup-items"
  fi
  ex_record_update '.cleanup={complete:false,remaining:(((.cleanup.remaining//[])+$remaining)|unique_by([.kind,.name])),preparation:"retained-or-unobservable"}' --slurpfile remaining "$EX_OPERATION_DIR/.private/cleanup.ndjson"
}
ex_namespace_inventory() {
  ex_query "$EX_OPERATION_DIR/.private/resource-types" api-resources --verbs=list --namespaced=true --output=name || return 1
  [ -s "$EX_OPERATION_DIR/.private/resource-types" ] || return 1
  : >"$EX_OPERATION_DIR/.private/namespace.ndjson"
  sort -u "$EX_OPERATION_DIR/.private/resource-types" >"$EX_OPERATION_DIR/.private/resource-types.sorted"
  while IFS= read -r ex_inventory_type; do
    case "$ex_inventory_type" in ''|*[!a-z0-9.-]*) return 1 ;; esac
    ex_query "$EX_OPERATION_DIR/.private/resources.json" get "$ex_inventory_type" --output=json || return 1
    jq -e '.items|type=="array"' "$EX_OPERATION_DIR/.private/resources.json" >/dev/null || return 1
    jq -c '.items[]' "$EX_OPERATION_DIR/.private/resources.json" >>"$EX_OPERATION_DIR/.private/namespace.ndjson"
  done <"$EX_OPERATION_DIR/.private/resource-types.sorted"
  jq -s 'unique_by(.metadata.uid)' "$EX_OPERATION_DIR/.private/namespace.ndjson" >"$EX_OPERATION_DIR/.private/namespace-all.json"
}
ex_namespace_empty_owned() {
  ex_namespace_inventory || { ex_event cleanup failed 'Cannot enumerate every namespaced resource; preparation resources are retained.'; return 1; }
  jq --slurpfile ledger "$EX_STATE_DIR/ledger.json" '
    [.[] | . as $resource | select((any($ledger[0].baseline[]; .uid==$resource.metadata.uid and .kind==$resource.kind and .name==$resource.metadata.name and .body==($resource|del(.metadata.resourceVersion,.metadata.managedFields,.status))) or (.kind=="Event" and any($ledger[0].observedUids[]?; .==($resource.involvedObject.uid//$resource.regarding.uid)))) | not)
      | {kind,name:.metadata.name,uid:.metadata.uid,disposition:"retained-foreign-or-unresolved"}]
  ' "$EX_OPERATION_DIR/.private/namespace-all.json" >"$EX_OPERATION_DIR/.private/remaining.json" || return 1
  if ! jq -e 'length==0' "$EX_OPERATION_DIR/.private/remaining.json" >/dev/null; then
    ex_record_update '.cleanup={complete:false,remaining:$remaining[0]}' --slurpfile remaining "$EX_OPERATION_DIR/.private/remaining.json"
    ex_event cleanup failed 'Foreign, retained, changed, or unresolved resources prevent namespace deletion.'
    return 1
  fi
}
ex_delete_recorded() {
  ex_delete_item=$1
  ex_delete_kind=$(printf '%s' "$ex_delete_item" | jq -r '.kind')
  ex_delete_name=$(printf '%s' "$ex_delete_item" | jq -r '.name')
  ex_delete_uid=$(printf '%s' "$ex_delete_item" | jq -r '.uid')
  ex_query "$EX_OPERATION_DIR/.private/current.json" get "$ex_delete_kind" "$ex_delete_name" --ignore-not-found --output=json || return 1
  if [ ! -s "$EX_OPERATION_DIR/.private/current.json" ]; then return 0; fi
  ex_identity_owned "$EX_OPERATION_DIR/.private/current.json" "$ex_delete_uid" || { ex_event cleanup failed 'Recorded workload identity no longer matches; resource retained.'; return 1; }
  case "$ex_delete_kind" in
    Deployment) ex_delete_path="/apis/apps/v1/namespaces/$EX_KUBERNETES_NAMESPACE/deployments/$ex_delete_name" ;;
    Service) ex_delete_path="/api/v1/namespaces/$EX_KUBERNETES_NAMESPACE/services/$ex_delete_name" ;;
    *) return 1 ;;
  esac
  jq -n --arg uid "$ex_delete_uid" '{apiVersion:"v1",kind:"DeleteOptions",preconditions:{uid:$uid},propagationPolicy:"Foreground"}' >"$EX_OPERATION_DIR/.private/delete-options.json"
  ex_query "$EX_OPERATION_DIR/.private/delete.out" delete "--raw=$ex_delete_path" --filename "$EX_OPERATION_DIR/.private/delete-options.json" || return 1
  ex_query "$EX_OPERATION_DIR/.private/delete-wait.out" wait --for=delete "$ex_delete_kind/$ex_delete_name" "--timeout=${EX_TIMEOUT}s" || return 1
  ex_query "$EX_OPERATION_DIR/.private/current.json" get "$ex_delete_kind" "$ex_delete_name" --ignore-not-found --output=json || return 1
  [ ! -s "$EX_OPERATION_DIR/.private/current.json" ] || return 1
}
ex_workloads_down() {
  if [ -e "$EX_STATE_DIR/terraform.tfstate" ]; then ex_terraform_state_check || return 1; fi
  if [ ! -f "$EX_STATE_DIR/ledger.json" ]; then
    ex_current_namespace || return 1
    [ ! -s "$EX_OPERATION_DIR/.private/namespace.json" ] || { ex_event cleanup failed 'No recorded ownership exists for the selected namespace.'; return 1; }
    if [ -f "$EX_STATE_DIR/terraform.tfstate" ]; then
      jq -e '.resources|length==0' "$EX_STATE_DIR/terraform.tfstate" >/dev/null || { ex_event cleanup failed 'Native resources remain without a ledger; retain state and recover the ownership evidence.'; return 1; }
    fi
    ex_record_update '.cleanup={complete:true,remaining:[],detail:"No observed namespace or recorded resources."}'
    return 0
  fi
  ex_target_matches_ledger && ex_previous_evidence && ex_reconcile_preparation && ex_check_existing_namespace || return 1
  if jq -e '.pending|length>0' "$EX_STATE_DIR/ledger.json" >/dev/null; then
    if [ "$EX_RECOVER" != true ] || ! ex_reconcile_pending; then ex_event cleanup failed 'Interrupted mutation intents require down --recover with intact ownership evidence.'; return 1; fi
  fi
  jq -c '.resources[]' "$EX_STATE_DIR/ledger.json" >"$EX_OPERATION_DIR/.private/delete-items"
  ex_delete_failed=false
  while IFS= read -r ex_down_item; do
    ex_delete_recorded "$ex_down_item" || ex_delete_failed=true
  done <"$EX_OPERATION_DIR/.private/delete-items"
  [ "$ex_delete_failed" = false ] || { ex_event cleanup failed 'At least one workload could not be removed; preparation retained.'; return 1; }
  ex_current_namespace || return 1
  if [ -s "$EX_OPERATION_DIR/.private/namespace.json" ]; then
    ex_namespace_empty_owned || return 1
    ex_terraform_destroy || { ex_event cleanup failed 'Terraform preparation removal failed; state retained.'; return 1; }
  elif [ -f "$EX_STATE_DIR/terraform.tfstate" ] && ! jq -e '.resources|length==0' "$EX_STATE_DIR/terraform.tfstate" >/dev/null; then
    ex_terraform_destroy || { ex_event cleanup failed 'Absent namespace could not be reconciled with retained native state; preparation retained.'; return 1; }
  fi
  ex_current_namespace || return 1
  [ ! -s "$EX_OPERATION_DIR/.private/namespace.json" ] || { ex_event cleanup failed 'Namespace remains after preparation removal.'; return 1; }
  ex_complete_cleanup
}
