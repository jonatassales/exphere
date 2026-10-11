#!/bin/sh

# This boundary supports one native root, namespace and quota only.
ex_terraform_validate() (
  ex_tf_root=${1:-$EX_TERRAFORM_DIR}
  [ -d "$ex_tf_root" ] && [ ! -L "$ex_tf_root" ] || {
    printf 'ex: Terraform directory must be a regular local directory.\n' >&2
    return 1
  }
  for ex_tf_entry in "$ex_tf_root"/* "$ex_tf_root"/.[!.]* "$ex_tf_root"/..?*; do
    [ -e "$ex_tf_entry" ] || [ -L "$ex_tf_entry" ] || continue
    [ "$ex_tf_entry" = "$ex_tf_root/main.tf.json" ] || {
      printf 'ex: Supported Terraform roots contain only main.tf.json; remove additional files and directories.\n' >&2
      return 1
    }
  done
  [ -f "$ex_tf_root/main.tf.json" ] && [ -r "$ex_tf_root/main.tf.json" ] && [ ! -L "$ex_tf_root/main.tf.json" ] || {
    printf 'ex: Terraform root requires a readable regular main.tf.json.\n' >&2
    return 1
  }
  jq -se --arg runtime "$EX_RUNTIME_ID" '
    def block:
      if type == "object" then .
      elif type == "array" and length == 1 and (.[0] | type == "object") then .[0]
      else error("expected one block") end;
    def labels:
      type == "object" and ((keys - ["exphere.dev/owner", "exphere.dev/runtime"]) | length == 0)
      and .["exphere.dev/owner"] == "${var.ex_runtime_owner}"
      and (if has("exphere.dev/runtime") then .["exphere.dev/runtime"] == $runtime else true end);
    def quantity:
      type == "string" and test("^[0-9]+([.][0-9]+)?([eE][+-]?[0-9]+|[numkKMGTP]|[KMGTPE]i)?$");
    length == 1 and (.[0] |
      type == "object" and keys == ["provider", "resource", "terraform", "variable"]
      and (.terraform | block |
        keys == ["backend", "required_providers", "required_version"]
        and .required_version == "= 1.16.5"
        and .backend == {local:{}}
        and (.required_providers | keys == ["kubernetes"])
        and (.required_providers.kubernetes | keys == ["source", "version"]
          and .source == "hashicorp/kubernetes"
          and (.version == "= 3.2.1" or .version == "3.2.1")))
      and .variable == {ex_context:{type:"string"},ex_namespace:{type:"string"},ex_kubeconfig:{type:"string"},ex_runtime_owner:{type:"string"}}
      and (.provider | keys == ["kubernetes"])
      and (.provider.kubernetes | block | . == {config_path:"${var.ex_kubeconfig}",config_context:"${var.ex_context}"})
      and (.resource | keys == ["kubernetes_namespace_v1", "kubernetes_resource_quota_v1"])
      and (.resource.kubernetes_namespace_v1 | keys == ["runtime"])
      and (.resource.kubernetes_namespace_v1.runtime | keys == ["metadata"]
        and (.metadata | block | keys == ["labels", "name"]
          and .name == "${var.ex_namespace}" and (.labels | labels)))
      and (.resource.kubernetes_resource_quota_v1 | keys == ["runtime"])
      and (.resource.kubernetes_resource_quota_v1.runtime | keys == ["metadata", "spec"]
        and (.metadata | block | keys == ["labels", "name", "namespace"]
          and .name == "runtime"
          and .namespace == "${kubernetes_namespace_v1.runtime.metadata[0].name}"
          and (.labels | labels))
        and (.spec | block | keys == ["hard"] and (.hard | type == "object" and length > 0
          and all(keys[]; test("^[a-z][a-z0-9./-]*$"))
          and all(.[]; quantity))))
    )
  ' "$ex_tf_root/main.tf.json" >/dev/null 2>&1 || {
    printf 'ex: Unsupported Terraform root. Use the pinned local namespace/quota contract and its four explicit target variables; arbitrary expressions and resources are not supported.\n' >&2
    return 1
  }
)

# Preserve unrelated process variables, including the public test seam, while
# excluding every Terraform/provider environment override before native calls.
ex_terraform_native() (
  for ex_tf_environment in $(env | sed -n \
    -e 's/^\(TF_[A-Za-z0-9_]*\)=.*/\1/p' \
    -e 's/^\(KUBE_[A-Za-z0-9_]*\)=.*/\1/p' \
    -e 's/^\(KUBERNETES_[A-Za-z0-9_]*\)=.*/\1/p'); do
    unset "$ex_tf_environment"
  done
  TF_DATA_DIR="$EX_STATE_DIR/terraform-data"
  TF_WORKSPACE=default
  TF_INPUT=0
  TF_IN_AUTOMATION=1
  TF_CLI_CONFIG_FILE=/dev/null
  TF_VAR_ex_context=$EX_KUBERNETES_CONTEXT
  TF_VAR_ex_namespace=$EX_KUBERNETES_NAMESPACE
  TF_VAR_ex_kubeconfig=$EX_KUBECONFIG
  TF_VAR_ex_runtime_owner=$EX_OWNER_TOKEN
  KUBECONFIG=$EX_KUBECONFIG
  export TF_DATA_DIR TF_WORKSPACE TF_INPUT TF_IN_AUTOMATION TF_CLI_CONFIG_FILE
  export TF_VAR_ex_context TF_VAR_ex_namespace TF_VAR_ex_kubeconfig TF_VAR_ex_runtime_owner KUBECONFIG
  exec terraform "-chdir=$EX_STATE_DIR/terraform-root" "$@"
)

