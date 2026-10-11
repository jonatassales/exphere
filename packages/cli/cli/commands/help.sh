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

Explicit v2 lifecycle operations (timeout precedes operation arguments):
  runtime <id> up [--timeout SECONDS]
  runtime <id> inspect [--timeout SECONDS]
  runtime <id> down [--timeout SECONDS] [--recover]
  runtime <id> run [--timeout SECONDS] HOOK --effects none|runtime [-- args...]
  runtime <id> logs [--timeout SECONDS] UNIT
  runtime <id> connect [--timeout SECONDS] UNIT LOCAL_PORT SERVICE_PORT
Hooks are trusted consumer code, never automatic and never sandboxed.
none declares no Kubernetes/Terraform resource effects; runtime supports only
the declared owned Deployment/Service set. Terraform hook changes are unsupported.
Logs and hook output go to the caller; retained evidence omits their contents.
Connect binds 127.0.0.1 in the foreground and leaves no background connection.
The operation timeout is 120 seconds by default; valid bounds are 1–3600 seconds.

Legacy descriptors remain at .micro-runtime/<id>/schema.json, version 1.
Legacy-only commands:
  runtime <id> terraform <command>     Forward native Terraform arguments
  runtime <id> kubernetes <command>    Run kubectl against declared manifests
  runtime <id> run HOOK [-- args...]   Run a legacy explicit .sh hook
Terraform: init, validate, plan, apply, destroy, output, show, fmt, workspace.
Kubernetes: diff, apply, delete, status. No extra arguments in this version.
Same-ID descriptors in both locations are ambiguous and must be resolved.
There is no automatic migration, default deployment or implicit hook.
Tools for configuration: sh and jq. Lifecycle prerequisites are separate.
HELP
