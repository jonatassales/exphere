#!/bin/sh
set -eu

# npm may expose this file through a symlink; locate the owning package first.
_ex_source=$0
while [ -L "$_ex_source" ]; do
  _ex_dir=$(CDPATH= cd -P -- "$(dirname -- "$_ex_source")" && pwd)
  _ex_link=$(readlink "$_ex_source")
  case $_ex_link in
    /*) _ex_source=$_ex_link ;;
    *) _ex_source=$_ex_dir/$_ex_link ;;
  esac
done
_ex_package=$(CDPATH= cd -P -- "$(dirname -- "$_ex_source")/.." && pwd)

# Anchor resolution to this package so both hoisted npm and isolated pnpm work.
_ex_cli_manifest=$(node -e 'process.stdout.write(require.resolve("@exphere/ex/package.json", {paths: [process.argv[1]]}))' "$_ex_package")
_ex_cli_package=$(dirname -- "$_ex_cli_manifest")
exec "$_ex_cli_package/bin/ex.sh" "$@"
