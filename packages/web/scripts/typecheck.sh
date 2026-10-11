#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
node_modules/.bin/tsc --project tsconfig.json --noEmit
exec node_modules/.bin/tsc --project tsconfig.tests.json
