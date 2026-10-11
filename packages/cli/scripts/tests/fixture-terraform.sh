#!/bin/sh
set -eu
printf 'terraform %s\n' "$*" >>"$EX_FIXTURE_STATE/calls"
fixture_tf_root=.
case "${1:-}" in -chdir=*) fixture_tf_root=${1#-chdir=}; shift ;; esac
operation=${1:-}; [ "$#" -eq 0 ] || shift
if [ "$operation" != version ] && [ "${EX_FIXTURE_EXPECT_CLEAN_ENV:-}" = 1 ]; then
  [ -z "${TF_CLI_ARGS:-}${TF_CLI_ARGS_init:-}${TF_CLI_ARGS_plan:-}${TF_CLI_ARGS_apply:-}${KUBE_HOST:-}${KUBE_TOKEN:-}${KUBE_CONFIG_PATHS:-}" ] || exit 77
  [ "$TF_WORKSPACE" = default ] && [ "$TF_CLI_CONFIG_FILE" = /dev/null ] || exit 77
  [ "$TF_VAR_ex_context" = kind-pilot ] && [ "$TF_VAR_ex_namespace" = demo ] || exit 77
fi
if [ "${EX_FIXTURE_TERRAFORM_FAIL:-}" = "$operation" ]; then
  printf 'fixture-private-diagnostic-value\n' >&2
  exit "${EX_FIXTURE_TERRAFORM_EXIT:-17}"
fi

fixture_tf_write_state() {
  fixture_tf_items='[]'
  if [ -f "$EX_FIXTURE_STATE/namespace.json" ]; then
    fixture_tf_items=$(jq -c '[{mode:"managed",type:"kubernetes_namespace_v1",name:"runtime",provider:"provider[\"registry.terraform.io/hashicorp/kubernetes\"]",instances:[{schema_version:0,attributes:{id:.metadata.name,metadata:[.metadata]}}]}]' "$EX_FIXTURE_STATE/namespace.json")
  fi
  if [ -f "$EX_FIXTURE_STATE/quota.json" ]; then
    fixture_tf_items=$(jq -c --argjson existing "$fixture_tf_items" '$existing + [{mode:"managed",type:"kubernetes_resource_quota_v1",name:"runtime",provider:"provider[\"registry.terraform.io/hashicorp/kubernetes\"]",instances:[{schema_version:0,attributes:{id:(.metadata.namespace + "/" + .metadata.name),metadata:[.metadata],spec:[.spec]}}]}]' "$EX_FIXTURE_STATE/quota.json")
  fi
  fixture_tf_state=$(cat "$TF_DATA_DIR/state-path")
  jq -n --argjson resources "$fixture_tf_items" '{version:4,terraform_version:"1.16.5",serial:1,lineage:"fixture-lineage",outputs:{},resources:$resources}' >"$fixture_tf_state"
}

case "$operation" in
  version)
    jq -n --arg version "${EX_FIXTURE_TERRAFORM_VERSION:-1.16.5}" --arg provider "${EX_FIXTURE_PROVIDER_VERSION:-3.2.1}" \
      '{terraform_version:$version,provider_selections:{"registry.terraform.io/hashicorp/kubernetes":$provider}}' ;;
  init)
    for arg do
      case "$arg" in -backend-config=path=*) printf '%s\n' "${arg#-backend-config=path=}" >"$TF_DATA_DIR/state-path" ;; esac
    done
    printf '# Native provider lock fixture\n' >"$fixture_tf_root/.terraform.lock.hcl"
    printf 'Terraform initialized.\n' ;;
  validate) printf '{"valid":true}\n' ;;
  plan)
    destroy=false
    for arg do case "$arg" in -out=*) output=${arg#-out=} ;; -destroy) destroy=true ;; esac; done
    printf '{"destroy":%s}\n' "$destroy" >"$output"
    ;;
  show)
    for arg do file=$arg; done
    destroy=$(jq -r '.destroy // false' "$file" 2>/dev/null || printf false)
    jq -n --arg ns "${TF_VAR_ex_namespace:-demo}" --arg owner "${TF_VAR_ex_runtime_owner:-fixture}" --argjson destroy "$destroy" --arg foreign "${EX_FIXTURE_TERRAFORM_FOREIGN_PLAN:-}" '
      {resource_changes:[
        {address:"kubernetes_namespace_v1.runtime",mode:"managed",type:"kubernetes_namespace_v1",provider_name:"registry.terraform.io/hashicorp/kubernetes",change:{actions:(if $destroy then ["delete"] else ["create"] end),before:(if $destroy then {metadata:[{name:$ns,labels:{"exphere.dev/owner":$owner}}]} else null end),after:(if $destroy then null else {metadata:[{name:$ns,labels:{"exphere.dev/owner":$owner}}]} end)}},
        {address:"kubernetes_resource_quota_v1.runtime",mode:"managed",type:"kubernetes_resource_quota_v1",provider_name:"registry.terraform.io/hashicorp/kubernetes",change:{actions:(if $destroy then ["delete"] else ["create"] end),before:(if $destroy then {metadata:[{name:"runtime",namespace:$ns,labels:{"exphere.dev/owner":$owner}}]} else null end),after:(if $destroy then null else {metadata:[{name:"runtime",namespace:$ns,labels:{"exphere.dev/owner":$owner}}]} end)}}]}
      | if $foreign == "1" then .resource_changes[0].change.after.metadata[0].name = "foreign-namespace" else . end
    ' ;;
  apply)
    [ "${EX_FIXTURE_PREPARE_FAIL:-}" != 1 ] || exit 1
    for arg do file=$arg; done
    destroy=$(jq -r '.destroy // false' "$file")
    if [ "$destroy" = true ]; then
      rm -f "$EX_FIXTURE_STATE/namespace.json" "$EX_FIXTURE_STATE/quota.json"
    else
      jq -n --arg ns "$TF_VAR_ex_namespace" --arg owner "$TF_VAR_ex_runtime_owner" '{apiVersion:"v1",kind:"Namespace",metadata:{name:$ns,uid:"fixture-namespace",labels:{"exphere.dev/owner":$owner}}}' >"$EX_FIXTURE_STATE/namespace.json"
      if [ "${EX_FIXTURE_TERRAFORM_PARTIAL:-}" = 1 ]; then
        fixture_tf_write_state
        printf 'fixture-private-diagnostic-value\n' >&2
        exit 17
      fi
      jq -n --arg ns "$TF_VAR_ex_namespace" --arg owner "$TF_VAR_ex_runtime_owner" '{apiVersion:"v1",kind:"ResourceQuota",metadata:{name:"runtime",namespace:$ns,uid:"fixture-quota",labels:{"exphere.dev/owner":$owner}},spec:{hard:{pods:"5"}},status:{hard:{pods:"5"},used:{pods:"1"}}}' >"$EX_FIXTURE_STATE/quota.json"
    fi
    fixture_tf_write_state ;;
  *) printf 'unsupported fixture terraform: %s\n' "$operation" >&2; exit 2 ;;
esac
