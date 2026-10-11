#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"
[ "$#" -eq 0 ] || ex_die 'Help does not accept arguments.' 2
cat <<'HELP'
ex — Exphere microruntimes CLI

Usage: ex [--root DIRECTORY] <command>

  --help                              Show this help
  --version                           Show the CLI version
  setup                               Install ex in your user PATH
  runtime list                        List IDs, versions and descriptor paths
  runtime <id> init                    Create an incomplete manual v2 descriptor
  runtime <id> init --guided           Generate native files from explicit answers
  runtime <id> init --legacy           Explicitly create a legacy v1 descriptor
  runtime <id> validate                Validate descriptor shape and local paths

New descriptors: .exphere/runtimes/<id>/schema.json, version 2.
Complete owner, units, Terraform directory, local context and namespace before
validation. Native workload and quota settings remain in consumer files.
The project is found above the current directory, or selected with --root.
Initialization refuses existing runtime output in either descriptor location.
Validation is offline and performs no infrastructure operation or hook.

Legacy descriptors remain at .micro-runtime/<id>/schema.json, version 1.
Legacy-only commands:
  runtime <id> run <hook> [args...]     Execute an explicitly declared .sh hook
  runtime <id> terraform <command>     Forward native Terraform arguments
  runtime <id> kubernetes <command>    Run kubectl against declared manifests
Terraform: init, validate, plan, apply, destroy, output, show, fmt, workspace.
Kubernetes: diff, apply, delete, status. No extra arguments in this version.
Same-ID descriptors in both locations are ambiguous and must be resolved.
There is no automatic migration, default deployment or implicit hook.
Tools for configuration: sh and jq. Lifecycle prerequisites are separate.
HELP
