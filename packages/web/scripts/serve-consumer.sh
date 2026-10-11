#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
: "${EXPHERE_SHADER_CONSUMER_DIR:?Run through the disposable consumer test entry point.}"
exec node_modules/.bin/next start "$EXPHERE_SHADER_CONSUMER_DIR" --hostname 127.0.0.1 --port 3067
