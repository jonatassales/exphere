#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
[ -x node_modules/.bin/harness-score ] || {
  printf 'exphere: harness-score is unavailable; install development dependencies.\n' >&2
  exit 1
}
# Refuse network/package-install fallback even if the local installation is damaged.
exec npx --offline --yes=false -- harness-score "$@"
