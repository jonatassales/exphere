#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"

[ -n "$EX_KUBERNETES_MANIFESTS" ] || ex_die 'Kubernetes is not configured for this microruntime.' 2
[ "$#" -eq 1 ] || ex_die 'Usage: ex runtime <id> kubernetes <diff|apply|delete|status>' 2
case "$1" in
  diff|apply|delete) ex_kubernetes_command=$1 ;;
  status) ex_kubernetes_command=get ;;
  *) ex_die "Unsupported Kubernetes command: $1" 2 ;;
esac
ex_need kubectl
cd "$EX_RUNTIME_DIR"
exec kubectl "--context=$EX_KUBERNETES_CONTEXT" "--namespace=$EX_KUBERNETES_NAMESPACE" \
  "$ex_kubernetes_command" --filename "$EX_KUBERNETES_MANIFESTS"
