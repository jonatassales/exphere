#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"
[ "$#" -eq 0 ] || ex_die 'Help does not accept arguments.' 2
cat <<'EOF'
ex — Exphere microruntimes CLI

Usage: ex [--root DIRECTORY] <command>

  --help                              Show this help
  --version                           Show the CLI version
  setup                               Install ex in your user PATH
  runtime list                        List consumer microruntimes
  runtime <id> init                   Create .micro-runtime/<id>/schema.json
  runtime <id> validate               Validate descriptor shape and local paths
  runtime <id> terraform <command>    Run Terraform in the declared directory
  runtime <id> kubernetes <command>   Run kubectl against declared manifests
  runtime <id> run <hook> [args...]   Execute a consumer-provided .sh hook

Terraform: init, validate, plan, apply, destroy, output, show, fmt, workspace.
Terraform accepts native arguments, optionally separated by --.
Kubernetes: diff, apply, delete, status. No extra arguments in this version.

Descriptors: .micro-runtime/<id>/schema.json, version 1.
The project is found above the current directory, or selected with --root.
init creates a descriptor only and refuses to overwrite an existing runtime.
Tools: sh, jq; terraform or kubectl only for the selected adapter.
There is no default deployment, automatic initialization or implicit hook.
EOF
