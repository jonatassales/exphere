#!/bin/sh
# Public CLI fixtures: only external executable boundaries are controlled.
fixture_init() {
  fixture_base=$(CDPATH= cd "$(dirname "$0")/../.." && pwd -P)
  fixture_entry="$fixture_base/cli/ex.sh"
  fixture_area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-lifecycle.XXXXXX")
  fixture_project="$fixture_area/project"
  fixture_state="$fixture_area/cluster"
  fixture_tools="$fixture_area/tools"
  mkdir -p "$fixture_tools" "$fixture_state" "$fixture_project/apps/website" "$fixture_project/.exphere/runtimes/demo/terraform" "$fixture_project/.exphere/runtimes/demo/units/website/kubernetes"
  fixture_runtime="$fixture_project/.exphere/runtimes/demo"
  export EX_FIXTURE_STATE="$fixture_state" EX_FIXTURE_PROJECT="$fixture_project"
  printf '{"version":2,"id":"demo","environment":"local","owner":"fixture-owner","units":{"website":{"component":"apps/website","kubernetes":{"manifests":"units/website/kubernetes"}}},"terraform":{"directory":"terraform"},"kubernetes":{"context":"kind-pilot","namespace":"demo"}}\n' >"$fixture_runtime/schema.json"
  cat >"$fixture_runtime/units/website/kubernetes/website.json" <<'JSON'
{"apiVersion":"v1","kind":"List","items":[{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"name":"website"},"spec":{"replicas":1,"selector":{"matchLabels":{"app":"website"}},"template":{"metadata":{"labels":{"app":"website"}},"spec":{"containers":[{"name":"website","image":"website:pilot","imagePullPolicy":"Never","ports":[{"containerPort":3000}],"resources":{"requests":{"cpu":"100m","memory":"64Mi"},"limits":{"cpu":"200m","memory":"128Mi"}},"readinessProbe":{"httpGet":{"path":"/","port":3000},"initialDelaySeconds":1,"periodSeconds":1}}]}}}},{"apiVersion":"v1","kind":"Service","metadata":{"name":"website"},"spec":{"selector":{"app":"website"},"ports":[{"port":80,"targetPort":3000}]}}]}
JSON
  cat >"$fixture_runtime/terraform/main.tf.json" <<'JSON'
{"terraform":{"required_version":"= 1.16.5","required_providers":{"kubernetes":{"source":"hashicorp/kubernetes","version":"3.2.1"}},"backend":{"local":{}}},"variable":{"ex_context":{"type":"string"},"ex_namespace":{"type":"string"},"ex_kubeconfig":{"type":"string"},"ex_runtime_owner":{"type":"string"}},"provider":{"kubernetes":{"config_path":"${var.ex_kubeconfig}","config_context":"${var.ex_context}"}},"resource":{"kubernetes_namespace_v1":{"runtime":{"metadata":{"name":"${var.ex_namespace}","labels":{"exphere.dev/owner":"${var.ex_runtime_owner}","exphere.dev/runtime":"demo"}}}},"kubernetes_resource_quota_v1":{"runtime":{"metadata":{"name":"runtime","namespace":"${kubernetes_namespace_v1.runtime.metadata[0].name}","labels":{"exphere.dev/owner":"${var.ex_runtime_owner}"}},"spec":{"hard":{"requests.cpu":"1","requests.memory":"1Gi","limits.cpu":"2","limits.memory":"2Gi","pods":"5"}}}}}}
JSON
  cat >"$fixture_state/kubeconfig.json" <<'JSON'
{"apiVersion":"v1","kind":"Config","current-context":"kind-pilot","clusters":[{"name":"kind-pilot","cluster":{"server":"https://127.0.0.1:6443","certificate-authority-data":"Zml4dHVyZS1jYQ=="}}],"contexts":[{"name":"kind-pilot","context":{"cluster":"kind-pilot","user":"kind-pilot"}}],"users":[{"name":"kind-pilot","user":{"client-certificate-data":"Zml4dHVyZQ==","client-key-data":"Zml4dHVyZQ=="}}]}
JSON
  cp "$fixture_state/kubeconfig.json" "$fixture_state/kind-kubeconfig.json"
  cp "$fixture_base/scripts/tests/fixture-kubectl.sh" "$fixture_tools/kubectl"
  cp "$fixture_base/scripts/tests/fixture-terraform.sh" "$fixture_tools/terraform"
  cat >"$fixture_tools/kind" <<'TOOL'
#!/bin/sh
printf 'kind %s\n' "$*" >>"$EX_FIXTURE_STATE/calls"
case "$*" in
  version) printf 'kind v0.33.0\n' ;;
  'get clusters') printf 'pilot\n' ;;
  'get nodes --name pilot') printf 'pilot-control-plane\n' ;;
  'get kubeconfig --name pilot') cat "$EX_FIXTURE_STATE/kind-kubeconfig.json" ;;
  *) exit 2 ;;
esac
TOOL
  cat >"$fixture_tools/docker" <<'TOOL'
#!/bin/sh
printf 'docker %s\n' "$*" >>"$EX_FIXTURE_STATE/calls"
case "$*" in
  'context show') printf 'default\n' ;;
  'context inspect --format {{.Endpoints.docker.Host}}') printf 'unix:///tmp/exphere-fixture.sock\n' ;;
  context\ inspect*) printf '[{"Endpoints":{"docker":{"Host":"unix:///tmp/exphere-fixture.sock"}}}]\n' ;;
  version*) printf '{"Version":"29.5.0"}\n' ;;
  info*) printf '{"ServerVersion":"29.5.0"}\n' ;;
  inspect*) printf '[{"Config":{"Labels":{"io.x-k8s.kind.cluster":"pilot","io.x-k8s.kind.role":"control-plane"}},"State":{"Running":true}}]\n' ;;
  exec*images*) printf '{"images":[{"repoTags":["docker.io/library/website:pilot"],"repoDigests":["docker.io/library/website@sha256:fixture"]}]}\n' ;;
  *) exit 2 ;;
esac
TOOL
  chmod +x "$fixture_tools"/*
}
fixture_ex() { env PATH="$fixture_tools:$PATH" KUBECONFIG="$fixture_state/kubeconfig.json" sh "$fixture_entry" --root "$fixture_project" runtime demo "$@"; }
fixture_fail() { printf 'Lifecycle contract failed: %s\n' "$1" >&2; exit 1; }
fixture_cleanup() { [ -z "${fixture_area:-}" ] || rm -rf "$fixture_area"; }
