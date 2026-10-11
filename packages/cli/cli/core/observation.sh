#!/bin/sh

# Native outputs stay private. Published observations use explicit field allowlists.
ex_observation_failure() {
  printf 'ex: %s\n' "$1" >&2
  return 1
}

ex_local_target() {
  case "$EX_KUBERNETES_CONTEXT" in
    kind-?*) EX_KIND_CLUSTER=${EX_KUBERNETES_CONTEXT#kind-} ;;
    *) ex_observation_failure 'The local pilot requires an explicit kind-<cluster> context; aliases and other targets are unsupported.'; return 1 ;;
  esac
  case "${DOCKER_HOST:-}" in
    ''|unix://*) ;;
    *) ex_observation_failure 'The local pilot requires a local Docker Unix socket; remote DOCKER_HOST is unsupported.'; return 1 ;;
  esac
  mkdir -p "$EX_OPERATION_DIR/.private" || return 1
  ex_ob_private="$EX_OPERATION_DIR/.private"
  if ! ex_bounded 15 "$ex_ob_private/docker-endpoint" "$ex_ob_private/docker-error" docker context inspect --format '{{.Endpoints.docker.Host}}'; then
    ex_observation_failure 'Cannot inspect the selected Docker endpoint.'; return 1
  fi
  ex_ob_endpoint=$(cat "$ex_ob_private/docker-endpoint")
  case "$ex_ob_endpoint" in
    unix://?*) ;;
    *) ex_observation_failure 'The selected Docker context is not a local Unix socket.'; return 1 ;;
  esac
  if ! ex_bounded 15 "$ex_ob_private/kind-clusters" "$ex_ob_private/kind-error" env KIND_EXPERIMENTAL_PROVIDER=docker kind get clusters; then
    ex_observation_failure 'Cannot enumerate kind clusters on the local Docker engine.'; return 1
  fi
  if ! grep -Fxq "$EX_KIND_CLUSTER" "$ex_ob_private/kind-clusters"; then
    ex_observation_failure 'The explicitly selected kind cluster is not present in the local Docker engine.'; return 1
  fi
  if ! ex_bounded 15 "$ex_ob_private/selected-config.json" "$ex_ob_private/kubeconfig-error" env KUBECTL_KUBERC=false kubectl --context="$EX_KUBERNETES_CONTEXT" config view --minify --flatten --raw --output=json; then
    ex_observation_failure 'Cannot read the explicitly selected Kubernetes context.'; return 1
  fi
  if ! jq -e '
    (.clusters | length == 1) and (.contexts | length == 1)
    and all(.users[]?; (.user | has("exec") or has("auth-provider")) | not)
    and (.clusters[0].cluster | (."insecure-skip-tls-verify" != true)
      and (."proxy-url" // "" | length == 0)
      and (."certificate-authority-data" | type == "string" and length > 0)
      and (.server | type == "string" and test("^https://(127\\.0\\.0\\.1|\\[::1\\]):[0-9]+$")))
  ' "$ex_ob_private/selected-config.json" >/dev/null 2>&1; then
    ex_observation_failure 'Local proof requires a loopback HTTPS endpoint, verified CA, and static credentials; credential plugins, proxies, and insecure TLS are unsupported.'; return 1
  fi
  if ! ex_bounded 15 "$ex_ob_private/kind.kubeconfig" "$ex_ob_private/kind-error" env KIND_EXPERIMENTAL_PROVIDER=docker kind get kubeconfig --name "$EX_KIND_CLUSTER"; then
    ex_observation_failure 'Cannot obtain the selected kind cluster identity.'; return 1
  fi
  if ! ex_bounded 15 "$ex_ob_private/kind-config.json" "$ex_ob_private/kubeconfig-error" env KUBECTL_KUBERC=false kubectl --kubeconfig="$ex_ob_private/kind.kubeconfig" --context="$EX_KUBERNETES_CONTEXT" config view --minify --flatten --raw --output=json; then
    ex_observation_failure 'Cannot resolve the kind cluster kubeconfig.'; return 1
  fi
  if ! jq -en --slurpfile selected "$ex_ob_private/selected-config.json" --slurpfile actual "$ex_ob_private/kind-config.json" '
    ($selected[0].clusters[0].cluster | {server, ca:."certificate-authority-data"})
      == ($actual[0].clusters[0].cluster | {server, ca:."certificate-authority-data"})
  ' >/dev/null; then
    ex_observation_failure 'The selected context server and CA do not match the local kind cluster; a context name alone is insufficient.'; return 1
  fi
  EX_KUBECONFIG="$ex_ob_private/target.kubeconfig"
  # kind supplies identity proof only. Preserve the consumer's selected
  # credentials so an admin kubeconfig cannot expand their effective access.
  cp "$ex_ob_private/selected-config.json" "$EX_KUBECONFIG" || return 1
  chmod 600 "$EX_KUBECONFIG" || return 1
  jq -r '.clusters[0].cluster."certificate-authority-data"' "$ex_ob_private/selected-config.json" >"$ex_ob_private/ca.base64" || return 1
  if ! base64 --decode <"$ex_ob_private/ca.base64" >"$ex_ob_private/ca.bytes" 2>/dev/null; then
    ex_observation_failure 'The selected cluster CA data is not valid base64.'; return 1
  fi
  ex_ob_ca_hash=$(ex_hash "$ex_ob_private/ca.bytes") || return 1
  jq --arg cluster "$EX_KIND_CLUSTER" --arg context "$EX_KUBERNETES_CONTEXT" --arg ca "$ex_ob_ca_hash" '
    {kindCluster:$cluster,context:$context,server:.clusters[0].cluster.server,
      caSha256:$ca,identity:"server-and-ca-matched",containerEndpoint:"local-unix-socket"}
  ' "$ex_ob_private/selected-config.json" >"$EX_OPERATION_DIR/target.json" || return 1
  rm -f "$ex_ob_private/selected-config.json" "$ex_ob_private/kind-config.json" "$ex_ob_private/ca.base64" "$ex_ob_private/ca.bytes"
  export EX_KIND_CLUSTER EX_KUBECONFIG
}

