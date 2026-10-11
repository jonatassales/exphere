#!/bin/sh
set -eu
cd "$(dirname "$0")/../.."
[ "$#" -eq 1 ] || { printf 'Usage: commit-msg MESSAGE_FILE\n' >&2; exit 2; }
sh scripts/hooks/sdd.sh commit "$1" || printf 'SDD WARN: traceability checker unavailable.\n' >&2
[ -x node_modules/.bin/commitlint ] || {
  printf 'exphere: commitlint is missing; install development dependencies.\n' >&2
  exit 1
}
exec node_modules/.bin/commitlint --edit "$1"
