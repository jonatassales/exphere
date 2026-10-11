#!/bin/sh

ex_preflight_probe() {
  ex_pf_name=$1
  shift
  if ex_bounded 15 "$EX_OPERATION_DIR/.private/preflight-$ex_pf_name.stdout" "$EX_OPERATION_DIR/.private/preflight-$ex_pf_name.stderr" "$@"; then
    return 0
  fi
  ex_event preflight failed 'A required native version, availability, or access check failed; no infrastructure mutation is authorized by this result.' || return 1
  printf 'ex: Required preflight check failed: %s. Inspect the operation record.\n' "$ex_pf_name" >&2
  return 1
}

ex_preflight_version() {
  ex_pf_tool=$1
  ex_pf_observed=$2
  ex_pf_required=$3
  ex_record_update '.tools[$tool]={observed:$observed,required:$required}' \
    --arg tool "$ex_pf_tool" --arg observed "$ex_pf_observed" --arg required "$ex_pf_required" || return 1
  if [ "$ex_pf_observed" != "$ex_pf_required" ]; then
    ex_event preflight failed 'An observed tool or server version differs from the supported reference contract.' || return 1
    printf 'ex: Unsupported %s version; this pilot requires %s.\n' "$ex_pf_tool" "$ex_pf_required" >&2
    return 1
  fi
}

ex_preflight_access() {
  ex_pf_access="$EX_OPERATION_DIR/.private/preflight-access"
  printf 'get namespaces/%s\n' "$EX_KUBERNETES_NAMESPACE" >"$ex_pf_access" || return 1
  cat >>"$ex_pf_access" <<'ACCESS'
get deployments.apps
list deployments.apps
get services
list services
list pods
list replicasets.apps
list events
list resourcequotas
ACCESS
  case "$EX_OPERATION" in
    up)
      printf 'create namespaces\npatch namespaces/%s\nupdate namespaces/%s\n' "$EX_KUBERNETES_NAMESPACE" "$EX_KUBERNETES_NAMESPACE" >>"$ex_pf_access"
      cat >>"$ex_pf_access" <<'ACCESS'
create deployments.apps
patch deployments.apps
watch deployments.apps
create services
patch services
get resourcequotas
create resourcequotas
patch resourcequotas
update resourcequotas
ACCESS
      ;;
    down)
      printf 'delete namespaces/%s\n' "$EX_KUBERNETES_NAMESPACE" >>"$ex_pf_access"
      cat >>"$ex_pf_access" <<'ACCESS'
delete deployments.apps
delete services
delete resourcequotas
list replicasets.apps
list configmaps
list serviceaccounts
list endpointslices.discovery.k8s.io
ACCESS
      ;;
    logs) printf 'get pods/log\n' >>"$ex_pf_access" ;;
    connect) printf 'get pods\ncreate pods/portforward\n' >>"$ex_pf_access" ;;
  esac
  while IFS=' ' read -r ex_pf_verb ex_pf_resource; do
    case "$ex_pf_resource" in
      pods/log) set -- "$ex_pf_verb" pods --subresource=log ;;
      pods/portforward) set -- "$ex_pf_verb" pods --subresource=portforward ;;
      *) set -- "$ex_pf_verb" "$ex_pf_resource" ;;
    esac
    if ! ex_preflight_probe access env KUBECTL_KUBERC=false kubectl \
      "--kubeconfig=$EX_KUBECONFIG" "--context=$EX_KUBERNETES_CONTEXT" \
      "--namespace=$EX_KUBERNETES_NAMESPACE" --request-timeout=10s \
      auth can-i "$@" --quiet; then
      ex_event access failed 'Required scoped Kubernetes access is denied or unavailable.' || return 1
      printf 'ex: Required Kubernetes access is unavailable: %s %s in the selected target.\n' "$ex_pf_verb" "$ex_pf_resource" >&2
      return 1
    fi
  done <"$ex_pf_access"
  ex_event access passed 'Required scoped Kubernetes access checks passed for this operation.'
}

