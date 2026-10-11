#!/bin/sh
set -eu

exec next build --webpack "$@"
