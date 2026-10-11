#!/bin/sh
set -eu

ex_entry=$0
ex_link_count=0
while [ -L "$ex_entry" ]; do
  ex_link_count=$((ex_link_count + 1))
  if [ "$ex_link_count" -gt 40 ]; then
    printf 'ex: too many entrypoint symlinks.\n' >&2
    exit 1
  fi
  ex_entry_dir=$(CDPATH= cd -P "$(dirname "$ex_entry")" && pwd)
  ex_link=$(readlink "$ex_entry")
  case "$ex_link" in
    /*) ex_entry=$ex_link ;;
    *) ex_entry="$ex_entry_dir/$ex_link" ;;
  esac
done
EX_CLI_DIR=$(CDPATH= cd -P "$(dirname "$ex_entry")" && pwd)
EX_CLI_PATH="$EX_CLI_DIR/ex.sh"
export EX_CLI_DIR EX_CLI_PATH
. "$EX_CLI_DIR/core/common.sh"

ex_root_argument=
if [ "${1:-}" = --root ]; then
  [ "$#" -ge 2 ] && [ -n "$2" ] || ex_die 'Usage: ex --root DIRECTORY <command>' 2
  ex_root_argument=$2
  shift 2
fi

ex_command=${1:---help}
[ "$#" -eq 0 ] || shift
case "$ex_command" in
  --help|-h|help) exec sh "$EX_CLI_DIR/commands/help.sh" "$@" ;;
  setup) exec sh "$EX_CLI_DIR/commands/setup.sh" "$@" ;;
  --version|-V)
    [ "$#" -eq 0 ] || ex_die 'Version does not accept arguments.' 2
    ex_need jq
    jq -r '"ex " + .version' "$EX_CLI_DIR/../package.json"
    ;;
  runtime)
    ex_find_project "$ex_root_argument"
    export EX_PROJECT_ROOT
    exec sh "$EX_CLI_DIR/commands/runtime.sh" "$@"
    ;;
  *) ex_die "Unknown command: $ex_command. Run 'ex --help'." 2 ;;
esac
