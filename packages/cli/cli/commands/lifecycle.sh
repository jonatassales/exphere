#!/bin/sh
set -eu
. "$EX_CLI_DIR/core/common.sh"
. "$EX_CLI_DIR/core/operation.sh"
. "$EX_CLI_DIR/core/observation.sh"
. "$EX_CLI_DIR/core/terraform-runtime.sh"
. "$EX_CLI_DIR/core/workloads.sh"
. "$EX_CLI_DIR/core/recovery.sh"
. "$EX_CLI_DIR/core/preflight.sh"
EX_OPERATION=$1; shift
EX_TIMEOUT=120
EX_STREAM_OUTPUT=false
EX_RECOVER=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --timeout) [ "$#" -ge 2 ] || ex_die '--timeout needs positive seconds.' 2; EX_TIMEOUT=$2; shift 2 ;;
    --recover) [ "$EX_OPERATION" = down ] || ex_die '--recover is available only for down.' 2; EX_RECOVER=true; shift ;;
    *) case "$EX_OPERATION" in run|logs|connect) break ;; *) ex_die "Unsupported $EX_OPERATION argument: $1" 2 ;; esac ;;
  esac
done
case "$EX_TIMEOUT" in ''|*[!0-9]*) ex_die '--timeout needs positive seconds.' 2 ;; esac
[ "$EX_TIMEOUT" -ge 1 ] && [ "$EX_TIMEOUT" -le 3600 ] || ex_die '--timeout must be between 1 and 3600 seconds.' 2
export EX_TIMEOUT
ex_operation_begin || ex_die 'Cannot establish private runtime state and evidence directories.'
ex_event validation passed 'Version 2 descriptor and local references validated.'
ex_validate_ledger || exit 1
ex_recovery_record || exit 1
if ! ex_local_target; then ex_event preflight failed 'The explicitly selected local kind target could not be verified.'; ex_record_update '.outcome="failed"'; exit 1; fi
ex_record_update '.environment += $target' --slurpfile targets "$EX_OPERATION_DIR/target.json" --argjson target "$(cat "$EX_OPERATION_DIR/target.json")"
ex_preflight_tools || exit 1
if [ "$EX_OPERATION" != down ] && ! ex_terraform_validate; then ex_event preflight failed 'Unsupported native Terraform root or reference tool version.'; ex_record_update '.outcome="failed"'; exit 1; fi
if ! ex_manifest_inventory "$EX_OPERATION_DIR/.private/desired.json"; then ex_event preflight failed 'Unsupported, ambiguous, or invalid native workload configuration.'; ex_record_update '.outcome="failed"'; exit 1; fi
ex_record_update '.units=$units | .stages += [{stage:"preflight",status:"passed",detail:"Local target and supported native configuration inspected."}]' --argjson units "$(jq '[.[].unit] | unique | map({unit:.,status:"not-attempted"})' "$EX_OPERATION_DIR/.private/desired.json")"
case "$EX_OPERATION" in
  up|down)
    ex_lock_runtime || exit 1
    if [ "$EX_OPERATION" = up ]; then
      if ex_workloads_up; then ex_mutation_status=passed; else ex_mutation_status=failed; fi
    else
      if ex_workloads_down; then ex_mutation_status=passed; else ex_mutation_status=failed; fi
      [ "$ex_mutation_status" = passed ] || ex_cleanup_remaining || exit 1
    fi
    ex_recovery_inventory || exit 1
    if ex_observe_inventory "$EX_OPERATION_DIR/.private/observe.json" "$EX_OPERATION_DIR/observations.json"; then :; else
      [ "$ex_mutation_status" != passed ] || ex_mutation_status=inconclusive
    fi
    ex_record_update '.observations=$observations[0] | .outcome=$status' --slurpfile observations "$EX_OPERATION_DIR/observations.json" --arg status "$ex_mutation_status"
    if [ "$EX_OPERATION" = up ] && [ "$ex_mutation_status" = passed ]; then
      if ! jq -e 'all(.resources[]; .state=="present" and .ownership=="owned" and (.kind!="Deployment" or .readiness=="ready")) and (.pods.items|length>0) and all(.pods.items[].containers[]; .ready==true and (.imageID|type=="string" and length>0))' "$EX_OPERATION_DIR/observations.json" >/dev/null; then
        ex_event readiness failed 'Final workload or image identity evidence does not establish a ready startup.'
        ex_mutation_status=failed
      fi
    fi
    if [ -f "$EX_STATE_DIR/ledger.json" ]; then ex_ledger_update '.observedUids=((.observedUids//[])+($observed[0].ownedUids//[])|unique)' --slurpfile observed "$EX_OPERATION_DIR/observations.json" || exit 1; fi
    [ "$ex_mutation_status" = passed ]
    ;;
  inspect)
    ex_inspection_prerequisites=passed
    if ! ex_target_matches_ledger; then ex_event ownership failed 'Recorded and selected local targets differ.'; ex_inspection_prerequisites=failed; fi
    if ! ex_check_existing_namespace; then ex_inspection_prerequisites=failed; fi
    if ! ex_images_available; then ex_inspection_prerequisites=failed; fi
    ex_recovery_inventory || exit 1
    if ex_observe_inventory "$EX_OPERATION_DIR/.private/observe.json" "$EX_OPERATION_DIR/observations.json"; then ex_observation_status=passed; else ex_observation_status=inconclusive; fi
    [ "$ex_inspection_prerequisites" = passed ] || ex_observation_status=failed
    ex_record_update '.observations=$observations[0] | .outcome=$status' --slurpfile observations "$EX_OPERATION_DIR/observations.json" --arg status "$ex_observation_status"
    [ "$ex_observation_status" = passed ]
    ;;
  run|logs|connect)
    . "$EX_CLI_DIR/core/access.sh"
    if ex_access_operation "$EX_OPERATION" "$@"; then exit 0; else exit "$?"; fi
    ;;
  *) ex_event operation failed 'This lifecycle operation has not yet been enabled.'; ex_record_update '.outcome="failed"'; exit 2 ;;
esac
