#!/bin/sh
set -eu
package_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd -P)
cli="$package_dir/cli/ex.sh"
area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-configuration.XXXXXX")
trap 'rm -rf "$area"' EXIT HUP INT TERM
consumer="$area/consumer"
mkdir -p "$consumer/apps/website"
printf 'consumer source\n' >"$consumer/apps/website/source.txt"
fail() { printf 'Configuration contract failed: %s\n' "$1" >&2; exit 1; }
ex() { sh "$cli" --root "$consumer" "$@"; }
ex runtime pilot init >"$area/init.out"
runtime="$consumer/.exphere/runtimes/pilot"
[ -f "$runtime/schema.json" ] || fail 'New initialization did not use the v2 location.'
jq -e '.version == 2 and .id == "pilot" and .units == {}' "$runtime/schema.json" >/dev/null || fail 'Manual initialization has unexpected identity or units.'
[ ! -d "$runtime/terraform" ] && [ ! -d "$runtime/hooks" ] || fail 'Manual initialization created unused capability directories.'
before=$(cksum "$runtime/schema.json")
if ex runtime pilot init >"$area/repeat.out" 2>&1; then fail 'Repeated initialization succeeded.'; fi
[ "$(cksum "$runtime/schema.json")" = "$before" ] || fail 'Repeated initialization changed the descriptor.'
printf 'Configuration contract: manual initialization preserves existing content.\n'
if ex runtime pilot validate >"$area/incomplete.out" 2>&1; then fail 'An incomplete manual descriptor passed validation.'; fi
grep -Fq owner "$area/incomplete.out" || fail 'Incomplete validation did not identify the owner field.'
mkdir -p "$runtime/terraform" "$runtime/units/website/kubernetes/nested" "$consumer/packages/worker" "$runtime/units/worker/kubernetes"
printf '{"terraform":{"backend":{"local":{}}}}\n' >"$runtime/terraform/main.tf.json"
printf '{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"name":"website"}}\n' >"$runtime/units/website/kubernetes/nested/deployment.json"
printf '{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"name":"worker"}}\n' >"$runtime/units/worker/kubernetes/deployment.json"
jq '.owner = "team-example" | .units = {website: {component: "apps/website", kubernetes: {manifests: "units/website/kubernetes"}}, worker: {component: "packages/worker", kubernetes: {manifests: "units/worker/kubernetes"}}} | .kubernetes = {context: "kind-pilot", namespace: "pilot"}' "$runtime/schema.json" >"$area/schema.json"
mv "$area/schema.json" "$runtime/schema.json"
ex runtime pilot validate >"$area/validate.out" || { cat "$area/validate.out"; fail 'A complete manual v2 descriptor was rejected.'; }
(cd "$consumer/apps/website" && sh "$cli" runtime pilot validate) >"$area/nested.out" || fail 'Automatic project discovery failed from a component directory.'
ex runtime list >"$area/list.out"
grep -Fq 'pilot' "$area/list.out" && grep -Fq 'v2' "$area/list.out" && grep -Fq '.exphere/runtimes/pilot/schema.json' "$area/list.out" || fail 'Discovery omitted version or descriptor location.'
printf 'Configuration contract: complete multi-unit v2 input resolves from the consumer project.\n'
cp "$runtime/schema.json" "$area/valid.json"
for mutation in '.owner = "  "' '.version = 9' '.extra = true' '.units.website.image = "forbidden"' '.units.website.component = "../escape"' '.units.website.component = "packages/worker"' '.units.website.kubernetes.manifests = "missing"' '.kubernetes.context = ""' '.hooks = {prepare: "hooks/missing.sh"}'; do
  jq "$mutation" "$area/valid.json" >"$runtime/schema.json"
  before=$(cksum "$runtime/schema.json")
  if ex runtime pilot validate >"$area/invalid.out" 2>&1; then fail "Validation accepted $mutation"; fi
  [ "$(cksum "$runtime/schema.json")" = "$before" ] || fail 'Validation rewrote consumer configuration.'
