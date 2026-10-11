#!/bin/sh
set -eu
ps -p "$$" -o stat= >/dev/null 2>&1 || { printf 'Process-boundary verification requires observable local process state.\n' >&2; exit 1; }
. "$(dirname "$0")/lifecycle-fixture.sh"
fixture_init
trap fixture_cleanup EXIT HUP INT TERM
cat >"$fixture_tools/pgrep" <<'TOOL'
#!/bin/sh
exit 2
TOOL
chmod +x "$fixture_tools/pgrep"
if fixture_ex inspect >"$fixture_area/unavailable.out" 2>"$fixture_area/unavailable.err"; then fixture_fail 'unavailable process enumeration passed preflight'; fi
[ ! -s "$fixture_state/calls" ] || fixture_fail 'native tools ran without usable process enumeration'
rm "$fixture_tools/pgrep"
mkdir "$fixture_runtime/hooks"
jq '.hooks={resist:"hooks/resist.sh"}' "$fixture_runtime/schema.json" >"$fixture_area/descriptor.json"
mv "$fixture_area/descriptor.json" "$fixture_runtime/schema.json"
cat >"$fixture_runtime/hooks/resist.sh" <<'HOOK'
#!/bin/sh
sh -c 'trap "" TERM; printf "%s\n" "$$" >"$EX_RUNTIME_DIR/resistant-pid"; while :; do sleep 1; done' >/dev/null 2>&1 &
wait
HOOK
status=0
fixture_ex run --timeout 4 resist --effects none >"$fixture_area/timeout.out" 2>"$fixture_area/timeout.err" || status=$?
[ "$status" -eq 124 ] || { cat "$fixture_area/timeout.err"; fixture_fail 'resistant descendant did not hit the operation bound'; }
[ -f "$fixture_runtime/resistant-pid" ] || fixture_fail 'resistant hook never started'
process_state=$(ps -p "$(cat "$fixture_runtime/resistant-pid")" -o stat= 2>/dev/null | tr -d ' ' || true)
case "$process_state" in ''|Z*) ;; *) kill -KILL "$(cat "$fixture_runtime/resistant-pid")" 2>/dev/null || true; fixture_fail 'TERM-resistant descendant survived bounded shutdown' ;; esac
printf 'Process boundary: a TERM-resistant owned descendant is stopped at timeout.\n'
fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err" || fixture_fail 'uncertain process setup failed'
fixture_pgrep=$(command -v pgrep)
export EX_FIXTURE_PGREP="$fixture_pgrep"
cat >"$fixture_tools/pgrep" <<'TOOL'
#!/bin/sh
if [ -f "$EX_FIXTURE_STATE/enumeration-failed" ]; then exit 2; fi
exec "$EX_FIXTURE_PGREP" "$@"
TOOL
cat >"$fixture_runtime/hooks/uncertain.sh" <<'HOOK'
#!/bin/sh
printf '%s\n' "$$" >"$EX_RUNTIME_DIR/uncertain-pid"
: >"$EX_FIXTURE_STATE/enumeration-failed"
exec sleep 30
HOOK
chmod +x "$fixture_tools/pgrep"
jq '.hooks.uncertain="hooks/uncertain.sh"' "$fixture_runtime/schema.json" >"$fixture_area/descriptor.json"
mv "$fixture_area/descriptor.json" "$fixture_runtime/schema.json"
status=0
fixture_ex run --timeout 7 uncertain --effects runtime >"$fixture_area/uncertain.out" 2>"$fixture_area/uncertain.err" || status=$?
if [ -f "$fixture_runtime/uncertain-pid" ]; then kill -KILL "$(cat "$fixture_runtime/uncertain-pid")" 2>/dev/null || true; fi
[ "$status" -ne 0 ] || fixture_fail 'unobservable process ancestry passed'
[ -f "$fixture_project/.exphere/state/runtimes/demo/lock/uncertain" ] || fixture_fail 'unobservable ancestry released the mutation boundary'
rm "$fixture_state/enumeration-failed" "$fixture_tools/pgrep"
printf 'Process boundary: unavailable enumeration refuses execution; later failure retains its mutation lock.\n'
