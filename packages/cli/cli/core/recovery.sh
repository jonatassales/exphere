#!/bin/sh
# Recovery reconciles recorded identities; it never treats names as authority.
ex_recovery_record() {
  ex_record_update '.recovery={requested:$requested,lockPresent:$lock,previousRun:$previous,recordedResources:$resources,pendingMutations:$pending}' \
    --argjson requested "$EX_RECOVER" --argjson lock "$([ -d "$EX_STATE_DIR/lock" ] && printf true || printf false)" \
    --arg previous "$(cat "$EX_STATE_DIR/last-run" 2>/dev/null || true)" \
    --argjson resources "$(jq '.resources|length' "$EX_STATE_DIR/ledger.json" 2>/dev/null || printf 0)" \
    --argjson pending "$(jq '.pending|length' "$EX_STATE_DIR/ledger.json" 2>/dev/null || printf 0)"
}
ex_recover_lock() {
  [ "$EX_RECOVER" = true ] || return 1
  [ -d "$EX_STATE_DIR/lock" ] && [ ! -L "$EX_STATE_DIR/lock" ] || return 1
  [ ! -e "$EX_STATE_DIR/lock/uncertain" ] || { ex_event recovery failed 'Previous process ownership is uncertain; inspect and stop its processes before manually reconciling the retained lock.'; return 1; }
  for ex_recover_name in pid deadline; do
    [ -f "$EX_STATE_DIR/lock/$ex_recover_name" ] && [ ! -L "$EX_STATE_DIR/lock/$ex_recover_name" ] || return 1
  done
  ex_recover_pid=$(cat "$EX_STATE_DIR/lock/pid")
  ex_recover_deadline=$(cat "$EX_STATE_DIR/lock/deadline")
  case "$ex_recover_pid:$ex_recover_deadline" in *[!0-9:]*) return 1 ;; esac
  [ -n "$ex_recover_pid" ] && [ -n "$ex_recover_deadline" ] && [ "$ex_recover_pid" -gt 1 ] || return 1
  # A live or reused PID is uncertain. Never signal it or release its boundary.
  if kill -0 "$ex_recover_pid" 2>/dev/null; then return 1; fi
  [ "$(date +%s)" -gt "$((ex_recover_deadline+3))" ] || return 1
  if [ -e "$EX_STATE_DIR/lock/child" ]; then
    [ -f "$EX_STATE_DIR/lock/child" ] && [ ! -L "$EX_STATE_DIR/lock/child" ] || return 1
    ex_recover_child=$(cat "$EX_STATE_DIR/lock/child")
    case "$ex_recover_child" in ''|*[!0-9]*) return 1 ;; esac
    [ "$ex_recover_child" -gt 1 ] || return 1
    if kill -0 "$ex_recover_child" 2>/dev/null; then return 1; fi
  fi
  # Atomic rename claims this exact stale boundary; another operator cannot
  # release a newly acquired lock during recovery.
  ex_recover_archive="$EX_STATE_DIR/recovered-lock-$EX_RUN_ID"
  mv "$EX_STATE_DIR/lock" "$ex_recover_archive" || return 1
  ex_event recovery passed 'An expired lock with no live recorded process was preserved and released explicitly.'
}
ex_validate_ledger() {
  [ ! -e "$EX_STATE_DIR/ledger.json" ] || jq -e '
    type=="object" and (.target|type=="object") and (.namespace.name|type=="string")
    and (.resources|type=="array") and (.pending|type=="array") and (.baseline|type=="array")
    and all(.resources[]; (.kind=="Deployment" or .kind=="Service") and (.name|type=="string") and (.uid|type=="string" and length>0))
  ' "$EX_STATE_DIR/ledger.json" >/dev/null 2>&1 || { ex_event recovery failed 'Runtime ledger is corrupt; preserve state and recover its recorded identities.'; return 1; }
}
ex_previous_evidence() {
  [ ! -f "$EX_STATE_DIR/ledger.json" ] || {
    ex_previous_id=$(jq -r '.createdByRun // empty' "$EX_STATE_DIR/ledger.json")
    case "$ex_previous_id" in ''|*[!a-zA-Z0-9-]*) return 1 ;; esac
    ex_previous_path="$EX_PROJECT_ROOT/.audits/evidence/runs/$ex_previous_id/record.json"
    [ -f "$ex_previous_path" ] && [ ! -L "$ex_previous_path" ] && jq -e --arg id "$EX_RUNTIME_ID" '.runtime==$id and .schemaVersion==1' "$ex_previous_path" >/dev/null || return 1
  }
}
ex_reconcile_preparation() {
  ex_current_namespace || return 1
  [ -s "$EX_OPERATION_DIR/.private/namespace.json" ] || return 0
  [ -z "$(jq -r '.namespace.uid // empty' "$EX_STATE_DIR/ledger.json")" ] || return 0
  [ "$EX_RECOVER" = true ] || { ex_event recovery failed 'Interrupted preparation requires down --recover and its retained native namespace identity.'; return 1; }
  [ -f "$EX_STATE_DIR/terraform-target.json" ] && [ ! -L "$EX_STATE_DIR/terraform-target.json" ] &&
    [ -f "$EX_STATE_DIR/terraform.tfstate" ] && [ ! -L "$EX_STATE_DIR/terraform.tfstate" ] &&
    ex_terraform_target && ex_terraform_state_check || return 1
  # The native UID must agree with a prior attempt on this exact cluster.
  jq -e --slurpfile target "$EX_OPERATION_DIR/target.json" --arg namespace "$EX_KUBERNETES_NAMESPACE" '
    .operation=="up" and .environment.namespace==$namespace
    and (.environment | contains($target[0]))
    and any(.stages[]; .stage=="terraform-plan" and .status=="passed")
  ' "$ex_previous_path" >/dev/null || return 1
  ex_recover_namespace_uid=$(jq -er '[.resources[] | select(.type=="kubernetes_namespace_v1") | .instances[].attributes.metadata[0].uid] | select(length==1) | .[0] | select(type=="string" and length>0)' "$EX_STATE_DIR/terraform.tfstate") || return 1
  ex_identity_owned "$EX_OPERATION_DIR/.private/namespace.json" "$ex_recover_namespace_uid" || { ex_event recovery failed 'The retained native namespace UID does not match the current namespace; resources retained.'; return 1; }
  jq -er '.clusters[0].cluster["certificate-authority-data"]' "$EX_KUBECONFIG" >"$EX_OPERATION_DIR/.private/recovery-ca.base64" || return 1
  base64 --decode <"$EX_OPERATION_DIR/.private/recovery-ca.base64" >"$EX_OPERATION_DIR/.private/recovery-ca.crt" || return 1
  [ -s "$EX_OPERATION_DIR/.private/recovery-ca.crt" ] || return 1
  : >"$EX_OPERATION_DIR/.private/recovery-baseline.ndjson"
  for ex_recover_resource in serviceaccounts configmaps resourcequotas; do
    ex_query "$EX_OPERATION_DIR/.private/recovery-baseline.json" get "$ex_recover_resource" --output=json || return 1
    jq -c '.items[]?' "$EX_OPERATION_DIR/.private/recovery-baseline.json" >>"$EX_OPERATION_DIR/.private/recovery-baseline.ndjson" || return 1
  done
  jq -s --slurpfile state "$EX_STATE_DIR/terraform.tfstate" --rawfile ca "$EX_OPERATION_DIR/.private/recovery-ca.crt" --arg owner "$EX_OWNER_TOKEN" --arg namespace "$EX_KUBERNETES_NAMESPACE" '
    [.[] | select(.metadata.namespace==$namespace and (.metadata.uid|type=="string" and length>0))
      | select((.kind=="ServiceAccount" and .metadata.name=="default" and ((.secrets//[])|length)==0 and ((.imagePullSecrets//[])|length)==0 and ((.metadata.ownerReferences//[])|length)==0)
        or (.kind=="ConfigMap" and .metadata.name=="kube-root-ca.crt" and .data=={"ca.crt":$ca} and ((.binaryData//{})|length)==0 and ((.metadata.ownerReferences//[])|length)==0)
        or (.kind=="ResourceQuota" and .metadata.labels["exphere.dev/owner"]==$owner
          and (.metadata.uid as $uid | any($state[0].resources[]; .type=="kubernetes_resource_quota_v1" and any(.instances[]; .attributes.metadata[0].uid==$uid)))))
      | {kind,name:.metadata.name,uid:.metadata.uid,body:(del(.metadata.resourceVersion,.metadata.managedFields,.status))}]
  ' "$EX_OPERATION_DIR/.private/recovery-baseline.ndjson" >"$EX_OPERATION_DIR/.private/recovery-baseline-array.json" || return 1
  ex_current_namespace && ex_identity_owned "$EX_OPERATION_DIR/.private/namespace.json" "$ex_recover_namespace_uid" || return 1
  ex_ledger_update '.namespace.uid=$uid | if (.baseline|length)==0 then .baseline=$baseline[0] else . end' --arg uid "$ex_recover_namespace_uid" --slurpfile baseline "$EX_OPERATION_DIR/.private/recovery-baseline-array.json" || return 1
  ex_event recovery passed 'Interrupted preparation was reconciled with the retained Terraform namespace UID and prior target evidence.'
}
ex_complete_cleanup() {
  if [ -e "$EX_STATE_DIR/terraform.tfstate" ]; then
    ex_terraform_state_check && jq -e '.resources|length==0' "$EX_STATE_DIR/terraform.tfstate" >/dev/null || { ex_event cleanup failed 'Native preparation state still contains resources; source and ownership evidence retained.'; return 1; }
  fi
  # Only retire a recognized preparation snapshot after observed absence and
  # empty native state. Keep provider data, state backups and operation history.
  if [ -e "$EX_STATE_DIR/terraform-root/main.tf.json" ] || [ -e "$EX_STATE_DIR/terraform-target.json" ]; then
    [ -f "$EX_STATE_DIR/terraform-root/main.tf.json" ] && [ -f "$EX_STATE_DIR/terraform-target.json" ] &&
      ex_terraform_paths && ex_terraform_target || return 1
    ex_cleanup_source="$EX_OPERATION_DIR/.private/cleanup-source"
    mkdir "$ex_cleanup_source" && cp "$EX_STATE_DIR/terraform-root/main.tf.json" "$ex_cleanup_source/main.tf.json" && ex_terraform_validate "$ex_cleanup_source" || return 1
  fi
  ex_completed_ledger="$EX_STATE_DIR/completed-ledger-$EX_RUN_ID.json"
  [ ! -e "$ex_completed_ledger" ] && [ ! -L "$ex_completed_ledger" ] || return 1
  jq --arg run "$EX_RUN_ID" --arg time "$(ex_now)" '.completedByRun=$run | .completedAt=$time | .cleanup={complete:true,remaining:[]}' "$EX_STATE_DIR/ledger.json" >"$ex_completed_ledger" || return 1
  rm -f "$EX_STATE_DIR/terraform-root/main.tf.json" "$EX_STATE_DIR/terraform-target.json" || return 1
  rm -f "$EX_STATE_DIR/ledger.json" || return 1
  ex_record_update '.cleanup={complete:true,remaining:[]}' || return 1
  ex_event cleanup passed 'Owned workloads and preparation resources are absent; completed ownership history, native state backups and authored configuration retained.'
}
ex_reconcile_pending() {
  [ -f "$EX_STATE_DIR/ledger.json" ] || return 0
  jq -c '.pending[]' "$EX_STATE_DIR/ledger.json" >"$EX_OPERATION_DIR/.private/pending-items" || return 1
  while IFS= read -r ex_pending; do
    ex_pending_kind=$(printf '%s' "$ex_pending" | jq -r '.kind')
    ex_pending_name=$(printf '%s' "$ex_pending" | jq -r '.name')
    ex_pending_run=$(printf '%s' "$ex_pending" | jq -r '.run // empty')
    case "$ex_pending_run" in ''|*[!a-zA-Z0-9-]*) return 1 ;; esac
    ex_pending_record="$EX_PROJECT_ROOT/.audits/evidence/runs/$ex_pending_run/record.json"
    [ -f "$ex_pending_record" ] && [ ! -L "$ex_pending_record" ] && jq -e --arg id "$EX_RUNTIME_ID" '.runtime==$id' "$ex_pending_record" >/dev/null || return 1
    ex_query "$EX_OPERATION_DIR/.private/pending-current.json" get "$ex_pending_kind" "$ex_pending_name" --ignore-not-found --output=json || return 1
    if [ -s "$EX_OPERATION_DIR/.private/pending-current.json" ]; then
      ex_pending_old_uid=$(jq -r --arg kind "$ex_pending_kind" --arg name "$ex_pending_name" '[.resources[]|select(.kind==$kind and .name==$name)|.uid][0]//empty' "$EX_STATE_DIR/ledger.json")
      ex_identity_owned "$EX_OPERATION_DIR/.private/pending-current.json" "$ex_pending_old_uid" || return 1
      ex_pending_uid=$(jq -r '.metadata.uid' "$EX_OPERATION_DIR/.private/pending-current.json")
      ex_ledger_update '.resources=([.resources[]|select(.kind!=$kind or .name!=$name)]+[$item|del(.run)|.uid=$uid])' --arg kind "$ex_pending_kind" --arg name "$ex_pending_name" --arg uid "$ex_pending_uid" --argjson item "$ex_pending" || return 1
    fi
    ex_ledger_update '.pending |= map(select(.kind!=$kind or .name!=$name))' --arg kind "$ex_pending_kind" --arg name "$ex_pending_name" || return 1
  done <"$EX_OPERATION_DIR/.private/pending-items"
  ex_event recovery passed 'Recorded mutation intents were reconciled with current ownership and resource identities.'
}
ex_recovery_inventory() {
  cp "$EX_OPERATION_DIR/.private/desired.json" "$EX_OPERATION_DIR/.private/observe.json" || return 1
  if [ -f "$EX_STATE_DIR/ledger.json" ]; then
    jq --slurpfile ledger "$EX_STATE_DIR/ledger.json" '. as $desired | $desired + [$ledger[0].resources[], $ledger[0].pending[] | . as $old | select(any($desired[]; .kind==$old.kind and .name==$old.name)|not)] | unique_by([.kind,.name])' "$EX_OPERATION_DIR/.private/desired.json" >"$EX_OPERATION_DIR/.private/observe.json" || return 1
  fi
}
