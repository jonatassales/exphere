#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"
. "$EX_CLI_DIR/core/runtime.sh"

[ "$#" -ge 1 ] || ex_die 'Usage: ex runtime <list|id operation>. Run ex --help.' 2
if [ "$1" = list ] && [ "$#" -eq 1 ]; then
  [ -e "$EX_PROJECT_ROOT/.micro-runtime" ] || exit 0
  EX_RUNTIMES_DIR=$(ex_resolve_path "$EX_PROJECT_ROOT" .micro-runtime)
  [ -d "$EX_RUNTIMES_DIR" ] || ex_die '.micro-runtime must be a directory.' 2
  for ex_candidate in "$EX_RUNTIMES_DIR"/*; do
    [ -d "$ex_candidate" ] && [ -f "$ex_candidate/schema.json" ] || continue
    ex_candidate_id=$(basename "$ex_candidate")
    ex_valid_id "$ex_candidate_id" || continue
    printf '%s\n' "$ex_candidate_id"
  done
  exit 0
fi

[ "$#" -ge 2 ] || ex_die 'An explicit runtime operation is required.' 2
ex_runtime_id=$1
ex_operation=$2
shift 2
case "$ex_operation" in
  init|validate) [ "$#" -eq 0 ] || ex_die "$ex_operation does not accept arguments." 2 ;;
  terraform|kubernetes|run) [ "$#" -ge 1 ] || ex_die "Missing $ex_operation command or hook." 2 ;;
  *) ex_die "Unknown runtime operation: $ex_operation" 2 ;;
esac

if [ "$ex_operation" = init ]; then
  ex_init_runtime "$ex_runtime_id"
  exit 0
fi
EX_RUNTIMES_DIR=$(ex_resolve_path "$EX_PROJECT_ROOT" .micro-runtime)
[ -d "$EX_RUNTIMES_DIR" ] || ex_die '.micro-runtime must be a directory.' 2
ex_load_runtime "$ex_runtime_id"
case "$ex_operation" in
  validate) printf 'ex: microruntime %s has a valid descriptor and local paths.\n' "$EX_RUNTIME_ID" ;;
  terraform|kubernetes) exec sh "$EX_CLI_DIR/adapters/$ex_operation.sh" "$@" ;;
  run)
    ex_hook_name=$1
    shift
    ex_valid_id "$ex_hook_name" || ex_die 'Invalid hook name.' 2
    ex_hook_relative=$(jq -er --arg name "$ex_hook_name" '.hooks[$name] // empty' "$EX_RUNTIME_SCHEMA") || ex_die "Hook not configured: $ex_hook_name" 2
    ex_hook_path=$(ex_resolve_path "$EX_RUNTIME_DIR" "$ex_hook_relative")
    [ "${1:-}" != -- ] || shift
    cd "$EX_RUNTIME_DIR"
    exec sh "$ex_hook_path" "$@"
    ;;
esac
