#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"
[ "$#" -eq 0 ] || ex_die 'Usage: ex setup' 2

if [ "${npm_lifecycle_event:-}" = postinstall ] &&
   [ -n "${CI:-}" ] && [ "${CI:-}" != false ]; then
  printf 'ex: skipping user PATH setup in CI.\n'
  exit 0
fi

case "${HOME:-}" in
  /*) ;;
  *) ex_die 'An absolute HOME directory is required for local setup.' ;;
esac

ex_install_dir="$HOME/.local/share/exphere"
ex_bin_dir="$ex_install_dir/bin"
ex_env_link="$ex_install_dir/env.sh"
ex_bin_link="$ex_bin_dir/ex"

ex_check_link() {
  if [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]; then
    return 0
  fi
  if [ -e "$2" ] || [ -L "$2" ]; then
    ex_die "Refusing to overwrite $2. It belongs to another installation or file."
  fi
}

ex_configure_shell() {
  ex_rc=$1
  ex_source_line='[ ! -f "$HOME/.local/share/exphere/env.sh" ] || . "$HOME/.local/share/exphere/env.sh"'
  if [ -f "$ex_rc" ] && grep -Fqx "$ex_source_line" "$ex_rc"; then
    return 0
  fi
  mkdir -p "$(dirname "$ex_rc")"
  printf '\n# Exphere CLI: user-local command\n%s\n' "$ex_source_line" >> "$ex_rc"
}

ex_check_link "$EX_CLI_PATH" "$ex_bin_link"
ex_check_link "$EX_CLI_DIR/env.sh" "$ex_env_link"
mkdir -p "$ex_bin_dir"
if [ ! -L "$ex_bin_link" ]; then
  ln -s "$EX_CLI_PATH" "$ex_bin_link"
fi
if [ ! -L "$ex_env_link" ]; then
  ln -s "$EX_CLI_DIR/env.sh" "$ex_env_link"
fi

ex_shell=${SHELL:-}
case "${ex_shell##*/}" in
  zsh) ex_configure_shell "${ZDOTDIR:-$HOME}/.zshrc" ;;
  bash)
    ex_configure_shell "$HOME/.bashrc"
    # Bash login shells read only the first existing profile in this order.
    if [ -f "$HOME/.bash_profile" ]; then
      ex_configure_shell "$HOME/.bash_profile"
    elif [ -f "$HOME/.bash_login" ]; then
      ex_configure_shell "$HOME/.bash_login"
    else
      ex_configure_shell "$HOME/.profile"
    fi
    ;;
  *) printf 'ex: configure your shell to prepend %s to PATH.\n' "$ex_bin_dir" ;;
esac

printf 'ex: installed at %s\n' "$ex_bin_link"
printf 'Open a new terminal, or activate in the current POSIX shell:\n'
printf '  . "$HOME/.local/share/exphere/env.sh"\n'
