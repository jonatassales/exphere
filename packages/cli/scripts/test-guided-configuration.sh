#!/bin/sh
set -eu
package_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd -P)
cli="$package_dir/cli/ex.sh"
area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-guided.XXXXXX")
trap 'rm -rf "$area"' EXIT HUP INT TERM
consumer="$area/consumer"
mkdir -p "$consumer/apps/website"
printf 'consumer source\n' >"$consumer/apps/website/source.txt"
fail() { printf 'Guided configuration contract failed: %s\n' "$1" >&2; exit 1; }
ex() { sh "$cli" --root "$consumer" "$@"; }
cat >"$area/answers" <<'ANSWERS'
team-example
kind-pilot
pilot
{"requests.cpu":"1","requests.memory":"1Gi","requests.ephemeral-storage":"2Gi","limits.cpu":"2","limits.memory":"2Gi","limits.ephemeral-storage":"4Gi","pods":"4"}
apps/website
example.invalid/website:fixture
3000
80
1
{"requests":{"cpu":"100m","memory":"128Mi","ephemeral-storage":"128Mi"},"limits":{"cpu":"500m","memory":"256Mi","ephemeral-storage":"256Mi"}}
{"httpGet":{"path":"/ready","port":3000},"initialDelaySeconds":1,"periodSeconds":2,"timeoutSeconds":1,"failureThreshold":3}


ANSWERS
ex runtime guided init --guided <"$area/answers" >"$area/guided.out" 2>&1 || { cat "$area/guided.out"; fail 'Guided generation failed for explicit consumer inputs.'; }
runtime="$consumer/.exphere/runtimes/guided"
ex runtime guided validate >"$area/validate.out"
jq -e '.version == 2 and .owner == "team-example" and .units.website.component == "apps/website" and .units.website.kubernetes.manifests == "units/website/kubernetes" and (has("image") | not) and (has("hooks") | not)' "$runtime/schema.json" >/dev/null || fail 'Guided descriptor lost references or duplicated native fields.'
jq -e '.spec.template.spec.containers[0] | .image == "example.invalid/website:fixture" and .resources.requests.cpu == "100m" and .readinessProbe.httpGet.path == "/ready"' "$runtime/units/website/kubernetes/deployment.json" >/dev/null || fail 'Guided Deployment lost supplied image, resources or readiness values.'
jq -e '.spec.ports[0].port == 80 and .spec.ports[0].targetPort == 3000' "$runtime/units/website/kubernetes/service.json" >/dev/null || fail 'Guided Service lost supplied ports.'
jq -e '.terraform.required_version == "= 1.16.5" and .terraform.required_providers.kubernetes.version == "= 3.2.1" and .terraform.backend == {local:{}} and .resource.kubernetes_resource_quota_v1.runtime.spec.hard.pods == "4" and .resource.kubernetes_resource_quota_v1.runtime.metadata.namespace == "${kubernetes_namespace_v1.runtime.metadata[0].name}"' "$runtime/terraform/main.tf.json" >/dev/null || fail 'Guided preparation lost versions, local backend, quota input or namespace dependency.'
[ ! -d "$runtime/hooks" ] || fail 'Guided setup created unselected hook placeholders.'
[ "$(cat "$consumer/apps/website/source.txt")" = 'consumer source' ] || fail 'Guided setup modified application source.'
printf 'Guided configuration contract: explicit native values and references pass the shared validator.\n'
before=$(find "$runtime" -type f -exec cksum {} \; | sort)
if ex runtime guided init --guided <"$area/answers" >"$area/existing.out" 2>&1; then fail 'Guided setup overwrote an existing runtime.'; fi
[ "$(find "$runtime" -type f -exec cksum {} \; | sort)" = "$before" ] || fail 'Existing guided runtime changed after refusal.'
if printf 'owner\n' | ex runtime canceled init --guided >"$area/canceled.out" 2>&1; then fail 'Canceled guidance reported success.'; fi
[ ! -e "$consumer/.exphere/runtimes/canceled" ] || fail 'Canceled guidance published partial output.'
mkdir -p "$consumer/packages/website"
sed '$d' "$area/answers" | sed '$d' >"$area/collision.answers"
printf 'packages/website\n' >>"$area/collision.answers"
if ex runtime collision init --guided <"$area/collision.answers" >"$area/collision.out" 2>&1; then fail 'Conflicting component basenames were silently renamed or accepted.'; fi
grep -Fq 'collision' "$area/collision.out" || fail 'Conflicting names did not get an actionable diagnostic.'
[ ! -e "$consumer/.exphere/runtimes/collision" ] || fail 'A component-name conflict published partial output.'
mkdir "$area/tools"
cat >"$area/tools/cp" <<'TOOL'
#!/bin/sh
for argument do destination=$argument; done
case "$destination" in
  */.exphere/runtimes/write-failure/|*/.exphere/runtimes/interrupted/)
    printf 'partial\n' >"$destination/partial"
    case "$destination" in */interrupted/) kill -TERM "$PPID" ;; esac
    exit 1
    ;;
