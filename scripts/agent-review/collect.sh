#!/bin/sh
# Sourced by run.sh after configuration and event validation.
set -eu

advisory() {
  jq -n --arg message "$1" '{severity:"advisory",message:$message}' >>"$scratch/advisories.jsonl"
}

read_blob() {
  blob_ref=$1
  blob_path=$2
  blob_size=$(git cat-file -s "$blob_ref:$blob_path")
  [ "$blob_size" -le 262144 ] || fail 'A source or policy blob exceeds the input limit; review is incomplete.'
  git cat-file blob "$blob_ref:$blob_path" >"$scratch/blob"
}

git cat-file -e "$base^{commit}" && git cat-file -e "$head^{commit}" || fail 'An immutable source commit is unavailable.'
merge_base=$(git merge-base "$base" "$head") || fail 'Comparison merge-base is unavailable.'
git -c core.quotePath=false diff --no-ext-diff --no-textconv --name-status -z --find-renames "$merge_base" "$head" >"$scratch/names"
jq -Rs '
  split("\u0000") | .[:-1] | {remaining:.,paths:[]} |
  until(.remaining | length == 0;
    .remaining as $r | ($r[0] | startswith("R") or startswith("C")) as $rename |
    .paths += [{status:$r[0],path:(if $rename then $r[2] else $r[1] end),old_path:(if $rename then $r[1] else $r[1] end)}] |
    .remaining = $r[(if $rename then 3 else 2 end):]) | .paths
' "$scratch/names" >"$scratch/paths.json"
[ "$(jq length "$scratch/paths.json")" -le 100 ] || fail 'More than 100 changed paths; review is incomplete.'
jq -e 'all(.[]; [.path,.old_path][] | test("[\u0000-\u001f\u007f]") | not)' "$scratch/paths.json" >/dev/null || fail 'Control characters in paths are unsupported; review is incomplete.'
if jq -e 'any(.[]; [.path,.old_path][] | test("(^|/)(\\.env($|\\.)|id_rsa|id_ed25519|credentials($|\\.))|\\.(pem|key|p12|pfx)$";"i"))' "$scratch/paths.json" >/dev/null; then
  fail 'A potentially secret-bearing path changed; source was not sent to the provider.'
fi
git log --format=%H "$merge_base..$head" >"$scratch/commits"
jq -Rn '[inputs]' <"$scratch/commits" >"$scratch/commits.json"
jq --arg merge_base "$merge_base" --slurpfile paths "$scratch/paths.json" --slurpfile commits "$scratch/commits.json" \
  '. + {merge_base:$merge_base,paths:$paths[0],commits:$commits[0],exclusions:[]}' "$scratch/snapshot.json" >"$scratch/updated.json"
mv "$scratch/updated.json" "$scratch/snapshot.json"
if [ "$(jq length "$scratch/paths.json")" -eq 0 ]; then outcome=skipped; reason='No changes in the comparison scope.'; exit 0; fi

printf '' >"$scratch/changes.jsonl"
jq -c '.[]' "$scratch/paths.json" >"$scratch/paths.jsonl"
while IFS= read -r entry; do
  path=$(printf '%s' "$entry" | jq -r .path)
  old_path=$(printf '%s' "$entry" | jq -r .old_path)
  for side in before after; do
    ref=$merge_base; selected_path=$old_path
    if [ "$side" = after ]; then ref=$head; selected_path=$path; fi
    printf 'null\n' >"$scratch/$side.json"
    if git cat-file -e "$ref:$selected_path" 2>/dev/null; then
      object_type=$(git cat-file -t "$ref:$selected_path")
      if [ "$object_type" != blob ]; then
        jq -n --arg reason 'Non-blob object (for example a submodule); contents not reviewed.' '{excluded:$reason}' >"$scratch/$side.json"
      else
        read_blob "$ref" "$selected_path"
        if [ "$(tr -d '\000' <"$scratch/blob" | wc -c)" -ne "$(wc -c <"$scratch/blob")" ] || ! iconv -f UTF-8 -t UTF-8 "$scratch/blob" >/dev/null 2>&1; then
          jq -n '{excluded:"Binary or non-UTF-8 contents; not reviewed."}' >"$scratch/$side.json"
        else
          jq -Rs '{content:.}' "$scratch/blob" >"$scratch/$side.json"
        fi
      fi
    fi
  done
  git diff --no-ext-diff --no-textconv --find-renames --unified=3 "$merge_base" "$head" -- "$old_path" "$path" >"$scratch/diff"
  jq -n --argjson file "$entry" --slurpfile before "$scratch/before.json" --slurpfile after "$scratch/after.json" --rawfile diff "$scratch/diff" \
    '$file + {before:$before[0],after:$after[0],diff:$diff}' >>"$scratch/changes.jsonl"
  [ "$(wc -c <"$scratch/changes.jsonl")" -le 262144 ] || fail 'Combined source context exceeds the input limit; review is incomplete.'
