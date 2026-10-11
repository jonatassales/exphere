#!/bin/sh

ex_runtime_parent() (
  ex_parent_relative=$1
  ex_parent_path=$EX_PROJECT_ROOT
  ex_parent_accumulated=
  ex_old_ifs=$IFS
  IFS=/
  set -- $ex_parent_relative
  IFS=$ex_old_ifs
  for ex_part do
    ex_parent_accumulated=${ex_parent_accumulated:+$ex_parent_accumulated/}$ex_part
    if [ ! -e "$ex_parent_path/$ex_part" ] && [ ! -L "$ex_parent_path/$ex_part" ]; then
      mkdir "$ex_parent_path/$ex_part" || ex_die "Cannot create $ex_parent_accumulated."
    fi
    ex_parent_path=$(ex_resolve_path "$EX_PROJECT_ROOT" "$ex_parent_accumulated")
    [ -d "$ex_parent_path" ] || ex_die "$ex_parent_accumulated must be a directory." 2
  done
  printf '%s\n' "$ex_parent_path"
)

ex_init_runtime() (
  ex_need jq
  ex_valid_id "$1" || ex_die 'Invalid runtime id: use lowercase letters, numbers and hyphens.' 2
  ex_new_id=$1
  ex_init_mode=${2:-manual}
  for ex_location in .exphere/runtimes .micro-runtime; do
    [ ! -e "$EX_PROJECT_ROOT/$ex_location/$ex_new_id" ] && [ ! -L "$EX_PROJECT_ROOT/$ex_location/$ex_new_id" ] ||
      ex_die "Microruntime already exists: $ex_location/$ex_new_id. Existing output is never overwritten." 2
  done
  umask 077
  ex_stage=$(mktemp -d "${TMPDIR:-/tmp}/exphere-init.XXXXXX")
  ex_created=
  trap 'rm -rf "$ex_stage" || printf "ex: inspect temporary partial output: %s\n" "$ex_stage" >&2; if [ -n "$ex_created" ]; then rm -rf "$ex_created" || printf "ex: inspect partial output: %s\n" "$ex_created" >&2; fi' EXIT
  trap 'exit 130' INT
  trap 'exit 143' HUP TERM
  if [ "$ex_init_mode" = legacy ]; then
    jq -n --arg id "$ex_new_id" '{version: 1, id: $id, components: {}}' >"$ex_stage/schema.json"
    ex_parent=$(ex_runtime_parent .micro-runtime)
  elif [ "$ex_init_mode" = guided ]; then
    ex_guided_generate
    ex_parent=$(ex_runtime_parent .exphere/runtimes)
  else
    jq -n --arg id "$ex_new_id" '{version: 2, id: $id, environment: "local", owner: "", units: {}, terraform: {directory: "terraform"}, kubernetes: {context: "", namespace: ""}}' >"$ex_stage/schema.json"
    cat >"$ex_stage/README.md" <<'GUIDE'
# Manual microruntime configuration

This is an incomplete version 2 descriptor. Supply the owner, explicit local Kubernetes context and namespace, selected units, and existing native configuration before validation or execution.

Each unit key matches its existing component directory basename. Its `component` path is project-relative; `kubernetes.manifests` is runtime-relative. Terraform owns the namespace and quotas. Workload images, replicas, resources and probes belong in Kubernetes files. Do not copy application source or store credentials here.

Run `ex runtime <id> validate` after configuring the descriptor. Validation performs no infrastructure operations. Explicit lifecycle operations require local Docker, kind, kubectl, Terraform, jq, and a supported native configuration. Generated configuration does not demonstrate execution, readiness, quota enforcement or cleanup.
GUIDE
    ex_parent=$(ex_runtime_parent .exphere/runtimes)
  fi
  ex_destination="$ex_parent/$ex_new_id"
  mkdir "$ex_destination" || ex_die "Microruntime already exists or cannot be created: $ex_new_id"
  ex_created=$ex_destination
  cp -R "$ex_stage/." "$ex_destination/" || ex_die "Unable to publish runtime: $ex_destination"
  ex_created=
  printf 'ex: created %s/schema.json. Configure required inputs and native files before validation or execution.\n' "$ex_destination"
)
ex_validate_v1() {
  ex_need jq
  EX_RUNTIME_ID=$1
  ex_valid_id "$EX_RUNTIME_ID" || ex_die 'Runtime id must contain lowercase letters, numbers and hyphens, and cannot start with a hyphen.' 2
  EX_RUNTIME_DIR=$(ex_resolve_path "$EX_RUNTIMES_DIR" "$EX_RUNTIME_ID")
  [ -d "$EX_RUNTIME_DIR" ] || ex_die 'Runtime must be a directory.'
  EX_RUNTIME_SCHEMA=$(ex_resolve_path "$EX_RUNTIME_DIR" schema.json)
  [ -f "$EX_RUNTIME_SCHEMA" ] || ex_die 'schema.json must be a file.'

  if ! jq -se --arg id "$EX_RUNTIME_ID" '
    def text:
      type == "string" and length > 0 and (test("[\u0000-\u001f\u007f]") | not);
    def identifier:
      type == "string" and test("^[a-z0-9][a-z0-9-]*$");
    def relative:
      text and (startswith("/") | not)
      and (split("/") | all(. != ".." and . != ""));
    length == 1 and (.[0] |
      type == "object"
      and ((keys - ["version", "id", "components", "terraform", "kubernetes", "hooks"]) | length == 0)
      and .version == 1 and .id == $id
      and (.components | type == "object")
      and all(.components[]; type == "object")
      and (if has("terraform") then
        (.terraform | type == "object" and keys == ["directory"] and (.directory | relative))
      else true end)
      and (if has("kubernetes") then
        (.kubernetes | type == "object" and keys == ["context", "manifests", "namespace"]
          and (.context | text)
          and (.namespace | text and length <= 63 and test("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$"))
          and (.manifests | relative))
      else true end)
      and (if has("hooks") then
        (.hooks | type == "object"
          and all(keys[]; identifier)
          and all(.[]; relative and endswith(".sh")))
      else true end)
    )
  ' "$EX_RUNTIME_SCHEMA" >/dev/null; then
    ex_die 'Invalid schema.json: expected version 1, matching id, components object and valid adapter/hook paths. See the CLI README.' 2
  fi

  EX_TERRAFORM_DIR=
  EX_KUBERNETES_MANIFESTS=
  EX_KUBERNETES_CONTEXT=
  EX_KUBERNETES_NAMESPACE=
  if jq -e 'has("terraform")' "$EX_RUNTIME_SCHEMA" >/dev/null; then
    EX_TERRAFORM_DIR=$(ex_resolve_path "$EX_RUNTIME_DIR" "$(jq -r '.terraform.directory' "$EX_RUNTIME_SCHEMA")")
    [ -d "$EX_TERRAFORM_DIR" ] || ex_die 'terraform.directory must be a directory.' 2
  fi
  if jq -e 'has("kubernetes")' "$EX_RUNTIME_SCHEMA" >/dev/null; then
    EX_KUBERNETES_MANIFESTS=$(ex_resolve_path "$EX_RUNTIME_DIR" "$(jq -r '.kubernetes.manifests' "$EX_RUNTIME_SCHEMA")")
    EX_KUBERNETES_CONTEXT=$(jq -r '.kubernetes.context' "$EX_RUNTIME_SCHEMA")
    EX_KUBERNETES_NAMESPACE=$(jq -r '.kubernetes.namespace' "$EX_RUNTIME_SCHEMA")
  fi
  jq -r '(.hooks // {})[]' "$EX_RUNTIME_SCHEMA" | while IFS= read -r ex_hook_relative; do
    ex_hook_path=$(ex_resolve_path "$EX_RUNTIME_DIR" "$ex_hook_relative")
    [ -f "$ex_hook_path" ] && [ -r "$ex_hook_path" ] || ex_die "Hook must be a readable .sh file: $ex_hook_relative" 2
  done
  export EX_RUNTIME_ID EX_RUNTIME_DIR EX_RUNTIME_SCHEMA
  export EX_TERRAFORM_DIR EX_KUBERNETES_MANIFESTS EX_KUBERNETES_CONTEXT EX_KUBERNETES_NAMESPACE
}

. "$EX_CLI_DIR/core/configuration.sh"
. "$EX_CLI_DIR/core/guided.sh"
