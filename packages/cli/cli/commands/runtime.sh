#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"
. "$EX_CLI_DIR/core/runtime.sh"

[ "$#" -ge 1 ] || ex_die 'Usage: ex runtime <list|id operation>. Run ex --help.' 2
if [ "$1" = list ] && [ "$#" -eq 1 ]; then
  ex_list_runtimes
  exit 0
fi
[ "$#" -ge 2 ] || ex_die 'An explicit runtime operation is required.' 2
ex_runtime_id=$1
ex_operation=$2
shift 2
case "$ex_operation" in
  init)
    case "$*" in
      '') ex_init_runtime "$ex_runtime_id" ;;
      --legacy) ex_init_runtime "$ex_runtime_id" legacy ;;
      --guided) ex_init_runtime "$ex_runtime_id" guided ;;
      *) ex_die 'Usage: ex runtime <id> init [--guided|--legacy]' 2 ;;
    esac
    exit 0
    ;;
  validate) [ "$#" -eq 0 ] || ex_die 'validate does not accept arguments.' 2 ;;
  terraform|kubernetes|run) [ "$#" -ge 1 ] || ex_die "Missing $ex_operation command or hook." 2 ;;
  up|inspect|down|connect|logs) ;;
  *) ex_die "Unknown runtime operation: $ex_operation" 2 ;;
esac
ex_load_runtime "$ex_runtime_id"
if [ "$ex_operation" = validate ]; then
  printf 'ex: microruntime %s v%s has a valid descriptor and local paths; execution is not verified.\n' "$EX_RUNTIME_ID" "$EX_RUNTIME_VERSION"
  exit 0
fi
if [ "$EX_RUNTIME_VERSION" = 2 ]; then
  case "$ex_operation" in
    terraform|kubernetes) ex_die 'v2 uses explicit lifecycle operations; raw adapters cannot bypass lifecycle ownership and evidence.' 2 ;;
  esac
  [ -f "$EX_CLI_DIR/commands/lifecycle.sh" ] || ex_die 'This package revision provides v2 configuration only; local lifecycle support is not installed.' 2
  exec sh "$EX_CLI_DIR/commands/lifecycle.sh" "$ex_operation" "$@"
fi
case "$ex_operation" in
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
  *) ex_die 'Lifecycle operations require a version 2 descriptor. Legacy v1 supports validate, adapters, and explicit run only.' 2 ;;
esac