esac
exec /bin/cp "$@"
TOOL
chmod +x "$area/tools/cp"
for rejected in write-failure interrupted; do
  if env PATH="$area/tools:$PATH" sh "$cli" --root "$consumer" runtime "$rejected" init --guided <"$area/answers" >"$area/write.out" 2>&1; then fail 'A failed or interrupted publication reported success.'; fi
  [ ! -e "$consumer/.exphere/runtimes/$rejected" ] || fail 'A failed publication left owned partial output.'
done
[ "$(find "$runtime" -type f -exec cksum {} \; | sort)" = "$before" ] || fail 'Failed or canceled generation changed an existing runtime.'
printf 'Guided configuration contract: collisions, cancellation and failed or interrupted publication preserve existing files.\n'

mkdir "$consumer/scripts"
printf '#!/bin/sh\nprintf executed >"$EX_RUNTIME_DIR/hook-ran"\n' >"$consumer/scripts/prepare.sh"
sed '$d' "$area/answers" >"$area/hooks.answers"
printf 'scripts/prepare.sh\n\n' >>"$area/hooks.answers"
ex runtime hooks init --guided <"$area/hooks.answers" >"$area/hooks.out" 2>&1 || { cat "$area/hooks.out"; fail 'Selected consumer hook was rejected.'; }
hooks="$consumer/.exphere/runtimes/hooks"
jq -e '.hooks == {prepare:"hooks/prepare.sh"}' "$hooks/schema.json" >/dev/null || fail 'Selected hook did not become an explicit descriptor reference.'
cmp -s "$consumer/scripts/prepare.sh" "$hooks/hooks/prepare.sh" || fail 'Selected hook source was modified.'
[ ! -f "$hooks/hook-ran" ] || fail 'Guided setup implicitly invoked a hook.'
ex runtime hooks validate >"$area/hooks-validate.out"
printf 'Guided configuration contract: selected hooks are declared and copied without invocation.\n'

