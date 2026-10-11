#!/bin/sh
set -eu

next typegen
exec tsc --noEmit "$@"