ex_manifest_inventory() (
  ex_ob_destination=$1
  ex_ob_private="$EX_OPERATION_DIR/.private"
  mkdir -p "$ex_ob_private" || exit 1
  : >"$ex_ob_private/inventory.ndjson"
  jq -r '.units | keys[]' "$EX_RUNTIME_SCHEMA" >"$ex_ob_private/units"
  while IFS= read -r ex_ob_unit; do
    ex_ob_relative=$(jq -r --arg unit "$ex_ob_unit" '.units[$unit].kubernetes.manifests' "$EX_RUNTIME_SCHEMA")
    ex_ob_path=$(ex_resolve_path "$EX_RUNTIME_DIR" "$ex_ob_relative") || exit 1
    if [ -n "$(find "$ex_ob_path" -type l -print)" ]; then
      ex_observation_failure "Unit $ex_ob_unit contains manifest symlinks; use ordinary files within the runtime."; exit 1
    fi
    if ! ex_bounded 15 "$ex_ob_private/parsed.json" "$ex_ob_private/manifest-error" env KUBECTL_KUBERC=false kubectl --kubeconfig=/dev/null patch --local --type=merge --patch='{}' --recursive --filename "$ex_ob_path" --output=json; then
      ex_observation_failure "Cannot parse every native manifest for unit $ex_ob_unit. Supported files are JSON, YAML, or YML."; exit 1
    fi
    if ! jq -s --arg unit "$ex_ob_unit" --arg namespace "$EX_KUBERNETES_NAMESPACE" --arg owner "$EX_OWNER_TOKEN" '
      def name: type == "string" and length <= 63 and test("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$");
      def positive: type == "number" and floor == . and . > 0;
      def quantity: type == "string" and test("^[0-9]+(\\.[0-9]+)?([numkKMGTEP]i?)?$");
      def resources:
        type == "object" and (.requests | type == "object") and (.limits | type == "object")
        and all(.requests.cpu,.requests.memory,.limits.cpu,.limits.memory; quantity);
      def container:
        (.name | name) and (.image | type == "string" and length > 0 and test("^[^[:space:]]+$"))
        and (.imagePullPolicy == "Never" or .imagePullPolicy == "IfNotPresent")
        and (.resources | resources)
        and (.securityContext.privileged != true)
        and ((.securityContext.capabilities.add // []) | length == 0);
      def probe:
        type == "object" and (([.httpGet,.tcpSocket,.exec,.grpc] | map(select(. != null)) | length) == 1);
      [ .[] | if .kind == "List" and .apiVersion == "v1" and (.items | type == "array") then .items[] else . end ]
      | if length == 0 then error("empty native resource set") else . end
      | map(. as $manifest |
        if (type != "object") or
          ((.apiVersion != "apps/v1" or .kind != "Deployment") and (.apiVersion != "v1" or .kind != "Service"))
          then error("only apps/v1 Deployment and v1 Service are supported") else . end
        | if (.metadata.name | name | not) or (.metadata.generateName != null)
          or (.metadata.uid != null) or (.metadata.resourceVersion != null)
          or ((.metadata.managedFields // []) | length > 0)
          or ((.metadata.namespace // $namespace) != $namespace)
          or ((.metadata.ownerReferences // []) | length > 0)
          or ((.metadata.finalizers // []) | length > 0)
          or (.status != null)
          or ((.metadata.labels["exphere.dev/owner"] // $owner) != $owner)
          then error("invalid identity, namespace, or reserved ownership") else . end
        | if .kind == "Deployment" then
          if (.spec.replicas | positive | not)
            or (.spec.selector.matchLabels | type != "object" or length == 0)
            or ((.spec.selector.matchExpressions // []) | length > 0)
            or (.spec.template.metadata.labels | type != "object")
            or (all(.spec.selector.matchLabels | to_entries[]; . as $entry | $manifest.spec.template.metadata.labels[$entry.key] == $entry.value) | not)
            or (.spec.template.spec.hostNetwork == true) or (.spec.template.spec.hostPID == true) or (.spec.template.spec.hostIPC == true)
            or (any(.spec.template.spec.volumes[]?;
              ((keys - ["name","emptyDir","configMap","secret","projected","downwardAPI"]) | length > 0)
              or ((keys - ["name"]) | length != 1)))
            or (.spec.template.spec.containers | type != "array" or length == 0)
            or (all(.spec.template.spec.containers[]; container and (.readinessProbe | probe)) | not)
            or (all(.spec.template.spec.initContainers[]?; container) | not)
            or ((.spec.template.metadata.labels["exphere.dev/owner"] // $owner) != $owner)
          then error("unsupported Deployment: explicit replicas, matching labels, prebuilt local images, resources, readiness, and stateless unprivileged containers are required") else . end
        else
          if ((.spec.type // "ClusterIP") != "ClusterIP")
            or ((.spec.externalIPs // []) | length > 0)
            or (.spec.selector | type != "object" or length == 0)
            or (.spec.ports | type != "array" or length == 0)
            or (all(.spec.ports[]; (.port | positive and . <= 65535) and ((.targetPort // .port) | (type == "number" and positive and . <= 65535) or name)) | not)
          then error("unsupported Service: a ClusterIP selector and valid ports are required") else . end
        end
        | .metadata.namespace = $namespace
        | .metadata.labels["exphere.dev/owner"] = $owner
        | if .kind == "Deployment" then .spec.template.metadata.labels["exphere.dev/owner"] = $owner
          else .spec.selector["exphere.dev/owner"] = $owner end
        | {unit:$unit,apiVersion,kind,name:.metadata.name,namespace:$namespace,manifest:.})
      | .[]
    ' "$ex_ob_private/parsed.json" >>"$ex_ob_private/inventory.ndjson" 2>"$ex_ob_private/validation-error"; then
      ex_observation_failure "Unsupported native resources for unit $ex_ob_unit: check kinds, unique identities, namespace, ownership, selectors, stateless volumes, images, resources, and readiness."; exit 1
    fi
  done <"$ex_ob_private/units"
  if ! jq -s -e '
    . as $all
    | if length > 64 then error("the local pilot supports at most 64 workload resources") else . end
    | if (group_by([.namespace,.kind,.name]) | any(length > 1)) then error("duplicate identity") else . end
    | if (group_by(.unit) | any(all(.kind != "Deployment"))) then error("unit has no Deployment") else . end
    | if any(.[] | select(.kind == "Service"); . as $service |
      [$all[] | select(.kind == "Deployment") | . as $deployment
        | select(all($service.manifest.spec.selector | to_entries[]; . as $entry | $deployment.manifest.spec.template.metadata.labels[$entry.key] == $entry.value))]
      | length == 0 or any(.unit != $service.unit)) then error("Service selector crosses or misses its unit") else . end
    | sort_by(.unit,.kind,.name)
  ' "$ex_ob_private/inventory.ndjson" >"$ex_ob_destination" 2>"$ex_ob_private/validation-error"; then
    ex_observation_failure 'At most 64 workload resources are supported. Identities must be unique across units; each unit needs a Deployment and Services must select Deployments in their own unit.'; exit 1
  fi
)

ex_observe_inventory() (
  ex_ob_inventory=$1
  ex_ob_destination=$2
  ex_ob_private="$EX_OPERATION_DIR/.private"
  ex_ob_failed=0
  : >"$ex_ob_private/observed.ndjson"
  jq -c '.[]' "$ex_ob_inventory" >"$ex_ob_private/desired.ndjson" || exit 1
  while IFS= read -r ex_ob_item; do
    ex_ob_kind=$(printf '%s\n' "$ex_ob_item" | jq -r '.kind')
    ex_ob_name=$(printf '%s\n' "$ex_ob_item" | jq -r '.name')
    printf '%s\n' "$ex_ob_item" >"$ex_ob_private/desired-object.json"
    if ! ex_bounded 15 "$ex_ob_private/live-object.json" "$ex_ob_private/observe-error" env KUBECTL_KUBERC=false kubectl --kubeconfig="$EX_KUBECONFIG" --context="$EX_KUBERNETES_CONTEXT" --namespace="$EX_KUBERNETES_NAMESPACE" --request-timeout=10s get "$ex_ob_kind" "$ex_ob_name" --ignore-not-found --output=json; then
      jq '{unit,kind,name,namespace,state:"unavailable",ownership:"unknown",readiness:"unavailable"}' "$ex_ob_private/desired-object.json" >>"$ex_ob_private/observed.ndjson"
      ex_ob_failed=1
      continue
    fi
    if [ ! -s "$ex_ob_private/live-object.json" ]; then
      jq '{unit,kind,name,namespace,state:"absent",ownership:"absent",readiness:"not-running"}' "$ex_ob_private/desired-object.json" >>"$ex_ob_private/observed.ndjson"
      continue
    fi
    if ! jq --arg owner "$EX_OWNER_TOKEN" --slurpfile desired "$ex_ob_private/desired-object.json" '
      def resource_config:
        {requests:{cpu:.requests.cpu,memory:.requests.memory,ephemeralStorage:.requests."ephemeral-storage"},
         limits:{cpu:.limits.cpu,memory:.limits.memory,ephemeralStorage:.limits."ephemeral-storage"}};
      if .kind != $desired[0].kind or .metadata.name != $desired[0].name
        or .metadata.namespace != $desired[0].namespace then error("unexpected live identity") else . end
      | {unit:$desired[0].unit,kind,name:.metadata.name,namespace:.metadata.namespace,
         uid:.metadata.uid,state:"present",
         ownership:(if .metadata.labels["exphere.dev/owner"] == $owner then "owned" else "foreign" end),
         readiness:(if .kind != "Deployment" then "not-applicable"
           elif (.status.observedGeneration // 0) >= (.metadata.generation // 1)
             and (.status.updatedReplicas // 0) == .spec.replicas
             and (.status.availableReplicas // 0) == .spec.replicas
             and (.status.replicas // 0) == .spec.replicas then "ready" else "not-ready" end),
         conditions:[.status.conditions[]? | {type,status,reason}],
         configured:(if .kind == "Deployment" then
           {replicas:.spec.replicas,containers:[.spec.template.spec.containers[] | {name,image,resources:(.resources | resource_config)}],
            initContainers:[.spec.template.spec.initContainers[]? | {name,image,resources:(.resources | resource_config)}]}
           else {type:(.spec.type // "ClusterIP"),ports:[.spec.ports[]? | {name,port,targetPort,protocol}]} end)}
    ' "$ex_ob_private/live-object.json" >>"$ex_ob_private/observed.ndjson" 2>"$ex_ob_private/observe-error"; then
      jq '{unit,kind,name,namespace,state:"unavailable",ownership:"unknown",readiness:"unavailable"}' "$ex_ob_private/desired-object.json" >>"$ex_ob_private/observed.ndjson"
      ex_ob_failed=1
    fi
  done <"$ex_ob_private/desired.ndjson"
  jq -s . "$ex_ob_private/observed.ndjson" >"$ex_ob_private/resources.json" || exit 1

  printf '{"state":"unavailable","reason":"native-query-failed","items":[]}\n' >"$ex_ob_private/replicasets.json"
  if ex_bounded 15 "$ex_ob_private/replicasets-raw.json" "$ex_ob_private/observe-error" env KUBECTL_KUBERC=false kubectl --kubeconfig="$EX_KUBECONFIG" --context="$EX_KUBERNETES_CONTEXT" --namespace="$EX_KUBERNETES_NAMESPACE" --request-timeout=10s get replicasets --selector="exphere.dev/owner=$EX_OWNER_TOKEN" --output=json; then
    if jq --arg owner "$EX_OWNER_TOKEN" --slurpfile resources "$ex_ob_private/resources.json" '
      [$resources[0][] | select(.kind == "Deployment" and .ownership == "owned") | .uid] as $deployments
      | {state:"observed",items:[.items[] |
        select(.metadata.labels["exphere.dev/owner"] == $owner)
        | select(any(.metadata.ownerReferences[]?; .kind == "Deployment" and .controller == true and (.uid as $uid | $deployments | index($uid))))
        | {name:.metadata.name,uid:.metadata.uid}]}
    ' "$ex_ob_private/replicasets-raw.json" >"$ex_ob_private/replicasets.next.json" 2>"$ex_ob_private/observe-error"; then
      mv "$ex_ob_private/replicasets.next.json" "$ex_ob_private/replicasets.json"
    else
      ex_ob_failed=1
    fi
  else
    ex_ob_failed=1
  fi

  printf '{"state":"unavailable","reason":"native-query-failed","items":[]}\n' >"$ex_ob_private/pods.json"
  if ex_bounded 15 "$ex_ob_private/pods-raw.json" "$ex_ob_private/observe-error" env KUBECTL_KUBERC=false kubectl --kubeconfig="$EX_KUBECONFIG" --context="$EX_KUBERNETES_CONTEXT" --namespace="$EX_KUBERNETES_NAMESPACE" --request-timeout=10s get pods --selector="exphere.dev/owner=$EX_OWNER_TOKEN" --output=json; then
    if ! jq --arg owner "$EX_OWNER_TOKEN" --slurpfile resources "$ex_ob_private/resources.json" --slurpfile replicasets "$ex_ob_private/replicasets.json" '
      ([$resources[0][] | select(.kind == "Deployment" and .ownership == "owned") | .uid] + [$replicasets[0].items[].uid]) as $controllers
      |
      {state:"observed",items:[.items[] | select(.metadata.labels["exphere.dev/owner"] == $owner) |
        select(any(.metadata.ownerReferences[]?; .uid as $uid | $controllers | index($uid))) |
        {name:.metadata.name,uid:.metadata.uid,phase:.status.phase,
         conditions:[.status.conditions[]? | {type,status,reason}],
         containers:[(.status.containerStatuses[]?,.status.initContainerStatuses[]?) |
           {name,image,imageID,ready,restartCount,
            waitingReason:.state.waiting.reason,terminatedReason:.state.terminated.reason,
            exitCode:.state.terminated.exitCode}]}]}
    ' "$ex_ob_private/pods-raw.json" >"$ex_ob_private/pods.next.json" 2>"$ex_ob_private/observe-error"; then
      ex_ob_failed=1
    else
      mv "$ex_ob_private/pods.next.json" "$ex_ob_private/pods.json"
    fi
  else
    ex_ob_failed=1
  fi

  printf '{"state":"unavailable","reason":"native-query-failed","items":[]}\n' >"$ex_ob_private/events.json"
  if ex_bounded 15 "$ex_ob_private/events-raw.json" "$ex_ob_private/observe-error" env KUBECTL_KUBERC=false kubectl --kubeconfig="$EX_KUBECONFIG" --context="$EX_KUBERNETES_CONTEXT" --namespace="$EX_KUBERNETES_NAMESPACE" --request-timeout=10s get events --output=json; then
    if jq --slurpfile resources "$ex_ob_private/resources.json" --slurpfile replicasets "$ex_ob_private/replicasets.json" --slurpfile pods "$ex_ob_private/pods.json" '
      ([$resources[0][] | .uid // empty] + [$replicasets[0].items[].uid] + [$pods[0].items[] | .uid // empty]) as $uids
      | {state:"observed",content:"messages-omitted",items:[.items[] |
          select(.involvedObject.uid as $uid | $uids | index($uid)) |
          {type,reason,count,firstTimestamp,lastTimestamp,quotaMentioned:((.message // "") | contains("exceeded quota:")),
           object:{kind:.involvedObject.kind,name:.involvedObject.name,uid:.involvedObject.uid}}][:100]}
    ' "$ex_ob_private/events-raw.json" >"$ex_ob_private/events.next.json" 2>"$ex_ob_private/observe-error"; then
      mv "$ex_ob_private/events.next.json" "$ex_ob_private/events.json"
    else
      ex_ob_failed=1
    fi
  else
    ex_ob_failed=1
  fi

  printf '{"state":"unavailable","reason":"native-query-failed","items":[]}\n' >"$ex_ob_private/quotas.json"
  if ex_bounded 15 "$ex_ob_private/quotas-raw.json" "$ex_ob_private/observe-error" env KUBECTL_KUBERC=false kubectl --kubeconfig="$EX_KUBECONFIG" --context="$EX_KUBERNETES_CONTEXT" --namespace="$EX_KUBERNETES_NAMESPACE" --request-timeout=10s get resourcequotas --output=json; then
    if jq '{state:"observed",source:"Kubernetes ResourceQuota",items:[.items[] | {name:.metadata.name,configured:.spec.hard,accounted:.status.used}]}' "$ex_ob_private/quotas-raw.json" >"$ex_ob_private/quotas.next.json" 2>"$ex_ob_private/observe-error"; then
      mv "$ex_ob_private/quotas.next.json" "$ex_ob_private/quotas.json"
    else
      ex_ob_failed=1
    fi
  else
    ex_ob_failed=1
  fi

  printf '{"state":"unavailable","source":"metrics.k8s.io","reason":"metrics-api-unavailable","items":[]}\n' >"$ex_ob_private/metrics.json"
  if ex_bounded 15 "$ex_ob_private/metrics-raw.json" "$ex_ob_private/observe-error" env KUBECTL_KUBERC=false kubectl --kubeconfig="$EX_KUBECONFIG" --context="$EX_KUBERNETES_CONTEXT" --namespace="$EX_KUBERNETES_NAMESPACE" --request-timeout=10s get --raw "/apis/metrics.k8s.io/v1beta1/namespaces/$EX_KUBERNETES_NAMESPACE/pods"; then
    if jq --slurpfile pods "$ex_ob_private/pods.json" '
      [$pods[0].items[].name] as $names
      | {state:"observed",source:"metrics.k8s.io",items:[.items[] |
        select(.metadata.name as $name | $names | index($name)) |
        {name:.metadata.name,timestamp,window,containers:[.containers[] | {name,usage:{cpu:.usage.cpu,memory:.usage.memory}}]}]}
    ' "$ex_ob_private/metrics-raw.json" >"$ex_ob_private/metrics.next.json" 2>"$ex_ob_private/observe-error"; then
      mv "$ex_ob_private/metrics.next.json" "$ex_ob_private/metrics.json"
    fi
  fi
  jq -n --slurpfile desired "$ex_ob_inventory" --slurpfile resources "$ex_ob_private/resources.json" --slurpfile replicasets "$ex_ob_private/replicasets.json" --slurpfile pods "$ex_ob_private/pods.json" --slurpfile events "$ex_ob_private/events.json" --slurpfile quotas "$ex_ob_private/quotas.json" --slurpfile metrics "$ex_ob_private/metrics.json" '
    def resource_config:
      {requests:{cpu:.requests.cpu,memory:.requests.memory,ephemeralStorage:.requests."ephemeral-storage"},
       limits:{cpu:.limits.cpu,memory:.limits.memory,ephemeralStorage:.limits."ephemeral-storage"}};
    {configured:[$desired[0][] | {unit,kind,name,namespace} +
      (if .manifest == null then {state:"unavailable",reason:"native-input-not-in-current-configuration"}
       elif .kind == "Deployment" then
        {replicas:.manifest.spec.replicas,containers:[.manifest.spec.template.spec.containers[] |
          {name,image,imagePullPolicy,resources:(.resources | resource_config)}],
         initContainers:[.manifest.spec.template.spec.initContainers[]? |
          {name,image,imagePullPolicy,resources:(.resources | resource_config)}]}
       else {ports:[.manifest.spec.ports[] | {name,port,targetPort,protocol}]} end)],
     resources:$resources[0],replicaSets:$replicasets[0],pods:$pods[0],events:$events[0],quotas:$quotas[0],usage:$metrics[0],
     ownedUids:(([$resources[0][] | select(.ownership == "owned") | .uid] + [$replicasets[0].items[].uid] + [$pods[0].items[].uid]) | unique),
     logs:{state:"not-collected",reason:"use-explicit-logs-command; content-can-contain-secrets"},
     monetary:{state:"unavailable",reason:"no-billing-source"},load:{state:"not-run"}}
  ' >"$ex_ob_destination" || exit 1
  exit "$ex_ob_failed"
)
