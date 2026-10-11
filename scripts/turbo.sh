#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
[ -x node_modules/.bin/turbo ] || { printf 'exphere: Turbo is missing.\n' >&2; exit 1; }
exec node_modules/.bin/turbo run "$@"
