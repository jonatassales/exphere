#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"
[ "$#" -eq 0 ] || ex_die 'Usage: ex setup' 2

if [ "${npm_lifecycle_event:-}" = postinstall ] &&
   [ -n "${CI:-}" ] && [ "${CI:-}" != false ]; then
  printf 'ex: skipping user PATH setup in CI.\n'
  exit 0
fi

if [ ! -f "$EX_CLI_PATH" ] || [ ! -r "$EX_CLI_PATH" ] || [ ! -x "$EX_CLI_PATH" ]; then
  ex_die "CLI executable must be a readable, executable regular file: $EX_CLI_PATH."
fi
if [ ! -f "$EX_CLI_DIR/env.sh" ] || [ ! -r "$EX_CLI_DIR/env.sh" ]; then
  ex_die "Environment asset must be a readable regular file: $EX_CLI_DIR/env.sh."
fi

case "${HOME:-}" in
  /*) ;;
  *) ex_die 'An absolute HOME directory is required for local setup.' ;;
esac

ex_install_dir="$HOME/.local/share/exphere"
ex_bin_dir="$ex_install_dir/bin"
ex_env_link="$ex_install_dir/env.sh"
ex_bin_link="$ex_bin_dir/ex"
ex_legacy_bin=
ex_legacy_env=
ex_checkout=$(CDPATH= cd "$EX_CLI_DIR/../../.." && pwd -P)
if [ "$EX_CLI_DIR" = "$ex_checkout/packages/cli/cli" ] &&
   [ -f "$ex_checkout/pnpm-workspace.yaml" ]; then
  ex_legacy_bin="$ex_checkout/packages/exphere/cli/ex.sh"
  ex_legacy_env="$ex_checkout/packages/exphere/cli/env.sh"
fi

ex_check_link() {
  [ ! -d "$2" ] || ex_die "Refusing to replace a directory or directory link: $2."
  if [ -L "$2" ]; then
    ex_existing_target=$(readlink "$2")
    if [ "$ex_existing_target" = "$1" ] ||
       { [ -n "$3" ] && [ "$ex_existing_target" = "$3" ]; }; then
      return 0
    fi
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

ex_check_link "$EX_CLI_PATH" "$ex_bin_link" "$ex_legacy_bin"
ex_check_link "$EX_CLI_DIR/env.sh" "$ex_env_link" "$ex_legacy_env"
mkdir -p "$ex_bin_dir"
ex_stage=$(mktemp -d "$ex_install_dir/.setup.XXXXXX")
ex_bin_changed=0
ex_env_changed=0
ex_setup_committed=0

ex_restore_link() {
  [ ! -d "$1" ] || return 1
  if [ -L "$1" ] && [ "$(readlink "$1")" = "$2" ]; then
    if [ -L "$3" ]; then
      mv -f "$3" "$1" || return 1
    else
      rm "$1" || return 1
    fi
  elif [ -L "$3" ] && [ -L "$1" ] &&
       [ "$(readlink "$1")" = "$(readlink "$3")" ]; then
    return 0
  elif [ ! -L "$3" ] && [ ! -e "$1" ] && [ ! -L "$1" ]; then
    return 0
  else
    printf 'ex: setup recovery refused to overwrite a changed path: %s\n' "$1" >&2
    return 1
  fi
}

ex_cleanup_setup() {
  ex_setup_status=$1
  trap - 0
  ex_recovery_failed=0
  if [ "$ex_setup_committed" -eq 0 ]; then
    if [ "$ex_env_changed" -eq 1 ]; then
      ex_restore_link "$ex_env_link" "$EX_CLI_DIR/env.sh" "$ex_stage/env.previous" || ex_recovery_failed=1
    fi
    if [ "$ex_bin_changed" -eq 1 ]; then
      ex_restore_link "$ex_bin_link" "$EX_CLI_PATH" "$ex_stage/bin.previous" || ex_recovery_failed=1
    fi
  fi
  if [ "$ex_recovery_failed" -eq 1 ]; then
    printf 'ex: setup recovery incomplete; inspect links and recovery files at %s before retrying.\n' "$ex_stage" >&2
    ex_setup_status=1
  else
    rm -rf "$ex_stage"
  fi
  exit "$ex_setup_status"
}

trap 'ex_cleanup_setup $?' 0
trap 'exit 130' HUP INT TERM
if [ -L "$ex_bin_link" ]; then ln -s "$(readlink "$ex_bin_link")" "$ex_stage/bin.previous"; fi
if [ -L "$ex_env_link" ]; then ln -s "$(readlink "$ex_env_link")" "$ex_stage/env.previous"; fi
ln -s "$EX_CLI_PATH" "$ex_stage/bin.next"
ln -s "$EX_CLI_DIR/env.sh" "$ex_stage/env.next"

if [ ! -L "$ex_bin_link" ] || [ "$(readlink "$ex_bin_link")" != "$EX_CLI_PATH" ]; then
  ex_check_link "$EX_CLI_PATH" "$ex_bin_link" "$ex_legacy_bin"
  ex_bin_changed=1
  mv -f "$ex_stage/bin.next" "$ex_bin_link" || ex_die 'Unable to update the executable link; restoring setup.'
fi
if [ ! -L "$ex_env_link" ] || [ "$(readlink "$ex_env_link")" != "$EX_CLI_DIR/env.sh" ]; then
  ex_check_link "$EX_CLI_DIR/env.sh" "$ex_env_link" "$ex_legacy_env"
  ex_env_changed=1
  mv -f "$ex_stage/env.next" "$ex_env_link" || ex_die 'Unable to update the environment link; restoring setup.'
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

ex_setup_committed=1
printf 'ex: installed at %s\n' "$ex_bin_link"
printf 'Open a new terminal, or activate in the current POSIX shell:\n'
printf '  . "$HOME/.local/share/exphere/env.sh"\n'
