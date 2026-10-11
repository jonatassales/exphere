#!/bin/sh

ex_prompt() {
  printf '%s: ' "$1" >&2
  IFS= read -r ex_answer || ex_die 'Guided setup canceled before publication; existing files are unchanged.' 2
  printf '%s\n' "$ex_answer"
}

ex_guided_generate() {
  ex_owner=$(ex_prompt 'Owner reference')
  ex_context=$(ex_prompt 'Local Kubernetes context')
  ex_namespace=$(ex_prompt 'Namespace')
  ex_quota=$(ex_prompt 'Namespace quotas (JSON hard-limit object)')
  printf '%s\n' "$ex_quota" | jq -se '
    length == 1 and (.[0] | type == "object" and length > 0
      and all(keys[]; test("^[a-z0-9][a-z0-9./-]*$"))
      and all(.[]; type == "string" and test("^[0-9]+([.][0-9]+)?([eE][+-]?[0-9]+|[numkKMGTP]|[KMGTPE]i)?$")))
  ' >/dev/null || ex_die 'Quotas must be one nonempty JSON object of native quota names and nonnegative quantity strings; expressions are not supported.' 2
  jq -n --arg id "$ex_new_id" --arg owner "$ex_owner" --arg context "$ex_context" --arg namespace "$ex_namespace" \
    '{version:2,id:$id,environment:"local",owner:$owner,units:{},terraform:{directory:"terraform"},kubernetes:{context:$context,namespace:$namespace}}' >"$ex_stage/schema.json"
  while :; do
    ex_component=$(ex_prompt 'Component directory (project-relative; blank finishes units)')
    [ -n "$ex_component" ] || break
    ex_component_path=$(ex_resolve_path "$EX_PROJECT_ROOT" "$ex_component")
    [ -d "$ex_component_path" ] || ex_die 'Component must reference an existing directory.' 2
    ex_unit=$(basename "$ex_component_path")
    printf '%s\n' "$ex_unit" | jq -Rse 'rtrimstr("\n") | length <= 63 and test("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")' >/dev/null ||
      ex_die 'Component directory name must be a Kubernetes DNS label of at most 63 characters.' 2
    if jq -e --arg unit "$ex_unit" '.units | has($unit)' "$ex_stage/schema.json" >/dev/null; then
      ex_die "Component name collision: $ex_unit. Resolve the names before generating a runtime." 2
    fi
    ex_image=$(ex_prompt "$ex_unit prebuilt image reference")
    printf '%s\n' "$ex_image" | jq -Rse 'rtrimstr("\n") | test("^[^[:space:]]+$")' >/dev/null || ex_die 'Image must be a nonblank prebuilt reference without whitespace.' 2
    ex_container_port=$(ex_prompt "$ex_unit container port")
    ex_service_port=$(ex_prompt "$ex_unit service port")
    for ex_port in "$ex_container_port" "$ex_service_port"; do
      case "$ex_port" in ''|*[!0-9]*) ex_die 'Ports must be integers from 1 through 65535.' 2 ;; esac
      [ "$ex_port" -ge 1 ] && [ "$ex_port" -le 65535 ] || ex_die 'Ports must be integers from 1 through 65535.' 2
    done
    ex_replicas=$(ex_prompt "$ex_unit replicas")
    case "$ex_replicas" in ''|*[!0-9]*) ex_die 'Replicas must be a positive integer.' 2 ;; esac
    [ "$ex_replicas" -ge 1 ] || ex_die 'Replicas must be a positive integer.' 2
    ex_resources=$(ex_prompt "$ex_unit resources (JSON requests/limits with cpu, memory and ephemeral-storage)")
    printf '%s\n' "$ex_resources" | jq -se '
      def quantity: type == "string" and test("^[0-9]+([.][0-9]+)?([eE][+-]?[0-9]+|[numkKMGTP]|[KMGTPE]i)?$");
      length == 1 and (.[0] | type == "object" and keys == ["limits", "requests"]
        and all(.[]; type == "object" and keys == ["cpu", "ephemeral-storage", "memory"] and all(.[]; quantity)))
    ' >/dev/null || ex_die 'Resources must declare requests and limits for cpu, memory and ephemeral-storage as native quantity strings.' 2
    ex_probe=$(ex_prompt "$ex_unit readiness probe (native HTTP or TCP JSON object)")
    printf '%s\n' "$ex_probe" | jq -se --argjson port "$ex_container_port" '
      length == 1 and (.[0] | type == "object"
        and ((keys - ["httpGet", "tcpSocket", "initialDelaySeconds", "periodSeconds", "timeoutSeconds", "successThreshold", "failureThreshold"]) | length == 0)
        and (([has("httpGet"), has("tcpSocket")] | map(select(.)) | length) == 1)
        and (if has("httpGet") then (.httpGet | type == "object" and ((keys - ["path", "port", "scheme"]) | length == 0)
          and .port == $port and (.path | type == "string" and startswith("/"))
          and ((has("scheme") | not) or .scheme == "HTTP" or .scheme == "HTTPS"))
          else (.tcpSocket | type == "object" and keys == ["port"] and .port == $port) end)
        and (to_entries | all(.[]; if .key == "initialDelaySeconds" then (.value | type == "number" and floor == . and . >= 0)
          elif (.key | IN("periodSeconds", "timeoutSeconds", "successThreshold", "failureThreshold")) then (.value | type == "number" and floor == . and . >= 1) else true end)))
    ' >/dev/null || ex_die 'Readiness must be a native HTTP or TCP probe for the container port, with valid integer timing criteria.' 2
    ex_unit_dir="$ex_stage/units/$ex_unit/kubernetes"
    mkdir -p "$ex_unit_dir"
    jq -n --arg unit "$ex_unit" --arg image "$ex_image" --argjson port "$ex_container_port" --argjson replicas "$ex_replicas" --argjson resources "$ex_resources" --argjson probe "$ex_probe" '
      {apiVersion:"apps/v1",kind:"Deployment",metadata:{name:$unit},spec:{replicas:$replicas,selector:{matchLabels:{"app.kubernetes.io/name":$unit}},template:{metadata:{labels:{"app.kubernetes.io/name":$unit}},spec:{containers:[{name:$unit,image:$image,imagePullPolicy:"Never",ports:[{containerPort:$port}],resources:$resources,readinessProbe:$probe}]}}}}
    ' >"$ex_unit_dir/deployment.json"
    jq -n --arg unit "$ex_unit" --argjson port "$ex_service_port" --argjson target "$ex_container_port" '
      {apiVersion:"v1",kind:"Service",metadata:{name:$unit},spec:{type:"ClusterIP",selector:{"app.kubernetes.io/name":$unit},ports:[{port:$port,targetPort:$target}]}}
    ' >"$ex_unit_dir/service.json"
    jq --arg unit "$ex_unit" --arg component "$ex_component" '.units[$unit] = {component:$component,kubernetes:{manifests:("units/" + $unit + "/kubernetes")}}' "$ex_stage/schema.json" >"$ex_stage/next.json"
    mv "$ex_stage/next.json" "$ex_stage/schema.json"
  done
  while :; do
    ex_hook_source=$(ex_prompt 'Optional hook source (.sh project-relative; blank finishes hooks)')
    [ -n "$ex_hook_source" ] || break
    case "$ex_hook_source" in *.sh) ;; *) ex_die 'A selected hook source must be a .sh file.' 2 ;; esac
    ex_hook_file=$(ex_resolve_path "$EX_PROJECT_ROOT" "$ex_hook_source")
    [ -f "$ex_hook_file" ] && [ -r "$ex_hook_file" ] || ex_die 'A selected hook source must be a readable .sh file.' 2
    ex_hook_filename=$(basename "$ex_hook_file")
    ex_hook_name=${ex_hook_filename%.sh}
    ex_valid_id "$ex_hook_name" || ex_die 'Hook filenames must use lowercase letters, numbers and hyphens before .sh.' 2
    if jq -e --arg hook "$ex_hook_name" '(.hooks // {}) | has($hook)' "$ex_stage/schema.json" >/dev/null; then
      ex_die "Hook name collision: $ex_hook_name." 2
    fi
    mkdir -p "$ex_stage/hooks"
    cp "$ex_hook_file" "$ex_stage/hooks/$ex_hook_filename"
    jq --arg hook "$ex_hook_name" --arg path "hooks/$ex_hook_filename" '.hooks[$hook] = $path' "$ex_stage/schema.json" >"$ex_stage/next.json"
    mv "$ex_stage/next.json" "$ex_stage/schema.json"
  done
  mkdir "$ex_stage/terraform"
  jq -n --arg id "$ex_new_id" --argjson hard "$ex_quota" '
    {terraform:{required_version:"= 1.16.5",required_providers:{kubernetes:{source:"hashicorp/kubernetes",version:"= 3.2.1"}},backend:{local:{}}},
     variable:{ex_context:{type:"string"},ex_namespace:{type:"string"},ex_kubeconfig:{type:"string"},ex_runtime_owner:{type:"string"}},
     provider:{kubernetes:{config_path:"${var.ex_kubeconfig}",config_context:"${var.ex_context}"}},
     resource:{kubernetes_namespace_v1:{runtime:{metadata:{name:"${var.ex_namespace}",labels:{"exphere.dev/runtime":$id,"exphere.dev/owner":"${var.ex_runtime_owner}"}}}},
       kubernetes_resource_quota_v1:{runtime:{metadata:{name:"runtime",namespace:"${kubernetes_namespace_v1.runtime.metadata[0].name}",labels:{"exphere.dev/runtime":$id,"exphere.dev/owner":"${var.ex_runtime_owner}"}},spec:{hard:$hard}}}}}
  ' >"$ex_stage/terraform/main.tf.json"
  {
    printf '# Local microruntime %s\n\n' "$ex_new_id"
    printf 'This configuration has been generated and validated locally. Infrastructure, readiness, quota enforcement and cleanup have not been executed or verified.\n\n'
    printf '## Selected components\n\n'
    jq -r '.units | to_entries[] | "- `\(.key)` references project component `\(.value.component)`; native workloads are in `\(.value.kubernetes.manifests)`."' "$ex_stage/schema.json"
    printf '\n## Configuration authority\n\n'
    printf '`schema.json` owns identity, owner, source references and explicit context/namespace. Kubernetes files own images, ports, replicas, resource settings and probes. `terraform/main.tf.json` owns namespace and quota resources. Edit native values there; validation never regenerates consumer edits. Application source remains in the project. Selected hooks are copied consumer scripts, run only through an explicit hook command. No credentials belong in these files.\n\n'
    printf '## Explicit lifecycle\n\n'
    printf 'Prerequisites: sh, jq, Docker, kind, kubectl, Terraform 1.16.5 and the pinned HashiCorp Kubernetes provider 3.2.1. Supply prebuilt images and an existing local kind cluster. Generation does not build images or create the cluster. The lifecycle supplies an isolated kubeconfig, target and owner variables to Terraform.\n\n'
    printf 'Run `ex runtime %s validate` to check configuration. Operational commands require the separately delivered SPEC-MICRORUNTIME-LIFECYCLE implementation in the installed CLI; consult its help before using startup, inspection, access, hooks or cleanup. Hooks are trusted consumer code, never automatic or sandboxed. A valid descriptor does not prove an operational result.\n' "$ex_new_id"
  } >"$ex_stage/README.md"
  EX_RUNTIME_ID=$ex_new_id
  EX_RUNTIME_DIR=$(CDPATH= cd -P "$ex_stage" && pwd)
  EX_RUNTIME_SCHEMA="$EX_RUNTIME_DIR/schema.json"
  ex_validate_v2
}
