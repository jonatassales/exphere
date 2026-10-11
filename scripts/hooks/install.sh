#!/bin/sh
set -eu
cd "$(dirname "$0")/../.."

skip() { printf 'exphere: hook activation skipped (%s).\n' "$1"; exit 0; }
[ "${HUSKY:-}" != 0 ] || skip 'HUSKY=0'
case "${CI:-}" in ''|0|false) ;; *) skip 'CI' ;; esac
[ "${NODE_ENV:-}" != production ] || skip 'production'
[ "${npm_config_production:-}" != true ] || skip 'production-only install'
case " ${npm_config_omit:-} " in *' dev '*) skip 'development dependencies omitted' ;; esac
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || skip 'no Git worktree'
hook_root=$(git rev-parse --show-toplevel)
[ "$(pwd -P)" = "$(CDPATH= cd "$hook_root" && pwd -P)" ] || {
  printf 'exphere: refusing to configure hooks outside this project root.\n' >&2
  exit 1
}
hook_path=$(git config --get core.hooksPath || :)
case "$hook_path" in
  ''|.husky/_) ;;
  *) printf 'exphere: existing hooks path conflicts: %s\n' "$hook_path" >&2; exit 1 ;;
esac
[ -x node_modules/.bin/husky ] || {
  printf 'exphere: Husky is missing; install development dependencies.\n' >&2
  exit 1
}
node_modules/.bin/husky
[ "$(git config --local --get core.hooksPath)" = .husky/_ ] && [ -f .husky/_/h ] || {
  printf 'exphere: hook activation could not be verified.\n' >&2
  exit 1
}
printf 'exphere: hooks activated for this Git worktree.\n'