ex_terraform_step() {
  ex_tf_step=$1
  shift
  if ex_bounded "$EX_TIMEOUT" "$EX_OPERATION_DIR/.private/terraform-$ex_tf_step.stdout" "$EX_OPERATION_DIR/.private/terraform-$ex_tf_step.stderr" ex_terraform_native "$@"; then
    ex_event "terraform-$ex_tf_step" passed 'Native Terraform step completed.' || return 1
    return 0
  else
    ex_tf_status=${EX_LAST_STATUS:-1}
    ex_event "terraform-$ex_tf_step" failed "Native Terraform step failed with exit status $ex_tf_status. Raw output is private."
    printf 'ex: Terraform %s failed (exit %s); infrastructure may be partially changed. Inspect the operation record.\n' "$ex_tf_step" "$ex_tf_status" >&2
    return "$ex_tf_status"
  fi
}

ex_terraform_target() {
  ex_tf_identity="$EX_STATE_DIR/terraform-target.json"
  if [ -e "$ex_tf_identity" ] || [ -L "$ex_tf_identity" ]; then
    [ -f "$ex_tf_identity" ] && [ ! -L "$ex_tf_identity" ] &&
      jq -se --arg context "$EX_KUBERNETES_CONTEXT" --arg namespace "$EX_KUBERNETES_NAMESPACE" --arg owner "$EX_OWNER_TOKEN" --arg runtime "$EX_RUNTIME_ID" '
        length == 1 and .[0] == {context:$context,namespace:$namespace,owner:$owner,runtime:$runtime}
      ' "$ex_tf_identity" >/dev/null 2>&1 || {
      printf 'ex: Terraform target differs from its recorded owner or target. Preserve state and reconcile before proceeding.\n' >&2
      return 1
    }
  else
    jq -n --arg context "$EX_KUBERNETES_CONTEXT" --arg namespace "$EX_KUBERNETES_NAMESPACE" --arg owner "$EX_OWNER_TOKEN" --arg runtime "$EX_RUNTIME_ID" \
      '{context:$context,namespace:$namespace,owner:$owner,runtime:$runtime}' >"$ex_tf_identity" || return 1
  fi
}

