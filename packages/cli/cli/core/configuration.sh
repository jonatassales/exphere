#!/bin/sh

ex_validate_v2() {
  jq -se --arg id "$EX_RUNTIME_ID" '
    def text: type == "string" and test("[^[:space:]]") and (test("[\u0000-\u001f\u007f]") | not);
    def identifier: type == "string" and test("^[a-z0-9][a-z0-9-]*$");
    def relative: text and (startswith("/") | not) and (split("/") | all(. != ".." and . != ""));
    def check($ok; $field; $expected): if $ok then . else error($field + ": " + $expected) end;
    check(length == 1; "schema.json"; "provide one JSON object") | .[0]
    | check(type == "object"; "schema.json"; "expected an object")
    | check(((keys - ["version", "id", "environment", "owner", "units", "terraform", "kubernetes", "hooks"]) | length == 0); "schema.json"; "remove unknown contract fields")
    | check(.version == 2; "version"; "expected integer 2")
    | check(.id == $id; "id"; "must match its runtime directory")
    | check(.environment == "local"; "environment"; "expected local")
    | check((.owner | text); "owner"; "provide a nonblank owner reference")
    | check((.units | type == "object" and length > 0); "units"; "select at least one existing component")
    | reduce (.units | to_entries[]) as $unit (.;
        check(($unit.key | identifier); "units." + $unit.key; "use a lowercase component directory name")
        | check(($unit.value | type == "object" and keys == ["component", "kubernetes"]); "units." + $unit.key; "expected only component and kubernetes")
        | check(($unit.value.component | relative); "units." + $unit.key + ".component"; "expected a project-relative path without parent traversal")
        | check(($unit.value.kubernetes | type == "object" and keys == ["manifests"] and (.manifests | relative)); "units." + $unit.key + ".kubernetes.manifests"; "expected a runtime-relative native configuration path"))
    | check((.terraform | type == "object" and keys == ["directory"] and (.directory | relative)); "terraform.directory"; "expected one runtime-relative directory")
    | check((.kubernetes | type == "object" and keys == ["context", "namespace"]); "kubernetes"; "expected only context and namespace")
    | check((.kubernetes.context | text); "kubernetes.context"; "provide an explicit context")
    | check((.kubernetes.namespace | text and length <= 63 and test("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")); "kubernetes.namespace"; "provide a DNS label of at most 63 characters")
    | check((if has("hooks") then (.hooks | type == "object" and all(keys[]; identifier) and all(.[]; relative and endswith(".sh"))) else true end); "hooks"; "map lowercase names to runtime-relative .sh files")
  ' "$EX_RUNTIME_SCHEMA" >/dev/null || ex_die 'Invalid v2 descriptor. Correct the reported field and run validate again.' 2

  EX_TERRAFORM_DIR=$(ex_resolve_path "$EX_RUNTIME_DIR" "$(jq -r '.terraform.directory' "$EX_RUNTIME_SCHEMA")")
  [ -d "$EX_TERRAFORM_DIR" ] || ex_die 'terraform.directory must reference an existing directory.' 2
  EX_KUBERNETES_CONTEXT=$(jq -r '.kubernetes.context' "$EX_RUNTIME_SCHEMA")
  EX_KUBERNETES_NAMESPACE=$(jq -r '.kubernetes.namespace' "$EX_RUNTIME_SCHEMA")
  EX_KUBERNETES_MANIFESTS=
  jq -r '.units | to_entries[] | [.key, .value.component, .value.kubernetes.manifests] | @tsv' "$EX_RUNTIME_SCHEMA" |
    while IFS="$(printf '\t')" read -r ex_unit ex_component ex_manifests; do
      ex_component_path=$(ex_resolve_path "$EX_PROJECT_ROOT" "$ex_component")
      [ -d "$ex_component_path" ] || ex_die "units.$ex_unit.component must reference an existing directory." 2
      [ "$(basename "$ex_component_path")" = "$ex_unit" ] || ex_die "units.$ex_unit.component must have the same directory basename as its unit key." 2
      ex_manifest_path=$(ex_resolve_path "$EX_RUNTIME_DIR" "$ex_manifests")
      if [ -f "$ex_manifest_path" ]; then
        case "$ex_manifest_path" in
          *.json|*.yaml|*.yml) [ -r "$ex_manifest_path" ] || ex_die "units.$ex_unit.kubernetes.manifests must be readable." 2 ;;
          *) ex_die "units.$ex_unit.kubernetes.manifests must reference a native .json, .yaml or .yml file, or a directory." 2 ;;
        esac
      else
        [ -d "$ex_manifest_path" ] || ex_die "units.$ex_unit.kubernetes.manifests must reference a file or directory." 2
      fi
    done
  jq -r '(.hooks // {})[]' "$EX_RUNTIME_SCHEMA" | while IFS= read -r ex_hook_relative; do
    ex_hook_path=$(ex_resolve_path "$EX_RUNTIME_DIR" "$ex_hook_relative")
    [ -f "$ex_hook_path" ] && [ -r "$ex_hook_path" ] || ex_die "Hook must be a readable .sh file: $ex_hook_relative" 2
  done
}

