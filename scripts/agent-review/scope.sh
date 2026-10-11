#!/bin/sh
set -eu
adapter=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$adapter/common.sh"
read_event
group="agent-review-$repository-pr-$pr"
if irrelevant_edit; then
  group="agent-review-$repository-run-$GITHUB_RUN_ID"
else
  metadata=$(mktemp "${TMPDIR:-/tmp}/exphere-review-scope.XXXXXX")
  trap 'rm -f "$metadata"' EXIT
  trap 'exit 130' INT TERM
  fetch_current_pr "$metadata" || { printf 'Cannot establish current PR identity for concurrency.\n' >&2; exit 1; }
  if ! current_pr_matches_event "$metadata"; then group="agent-review-$repository-run-$GITHUB_RUN_ID"; fi
fi
printf 'group=%s\n' "$group" >>"$GITHUB_OUTPUT"
