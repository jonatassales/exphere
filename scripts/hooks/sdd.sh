#!/bin/sh
# Advisory artifact resolution uses Git objects, never working-tree Markdown.
set -eu
cd "$(dirname "$0")/../.."
sdd_area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-sdd.XXXXXX")
trap 'rm -rf "$sdd_area"' EXIT
trap 'exit 130' INT TERM
: >"$sdd_area/specs"
warn() { printf 'SDD WARN: %s\n' "$*" >&2; }

objects() {
  if [ "$sdd_revision" = index ]; then
    git ls-files --stage -- ".artifacts/$1/" | awk '$3 == 0 { print $2 }'
  else
    git ls-tree -r "$sdd_revision" -- ".artifacts/$1/" | awk '$2 == "blob" { print $3 }'
  fi
}

assess() {
  sdd_revision=$1
  sdd_message=$2
  git interpret-trailers --parse <"$sdd_message" |
    awk 'tolower($0) ~ /^ticket:/ { sub(/^[^:]*:[[:space:]]*/, ""); sub(/[[:space:]]*$/, ""); print }' >"$sdd_area/tickets"
  if [ "$(wc -l <"$sdd_area/tickets" | tr -d ' ')" -ne 1 ]; then
    warn "$sdd_revision: declare exactly one Ticket: <stable-ticket-id> trailer."
    return
  fi
  sdd_ticket=$(cat "$sdd_area/tickets")
  case "$sdd_ticket" in ''|*[!A-Z0-9-]*) warn "$sdd_revision: invalid ticket identity '$sdd_ticket'."; return ;; esac
  objects tickets >"$sdd_area/objects"
  : >"$sdd_area/matches"
  while IFS= read -r sdd_object; do
    git cat-file blob "$sdd_object" >"$sdd_area/document"
    sdd_identity=$(sed -n '1s/^# \([A-Z0-9-]*\):.*/\1/p' "$sdd_area/document")
    if [ "$sdd_identity" = "$sdd_ticket" ]; then printf '%s\n' "$sdd_object" >>"$sdd_area/matches"; fi
  done <"$sdd_area/objects"
  sdd_count=$(wc -l <"$sdd_area/matches" | tr -d ' ')
  if [ "$sdd_count" -ne 1 ]; then
    warn "$sdd_revision: ticket $sdd_ticket resolves to $sdd_count artifacts; stage/commit one uniquely identified ticket."
    return
  fi
  git cat-file blob "$(cat "$sdd_area/matches")" >"$sdd_area/document"
  awk '/^(\*\*Spec:\*\*|- Spec:)/ {
    while (match($0, /[\[`]SPEC-[A-Z0-9-]+/)) {
      print substr($0, RSTART + 1, RLENGTH - 1)
      $0 = substr($0, RSTART + RLENGTH)
    }
  }' "$sdd_area/document" >"$sdd_area/parents"
  if [ "$(wc -l <"$sdd_area/parents" | tr -d ' ')" -ne 1 ]; then
    warn "$sdd_revision: ticket $sdd_ticket must declare one parent Spec using its stable ID."
    return
  fi
  sdd_spec=$(cat "$sdd_area/parents")
  objects specs >"$sdd_area/objects"
  : >"$sdd_area/matches"
  while IFS= read -r sdd_object; do
    git cat-file blob "$sdd_object" >"$sdd_area/document"
    sdd_identity=$(sed -n 's/^- ID: `\([^`]*\)`[[:space:]]*$/\1/p' "$sdd_area/document")
    if [ "$sdd_identity" = "$sdd_spec" ]; then printf '%s\n' "$sdd_object" >>"$sdd_area/matches"; fi
  done <"$sdd_area/objects"
  sdd_count=$(wc -l <"$sdd_area/matches" | tr -d ' ')
  if [ "$sdd_count" -ne 1 ]; then
    warn "$sdd_revision: parent spec $sdd_spec resolves to $sdd_count artifacts; stage/commit one uniquely identified spec."
    return
  fi
  printf 'SDD: %s: %s -> %s (identity only; scope review required).\n' "$sdd_revision" "$sdd_ticket" "$sdd_spec"
  printf '%s\n' "$sdd_spec" >>"$sdd_area/specs"
}

case "${1:-}" in
  commit)
    [ "$#" -eq 2 ] || exit 2
    assess index "$2"
    ;;
  push)
    [ "$#" -eq 3 ] || exit 2
    : >"$sdd_area/commits"
    sdd_branches=0
    if [ "$(git rev-parse --is-shallow-repository)" = true ]; then
      warn 'shallow history: outgoing association coverage may be incomplete; no fetch was performed.'
    fi
    while read -r sdd_local_ref sdd_local_oid sdd_remote_ref sdd_remote_oid; do
      [ -n "$sdd_local_oid" ] || continue
      case "$sdd_local_oid" in *[!0]*) ;; *) printf 'SDD: deletion %s has no outgoing commits.\n' "$sdd_remote_ref"; continue ;; esac
      case "$sdd_remote_ref" in refs/tags/*) printf 'SDD: tag %s is separate from PR branch evidence.\n' "$sdd_remote_ref" ;; *) sdd_branches=1 ;; esac
      if ! sdd_tip=$(git rev-parse --verify "$sdd_local_oid^{commit}" 2>/dev/null); then
        warn "$sdd_remote_ref: no resolvable commit tree; association check not applicable to a non-commit tag, otherwise unavailable."
        continue
      fi
      printf 'SDD: inspecting %s (%s -> %s).\n' "$sdd_remote_ref" "$sdd_remote_oid" "$sdd_local_oid"
      printf '%s\n' "$sdd_tip" >"$sdd_area/revisions"
      case "$sdd_remote_oid" in
        *[!0]*)
          if sdd_old=$(git rev-parse --verify "$sdd_remote_oid^{commit}" 2>/dev/null); then
            printf '^%s\n' "$sdd_old" >>"$sdd_area/revisions"
          else
            warn "$sdd_remote_ref: remote base unavailable; inspecting locally reachable history only, with incomplete range evidence."
          fi
          ;;
        *)
          # A new ref has no prior tip: inspect all its reachable local commits.
          printf 'SDD: new ref; inspecting all locally reachable commits.\n'
          ;;
      esac
      if ! git rev-list --stdin <"$sdd_area/revisions" >>"$sdd_area/commits"; then
        warn "$sdd_remote_ref: outgoing range could not be fully enumerated."
      fi
    done <"$3"
    sort -u "$sdd_area/commits" >"$sdd_area/unique"
    while IFS= read -r sdd_commit; do
      git show -s --format=%B "$sdd_commit" >"$sdd_area/message"
      assess "$sdd_commit" "$sdd_area/message"
    done <"$sdd_area/unique"
    if [ "$(sort -u "$sdd_area/specs" | wc -l | tr -d ' ')" -gt 1 ]; then
      warn 'outgoing associations span multiple specs; separate PR scopes or review the actual PR-to-spec relationship.'
    fi
    if [ "$sdd_branches" -eq 1 ]; then
      warn 'PR-to-spec verification unavailable locally: declare Spec: <stable-spec-id> in the actual PR and review all ticket relationships. Local candidates do not verify PR metadata.'
    fi
    ;;
  *) printf 'Usage: sdd.sh commit MESSAGE_FILE | push REMOTE UPDATES_FILE\n' >&2; exit 2 ;;
esac
