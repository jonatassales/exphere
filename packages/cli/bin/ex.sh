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

# The CLI implementation is the compiled Go executable, not this package bridge.
if [ ! -x "$_ex_package/dist/ex" ]; then
  printf '%s\n' 'Exphere is not built. Install Go 1.23+ and run the CLI package scripts/build.sh; dependency scripts may have been disabled.' >&2
  exit 1
fi
exec "$_ex_package/dist/ex" "$@"
