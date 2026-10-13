#!/bin/sh
set -eu

# Explicit, opt-in setup. Package postinstall never invokes this script.
_ex_shell=
_ex_profile=
while [ "$#" -gt 0 ]; do
  case $1 in
    --shell)
      [ "$#" -ge 2 ] || { printf '%s\n' 'Missing --shell value.' >&2; exit 2; }
      _ex_shell=$2; shift 2 ;;
    --profile)
      [ "$#" -ge 2 ] || { printf '%s\n' 'Missing --profile value.' >&2; exit 2; }
      _ex_profile=$2; shift 2 ;;
    -h|--help)
      printf '%s\n' 'Usage: setup-shell.sh [--shell zsh|bash] [--profile <file>]' 'Adds a project-aware ex function to the selected profile. No global executable or PATH mutation.'
      exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
done
if [ -z "$_ex_shell" ]; then _ex_shell=${SHELL:-}; _ex_shell=${_ex_shell##*/}; fi
case $_ex_shell in
  zsh) [ -n "$_ex_profile" ] || _ex_profile=$HOME/.zshrc ;;
  bash) [ -n "$_ex_profile" ] || _ex_profile=$HOME/.bashrc ;;
  *) printf '%s\n' 'Choose --shell zsh or --shell bash.' >&2; exit 2 ;;
esac
if [ -L "$_ex_profile" ] || { [ -e "$_ex_profile" ] && [ ! -f "$_ex_profile" ]; }; then
  printf '%s\n' 'Refusing a profile that is a symlink or not a regular file.' >&2
  exit 1
fi
_ex_parent=$(dirname -- "$_ex_profile")
[ -d "$_ex_parent" ] || { printf '%s\n' 'The selected profile directory must already exist.' >&2; exit 1; }
_ex_tmp=$(mktemp "$_ex_profile.exphere.XXXXXX")
trap 'rm -f "$_ex_tmp"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP
if [ -f "$_ex_profile" ]; then
  [ -w "$_ex_profile" ] || { printf '%s\n' 'The selected profile is not writable.' >&2; exit 1; }
  cp -p "$_ex_profile" "$_ex_tmp"
  # Reject ambiguous markers instead of deleting unrelated profile content.
  awk '
    $0 == "# >>> exphere project CLI >>>" { if (inside || count++) exit 2; inside=1; next }
    $0 == "# <<< exphere project CLI <<<" { if (!inside) exit 2; inside=0; next }
    !inside { print }
    END { if (inside) exit 2 }
  ' "$_ex_profile" > "$_ex_tmp" || { printf '%s\n' 'Malformed or repeated Exphere profile markers; no profile was changed.' >&2; exit 1; }
fi
cat >> "$_ex_tmp" <<'EXPHERE_SHELL'
# >>> exphere project CLI >>>
# Resolve the CLI belonging to the current project, not a global installation.
ex() {
  local _ex_dir _ex_candidate
  _ex_dir=$(pwd -P) || return 1
  while :; do
    _ex_candidate="$_ex_dir/node_modules/.bin/ex"
    if [ -e "$_ex_candidate" ] || [ -L "$_ex_candidate" ]; then
      if [ ! -x "$_ex_candidate" ]; then
        printf '%s\n' 'The current project Exphere executable is unavailable; reinstall/build its CLI dependency.' >&2
        return 1
      fi
      command "$_ex_candidate" "$@"
      return $?
    fi
    [ "$_ex_dir" = / ] && break
    _ex_dir=$(dirname -- "$_ex_dir")
  done
  printf '%s\n' 'No project-local Exphere executable found. Add the Exphere CLI/SDK dependency in this project first.' >&2
  return 127
}
# <<< exphere project CLI <<<
EXPHERE_SHELL
mv -f "$_ex_tmp" "$_ex_profile"
printf 'Installed project-aware ex in %s. Reload that profile or open a new configured shell, then run ex --help.\n' "$_ex_profile"
