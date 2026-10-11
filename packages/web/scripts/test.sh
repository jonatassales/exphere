#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
web_root=$(pwd)
repo_root=$(CDPATH= cd ../.. && pwd)
fixture=$(mktemp -d "${TMPDIR:-/tmp}/exphere-shader-consumer.XXXXXX")
trap 'rm -rf "$fixture"' EXIT HUP INT TERM
cp -R tests/consumer/. "$fixture/"
mkdir -p "$fixture/node_modules/@repo" "$fixture/node_modules/@types"
for package in web design; do
  mkdir -p "$fixture/node_modules/@repo/$package"
  cp "$repo_root/packages/$package/package.json" "$fixture/node_modules/@repo/$package/"
  if [ -d "$repo_root/packages/$package/dist" ]; then
    cp -R "$repo_root/packages/$package/dist" "$fixture/node_modules/@repo/$package/"
  fi
done
for package in next react react-dom typescript; do
  ln -s "$web_root/node_modules/$package" "$fixture/node_modules/$package"
done
for package in node react react-dom; do
  ln -s "$web_root/node_modules/@types/$package" "$fixture/node_modules/@types/$package"
done
node_modules/.bin/tailwindcss -i tests/consumer/styles.input.css -o "$fixture/src/app/fixture.css" --minify
NEXT_TELEMETRY_DISABLED=1 node_modules/.bin/next build "$fixture" --webpack
export EXPHERE_SHADER_CONSUMER_DIR="$fixture"
node_modules/.bin/playwright test "$@"
