#!/bin/sh
set -eu
umask 077
request=$1
destination=$2
worker_area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-review-worker.XXXXXX")
transport=
worker_started=$(date +%s)
cleanup() {
  result=$?
  trap - EXIT INT TERM
  if [ -n "$transport" ]; then kill -TERM "$transport" 2>/dev/null || :; wait "$transport" 2>/dev/null || :; fi
  rm -rf "$worker_area"
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' INT TERM
printf 'Authorization: Bearer %s\nOpenAI-Project: %s\nContent-Type: application/json\n' "$OPENAI_API_KEY" "$OPENAI_PROJECT_ID" >"$worker_area/headers"
unset OPENAI_API_KEY GH_TOKEN GITHUB_TOKEN
curl --silent --show-error --fail --proto '=https' --connect-timeout 15 --max-time 300 \
  --request POST --header "@$worker_area/headers" --data-binary "@$request" \
  --output "$worker_area/response.json" https://api.openai.com/v1/responses 2>"$worker_area/transport-error" &
transport=$!
wait "$transport" || exit 1
transport=
jq -e '
  .status == "completed" and .error == null and .incomplete_details == null and
  ([.output[]? | select(.type == "message") | .content[]? | select(.type == "refusal")] | length == 0) and
  ([.output[]? | select(.type == "message") | .content[]? | select(.type == "output_text")] | length == 1)
' "$worker_area/response.json" >/dev/null || exit 1
jq -er '[.output[] | select(.type == "message") | .content[] | select(.type == "output_text")][0].text' "$worker_area/response.json" >"$worker_area/review.json"
jq -e --slurpfile request "$request" '
  ($request[0].input[0].content | fromjson) as $context |
  (keys == ["axis","base_sha","coverage_limits","findings","head_sha","merge_base","status","summary"]) and
  .axis == $request[0].text.format.schema.properties.axis.enum[0] and
  .base_sha == $context.snapshot.base_sha and .head_sha == $context.snapshot.head_sha and .merge_base == $context.snapshot.merge_base and
  (.status == "completed" or .status == "not-verified") and
  (.summary | type == "string") and (.coverage_limits | type == "array" and all(.[]; type == "string")) and
  (.findings | type == "array" and all(.[];
    (.severity | IN("P0","P1","P2","P3")) and (.kind | IN("hard","heuristic")) and
    (keys == ["evidence","file","kind","line","message","severity"]) and
    (.file | type == "string") and
    (.file as $file | $file == "" or any($context.changes[]; .path == $file or .old_path == $file)) and
    (.line == null or (.line | type == "number" and . > 0 and floor == .)) and
    (.evidence | type == "string" and length > 0) and (.message | type == "string" and length > 0))) and
  ([.summary,.coverage_limits[],.findings[] | if type == "object" then .message,.evidence else . end] | join(" ") | [scan("\\S+")] | length <= 400) and
  (if .status == "not-verified" then (.coverage_limits | length > 0) else true end)
' "$worker_area/review.json" >/dev/null || exit 1
jq --slurpfile response "$worker_area/response.json" --argjson request_bytes "$(wc -c <"$request" | tr -d ' ')" \
  --argjson duration "$(( $(date +%s) - worker_started ))" \
  '. + {usage:($response[0].usage // null),provider_model:($response[0].model // null),request_bytes:$request_bytes,duration_seconds:$duration,worst_severity:([.findings[].severity] | min)}' \
  "$worker_area/review.json" >"$destination"