ex_load_runtime() {
  ex_need jq
  EX_RUNTIME_ID=$1
  ex_valid_id "$EX_RUNTIME_ID" || ex_die 'Runtime id must contain lowercase letters, numbers and hyphens, and cannot start with a hyphen.' 2
  ex_new="$EX_PROJECT_ROOT/.exphere/runtimes/$EX_RUNTIME_ID"
  ex_old="$EX_PROJECT_ROOT/.micro-runtime/$EX_RUNTIME_ID"
  if { [ -e "$ex_new" ] || [ -L "$ex_new" ]; } && { [ -e "$ex_old" ] || [ -L "$ex_old" ]; }; then
    ex_die "Ambiguous runtime id '$EX_RUNTIME_ID': present in .exphere/runtimes and .micro-runtime. Resolve the duplicate locations explicitly." 2
  fi
  if [ -e "$ex_new" ] || [ -L "$ex_new" ]; then
    ex_location=.exphere/runtimes
    ex_expected_version=2
  elif [ -e "$ex_old" ] || [ -L "$ex_old" ]; then
    ex_location=.micro-runtime
    ex_expected_version=1
  else
    ex_die "Microruntime not found: $EX_RUNTIME_ID. Run ex runtime list." 2
  fi
  EX_RUNTIMES_DIR=$(ex_resolve_path "$EX_PROJECT_ROOT" "$ex_location")
  EX_RUNTIME_DIR=$(ex_resolve_path "$EX_RUNTIMES_DIR" "$EX_RUNTIME_ID")
  [ -d "$EX_RUNTIME_DIR" ] || ex_die 'Runtime must be a directory.' 2
  EX_RUNTIME_SCHEMA=$(ex_resolve_path "$EX_RUNTIME_DIR" schema.json)
  [ -f "$EX_RUNTIME_SCHEMA" ] || ex_die 'schema.json must be a regular file.' 2
  # Streamed closing events identify the container at the parent path. Recording
  # each scalar or container once also detects duplicate object keys before jq
  # can silently retain only their final value.
  jq --stream -se 'map(if length == 2 then .[0] else .[0][0:-1] end) | length == (unique | length)' "$EX_RUNTIME_SCHEMA" >/dev/null ||
    ex_die 'schema.json contains invalid JSON or duplicate fields; provide one unambiguous value for each field.' 2
  EX_RUNTIME_VERSION=$(jq -er '.version | numbers' "$EX_RUNTIME_SCHEMA") || ex_die 'version: expected integer 1 or 2 in schema.json.' 2
  [ "$EX_RUNTIME_VERSION" = "$ex_expected_version" ] || ex_die "Unsupported version/location combination: $ex_location requires version $ex_expected_version." 2
  if [ "$EX_RUNTIME_VERSION" = 1 ]; then
    printf 'ex: legacy v1 descriptor at %s; no automatic migration is performed.\n' "$EX_RUNTIME_SCHEMA" >&2
    ex_validate_v1 "$EX_RUNTIME_ID"
  else
    ex_validate_v2
  fi
  export EX_RUNTIME_ID EX_RUNTIME_VERSION EX_RUNTIME_DIR EX_RUNTIME_SCHEMA EX_PROJECT_ROOT
  export EX_TERRAFORM_DIR EX_KUBERNETES_MANIFESTS EX_KUBERNETES_CONTEXT EX_KUBERNETES_NAMESPACE
}

ex_list_runtimes() {
  ex_need jq
  for ex_location in .exphere/runtimes .micro-runtime; do
    [ -e "$EX_PROJECT_ROOT/$ex_location" ] || continue
    ex_list_parent=$(ex_resolve_path "$EX_PROJECT_ROOT" "$ex_location")
    [ -d "$ex_list_parent" ] || ex_die "$ex_location must be a directory." 2
    for ex_candidate in "$ex_list_parent"/*; do
      [ -d "$ex_candidate" ] && [ -f "$ex_candidate/schema.json" ] || continue
      ex_candidate_id=$(basename "$ex_candidate")
      ex_valid_id "$ex_candidate_id" || continue
      ex_candidate_version=$(jq -r '.version // "unknown"' "$ex_candidate/schema.json" 2>/dev/null) || ex_candidate_version=invalid
      printf '%s\tv%s\t%s/%s/schema.json\n' "$ex_candidate_id" "$ex_candidate_version" "$ex_location" "$ex_candidate_id"
    done
  done
}
