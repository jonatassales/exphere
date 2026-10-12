#!/bin/sh
# Private, read-only helpers. Sourcing this file defines functions only.
h_fail() { printf 'consumer-harness: %s\n' "$1" >&2; exit "${2:-1}"; }
h_sha() {
  if command -v sha256sum >/dev/null 2>&1; then h_hash_output=$(sha256sum <"$1") || return 1
  elif command -v shasum >/dev/null 2>&1; then h_hash_output=$(shasum -a 256 <"$1") || return 1
  else h_fail 'SHA-256 requires sha256sum or shasum.' 2; fi
  printf '%s\n' "${h_hash_output%% *}"
}
h_root() (
  [ -n "$1" ] || h_fail 'An explicit root is required.' 2
  case "$1" in *'
'*) h_fail 'Control characters in roots are unsupported.' 2 ;; esac
  printf '%s' "$1" | LC_ALL=C grep '[[:cntrl:]]' >/dev/null && h_fail 'Control characters in roots are unsupported.' 2
  case "$1" in /*) candidate=$1 ;; *) candidate="$PWD/$1" ;; esac
  [ -d "$candidate" ] || h_fail "Root directory not found: $1" 2
  CDPATH= cd -P "$candidate" || exit 2
  pwd -P
)
h_path() (
  root=$1; relative=$2; kind=$3
  case "$relative" in ''|/*|*\\*) h_fail "Invalid relative reference: $relative" ;; esac
  case "/$relative/" in *//*/|*//*) h_fail "Empty path segment: $relative" ;; esac
  case "/$relative/" in */../*|*/./*) h_fail "Parent/dot traversal is forbidden: $relative" ;; esac
  case "$relative" in *'
'*) h_fail 'Control characters in references are forbidden.' ;; esac
  printf '%s' "$relative" | LC_ALL=C grep '[[:cntrl:]]' >/dev/null && h_fail 'Control characters in references are forbidden.'
  set -f; IFS=/; set -- $relative
  [ "$#" -le 32 ] || h_fail 'Reference depth exceeds 32 segments.'
  current=$root
  while [ "$#" -gt 0 ]; do
    current="$current/$1"; shift
    [ ! -L "$current" ] || h_fail "Symlink reference is unsupported: $relative"
    if [ "$#" -gt 0 ] && [ -e "$current" ]; then
      [ -d "$current" ] || h_fail "A reference ancestor is not a directory: $relative"
    fi
  done
  case "$kind" in
    file) [ -f "$current" ] && [ -r "$current" ] || h_fail "Required file not found: $relative" ;;
    directory) [ -d "$current" ] || h_fail "Required directory not found: $relative" ;;
    future) ;;
    *) h_fail 'Internal reference-kind error.' 2 ;;
  esac
  printf '%s\n' "$current"
)
h_file() (
  file=$(h_path "$1" "$2" file) || exit 1
  [ "$(wc -c <"$file")" -le 1048576 ] || h_fail "$2: exceeds 1 MiB."
  hash=$(h_sha "$file") || exit 1
  printf '%s\t%s\t%s\n' "$1" "$2" "$hash" >>"$h_seen"
  printf '%s\n' "$file"
)
h_unchanged() {
  LC_ALL=C sort -u "$h_seen" >"$h_area/observed.tsv"
  while IFS="$(printf '\t')" read -r base relative before; do
    file=$(h_path "$base" "$relative" file) || return 1
    after=$(h_sha "$file") || return 1
    [ "$before" = "$after" ] || h_fail "Input changed during validation: $relative"
  done <"$h_area/observed.tsv"
}
h_inventory_ref() (
  jq -e --arg path "$1" 'any(.entries[]; .path==$path)' "$h_inventory" >/dev/null || h_fail "Dependency absent from inventory: $1"
  h_file "$h_consumer" "$1"
)
h_json() { sh "$h_tools/schema.sh" "$h_schemas/$1.schema.json" "$2"; }
