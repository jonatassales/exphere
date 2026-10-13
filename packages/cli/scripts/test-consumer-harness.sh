#!/bin/sh
# Contract-only tests in disposable consumers; no application, provider or profile access.
set -eu
package=$(CDPATH= cd "$(dirname "$0")/.." && pwd -P)
verify="$package/scripts/verify-consumer-harness.sh"
fixture="$package/fixtures/consumer-harness"
scenarios="$package/fixtures/consumer-harness-scenarios"
area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-harness-test.XXXXXX")
trap 'rm -rf "$area"' 0
trap 'exit 130' INT
trap 'exit 143' HUP TERM
count=0
. "$package/scripts/consumer-harness/files.sh"
fail() { printf 'FAIL: %s\n' "$1" >&2; [ ! -f "$area/err" ] || cat "$area/err" >&2; exit 1; }
pass() { count=$((count+1)); printf 'PASS %02d: %s\n' "$count" "$1"; }
edit() { jq -c "$2" "$1" >"$area/edit.json" && mv "$area/edit.json" "$1"; }
reset() {
  rm -rf "$area/consumer" "$area/scenario"
  mkdir "$area/consumer" "$area/scenario"
  cp -R "$fixture/." "$area/consumer/"
  cp -R "$scenarios/accepted-proposal/." "$area/scenario/"
  consumer="$area/consumer"; config="$consumer/.exphere/config.json"; lock="$consumer/.exphere/lock.json"
}
check() { sh "$verify" --root "$consumer" "$@" >"$area/out" 2>"$area/err"; }
reject() {
  name=$1; diagnostic=$2; shift 2
  if check "$@"; then fail "$name accepted invalid input"; fi
  grep -Fq "$diagnostic" "$area/err" || fail "$name did not identify $diagnostic"
  pass "$name"
}
# Rehash only test mutations so semantic failures are not masked by integrity failures.
rehash() {
  hash=$(h_sha "$consumer/$1")
  jq --arg p "$1" --arg h "$hash" '(.entries[]|select(.path==$p)).sha256=$h' "$lock" >"$area/edit.json"
  mv "$area/edit.json" "$lock"
}
context_hash() {
  hash=$(h_sha "$config")
  jq --arg h "$hash" '.configSha256=$h' "$area/scenario/context.json" >"$area/edit.json"; mv "$area/edit.json" "$area/scenario/context.json"
}
# A controlled shim makes accidental external execution an explicit test failure.
mkdir "$area/forbidden-tools"
for tool in terraform kubectl curl wget docker kind; do
  cat >"$area/forbidden-tools/$tool" <<'EOF'
#!/bin/sh
printf '%s\n' "$0" >>"$EXPHERE_FORBIDDEN_LOG"
exit 99
EOF
  chmod +x "$area/forbidden-tools/$tool"
