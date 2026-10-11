#!/bin/sh
set -eu
printf 'kubectl %s\n' "$*" >>"$EX_FIXTURE_STATE/calls"
if [ -n "${EX_FIXTURE_KUBECTL_FAIL:-}" ] && printf '%s' "$*" | grep -Fq "$EX_FIXTURE_KUBECTL_FAIL"; then printf 'fixture unavailable\n' >&2; exit 1; fi
while [ "$#" -gt 0 ]; do
  case "$1" in --kubeconfig=*) fixture_config=${1#--kubeconfig=}; shift ;; --context=*|--namespace=*|--request-timeout=*|--cache-dir=*) shift ;; *) break ;; esac
done
command_name=${1:-}; [ "$#" -eq 0 ] || shift
case "$command_name" in
  version) printf '{"clientVersion":{"gitVersion":"v1.37.0"},"serverVersion":{"gitVersion":"v1.37.0"}}\n' ;;
  config) cat "${fixture_config:-$KUBECONFIG}" ;;
  cluster-info) printf 'Kubernetes control plane fixture\n' ;;
  auth) printf 'yes\n' ;;
  patch)
    while [ "$#" -gt 0 ]; do
      case "$1" in -f|--filename) manifest=$2; shift 2 ;; *) shift ;; esac
    done
    if [ -d "$manifest" ]; then find "$manifest" -type f -name '*.json' -exec cat '{}' \;; else cat "$manifest"; fi
    ;;
  api-resources) printf 'deployments.apps\nservices\nreplicasets.apps\npods\nconfigmaps\nserviceaccounts\nresourcequotas\n' ;;
  get)
    kind=${1:-}; [ "$#" -eq 0 ] || shift
    case "$kind" in
      namespace|namespaces|ns)
        if [ -f "$EX_FIXTURE_STATE/namespace.json" ]; then cat "$EX_FIXTURE_STATE/namespace.json"; fi ;;
      Deployment|deployment|deployments|deployments.apps|Service|service|services)
        key=$kind
        case "$kind" in Deployment|deployment*) key=deployment ;; Service|service*) key=service ;; esac
        name=${1:-}
        case "$name" in ''|-*)
          if [ "$key" = deployment ]; then pattern='deployment-*.json'; else pattern='service-*.json'; fi
          find "$EX_FIXTURE_STATE" -name "$pattern" -exec cat '{}' \; | jq -s '{apiVersion:"v1",kind:"List",items:.}' ;;
          *) if [ -f "$EX_FIXTURE_STATE/$key-$name.json" ]; then cat "$EX_FIXTURE_STATE/$key-$name.json"; fi ;;
        esac ;;
      pods)
        find "$EX_FIXTURE_STATE" -name 'deployment-*.json' -exec cat '{}' \; | jq -s '{apiVersion:"v1",kind:"List",items:map({apiVersion:"v1",kind:"Pod",metadata:{name:(.metadata.name+"-pod"),namespace:.metadata.namespace,uid:(.metadata.uid+"-pod"),labels:.spec.template.metadata.labels,ownerReferences:[{kind:"ReplicaSet",uid:("rs-"+.metadata.uid),controller:true}]},spec:.spec.template.spec,status:{phase:"Running",containerStatuses:[{name:"website",ready:true,imageID:"containerd://sha256:fixture",restartCount:0}]}})}' ;;
      replicasets|replicasets.apps)
        find "$EX_FIXTURE_STATE" -name 'deployment-*.json' -exec cat '{}' \; | jq -s '{apiVersion:"apps/v1",kind:"ReplicaSetList",items:map({kind:"ReplicaSet",metadata:{name:(.metadata.name+"-rs"),uid:("rs-"+.metadata.uid),labels:.spec.template.metadata.labels,ownerReferences:[{kind:"Deployment",uid:.metadata.uid,controller:true}]}})}' ;;
      resourcequotas|resourcequota) if [ -f "$EX_FIXTURE_STATE/quota.json" ]; then jq '{apiVersion:"v1",kind:"List",items:[.]}' "$EX_FIXTURE_STATE/quota.json"; else printf '{"items":[]}\n'; fi ;;
      events) if [ -f "$EX_FIXTURE_STATE/events.json" ]; then cat "$EX_FIXTURE_STATE/events.json"; else printf '{"items":[]}\n'; fi ;;
      --raw) printf 'metrics unavailable\n' >&2; exit 1 ;;
      services,deployments*|deployments,services*) find "$EX_FIXTURE_STATE" -name 'deployment-*.json' -o -name 'service-*.json' | while IFS= read -r p; do cat "$p"; done | jq -s '{items:.}' ;;
      *) if [ -f "$EX_FIXTURE_STATE/foreign.json" ]; then cat "$EX_FIXTURE_STATE/foreign.json"; else printf '{"items":[]}\n'; fi ;;
    esac ;;
  apply)
    while [ "$#" -gt 0 ]; do case "$1" in -f|--filename) file=$2; shift 2 ;; *) shift ;; esac; done
    jq 'if .kind=="List" then .items[] else . end' "$file" | jq -c '.' | while IFS= read -r object; do
      name=$(printf '%s' "$object" | jq -r '.metadata.name')
      kind=$(printf '%s' "$object" | jq -r '.kind | ascii_downcase')
      printf '%s' "$object" | jq --arg uid "fixture-$kind-$name" '.metadata.uid=$uid | .metadata.generation=1 | if .kind=="Deployment" then .status={observedGeneration:1,readyReplicas:.spec.replicas,availableReplicas:.spec.replicas,updatedReplicas:.spec.replicas,replicas:.spec.replicas} else . end' >"$EX_FIXTURE_STATE/$kind-$name.json"
      printf '%s/%s configured\n' "$kind" "$name"
    done ;;
  rollout|wait)
    [ "${EX_FIXTURE_READY_FAIL:-}" != 1 ] || { printf 'fixture readiness timeout\n' >&2; exit 1; }
    printf 'condition met\n' ;;
  delete)
    case "$1" in
      --raw=*) raw=${1#--raw=}; name=${raw##*/}; kind=$(printf '%s' "$raw" | awk -F/ '{print $(NF-1)}'); shift
        while [ "$#" -gt 0 ]; do case "$1" in --filename|-f) options=$2; shift 2 ;; *) shift ;; esac; done ;;
      *) kind=$1; name=$2 ;;
    esac
    case "$kind" in deployment*|Deployment) key=deployment ;; service*|Service) key=service ;; *) exit 2 ;; esac
    [ "${EX_FIXTURE_DELETE_FAIL:-}" != 1 ] || exit 1
    if [ -n "${options:-}" ]; then
      jq -e --slurpfile options "$options" '.metadata.uid==$options[0].preconditions.uid' "$EX_FIXTURE_STATE/$key-$name.json" >/dev/null || exit 1
    fi
    rm -f "$EX_FIXTURE_STATE/$key-$name.json"
    printf '%s deleted\n' "$name" ;;
  logs) printf 'website fixture ready\n' ;;
  top) printf 'metrics unavailable\n' >&2; exit 1 ;;
  port-forward) printf 'Forwarding from 127.0.0.1\n'; sleep 2 ;;
  *) printf 'unsupported fixture kubectl: %s\n' "$command_name" >&2; exit 2 ;;
esac
