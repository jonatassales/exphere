#!/bin/sh
set -eu
. "$(dirname "$0")/lifecycle-fixture.sh"
fixture_init
trap fixture_cleanup EXIT HUP INT TERM
fixture_ex inspect >"$fixture_area/inspect.out" 2>"$fixture_area/inspect.err" || { cat "$fixture_area/inspect.err"; fixture_fail 'valid local configuration cannot be inspected'; }
jq -e '.operation == "inspect" and .outcome == "passed"' "$fixture_area/inspect.out" >/dev/null || fixture_fail 'inspection does not expose its operation record'
fixture_ex up >"$fixture_area/up.out" 2>"$fixture_area/up.err" || { cat "$fixture_area/up.err"; cat "$fixture_area/up.out"; fixture_fail 'startup failed'; }
jq -e '.outcome=="passed" and all(.units[]; .status=="ready")' "$fixture_area/up.out" >/dev/null || fixture_fail 'startup does not report readiness'
fixture_ex down >"$fixture_area/down.out" 2>"$fixture_area/down.err" || { cat "$fixture_area/down.err"; cat "$fixture_area/down.out"; fixture_fail 'cleanup failed'; }
jq -e '.cleanup.complete==true and .outcome=="passed"' "$fixture_area/down.out" >/dev/null || fixture_fail 'cleanup evidence missing'
[ ! -e "$fixture_state/namespace.json" ] || fixture_fail 'namespace survived complete cleanup'
fixture_ex down >"$fixture_area/repeated.out" 2>"$fixture_area/repeated.err" || fixture_fail 'repeated cleanup failed'
printf 'Lifecycle contract: preflight, startup, inspection, cleanup, and repeated cleanup passed.\n'