done
EXPHERE_FORBIDDEN_LOG="$area/forbidden.log"; export EXPHERE_FORBIDDEN_LOG
PATH="$area/forbidden-tools:$PATH"; export PATH
reset
check || fail 'valid reference'
jq -e '.contract=="valid" and (.executionReady|not) and (.financialEnforcement|not)' "$area/out" >/dev/null || fail 'readiness interpretation'
pass 'selected source reference and runtime schema validate without claiming readiness'
cp "$area/out" "$area/first"
check || fail 'repeat validation'
cmp -s "$area/out" "$area/first" || fail 'nondeterministic reference result'
pass 'same input has stable repeated output'
status=0; check --require-ready || status=$?
[ "$status" -eq 3 ] || fail 'unavailable handlers must return status 3'
pass 'required unavailable handlers prevent execution readiness'
[ ! -d "$consumer/.exphere/artifacts" ] && [ ! -e "$consumer/.exphere/agents/diagnostician.json" ] && [ ! -d "$consumer/.exphere/runtimes/website-preview/hooks" ] || fail 'unexpected selected state'
pass 'fresh setup omits history and unselected optional capabilities'
mv "$consumer" "$area/a consumer with spaces"; consumer="$area/a consumer with spaces"
check || fail 'relocation'
mv "$consumer" "$area/consumer"
pass 'reference is portable to an unrelated root with spaces'
reset; edit "$config" '.formatVersion=2'; reject 'unknown version' '/formatVersion'
reset; edit "$config" '.invented=true'; reject 'unknown config field' '/invented'
reset; edit "$config" '.models.profiles[1].id="economy"'; reject 'duplicate model identity' 'duplicate model'
reset; edit "$config" '.selected.workflowRef="../outside.json"'; reject 'parent path escape' '/selected/workflowRef'
reset; edit "$config" '.selected.workflowRef="/etc/passwd"'; reject 'absolute path escape' '/selected/workflowRef'
reset; edit "$config" '.selected.workflowRef=".exphere\\workflow"'; reject 'backslash path escape' '/selected/workflowRef'
reset; edit "$config" '.selected.workflowRef=".exphere/missing.json"'; reject 'unresolved dependency' 'Dependency absent from inventory'
reset; printf '{"formatVersion":1,"formatVersion":1}\n' >"$config"; reject 'duplicate scalar member' 'duplicate JSON member'
reset; printf '{"a":{"x":1},"a":{"y":2}}\n' >"$config"; reject 'duplicate container with distinct children' 'duplicate JSON member'
reset; rm "$consumer/.exphere/skills/review-plan/criteria.md"; reject 'missing supporting skill file' 'Required file not found'
reset; rm "$consumer/.exphere/guides/templates/spec.md"; reject 'missing template never falls back to checkout' 'Required file not found'
reset; rm "$consumer/.exphere/guides/feature.md"; ln -s /etc/passwd "$consumer/.exphere/guides/feature.md"; reject 'escaping file symlink' 'Symlink reference'
reset; mv "$consumer/.exphere/guides" "$area/outside-guides"; ln -s "$area/outside-guides" "$consumer/.exphere/guides"; reject 'escaping directory symlink' 'Symlink reference'; rm -rf "$area/outside-guides"
reset; printf 'tampered\n' >>"$consumer/.exphere/guides/execution.md"; reject 'changed installed asset' 'Inventory integrity mismatch'
reset; printf 'unlisted\n' >"$consumer/unlisted.md"; reject 'uninventoried file' 'Dependency absent from inventory'
reset; edit "$config" '.retrieval.corpora[0].sha256=("0"*64)'; reject 'stale corpus hash' 'Stale retrieval source hash'
reset; edit "$config" '.retrieval.corpora[0].repositoryId="another-repository"'; reject 'cross-repository retrieval' 'cross-repository'
reset; edit "$config" '.retrieval.exclude += ["feature.md"]'; reject 'explicit corpus exclusion' 'Retrieval source matches exclusion'
reset; edit "$config" '.bootstrap.effort="high"'; reject 'unsupported bootstrap effort' 'bootstrap profile/effort'
reset; edit "$config" '.budget.window.start="2000-99-01T00:00:00Z"'; reject 'invalid budget date' 'invalid budget calendar'
reset; edit "$config" '.models.currency="BRL"'; reject 'model and budget currencies conflict' 'currency mismatch'
reset; edit "$config" '.budget.accounts[0].parentId="cycle"'; reject 'cyclic account hierarchy' 'parent hierarchy'
reset; edit "$config" '.infrastructure.maxLifetimeSeconds=30'; reject 'inspection exceeds maximum lifetime' 'lifetime/cadence'
reset; edit "$consumer/.exphere/workflow/definition.json" '.transitions |= .[1:]'; rehash .exphere/workflow/definition.json; reject 'missing common lifecycle transition' 'missing common SDD transition'
reset; edit "$consumer/.exphere/sensors/checks.json" '.checks[0].handler.availability="available"'; rehash .exphere/sensors/checks.json; reject 'unimplemented handler cannot be declared available' 'const mismatch'
reset; edit "$consumer/.exphere/agents/planner.json" '.toolBindings[0].repositoryId="unrelated"'; rehash .exphere/agents/planner.json; reject 'MCP tool scope' 'scope mismatch'
reset; edit "$config" '.stores.graph.path=.stores.accounting.path'; reject 'graph and accounting authority collision' 'share an authority'

for d in "$scenarios"/*; do
  [ -d "$d" ] || continue
  reset; check --scenario "$d" || fail "scenario ${d##*/}"
  jq -e '.scenario.synthetic and (.scenario.dispatchPerformed|not)' "$area/out" >/dev/null || fail 'simulation leaked dispatch'
  pass "synthetic scenario ${d##*/} matches literal oracle and report"
