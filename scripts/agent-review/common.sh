#!/bin/sh
# Sourced only from the trusted adapter revision.
set -eu

read_event() {
  jq -e --arg repo "$GITHUB_REPOSITORY" '
    .repository.full_name == $repo and
    (.number | type == "number" and . > 0 and floor == .) and
    .pull_request.number == .number and
    .pull_request.base.repo.full_name == $repo and
    (.pull_request.base.sha | test("^[0-9a-f]{40}$")) and
    (.pull_request.head.sha | test("^[0-9a-f]{40}$")) and
    (.pull_request.body == null or (.pull_request.body | type == "string"))
  ' "$GITHUB_EVENT_PATH" >/dev/null || return 1
  repository=$GITHUB_REPOSITORY
  pr=$(jq -r '.number' "$GITHUB_EVENT_PATH")
  base=$(jq -r '.pull_request.base.sha' "$GITHUB_EVENT_PATH")
  head=$(jq -r '.pull_request.head.sha' "$GITHUB_EVENT_PATH")
}

irrelevant_edit() {
  jq -e '
    def declarations: split("\n") | map(select(test("^Spec:")));
    .action == "edited" and .changes.base == null and
    (.changes.body == null or
     ((.changes.body.from // "" | declarations) == (.pull_request.body // "" | declarations)))
  ' "$GITHUB_EVENT_PATH" >/dev/null
}

fetch_current_pr() {
  gh api "repos/$repository/pulls/$pr" >"$1" 2>/dev/null || return 1
  jq -e '
    (.head.sha | type == "string" and test("^[0-9a-f]{40}$")) and
    (.base.sha | type == "string" and test("^[0-9a-f]{40}$")) and
    (.state | IN("open","closed")) and (.draft | type == "boolean") and
    (.body == null or (.body | type == "string"))
  ' "$1" >/dev/null
}

current_pr_matches_event() {
  jq -e --slurpfile event "$GITHUB_EVENT_PATH" '
    def declarations: (. // "") | split("\n") | map(select(test("^Spec:")));
    .head.sha == $event[0].pull_request.head.sha and .base.sha == $event[0].pull_request.base.sha and
    .state == $event[0].pull_request.state and .draft == $event[0].pull_request.draft and
    ((.body | declarations) == ($event[0].pull_request.body | declarations))
  ' "$1" >/dev/null
}

eligibility() {
  skip_reason=
  if [ "${GITHUB_EVENT_NAME:-}" != pull_request_target ]; then
    skip_reason='Unsupported event.'
  elif ! jq -e '.pull_request.base.ref == "main" and .pull_request.state == "open"' "$GITHUB_EVENT_PATH" >/dev/null; then
    skip_reason='Only open PRs targeting main are eligible.'
  elif jq -e '.pull_request.draft == true' "$GITHUB_EVENT_PATH" >/dev/null; then
    skip_reason='Draft PR: review deferred.'
  elif ! jq -e --arg repo "$repository" '.pull_request.head.repo.full_name == $repo' "$GITHUB_EVENT_PATH" >/dev/null; then
    skip_reason='Fork PR: provider access is disabled.'
  elif jq -e '.pull_request.user.login == "dependabot[bot]" or .sender.login == "dependabot[bot]"' "$GITHUB_EVENT_PATH" >/dev/null; then
    skip_reason='Dependabot PR: provider access is disabled.'
  elif irrelevant_edit; then
    skip_reason='Metadata edit did not change the Spec declaration or base.'
  elif [ "${AGENT_REVIEW_ENABLED:-false}" != true ]; then
    skip_reason='Agent review is disabled; paid execution requires explicit configuration.'
  fi
}