done
cp "$area/valid.json" "$runtime/schema.json"
mkdir -p "$area/outside/website"
ln -s "$area/outside/website" "$consumer/apps/escape"
jq '.units.website.component = "apps/escape"' "$area/valid.json" >"$runtime/schema.json"
if ex runtime pilot validate >"$area/escape.out" 2>&1; then fail 'Component symlink escape was accepted.'; fi
cp "$area/valid.json" "$runtime/schema.json"
mkdir "$runtime/hooks"
printf '#!/bin/sh\nprintf forbidden >"$EX_RUNTIME_DIR/hook-ran"\n' >"$runtime/hooks/prepare.sh"
jq '.hooks = {prepare: "hooks/prepare.sh"}' "$area/valid.json" >"$runtime/schema.json"
ex runtime pilot validate >"$area/hooks.out"
[ ! -f "$runtime/hook-ran" ] || fail 'Validation invoked an explicit hook.'
printf '{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"name":"edited"}}\n' >"$runtime/units/website/kubernetes/nested/deployment.json"
native_before=$(cksum "$runtime/units/website/kubernetes/nested/deployment.json")
ex runtime pilot validate >"$area/edited.out"
[ "$(cksum "$runtime/units/website/kubernetes/nested/deployment.json")" = "$native_before" ] || fail 'Validation rewrote consumer native edits.'
[ "$(cat "$consumer/apps/website/source.txt")" = 'consumer source' ] || fail 'Configuration touched application source.'
if ex runtime pilot terraform apply >"$area/bypass.out" 2>&1; then fail 'v2 exposed the raw mutation adapter.'; fi
grep -Fq lifecycle "$area/bypass.out" || fail 'v2 adapter rejection did not explain lifecycle operations.'
ex runtime previous init --legacy >"$area/legacy.out"
ex runtime previous validate >>"$area/legacy.out" 2>&1 || fail 'Explicit legacy v1 validation regressed.'
ex runtime list >"$area/list.out"
grep -Fq 'v1' "$area/list.out" && grep -Fq '.micro-runtime/previous/schema.json' "$area/list.out" || fail 'Legacy discovery omitted its version or path.'
mkdir -p "$consumer/.micro-runtime/pilot"
printf '{"version":1,"id":"pilot","components":{}}\n' >"$consumer/.micro-runtime/pilot/schema.json"
if ex runtime pilot validate >"$area/ambiguous.out" 2>&1; then fail 'Same-ID location ambiguity was accepted.'; fi
grep -Fq Ambiguous "$area/ambiguous.out" || fail 'Ambiguity failure did not explain duplicate locations.'
rm -r "$consumer/.micro-runtime/pilot"
printf 'Configuration contract: invalid references, native edits, explicit hooks and legacy boundaries passed.\n'
unsafe="$area/unsafe"
mkdir "$unsafe" "$area/outside-config"
ln -s "$area/outside-config" "$unsafe/.exphere"
if sh "$cli" --root "$unsafe" runtime rejected init >"$area/unsafe.out" 2>&1; then fail 'Initialization followed an escaping configuration parent.'; fi
[ ! -e "$area/outside-config/runtimes" ] || fail 'Initialization wrote outside the consumer before rejecting the symlink.'
printf 'Configuration contract: initialization rejects escaping parents before writing.\n'
sed 's/"id": "pilot"/"id": "conflicting", "id": "pilot"/' "$area/valid.json" >"$runtime/schema.json"
if ex runtime pilot validate >"$area/duplicate.out" 2>&1; then fail 'Duplicate identity keys were silently coerced by the JSON parser.'; fi
grep -Fq duplicate "$area/duplicate.out" || fail 'Duplicate identity did not get an actionable diagnostic.'
cp "$area/valid.json" "$runtime/schema.json"
printf 'Configuration contract: duplicate JSON identities are rejected.\n'
jq '.units.website.kubernetes.manifests = "README.md"' "$area/valid.json" >"$runtime/schema.json"
if ex runtime pilot validate >"$area/non-native.out" 2>&1; then fail 'A non-native manifest file was accepted as Kubernetes configuration.'; fi
cp "$area/valid.json" "$runtime/schema.json"
printf 'Configuration contract: manifest file references require a supported native extension.\n'
