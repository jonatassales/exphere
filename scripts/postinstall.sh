#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
# The existing CLI setup retains its own CI and shell behavior.
if [ "${EXPHERE_SKIP_USER_SETUP:-}" = 1 ]; then
  printf 'exphere: user PATH setup explicitly skipped.\n'
else
  sh packages/exphere/cli/ex.sh setup
fi
exec sh scripts/hooks/install.sh