done <"$scratch/paths.jsonl"
jq -s . "$scratch/changes.jsonl" >"$scratch/changes.json"
jq -s '[.[] | select(.before.excluded or .after.excluded) | {path,reason:(.before.excluded // .after.excluded)}]' "$scratch/changes.jsonl" >"$scratch/exclusions.json"
jq --slurpfile exclusions "$scratch/exclusions.json" '.exclusions=$exclusions[0]' "$scratch/snapshot.json" >"$scratch/updated.json"
mv "$scratch/updated.json" "$scratch/snapshot.json"

# Discover policy sources at the trusted revision. Proposed policy edits remain PR data.
git ls-tree -r --name-only "$trusted" >"$scratch/tree"
grep -E '(^|/)(AGENTS\.md|CODING_STANDARDS\.md|CONTRIBUTING\.md)$|^\.agents/(rules|guardrails)/.*\.md$|^\.exphere/(rules|guardrails)/.*\.md$|^\.artifacts/agents/0006-|^README\.md$|^\.agents/(README|CONTEXT)\.md$' "$scratch/tree" >"$scratch/standards.paths" || :
printf '' >"$scratch/standards.jsonl"
while IFS= read -r path; do
  read_blob "$trusted" "$path"
  jq -n --arg path "$path" --rawfile content "$scratch/blob" '{path:$path,content:$content}' >>"$scratch/standards.jsonl"
  [ "$(wc -c <"$scratch/standards.jsonl")" -le 262144 ] || fail 'Trusted policy context exceeds the input limit.'
done <"$scratch/standards.paths"
jq -s . "$scratch/standards.jsonl" >"$scratch/standards.json"
git cat-file blob "$trusted:.agents/skills/code-review/SKILL.md" >"$scratch/skill.md" || fail 'Trusted code-review skill is unavailable.'

# Owning manifests and README files supply surrounding context without running the PR.
printf '' >"$scratch/owning.paths"
jq -r '.[].path' "$scratch/paths.json" | while IFS= read -r path; do
  parent=$(dirname "$path")
  while :; do
    for name in README.md package.json; do
      candidate=$name
      if [ "$parent" != . ]; then candidate="$parent/$name"; fi
      if git cat-file -e "$head:$candidate" 2>/dev/null; then printf '%s\n' "$candidate"; fi
    done
    [ "$parent" != . ] || break
    parent=$(dirname "$parent")
  done
done | sort -u >"$scratch/owning.paths"
printf '' >"$scratch/owning.jsonl"
while IFS= read -r path; do
  read_blob "$head" "$path"
  jq -n --arg path "$path" --rawfile content "$scratch/blob" '{path:$path,content:$content}' >>"$scratch/owning.jsonl"
  [ "$(wc -c <"$scratch/owning.jsonl")" -le 262144 ] || fail 'Owning context exceeds the input limit.'
done <"$scratch/owning.paths"
jq -s . "$scratch/owning.jsonl" >"$scratch/owning.json"

