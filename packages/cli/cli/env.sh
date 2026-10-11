#!/bin/sh

case "${PATH:-}" in
  "$HOME/.local/share/exphere/bin"|"$HOME/.local/share/exphere/bin":*) ;;
  *) export PATH="$HOME/.local/share/exphere/bin${PATH:+:$PATH}" ;;
esac
