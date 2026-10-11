#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
exec pnpm exec tsc --project tsconfig.json
