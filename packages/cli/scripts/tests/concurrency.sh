#!/bin/sh
set -eu
. "$(dirname "$0")/lifecycle-fixture.sh"
fixture_init
trap fixture_cleanup EXIT HUP INT TERM
fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err" || fixture_fail 'concurrency setup failed'
export EX_FIXTURE_LOCK_DIR="$(CDPATH= cd "$fixture_project" && pwd -P)/.exphere/state/runtimes/demo/lock"
mkdir "$EX_FIXTURE_LOCK_DIR"
printf '99999999\n' >"$EX_FIXTURE_LOCK_DIR/pid"
printf '1\n' >"$EX_FIXTURE_LOCK_DIR/deadline"
cat >"$fixture_tools/mv" <<'TOOL'
#!/bin/sh
if [ "$1" = "$EX_FIXTURE_LOCK_DIR" ]; then
  : >"$EX_FIXTURE_STATE/recovery-claim"
  attempts=0
  while [ ! -f "$EX_FIXTURE_STATE/release-claim" ] && [ "$attempts" -lt 60 ]; do sleep 1; attempts=$((attempts+1)); done
fi
exec /bin/mv "$@"
TOOL
chmod +x "$fixture_tools/mv"
fixture_ex down --recover >"$fixture_area/first.out" 2>"$fixture_area/first.err" &
first_pid=$!
attempts=0
while [ ! -f "$fixture_state/recovery-claim" ] && [ "$attempts" -lt 60 ]; do sleep 1; attempts=$((attempts+1)); done
[ -f "$fixture_state/recovery-claim" ] || { cat "$fixture_area/first.out" "$fixture_area/first.err" >&2; kill -TERM "$first_pid" 2>/dev/null || true; fixture_fail 'first recovery never claimed the stale lock'; }
if fixture_ex down --recover >"$fixture_area/second.out" 2>"$fixture_area/second.err"; then fixture_fail 'competing recovery entered the same mutation boundary'; fi
jq -e 'any(.stages[]; .stage=="lock" and .status=="failed")' "$fixture_area/second.out" >/dev/null || fixture_fail 'contended recovery did not explain its boundary'
: >"$fixture_state/release-claim"
wait "$first_pid" || { cat "$fixture_area/first.err"; fixture_fail 'first recovery failed after exclusive claim'; }
jq -e '.cleanup.complete and .outcome=="passed"' "$fixture_area/first.out" >/dev/null || fixture_fail 'exclusive recovery did not finish cleanup'
printf 'Concurrency: stale-lock recovery claims are serialized with normal mutation acquisition.\n'