ex_preflight_tools() {
  ex_record_update '.tools={}' || return 1
  for ex_pf_tool in jq docker kind kubectl terraform; do
    if ! command -v "$ex_pf_tool" >/dev/null 2>&1; then
      ex_record_update '.tools[$tool]={observed:null,status:"missing"}' --arg tool "$ex_pf_tool" || return 1
      ex_event preflight failed 'A required executable is unavailable; no dependency was installed.' || return 1
      printf 'ex: Required executable is unavailable: %s.\n' "$ex_pf_tool" >&2
      return 1
    fi
  done
  ex_preflight_probe docker-client docker version --format '{{json .Client}}' || return 1
  ex_pf_docker_client=$(jq -er '.Version | select(type == "string" and test("^[0-9]+[.][0-9]+[.][0-9]+([.+-][A-Za-z0-9.-]+)?$"))' "$EX_OPERATION_DIR/.private/preflight-docker-client.stdout" 2>/dev/null) || return 1
  ex_preflight_probe docker-server docker version --format '{{json .Server}}' || return 1
  ex_pf_docker_server=$(jq -er '.Version | select(type == "string" and test("^[0-9]+[.][0-9]+[.][0-9]+([.+-][A-Za-z0-9.-]+)?$"))' "$EX_OPERATION_DIR/.private/preflight-docker-server.stdout" 2>/dev/null) || return 1
  ex_record_update '.tools.dockerClient={observed:$client} | .tools.dockerServer={observed:$server,status:"available"}' \
    --arg client "$ex_pf_docker_client" --arg server "$ex_pf_docker_server" || return 1

  ex_preflight_probe kind env KIND_EXPERIMENTAL_PROVIDER=docker kind version || return 1
  ex_pf_kind=$(sed -n 's/^kind v\([0-9][0-9.]*\)\([[:space:]].*\)\{0,1\}$/\1/p' "$EX_OPERATION_DIR/.private/preflight-kind.stdout")
  ex_preflight_version kind "$ex_pf_kind" 0.33.0 || return 1

  ex_preflight_probe kubernetes env KUBECTL_KUBERC=false kubectl \
    "--kubeconfig=$EX_KUBECONFIG" "--context=$EX_KUBERNETES_CONTEXT" \
    --request-timeout=10s version --output=json || return 1
  ex_pf_client=$(jq -er '.clientVersion.gitVersion | select(type == "string" and test("^v[0-9]+[.][0-9]+[.][0-9]+([.+-][A-Za-z0-9.-]+)?$")) | ltrimstr("v")' "$EX_OPERATION_DIR/.private/preflight-kubernetes.stdout" 2>/dev/null) || return 1
  ex_pf_server=$(jq -er '.serverVersion.gitVersion | select(type == "string" and test("^v[0-9]+[.][0-9]+[.][0-9]+([.+-][A-Za-z0-9.-]+)?$")) | ltrimstr("v")' "$EX_OPERATION_DIR/.private/preflight-kubernetes.stdout" 2>/dev/null) || return 1
  ex_preflight_version kubectl "$ex_pf_client" 1.37.0 || return 1
  ex_preflight_version kubernetes "$ex_pf_server" 1.37.0 || return 1

  ex_preflight_probe terraform env TF_CLI_ARGS= TF_CLI_ARGS_version= TF_LOG=off TF_LOG_PATH= TF_CLI_CONFIG_FILE=/dev/null terraform version -json || return 1
  ex_pf_terraform=$(jq -er '.terraform_version | select(type == "string" and test("^[0-9]+[.][0-9]+[.][0-9]+([.+-][A-Za-z0-9.-]+)?$"))' "$EX_OPERATION_DIR/.private/preflight-terraform.stdout" 2>/dev/null) || return 1
  ex_preflight_version terraform "$ex_pf_terraform" 1.16.5 || return 1
  ex_record_update '.tools.kubernetesProvider={source:"hashicorp/kubernetes",required:"3.2.1",observed:null,status:"not-initialized"}' || return 1
  ex_preflight_access || return 1
  ex_event tools passed 'Native executable and server versions were observed; provider installation is deferred until explicit preparation.'
}
