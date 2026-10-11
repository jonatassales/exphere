#!/bin/sh
# Private local operation state and bounded native commands.
ex_random() { od -An -N12 -tx1 /dev/urandom | tr -d ' \n'; }
ex_hash() { shasum -a 256 "$1" | awk '{print $1}'; }
ex_now() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }
ex_private_directory() {
  ex_directory_base=$1
  ex_directory_relative=$2
  ex_directory_cursor=$ex_directory_base
  ex_directory_old_ifs=$IFS
  IFS=/
  for ex_directory_part in $ex_directory_relative; do
    IFS=$ex_directory_old_ifs
    case "$ex_directory_part" in ''|.|..) return 1 ;; esac
    ex_directory_cursor="$ex_directory_cursor/$ex_directory_part"
    [ ! -L "$ex_directory_cursor" ] || { printf 'ex: operational directory cannot be a symlink.\n' >&2; return 1; }
    [ -d "$ex_directory_cursor" ] || mkdir "$ex_directory_cursor" || return 1
    IFS=/
  done
  IFS=$ex_directory_old_ifs
}
ex_record_update() {
  ex_record_filter=$1
  shift
  jq "$@" "$ex_record_filter" "$EX_RECORD" >"$EX_RECORD.next" && mv "$EX_RECORD.next" "$EX_RECORD"
}
ex_event() {
  ex_record_update '.stages += [{stage:$stage,status:$status,detail:$detail,time:$time}] | if $status=="failed" then .outcome="failed" else . end' --arg stage "$1" --arg status "$2" --arg detail "$3" --arg time "$(ex_now)"
}
ex_child_pids() (
  if ex_enum_children=$(pgrep -P "$1" 2>/dev/null); then ex_enum_status=0; else ex_enum_status=$?; fi
  case "$ex_enum_status" in
    0) [ -n "$ex_enum_children" ] || return 1 ;;
    1) [ -z "$ex_enum_children" ] && return 0; return 1 ;;
    *) return 1 ;;
  esac
  for ex_enum_child in $ex_enum_children; do
    case "$ex_enum_child" in ''|*[!0-9]*) return 1 ;; esac
    [ "$ex_enum_child" -gt 1 ] && [ "$ex_enum_child" != "$1" ] || return 1
  done
  printf '%s\n' "$ex_enum_children"
)
ex_process_tools() (
  command -v pgrep >/dev/null 2>&1 && command -v ps >/dev/null 2>&1 || return 1
  ex_child_pids "$$" >/dev/null || return 1
  ex_probe_state=$(ps -o stat= -p "$$" 2>/dev/null) && [ -n "$ex_probe_state" ]
)
ex_process_tree() (
  ex_tree_status=0
  if ex_tree_children=$(ex_child_pids "$1"); then
    for ex_tree_child in $ex_tree_children; do ex_process_tree "$ex_tree_child" || ex_tree_status=1; done
  else ex_tree_status=1; fi
  # Even an incomplete tree must retain the root whose identity is known.
  printf '%s\n' "$1"
  return "$ex_tree_status"
)
ex_stop_children() (
  if ex_stop_processes=$(ex_process_tree "$1"); then ex_stop_status=0; else ex_stop_status=1; fi
  for ex_stop_pid in $ex_stop_processes; do kill -TERM "$ex_stop_pid" 2>/dev/null || true; done
  if [ "$ex_stop_status" -ne 0 ]; then
    # Unknown ancestry must not leave known FIFO readers or watchers blocking.
    for ex_stop_pid in $ex_stop_processes; do kill -KILL "$ex_stop_pid" 2>/dev/null || true; done
  fi
  return "$ex_stop_status"
)
ex_bounded() {
  ex_bound_seconds=$1; ex_bound_stdout=$2; ex_bound_stderr=$3; shift 3
  EX_LAST_TIMED_OUT=false
  ex_bound_remaining=$((EX_DEADLINE-$(date +%s)))
  if [ "$ex_bound_remaining" -le 0 ]; then EX_LAST_STATUS=124; EX_LAST_TIMED_OUT=true; return 124; fi
  [ "$ex_bound_seconds" -le "$ex_bound_remaining" ] || ex_bound_seconds=$ex_bound_remaining
  if ! ex_process_tools; then
    EX_LAST_STATUS=1
    ex_event process-tools failed 'Usable pgrep and ps are required before launching bounded native commands.'
    return 1
  fi
  ex_bound_marker="$EX_OPERATION_DIR/.private/timeout-$(ex_random)"
  ex_bound_pipe="$EX_OPERATION_DIR/.private/output-$(ex_random)"
  case "${EX_CAPTURE_LIMIT:-4194304}" in 65536) ex_bound_limit=65536 ;; *) ex_bound_limit=4194304 ;; esac
  mkfifo "$ex_bound_pipe.out" "$ex_bound_pipe.err" || return 1
  # Readers keep draining after the cap so a noisy child cannot deadlock or
  # fill the evidence disk. Truncation invalidates the native result.
  (head -c "$ex_bound_limit" >"$ex_bound_stdout"; if [ -n "$(dd bs=1 count=1 2>/dev/null | od -An -tx1)" ]; then : >"$ex_bound_pipe.truncated"; fi; cat >/dev/null) <"$ex_bound_pipe.out" &
  ex_bound_out_pid=$!
  (head -c "$ex_bound_limit" >"$ex_bound_stderr"; if [ -n "$(dd bs=1 count=1 2>/dev/null | od -An -tx1)" ]; then : >"$ex_bound_pipe.truncated"; fi; cat >/dev/null) <"$ex_bound_pipe.err" &
  ex_bound_err_pid=$!
  EX_CAPTURE_PIDS="$ex_bound_out_pid $ex_bound_err_pid"
  "$@" >"$ex_bound_pipe.out" 2>"$ex_bound_pipe.err" &
  EX_CHILD_PID=$!
  if [ "${EX_LOCK_HELD:-false}" = true ]; then printf '%s\n' "$EX_CHILD_PID" >"$EX_STATE_DIR/lock/child"; fi
  (
    trap - EXIT INT TERM HUP
    sleep "$ex_bound_seconds"
    if kill -0 "$EX_CHILD_PID" 2>/dev/null || kill -0 "$ex_bound_out_pid" 2>/dev/null || kill -0 "$ex_bound_err_pid" 2>/dev/null; then
      : >"$ex_bound_marker"
      if kill -0 "$EX_CHILD_PID" 2>/dev/null; then
        if ex_timeout_processes=$(ex_process_tree "$EX_CHILD_PID"); then :; else : >"$ex_bound_pipe.uncertain"; fi
        for ex_timeout_pid in $ex_timeout_processes; do kill -TERM "$ex_timeout_pid" 2>/dev/null || true; done
        sleep 1
        for ex_timeout_pid in $ex_timeout_processes; do kill -KILL "$ex_timeout_pid" 2>/dev/null || true; done
        for ex_timeout_pid in $ex_timeout_processes; do
          if kill -0 "$ex_timeout_pid" 2>/dev/null; then
            ex_timeout_state=$(ps -o stat= -p "$ex_timeout_pid" 2>/dev/null || true)
            case "$ex_timeout_state" in Z*) ;; *) : >"$ex_bound_pipe.uncertain" ;; esac
          fi
        done
      else
        # A producer exited while inherited streams stayed open: its remaining
        # process ancestry can no longer be established from the live parent.
        : >"$ex_bound_pipe.uncertain"
      fi
      ex_stop_children "$ex_bound_out_pid" || : >"$ex_bound_pipe.uncertain"
      ex_stop_children "$ex_bound_err_pid" || : >"$ex_bound_pipe.uncertain"
    fi
  ) &
  EX_WATCH_PID=$!
  if wait "$EX_CHILD_PID"; then EX_LAST_STATUS=0; else EX_LAST_STATUS=$?; fi
  wait "$ex_bound_out_pid" || EX_LAST_STATUS=1
  wait "$ex_bound_err_pid" || EX_LAST_STATUS=1
  # Once a timeout starts, its KILL/reconciliation pass owns shutdown. A
  # descendant may close both streams before it stops running.
  if [ ! -f "$ex_bound_marker" ]; then ex_stop_children "$EX_WATCH_PID" || : >"$ex_bound_pipe.uncertain"; fi
  wait "$EX_WATCH_PID" 2>/dev/null || true
  EX_CHILD_PID=; EX_WATCH_PID=
  EX_CAPTURE_PIDS=
  if [ "${EX_LOCK_HELD:-false}" = true ]; then rm -f "$EX_STATE_DIR/lock/child"; fi
  if [ -f "$ex_bound_marker" ]; then EX_LAST_TIMED_OUT=true; EX_LAST_STATUS=124; rm -f "$ex_bound_marker"; fi
  if [ -f "$ex_bound_pipe.uncertain" ]; then
    EX_PROCESS_UNCERTAIN=true
    [ "$EX_LAST_STATUS" -ne 0 ] || EX_LAST_STATUS=1
    ex_event process-ownership failed 'A remaining child process cannot be ruled out; retain any mutation lock for manual process reconciliation.'
  fi
  if [ -f "$ex_bound_pipe.truncated" ]; then EX_LAST_STATUS=125; ex_event output failed "Native output exceeded its $ex_bound_limit byte per-stream capture limit."; fi
  rm -f "$ex_bound_pipe.out" "$ex_bound_pipe.err" "$ex_bound_pipe.truncated" "$ex_bound_pipe.uncertain"
  return "$EX_LAST_STATUS"
}
ex_operation_begin() {
  umask 077
  ex_private_directory "$EX_PROJECT_ROOT" .exphere/state/runtimes || return 1
  ex_private_directory "$EX_PROJECT_ROOT" ".exphere/state/runtimes/$EX_RUNTIME_ID" || return 1
  EX_STATE_DIR="$EX_PROJECT_ROOT/.exphere/state/runtimes/$EX_RUNTIME_ID"
  chmod 700 "$EX_STATE_DIR"
  for ex_private_file in ledger.json ledger.next desired.json owner terraform-target.json terraform.tfstate; do
    [ ! -L "$EX_STATE_DIR/$ex_private_file" ] || return 1
  done
  [ ! -L "$EX_PROJECT_ROOT/.exphere/state/.gitignore" ] || return 1
  printf '*\n' >"$EX_PROJECT_ROOT/.exphere/state/.gitignore"
  ex_private_directory "$EX_PROJECT_ROOT" .audits/evidence/runs || return 1
  [ ! -L "$EX_PROJECT_ROOT/.audits/evidence/runs/.gitignore" ] || return 1
  printf '*\n' >"$EX_PROJECT_ROOT/.audits/evidence/runs/.gitignore"
  EX_RUN_ID="$(date -u '+%Y%m%dT%H%M%SZ')-$EX_RUNTIME_ID-$EX_OPERATION-$(ex_random)"
  EX_OPERATION_DIR="$EX_PROJECT_ROOT/.audits/evidence/runs/$EX_RUN_ID"
  mkdir "$EX_OPERATION_DIR" "$EX_OPERATION_DIR/.private" || return 1
  EX_RECORD="$EX_OPERATION_DIR/record.json"
  EX_STARTED=$(date +%s)
  EX_DEADLINE=$((EX_STARTED+EX_TIMEOUT))
  EX_OWNER_TOKEN=
  if [ -e "$EX_STATE_DIR/owner" ]; then
    [ -f "$EX_STATE_DIR/owner" ] && [ ! -L "$EX_STATE_DIR/owner" ] || return 1
    EX_OWNER_TOKEN=$(cat "$EX_STATE_DIR/owner")
    case "$EX_OWNER_TOKEN" in ''|*[!0-9a-f]*) return 1 ;; esac
  else
    EX_OWNER_TOKEN=$(ex_random)
    # A read-only inspection never establishes deletion authority.
  fi
  ex_code_revision=$(git -C "$EX_PROJECT_ROOT" rev-parse HEAD 2>/dev/null || printf unavailable)
  ex_config_revision=$(ex_hash "$EX_RUNTIME_SCHEMA")
  jq -n --arg operation "$EX_OPERATION" --arg run "$EX_RUN_ID" --arg runtime "$EX_RUNTIME_ID" --arg started "$(ex_now)" --arg revision "$ex_code_revision" --arg config "$ex_config_revision" --arg context "$EX_KUBERNETES_CONTEXT" --arg namespace "$EX_KUBERNETES_NAMESPACE" --arg owner "$(jq -r '.owner' "$EX_RUNTIME_SCHEMA")" --arg evidence "$EX_RECORD" \
    '{schemaVersion:1,initiative:"PRD-0002",spec:"SPEC-MICRORUNTIME-LIFECYCLE",requirements:["REQ-MR-005","REQ-MR-006","REQ-MR-007","REQ-MR-008","REQ-MR-009","REQ-MR-010","REQ-MR-011","REQ-MR-012","REQ-MR-013","REQ-MR-014"],operation:$operation,runId:$run,runtime:$runtime,owner:$owner,started:$started,ended:null,input:{codeRevision:$revision,descriptorSha256:$config},environment:{context:$context,namespace:$namespace},policies:{FinOps:"v1",TwelveFactor:"v1"},stages:[],units:[],observations:null,cleanup:null,outcome:"inconclusive",load:"No load test performed",record:$evidence}' >"$EX_RECORD" || return 1
  EX_EXIT_STATUS=1; EX_LOCK_HELD=false; EX_CHILD_PID=; EX_WATCH_PID=
  export EX_STATE_DIR EX_RUN_ID EX_OPERATION_DIR EX_RECORD EX_OWNER_TOKEN
  trap 'ex_operation_signal' HUP INT TERM
  trap 'ex_operation_finish' EXIT
  find "$EX_RUNTIME_DIR" -type f -print | sort >"$EX_OPERATION_DIR/.private/input-paths"
  : >"$EX_OPERATION_DIR/.private/input-hashes"
  while IFS= read -r ex_input_file; do
    [ -f "$ex_input_file" ] || return 1
    jq -nc --arg path "${ex_input_file#"$EX_RUNTIME_DIR"/}" --arg sha "$(ex_hash "$ex_input_file")" '{path:$path,sha256:$sha}' >>"$EX_OPERATION_DIR/.private/input-hashes"
  done <"$EX_OPERATION_DIR/.private/input-paths"
  if git -C "$EX_PROJECT_ROOT" status --porcelain --untracked-files=normal -- "$EX_RUNTIME_DIR" >"$EX_OPERATION_DIR/.private/git-status" 2>/dev/null; then
    if [ -s "$EX_OPERATION_DIR/.private/git-status" ]; then ex_input_dirty=dirty-or-untracked; else ex_input_dirty=clean; fi
  else ex_input_dirty=unavailable; fi
  ex_record_update '.input.files=$files | .input.configurationWorktree=$dirty | .input.components=$descriptor[0].units' --slurpfile files "$EX_OPERATION_DIR/.private/input-hashes" --arg dirty "$ex_input_dirty" --slurpfile descriptor "$EX_RUNTIME_SCHEMA"
}
ex_operation_signal() {
  trap '' HUP INT TERM
  if [ -n "${EX_CHILD_PID:-}" ]; then
    if ex_signal_processes=$(ex_process_tree "$EX_CHILD_PID"); then :; else EX_PROCESS_UNCERTAIN=true; fi
    for ex_signal_pid in $ex_signal_processes; do kill -TERM "$ex_signal_pid" 2>/dev/null || true; done
    sleep 1
    for ex_signal_pid in $ex_signal_processes; do kill -KILL "$ex_signal_pid" 2>/dev/null || true; done
    wait "$EX_CHILD_PID" 2>/dev/null || true
    EX_CHILD_PID=
  fi
  if [ -n "${EX_WATCH_PID:-}" ]; then ex_stop_children "$EX_WATCH_PID" || EX_PROCESS_UNCERTAIN=true; fi
  for ex_capture_pid in ${EX_CAPTURE_PIDS:-}; do ex_stop_children "$ex_capture_pid" || EX_PROCESS_UNCERTAIN=true; done
  ex_event cancellation failed 'Operation interrupted; remote effects may be partial.' || true
  EX_EXIT_STATUS=130
  exit 130
}
ex_operation_finish() {
  ex_finish_status=$?
  trap - EXIT HUP INT TERM
  if [ -n "${EX_CHILD_PID:-}" ]; then ex_stop_children "$EX_CHILD_PID" || EX_PROCESS_UNCERTAIN=true; fi
  if [ -n "${EX_WATCH_PID:-}" ]; then ex_stop_children "$EX_WATCH_PID" || EX_PROCESS_UNCERTAIN=true; fi
  for ex_capture_pid in ${EX_CAPTURE_PIDS:-}; do ex_stop_children "$ex_capture_pid" || EX_PROCESS_UNCERTAIN=true; done
  if [ "${EX_PROCESS_UNCERTAIN:-false}" = true ]; then
    [ "$ex_finish_status" -ne 0 ] || ex_finish_status=1
    ex_event process-ownership failed 'Process ancestry could not be reconciled; any mutation lock is retained for manual reconciliation.' || true
  fi
  if [ "${EX_LOCK_HELD:-false}" = true ] && [ "${EX_PROCESS_UNCERTAIN:-false}" = true ]; then
    printf 'Process ownership requires manual reconciliation.\n' >"$EX_STATE_DIR/lock/uncertain"
  elif [ "${EX_LOCK_HELD:-false}" = true ]; then
    rm -f "$EX_STATE_DIR/lock/pid" "$EX_STATE_DIR/lock/deadline" "$EX_STATE_DIR/lock/child"
    rmdir "$EX_STATE_DIR/lock" 2>/dev/null || true
  fi
  if [ "${EX_GUARD_HELD:-false}" = true ]; then rmdir "$EX_STATE_DIR/lock-guard" 2>/dev/null || true; fi
  # Raw native outputs may contain credentials or application data.
  if [ -n "${EX_OPERATION_DIR:-}" ]; then rm -rf "$EX_OPERATION_DIR/.private"; fi
  if [ -f "${EX_RECORD:-}" ]; then
    ex_record_update '.ended=$ended | .durationSeconds=$duration | if $status != 0 and .outcome=="passed" then .outcome="failed" else . end' --arg ended "$(ex_now)" --argjson duration "$(($(date +%s)-EX_STARTED))" --argjson status "$ex_finish_status" || ex_finish_status=1
    if [ "${EX_STREAM_OUTPUT:-false}" = true ]; then printf 'ex: operation record: %s\n' "$EX_RECORD" >&2; else cat "$EX_RECORD"; fi
  fi
  exit "$ex_finish_status"
}
ex_lock_runtime() {
  # Serialize both normal acquisition and stale-lock recovery. Validating an
  # old pathname and renaming it without this guard can steal a new lock.
  if ! mkdir "$EX_STATE_DIR/lock-guard" 2>/dev/null; then
    ex_event lock failed 'Another lock acquisition or unresolved acquisition guard exists; mutation is refused.'
    return 1
  fi
  EX_GUARD_HELD=true
  if ! mkdir "$EX_STATE_DIR/lock" 2>/dev/null; then
    if ! ex_recover_lock || ! mkdir "$EX_STATE_DIR/lock" 2>/dev/null; then
      ex_event lock failed 'A mutation lock exists; explicit down --recover requires expired bounds and no live recorded process.'
      rmdir "$EX_STATE_DIR/lock-guard" || return 1
      EX_GUARD_HELD=false
      return 1
    fi
  fi
  EX_LOCK_HELD=true
  printf '%s\n' "$$" >"$EX_STATE_DIR/lock/pid"
  printf '%s\n' "$EX_DEADLINE" >"$EX_STATE_DIR/lock/deadline"
  [ ! -L "$EX_STATE_DIR/last-run" ] || return 1
  printf '%s\n' "$EX_RUN_ID" >"$EX_STATE_DIR/last-run"
  if [ ! -e "$EX_STATE_DIR/owner" ]; then printf '%s\n' "$EX_OWNER_TOKEN" >"$EX_STATE_DIR/owner"; fi
  rmdir "$EX_STATE_DIR/lock-guard" || return 1
  EX_GUARD_HELD=false
}
ex_kubectl() {
  env KUBECTL_KUBERC=false kubectl "--kubeconfig=$EX_KUBECONFIG" "--context=$EX_KUBERNETES_CONTEXT" "--namespace=$EX_KUBERNETES_NAMESPACE" --request-timeout=15s "$@"
}
ex_query() {
  ex_query_target=$1; shift
  if ex_bounded "$EX_TIMEOUT" "$ex_query_target" "$EX_OPERATION_DIR/.private/kubectl.err" ex_kubectl "$@"; then ex_query_status=0; else ex_query_status=$?; fi
  ex_record_update '.commands=((.commands//[])+[{tool:"kubectl",action:$action,exitStatus:$status,timedOut:$timeout}])' --arg action "$1" --argjson status "$ex_query_status" --argjson timeout "$EX_LAST_TIMED_OUT" || return 1
  return "$ex_query_status"
}
