#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
sh scripts/tests/hooks.sh
sh scripts/tests/agent-review.sh
exec sh scripts/turbo.sh test