ex_terraform_paths() {
  for ex_tf_path in "$EX_STATE_DIR/terraform-root" "$EX_STATE_DIR/terraform-data" "$EX_STATE_DIR/terraform-workspaces" "$EX_OPERATION_DIR/.private"; do
    [ ! -L "$ex_tf_path" ] || {
      printf 'ex: Terraform private paths cannot be symbolic links.\n' >&2
      return 1
    }
    mkdir -p "$ex_tf_path" || return 1
    chmod 700 "$ex_tf_path" || return 1
  done
  for ex_tf_path in "$EX_STATE_DIR/terraform.tfstate" "$EX_STATE_DIR/terraform.tfstate.backup" "$EX_STATE_DIR/terraform-root/main.tf.json"; do
    [ ! -L "$ex_tf_path" ] || {
      printf 'ex: Terraform state and snapshots cannot be symbolic links.\n' >&2
      return 1
    }
  done
  for ex_tf_path in "$EX_STATE_DIR/terraform-root"/* "$EX_STATE_DIR/terraform-root"/.[!.]* "$EX_STATE_DIR/terraform-root"/..?*; do
    [ -e "$ex_tf_path" ] || [ -L "$ex_tf_path" ] || continue
    case "$ex_tf_path" in
      "$EX_STATE_DIR/terraform-root/main.tf.json"|"$EX_STATE_DIR/terraform-root/.terraform.lock.hcl")
        [ -f "$ex_tf_path" ] && [ ! -L "$ex_tf_path" ] || return 1 ;;
      *) printf 'ex: The recorded Terraform snapshot contains unexpected files. Preserve it and reconcile before proceeding.\n' >&2; return 1 ;;
    esac
  done
}

ex_terraform_state_check() {
  jq -se --arg namespace "$EX_KUBERNETES_NAMESPACE" --arg owner "$EX_OWNER_TOKEN" '
    def identity($resource_type):
      .metadata | if type == "array" and length == 1 then .[0] else error("metadata") end
      | .labels["exphere.dev/owner"] == $owner
        and (if $resource_type == "kubernetes_namespace_v1" then .name == $namespace
          else .name == "runtime" and .namespace == $namespace end);
    length == 1 and (.[0] | .version == 4
      and (.resources | type == "array" and length <= 2)
      and ([.resources[].type] | length == (unique | length))
      and all(.resources[]; . as $resource |
        .mode == "managed" and .name == "runtime" and (has("module") | not)
        and (.type == "kubernetes_namespace_v1" or .type == "kubernetes_resource_quota_v1")
        and .provider == "provider[\"registry.terraform.io/hashicorp/kubernetes\"]"
        and (.instances | type == "array" and length <= 1)
        and all(.instances[]; (has("index_key") | not) and (has("deposed") | not)
          and (.attributes | identity($resource.type)))))
  ' "$EX_STATE_DIR/terraform.tfstate" >/dev/null 2>&1 || {
    printf 'ex: Terraform state is missing, corrupt, or outside the recorded namespace/quota boundary. Preserve resources and reconcile before proceeding.\n' >&2
    return 1
  }
}

ex_terraform_plan_check() {
  ex_tf_mode=$1
  jq -se --arg namespace "$EX_KUBERNETES_NAMESPACE" --arg owner "$EX_OWNER_TOKEN" --arg mode "$ex_tf_mode" '
    def metadata: .metadata | if type == "array" and length == 1 then .[0] elif type == "object" then . else error("metadata") end;
    def identity($resource_type):
      metadata | .labels["exphere.dev/owner"] == $owner
      and (if $resource_type == "kubernetes_namespace_v1" then .name == $namespace and ((.namespace // "") == "")
        else .name == "runtime" and .namespace == $namespace end);
    def change:
      . as $resource
      | .mode == "managed"
      and (.type == "kubernetes_namespace_v1" or .type == "kubernetes_resource_quota_v1")
      and .address == (.type + ".runtime") and (has("index") | not)
      and ((.provider_name // "registry.terraform.io/hashicorp/kubernetes") == "registry.terraform.io/hashicorp/kubernetes")
      and (if .change.before != null then (.change.before | identity($resource.type)) else true end)
      and (if .change.after != null then (.change.after | identity($resource.type)) else true end)
      and (if $mode == "destroy" then
          (.change.actions == ["delete"] and .change.before != null and .change.after == null)
          or (.change.actions == ["no-op"] and .change.before != null and .change.after != null)
        else (.change.actions == ["create"] or .change.actions == ["update"] or .change.actions == ["no-op"])
          and .change.after != null end);
    length == 1 and (.[0] |
      type == "object" and ((.resource_changes // []) | type == "array")
      and ((.resource_changes // []) | length <= 2 and (if $mode == "prepare" then length == 2 else true end))
      and ([.resource_changes[]?.address] | length == (unique | length))
      and all(.resource_changes[]?; change)
      and ((.deferred_changes // []) | length == 0)
      and ((.errored // false) == false)
    )
  ' "$EX_OPERATION_DIR/.private/terraform-show.stdout" >/dev/null 2>&1 || {
    ex_event terraform-plan failed 'Terraform plan contains an unsupported action, identity or resource. No plan was applied.'
    printf 'ex: Terraform plan is outside the recorded namespace/quota boundary; no plan was applied.\n' >&2
    return 1
  }
  ex_event terraform-plan passed 'Every planned resource and action matches the recorded namespace/quota boundary.'
}

ex_terraform_execute() {
  ex_tf_mode=$1
  ex_tf_plan="$EX_OPERATION_DIR/.private/terraform.plan"
  ex_terraform_step init init -input=false -no-color -reconfigure \
    "-backend-config=path=$EX_STATE_DIR/terraform.tfstate" \
    "-backend-config=workspace_dir=$EX_STATE_DIR/terraform-workspaces" || return $?
  ex_terraform_step version version -json || return $?
  jq -e '.terraform_version == "1.16.5" and .provider_selections["registry.terraform.io/hashicorp/kubernetes"] == "3.2.1"' \
    "$EX_OPERATION_DIR/.private/terraform-version.stdout" >/dev/null 2>&1 || {
    ex_event terraform-provider failed 'Native Terraform or the initialized Kubernetes provider differs from the supported reference version.' || return 1
    printf 'ex: Initialized Terraform/provider versions do not match the supported reference.\n' >&2
    return 1
  }
  ex_record_update '.tools.kubernetesProvider={source:"hashicorp/kubernetes",required:"3.2.1",observed:"3.2.1",status:"initialized"}' || return 1
  ex_terraform_step validate validate -no-color -json || return $?
  if [ "$ex_tf_mode" = destroy ]; then
    ex_terraform_step plan plan -destroy -input=false -no-color -lock=true "-lock-timeout=${EX_TIMEOUT}s" "-out=$ex_tf_plan" || return $?
  else
    ex_terraform_step plan plan -input=false -no-color -lock=true "-lock-timeout=${EX_TIMEOUT}s" "-out=$ex_tf_plan" || return $?
  fi
  ex_terraform_step show show -no-color -json "$ex_tf_plan" || return $?
  ex_terraform_plan_check "$ex_tf_mode" || return 1
  ex_terraform_step apply apply -input=false -no-color -lock=true "-lock-timeout=${EX_TIMEOUT}s" "$ex_tf_plan"
}

ex_terraform_prepare() {
  ex_terraform_validate || return 1
  ex_terraform_paths || return 1
  ex_terraform_target || return 1
  if [ -e "$EX_STATE_DIR/terraform.tfstate" ]; then
    ex_terraform_state_check || return 1
  fi
  if [ -f "$EX_STATE_DIR/terraform-root/main.tf.json" ]; then
    cmp -s "$EX_TERRAFORM_DIR/main.tf.json" "$EX_STATE_DIR/terraform-root/main.tf.json" || {
      printf 'ex: Terraform configuration changed after preparation. Clean up the recorded runtime before preparing this revision.\n' >&2
      return 1
    }
  else
    cp "$EX_TERRAFORM_DIR/main.tf.json" "$EX_STATE_DIR/terraform-root/main.tf.json" || return 1
    chmod 600 "$EX_STATE_DIR/terraform-root/main.tf.json" || return 1
  fi
  ex_terraform_execute prepare
}

ex_terraform_destroy() {
  [ -f "$EX_STATE_DIR/terraform-target.json" ] && [ -f "$EX_STATE_DIR/terraform-root/main.tf.json" ] || {
    printf 'ex: Terraform cleanup requires the recorded preparation snapshot and target. Preserve remaining resources.\n' >&2
    return 1
  }
  ex_terraform_paths || return 1
  ex_terraform_target || return 1
  ex_terraform_state_check || return 1
  # Init writes lock material here; validate the retained source independently.
  ex_tf_check_dir="$EX_OPERATION_DIR/.private/terraform-check"
  [ ! -e "$ex_tf_check_dir" ] && [ ! -L "$ex_tf_check_dir" ] && mkdir "$ex_tf_check_dir" || return 1
  cp "$EX_STATE_DIR/terraform-root/main.tf.json" "$ex_tf_check_dir/main.tf.json" || return 1
  ex_terraform_validate "$ex_tf_check_dir" || return 1
  ex_terraform_execute destroy
}