# Independently authored manual configuration keeps the same native authority.
ex runtime manual init >"$area/manual.out"
manual="$consumer/.exphere/runtimes/manual"
mkdir -p "$manual/terraform" "$manual/units/website/kubernetes"
cat >"$manual/schema.json" <<'DESCRIPTOR'
{"version":2,"id":"manual","environment":"local","owner":"team-example","units":{"website":{"component":"apps/website","kubernetes":{"manifests":"units/website/kubernetes"}}},"terraform":{"directory":"terraform"},"kubernetes":{"context":"kind-pilot","namespace":"pilot"}}
DESCRIPTOR
cat >"$manual/units/website/kubernetes/deployment.json" <<'DEPLOYMENT'
{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"name":"website"},"spec":{"replicas":1,"selector":{"matchLabels":{"app.kubernetes.io/name":"website"}},"template":{"metadata":{"labels":{"app.kubernetes.io/name":"website"}},"spec":{"containers":[{"name":"website","image":"example.invalid/website:fixture","imagePullPolicy":"Never","ports":[{"containerPort":3000}],"resources":{"requests":{"cpu":"100m","memory":"128Mi","ephemeral-storage":"128Mi"},"limits":{"cpu":"500m","memory":"256Mi","ephemeral-storage":"256Mi"}},"readinessProbe":{"httpGet":{"path":"/ready","port":3000},"initialDelaySeconds":1,"periodSeconds":2,"timeoutSeconds":1,"failureThreshold":3}}]}}}}
DEPLOYMENT
ex runtime manual validate >"$area/manual-validate.out"
jq -S 'del(.id)' "$manual/schema.json" >"$area/manual.descriptor"
jq -S 'del(.id)' "$runtime/schema.json" >"$area/guided.descriptor"
cmp -s "$area/manual.descriptor" "$area/guided.descriptor" || fail 'Manual and guided equivalent descriptor intent differs.'
jq -S . "$manual/units/website/kubernetes/deployment.json" >"$area/manual.deployment"
jq -S . "$runtime/units/website/kubernetes/deployment.json" >"$area/guided.deployment"
cmp -s "$area/manual.deployment" "$area/guided.deployment" || fail 'Manual and guided equivalent workload intent differs.'
printf 'Guided configuration contract: equivalent manually authored descriptor and workload semantics passed.\n'
cat >"$manual/units/website/kubernetes/service.json" <<'SERVICE'
{"apiVersion":"v1","kind":"Service","metadata":{"name":"website"},"spec":{"type":"ClusterIP","selector":{"app.kubernetes.io/name":"website"},"ports":[{"port":80,"targetPort":3000}]}}
SERVICE
cat >"$manual/terraform/main.tf.json" <<'TERRAFORM'
{"terraform":{"required_version":"= 1.16.5","required_providers":{"kubernetes":{"source":"hashicorp/kubernetes","version":"= 3.2.1"}},"backend":{"local":{}}},"variable":{"ex_context":{"type":"string"},"ex_namespace":{"type":"string"},"ex_kubeconfig":{"type":"string"},"ex_runtime_owner":{"type":"string"}},"provider":{"kubernetes":{"config_path":"${var.ex_kubeconfig}","config_context":"${var.ex_context}"}},"resource":{"kubernetes_namespace_v1":{"runtime":{"metadata":{"name":"${var.ex_namespace}","labels":{"exphere.dev/runtime":"manual","exphere.dev/owner":"${var.ex_runtime_owner}"}}}},"kubernetes_resource_quota_v1":{"runtime":{"metadata":{"name":"runtime","namespace":"${kubernetes_namespace_v1.runtime.metadata[0].name}","labels":{"exphere.dev/runtime":"manual","exphere.dev/owner":"${var.ex_runtime_owner}"}},"spec":{"hard":{"requests.cpu":"1","requests.memory":"1Gi","requests.ephemeral-storage":"2Gi","limits.cpu":"2","limits.memory":"2Gi","limits.ephemeral-storage":"4Gi","pods":"4"}}}}}}
TERRAFORM
for native in units/website/kubernetes/service.json terraform/main.tf.json; do
  jq -S 'walk(if type == "object" and has("exphere.dev/runtime") then del(."exphere.dev/runtime") else . end)' "$manual/$native" >"$area/manual.native"
  jq -S 'walk(if type == "object" and has("exphere.dev/runtime") then del(."exphere.dev/runtime") else . end)' "$runtime/$native" >"$area/guided.native"
  cmp -s "$area/manual.native" "$area/guided.native" || fail "Manual and guided native semantics differ for $native."
done
ex runtime manual validate >"$area/manual-complete.out"
mkdir -p "$consumer/packages/worker"
sed '$d' "$area/answers" | sed '$d' >"$area/composed.answers"
cat >>"$area/composed.answers" <<'ANSWERS'
packages/worker
example.invalid/worker:fixture
4000
4000
2
{"requests":{"cpu":"50m","memory":"64Mi","ephemeral-storage":"64Mi"},"limits":{"cpu":"250m","memory":"128Mi","ephemeral-storage":"128Mi"}}
{"tcpSocket":{"port":4000},"periodSeconds":2,"timeoutSeconds":1,"failureThreshold":3}


ANSWERS
ex runtime composed init --guided <"$area/composed.answers" >"$area/composed.out" 2>&1 || { cat "$area/composed.out"; fail 'A selected two-component composition was rejected.'; }
composed="$consumer/.exphere/runtimes/composed"
jq -e '.units | keys == ["website","worker"]' "$composed/schema.json" >/dev/null || fail 'A selected unit was omitted or silently renamed.'
jq -e '.spec.replicas == 2 and .spec.template.spec.containers[0].readinessProbe.tcpSocket.port == 4000' "$composed/units/worker/kubernetes/deployment.json" >/dev/null || fail 'The second unit lost its supplied native values.'
ex runtime composed validate >"$area/composed-validate.out"
printf 'Guided configuration contract: full native equivalence and multiple selected units passed.\n'

sed '4c\
{"pods":"${file(\"private\")}"}\
' "$area/answers" >"$area/expression.answers"
if ex runtime expression init --guided <"$area/expression.answers" >"$area/expression.out" 2>&1; then fail 'A Terraform expression was accepted as a consumer quota scalar.'; fi
[ ! -e "$consumer/.exphere/runtimes/expression" ] || fail 'An invalid quota input published output.'
printf 'Guided configuration contract: quota scalar interpolation is rejected before publication.\n'
