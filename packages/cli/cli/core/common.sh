#!/bin/sh

ex_die() {
  printf 'ex: %s\n' "$1" >&2
  exit "${2:-1}"
}

ex_need() {
  command -v "$1" >/dev/null 2>&1 || ex_die "Required command not found: $1" 127
}

ex_valid_id() {
  case "$1" in ''|-*|*[!a-z0-9-]*) return 1 ;; esac
  return 0
}

ex_find_project() {
  if [ -n "$1" ]; then
    case "$1" in
      /*) ex_project_candidate=$1 ;;
      *) ex_project_candidate="$(pwd -P)/$1" ;;
    esac
    EX_PROJECT_ROOT=$(CDPATH= cd -P "$ex_project_candidate" && pwd) || ex_die 'Project directory not found.'
  else
    EX_PROJECT_ROOT=$(pwd -P)
    ex_project_candidate=$EX_PROJECT_ROOT
    while :; do
      if [ -d "$ex_project_candidate/.exphere/runtimes" ] ||
         [ -d "$ex_project_candidate/.micro-runtime" ] ||
         [ -f "$ex_project_candidate/pnpm-workspace.yaml" ] ||
         [ -e "$ex_project_candidate/.git" ]; then
        EX_PROJECT_ROOT=$ex_project_candidate
        break
      fi
      [ "$ex_project_candidate" != / ] || break
      ex_project_candidate=$(dirname "$ex_project_candidate")
    done
  fi
}

ex_resolve_path() (
  ex_base=$1
  ex_relative=$2
  case "/$ex_relative/" in
    //*|*/../*|*//*) ex_die "Expected a relative path without '..': $ex_relative" 2 ;;
  esac
  if [ -d "$ex_base/$ex_relative" ]; then
    ex_resolved=$(CDPATH= cd -P "$ex_base/$ex_relative" && pwd)
  else
    [ -f "$ex_base/$ex_relative" ] || ex_die "File or directory not found: $ex_relative"
    [ ! -L "$ex_base/$ex_relative" ] || ex_die "File symlinks are not supported: $ex_relative"
    ex_parent=$(CDPATH= cd -P "$(dirname "$ex_base/$ex_relative")" && pwd)
    ex_resolved="$ex_parent/$(basename "$ex_relative")"
  fi
  case "$ex_resolved" in
    "$ex_base"|"$ex_base"/*) printf '%s\n' "$ex_resolved" ;;
    *) ex_die "Path escapes its owning directory: $ex_relative" 2 ;;
  esac
)