printf '' >"$scratch/advisories.jsonl"
spec_id=$(jq -r '.pull_request.body // "" | split("\n") | map(select(test("^Spec:"))) | if length == 1 then .[0] | try capture("^Spec:[ \\t]*(?<id>[A-Z][A-Z0-9-]*)[ \\t\\r]*$").id catch "" else "" end' "$GITHUB_EVENT_PATH")
printf 'null\n' >"$scratch/spec.json"
spec_matches=0
git ls-tree -r --name-only "$head" .artifacts/specs >"$scratch/spec.paths"
if [ -z "$spec_id" ]; then advisory 'PR must declare exactly one valid Spec: identity.'; fi
while IFS= read -r path; do
  case "$path" in *.spec.md) ;; *) continue ;; esac
  read_blob "$head" "$path"
  count=$(grep -Fxc -- "- ID: \`$spec_id\`" "$scratch/blob" || :)
  if [ -n "$spec_id" ] && [ "$count" -gt 0 ]; then
    spec_matches=$((spec_matches + count))
    jq -n --arg path "$path" --arg id "$spec_id" --rawfile content "$scratch/blob" '{path:$path,id:$id,content:$content}' >"$scratch/spec.json"
  fi
done <"$scratch/spec.paths"
if [ "$spec_matches" -ne 1 ]; then
  printf 'null\n' >"$scratch/spec.json"
  advisory 'Authoritative Spec is missing or ambiguous; Spec review is not verified.'
fi
while IFS= read -r commit; do
  git show -s --format=%B "$commit" | git interpret-trailers --parse >"$scratch/trailers"
  tickets=$(sed -n 's/^Ticket:[[:space:]]*//p' "$scratch/trailers")
  if [ "$(printf '%s\n' "$tickets" | grep -c . || :)" -ne 1 ] || ! printf '%s' "$tickets" | grep -Eq '^[A-Z][A-Z0-9-]*$'; then
    advisory "Commit $commit must declare exactly one valid Ticket: identity."
    continue
  fi
  matches=0
  git ls-tree -r --name-only "$commit" .artifacts/tickets >"$scratch/ticket.paths"
  while IFS= read -r path; do
    case "$path" in *.ticket.md) ;; *) continue ;; esac
    read_blob "$commit" "$path"
    if grep -Eq "^# $tickets: " "$scratch/blob"; then
      matches=$((matches + 1))
      relation=$(sed -n -e 's/^\*\*Spec:\*\* \[\([^] ]*\) v[^]]*\](.*)[.]\{0,1\}[[:space:]]*$/\1/p' -e 's/^- Spec: \[\([^] ]*\) v[^]]*\](.*)[.]\{0,1\}[[:space:]]*$/\1/p' "$scratch/blob")
      link=$(sed -n -e 's/^\*\*Spec:\*\* \[[^]]*\](\([^)]*\)).*/\1/p' -e 's/^- Spec: \[[^]]*\](\([^)]*\)).*/\1/p' "$scratch/blob")
      resolved_path=$(jq -nr --arg path ".artifacts/tickets/$link" '$path | split("/") | reduce .[] as $part ([]; if $part == ".." then .[:-1] elif $part == "." or $part == "" then . else . + [$part] end) | join("/")')
      if [ "$relation" != "$spec_id" ] || [ "$spec_matches" -ne 1 ]; then advisory "Commit $commit ticket $tickets has a missing, ambiguous, or mismatched Spec relationship."; fi
      if [ -z "$link" ] || ! git cat-file -e "$commit:$resolved_path" 2>/dev/null; then
        advisory "Commit $commit ticket $tickets links to an unavailable Spec artifact."
      else
        read_blob "$commit" "$resolved_path"
        if [ "$(grep -Fxc -- "- ID: \`$relation\`" "$scratch/blob" || :)" -ne 1 ]; then advisory "Commit $commit ticket $tickets links to a conflicting Spec identity."; fi
      fi
    fi
  done <"$scratch/ticket.paths"
  if [ "$matches" -ne 1 ]; then advisory "Commit $commit ticket $tickets is unresolved or ambiguous in its commit tree."; fi
done <"$scratch/commits"
jq -s . "$scratch/advisories.jsonl" >"$scratch/traceability.json"
jq -n --slurpfile snapshot "$scratch/snapshot.json" --slurpfile changes "$scratch/changes.json" \
  --slurpfile standards "$scratch/standards.json" --slurpfile owning "$scratch/owning.json" --slurpfile spec "$scratch/spec.json" --slurpfile trace "$scratch/traceability.json" \
  '{snapshot:$snapshot[0],changes:$changes[0],standards:$standards[0],owning_context:$owning[0],spec:$spec[0],traceability:$trace[0]}' >"$scratch/context.json"
