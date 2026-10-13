#!/bin/sh
# Source-only consumer-contract verification; deliberately not an `ex` command.
set -eu
h_package=$(CDPATH= cd "$(dirname "$0")/.." && pwd -P)
h_tools="$h_package/scripts/consumer-harness"
h_schemas="$h_package/cli/schemas"
. "$h_tools/files.sh"
. "$h_tools/reference.sh"
h_root_arg=; h_scenario_arg=; h_ready=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --root) [ "$#" -ge 2 ] && [ -n "$2" ] && [ -z "$h_root_arg" ] || h_fail 'Use --root exactly once with a directory.' 2; h_root_arg=$2; shift 2 ;;
    --scenario) [ "$#" -ge 2 ] && [ -n "$2" ] && [ -z "$h_scenario_arg" ] || h_fail 'Use --scenario once with a directory.' 2; h_scenario_arg=$2; shift 2 ;;
    --require-ready) [ "$h_ready" -eq 0 ] || h_fail 'Duplicate --require-ready.' 2; h_ready=1; shift ;;
    --help) printf 'usage: verify-consumer-harness.sh --root DIRECTORY [--scenario DIRECTORY] [--require-ready]\n'; exit 0 ;;
    *) h_fail "Unknown argument: $1" 2 ;;
  esac
done
command -v jq >/dev/null 2>&1 || h_fail 'jq 1.7 or newer is required; validation never installs dependencies.' 2
jq --version | grep -Eq '^jq-(1\.([7-9]|[1-9][0-9]+)([.][0-9]+)?|[2-9][0-9]*[.][0-9]+([.][0-9]+)?)$' || h_fail 'Use a supported jq version (1.7 or newer).' 2
h_consumer=$(h_root "$h_root_arg") || exit 2
umask 077
h_area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-harness-verify.XXXXXX")
h_seen="$h_area/seen.tsv"; : >"$h_seen"
trap 'rm -rf "$h_area"' 0
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM
h_reference
if [ -n "$h_scenario_arg" ]; then
  . "$h_tools/scenario.sh"
  h_scenario=$(h_root "$h_scenario_arg") || exit 2
  h_check_scenario
fi
h_unchanged
cat "$h_area/result.json"
if [ "$h_ready" -eq 1 ]; then
  printf 'consumer-harness: required execution capabilities are unavailable; contract validity is not readiness.\n' >&2
  exit 3
fi
