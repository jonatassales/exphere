#!/bin/sh

ex_init_runtime() (
  ex_need jq
  ex_valid_id "$1" || ex_die 'Invalid runtime id: use lowercase letters, numbers and hyphens.' 2
  ex_descriptor=$(jq -n --arg id "$1" '{version: 1, id: $id, components: {}}')
  umask 077
  if [ ! -e "$EX_PROJECT_ROOT/.micro-runtime" ]; then
    mkdir "$EX_PROJECT_ROOT/.micro-runtime"
  fi
  ex_parent=$(ex_resolve_path "$EX_PROJECT_ROOT" .micro-runtime)
  [ -d "$ex_parent" ] || ex_die '.micro-runtime must be a directory.' 2
  ex_destination="$ex_parent/$1"
  mkdir "$ex_destination" || ex_die "Microruntime already exists or cannot be created: $1"
  if ! (set -C; printf '%s\n' "$ex_descriptor" > "$ex_destination/schema.json"); then
    ex_die 'Unable to write schema.json; inspect the newly created runtime directory.'
  fi
  printf 'ex: created %s/schema.json. Configure components and adapters before executing them.\n' "$ex_destination"
)

ex_load_runtime() {
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
