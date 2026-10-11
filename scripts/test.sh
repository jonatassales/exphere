#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
sh scripts/tests/hooks.sh