done
# To observe a changed admission reason, rewrite only the expected reason and its
# human-readable counterpart. Monetary oracle values remain independently fixed.
expect_reason() {
  reason=$1
  edit "$area/scenario/expected.json" ".decision=\"rejected\" | .reason=\"$reason\""
  sed "s/Decision: admitted-simulation/Decision: rejected/;s/Reason: covered-synthetic-proposal/Reason: $reason/" "$area/scenario/report.md" >"$area/report.md"
  mv "$area/report.md" "$area/scenario/report.md"
  context_hash
  check --scenario "$area/scenario" || fail "admission $reason"
  pass "synthetic admission rejects $reason"
}
reset; edit "$config" 'del(.models.profiles[0].inputMicrosPerToken)'; expect_reason missing-or-unbounded-price
reset; edit "$area/scenario/scenario.json" '.request.effort="high"'; expect_reason unsupported-effort
reset; edit "$area/scenario/scenario.json" '.request.currency="BRL"'; expect_reason currency-mismatch
reset; edit "$area/scenario/scenario.json" '.request.bounded=false'; expect_reason unbounded-request
reset; edit "$area/scenario/scenario.json" '.request.reservationMicros="2999"'; expect_reason under-reserved-request
reset; edit "$area/scenario/scenario.json" '.request.maxOutputTokens=1001'; expect_reason output-limit-exceeded
reset; edit "$area/scenario/scenario.json" '.request.category="infrastructure"'; expect_reason infrastructure-hard-cap-unavailable
reset; edit "$config" '.bootstrap.allowanceMicros="0"'; edit "$area/scenario/scenario.json" '.request.purpose="planning"'; expect_reason bootstrap-allowance-exceeded
reset; edit "$config" '.budget.accounts[0].caps.ai="100001"'; expect_reason budget-exceeded
reset; edit "$area/scenario/context.json" '.configSha256=("0"*64)'; reject 'context revision mismatch' 'revision mismatch' --scenario "$area/scenario"
reset; edit "$area/scenario/plan.json" '.tasks[0].effort="high"'; reject 'plan unsupported effort' 'plan profile' --scenario "$area/scenario"
reset; cp "$scenarios/pending-charge/accounting.jsonl" "$area/scenario/accounting.jsonl"; jq -c '.amountMicros="0"' "$scenarios/pending-charge/accounting.jsonl" | tail -n 1 >>"$area/scenario/accounting.jsonl"; reject 'conflicting event replay' 'conflicting duplicate' --scenario "$area/scenario"
reset; cp "$scenarios/pending-charge/accounting.jsonl" "$area/scenario/accounting.jsonl"; jq -c '.eventId="financial-3" | .eventType="released" | .amountMicros="0"' "$scenarios/pending-charge/accounting.jsonl" | tail -n 1 >>"$area/scenario/accounting.jsonl"; reject 'timeout cannot refund a charge' 'release requires confirmed' --scenario "$area/scenario"
reset; jq -c 'select(.eventType=="metered")' "$scenarios/duplicate-event/accounting.jsonl" | head -n 1 >"$area/scenario/accounting.jsonl"; reject 'usage without reservation' 'usage requires a prior reservation' --scenario "$area/scenario"
reset; cp "$scenarios/pending-charge/accounting.jsonl" "$area/scenario/accounting.jsonl"
jq -c 'if .eventType=="pending" then .amountMicros="0" else . end' "$area/scenario/accounting.jsonl" >"$area/events"; mv "$area/events" "$area/scenario/accounting.jsonl"; reject 'pending liability cannot shrink' 'retain the full' --scenario "$area/scenario"
reset; edit "$area/scenario/context.json" '.state.financialState="reconciled"'; reject 'inconsistent financial snapshot' 'financial snapshot disagrees' --scenario "$area/scenario"
reset; edit "$area/scenario/expected.json" '.accounts[0].consumedMicros.ai="1"'; reject 'oracle does not self-regenerate' 'differs from expected' --scenario "$area/scenario"
reset; printf 'false success\n' >"$area/scenario/report.md"; reject 'receipt cannot invent success' 'report differs' --scenario "$area/scenario"
reset; edit "$area/scenario/scenario.json" '.contextRef="../context.json"'; reject 'scenario reference escape' '/contextRef' --scenario "$area/scenario"
reset; edit "$area/scenario/events.jsonl" '.eventType="resumed"'; reject 'resume without pause' 'preceding pause' --scenario "$area/scenario"
reset; printf '{"formatVersion":1}\n{\n' >"$area/scenario/accounting.jsonl"; reject 'malformed JSONL' 'invalid event on line' --scenario "$area/scenario"

# Source-contract regression; retired runtime commands are not executed.
for mutation in '.version=3' '.budget=1' '.owner="bad\u0001owner"' '.id="wrong"' '.units.website.component="../website"'; do
  reset; descriptor="$consumer/.exphere/runtimes/website-preview/schema.json"; edit "$descriptor" "$mutation"
  rehash .exphere/runtimes/website-preview/schema.json
  if check; then fail "source verifier accepted malformed descriptor: $mutation"; fi
  pass "source runtime descriptor rejects $mutation"
