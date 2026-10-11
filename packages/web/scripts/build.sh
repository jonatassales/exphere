#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
node_modules/.bin/tsc --project tsconfig.json
exec node_modules/.bin/tailwindcss -i src/react/exphere-shader/exphere-shader.css -o dist/react/exphere-shader/exphere-shader.css --minify
