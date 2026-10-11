#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"

[ -n "$EX_TERRAFORM_DIR" ] || ex_die 'Terraform is not configured for this microruntime.' 2
ex_terraform_command=$1
shift
case "$ex_terraform_command" in
  init|validate|plan|apply|destroy|output|show|fmt|workspace) ;;
  *) ex_die "Unsupported Terraform command: $ex_terraform_command" 2 ;;
esac
[ "${1:-}" != -- ] || shift
ex_need terraform
cd "$EX_TERRAFORM_DIR"
exec terraform "-chdir=$EX_TERRAFORM_DIR" "$ex_terraform_command" "$@"