done
reset; descriptor="$consumer/.exphere/runtimes/website-preview/schema.json"
edit "$descriptor" '.terraform.directory="missing"'
rehash .exphere/runtimes/website-preview/schema.json
reject 'missing native runtime directory' 'Required native reference not found'
reset; native="$consumer/.exphere/runtimes/website-preview/units/website/kubernetes/deployment.json"; before=$(cksum "$native")
check || fail 'source native reference validation'
[ "$before" = "$(cksum "$native")" ] || fail 'validation changed native values'
pass 'source runtime checks preserve native configuration'

# Git inclusion and the private Go task bridge are different contracts.
reset
if command -v git >/dev/null 2>&1; then
  git -C "$consumer" -c init.defaultBranch=fixture init -q
  for path in .exphere/artifacts/accounting/ledger.db .exphere/artifacts/cycles/id/context.json .exphere/state/checkpoint .exphere/cache/index .exphere/logs/raw.log .exphere/secrets/key kubeconfig .env.local .exphere/runtimes/website-preview/terraform/terraform.tfstate; do
    git -C "$consumer" check-ignore -q "$path" || fail "sensitive state not ignored: $path"
  done
  if git -C "$consumer" check-ignore -q .exphere/runtimes/website-preview/terraform/.terraform.lock.hcl; then fail 'provider lock ignored'; fi
  pass 'Git ignores operational state but preserves provider dependency locks'
else fail 'Git is required for the declared inclusion test'; fi
jq -e '.private==true and (has("bin")|not) and .scripts.test=="go test ./..."' "$package/package.json" >/dev/null || fail 'private Go task bridge changed'
pass 'private task bridge has no retired shell executable'
reset; before=$(cd "$consumer" && find . -type f -exec cksum {} \; | LC_ALL=C sort)
check || fail 'non-mutating validation'; after=$(cd "$consumer" && find . -type f -exec cksum {} \; | LC_ALL=C sort)
[ "$before" = "$after" ] || fail 'consumer mutated'
pass 'whole consumer file inventory is unchanged by validation'
mkdir "$area/temp"; printf keep >"$area/temp/unrelated"
status=0; TMPDIR="$area/temp" check --require-ready || status=$?
[ "$status" -eq 3 ] && [ "$(cat "$area/temp/unrelated")" = keep ] || fail 'failure status or unrelated file changed'
[ "$(find "$area/temp" -mindepth 1 | wc -l)" -eq 1 ] || fail 'owned validation temporary files remain'
pass 'nonzero readiness exit cleans only owned temporaries'
# Coordinate a real TERM after the verifier has created its temporary area.
reset
before=$(cd "$consumer" && find . -type f -exec cksum {} \; | LC_ALL=C sort)
mkdir "$area/signal-tools" "$area/signal-temp"
mkfifo "$area/release"
real_jq=$(command -v jq)
cat >"$area/signal-tools/jq" <<'EOF'
#!/bin/sh
if [ "${1:-}" = --stream ] && [ ! -e "$EX_SIGNAL_MARKER" ]; then
  printf 'waiting\n' >"$EX_SIGNAL_MARKER"
  IFS= read -r release <"$EX_SIGNAL_FIFO"
fi
exec "$EX_REAL_JQ" "$@"
EOF
chmod +x "$area/signal-tools/jq"
env PATH="$area/signal-tools:$PATH" TMPDIR="$area/signal-temp" EX_REAL_JQ="$real_jq" EX_SIGNAL_MARKER="$area/signal-marker" EX_SIGNAL_FIFO="$area/release" \
  sh "$verify" --root "$consumer" >"$area/signal.out" 2>"$area/signal.err" &
verifier_pid=$!
tries=0
while [ ! -e "$area/signal-marker" ]; do
  tries=$((tries+1))
  if [ "$tries" -ge 200 ]; then kill -TERM "$verifier_pid" 2>/dev/null || :; fail 'signal rendezvous did not start'; fi
  sleep 0.01
done
kill -TERM "$verifier_pid"
printf 'release\n' >"$area/release"
status=0; wait "$verifier_pid" || status=$?
[ "$status" -eq 143 ] || fail "TERM returned $status rather than 143"
[ -z "$(find "$area/signal-temp" -mindepth 1 -print)" ] || fail 'TERM left temporary output'
after=$(cd "$consumer" && find . -type f -exec cksum {} \; | LC_ALL=C sort)
[ "$before" = "$after" ] || fail 'TERM changed consumer files'
pass 'coordinated TERM preserves consumer files and cleans owned output'
[ ! -e "$EXPHERE_FORBIDDEN_LOG" ] || fail 'external command was executed'
pass 'no Terraform, Kubernetes, network client, Docker or cluster command executed'
printf 'Consumer harness: %s contract checks passed. Local source-contract evidence only; no live execution readiness is established.\n' "$count"
