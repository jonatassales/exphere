#!/bin/sh
# Validates selected references; it never invokes configured handlers.
h_reference() {
  h_config=$(h_file "$h_consumer" .exphere/config.json) || return 1
  h_inventory=$(h_file "$h_consumer" .exphere/lock.json) || return 1
  h_json harness-config "$h_config" || return 1
  h_json harness-lock "$h_inventory" || return 1
  jq -n -e --slurpfile config "$h_config" --slurpfile lock "$h_inventory" '
    def check($ok;$msg): if $ok then . else error($msg) end;
    $config[0] as $c | $lock[0] as $l |
    check($l.repositoryId==$c.repositoryId and $l.referenceVersion==$c.referenceVersion; "inventory identity/version mismatch") |
    check(($l.entries|map(.path)|length)==($l.entries|map(.path)|unique|length); "duplicate inventory path") |
    check(all($l.entries[]; .path!=".exphere/config.json" and .path!=".exphere/lock.json"); "inventory must not hash its own file or editable configuration") |
    check(($c.selected.runtimes|map(.id)|length)==($c.selected.runtimes|map(.id)|unique|length); "duplicate runtime identity") |
    check(($c.models.profiles|map(.id)|length)==($c.models.profiles|map(.id)|unique|length); "duplicate model profile identity") |
    check(($c.retrieval.corpora|map(.id)|length)==($c.retrieval.corpora|map(.id)|unique|length); "duplicate corpus identity") |
    check($c.models.currency==$c.budget.currency; "models/budget currency mismatch") |
    check(($c.synthetic and $c.models.provenance=="synthetic") or (($c.synthetic|not) and $c.models.provenance=="governed"); "price provenance mismatch") |
    check(all($c.models.profiles[]; (.supportedEfforts|sort)==(.effortMapping|keys)); "unsupported or unmapped effort capability") |
    check(any($c.models.profiles[]; .id==$c.bootstrap.profileId and (.supportedEfforts|index($c.bootstrap.effort))!=null); "bootstrap profile/effort is unsupported") |
    check(all([$c.budget.window.start,$c.budget.window.end][]; . as $date |
      (try (fromdateiso8601|strftime("%Y-%m-%dT%H:%M:%SZ")) catch "invalid") == $date); "invalid budget calendar timestamp") |
    check($c.budget.window.start<$c.budget.window.end; "budget window must have positive duration") |
    check($c.infrastructure.horizonSeconds<=$c.infrastructure.maxLifetimeSeconds and $c.infrastructure.inspectionSeconds<=$c.infrastructure.maxLifetimeSeconds; "invalid infrastructure lifetime/cadence") |
    $c.budget.accounts as $accounts |
    check(($accounts|map(.id)|length)==($accounts|map(.id)|unique|length); "duplicate account identity") |
    check(([$accounts[]|select(.kind=="funding-window")]|length)==1; "exactly one funding-window root is required") |
    check(all($accounts[]; . as $a |
      if .kind=="funding-window" then (has("parentId")|not)
      elif .kind=="feature" then any($accounts[]; .id==$a.parentId and .kind=="funding-window")
      else any($accounts[]; .id==$a.parentId and .kind=="feature") end); "invalid or cyclic account parent hierarchy") |
    check(all($accounts[]; . as $a | all(["ai","infrastructure","combined"][]; . as $k | ($a.protected[$k]|tonumber)<=($a.caps[$k]|tonumber))); "protected allowance exceeds cap") |
    check($c.stores.accounting.id!=$c.stores.graph.id and $c.stores.accounting.path!=$c.stores.graph.path; "graph and accounting must not share an authority") |
    check(all($c.retrieval.corpora[]; . as $s | $s.repositoryId==$c.repositoryId and any($c.selected.runtimes[]; .id==$s.runtimeId)); "cross-repository or unknown runtime corpus") | true
  ' >/dev/null || return 1

  jq -r '.entries[] | [.path,.sha256] | @tsv' "$h_inventory" >"$h_area/inventory.tsv"
  while IFS="$(printf '\t')" read -r relative expected; do
    file=$(h_file "$h_consumer" "$relative") || return 1
    actual=$(h_sha "$file") || return 1
    [ "$actual" = "$expected" ] || h_fail "Inventory integrity mismatch: $relative"
  done <"$h_area/inventory.tsv"
  # The fresh reference has a closed inventory; extra files are not silently shipped.
  find "$h_consumer" -type l -print >"$h_area/symlinks.txt"
  [ ! -s "$h_area/symlinks.txt" ] || h_fail 'Fresh reference contains a symlink.'
  find "$h_consumer" -type f -print >"$h_area/reference-files.txt"
  [ "$(wc -l <"$h_area/reference-files.txt")" -le 512 ] || h_fail 'Reference exceeds 512 files.'
  while IFS= read -r absolute; do
    relative=${absolute#"$h_consumer/"}
    case "$relative" in .exphere/config.json|.exphere/lock.json) continue ;; esac
    h_inventory_ref "$relative" >/dev/null || return 1
  done <"$h_area/reference-files.txt"
  jq -r '.entries[] | select(.origin.licenseDisposition=="upstream-license-included") | .origin.licenseRef // error("upstream licenseRef required")' "$h_inventory" >"$h_area/licenses.txt"
  while IFS= read -r relative; do h_inventory_ref "$relative" >/dev/null || return 1; done <"$h_area/licenses.txt"

  # Resolve every selected JSON dependency before interpreting it.
  h_workflow=$(h_inventory_ref "$(jq -r '.selected.workflowRef' "$h_config")") || return 1
  h_sensors=$(h_inventory_ref "$(jq -r '.selected.sensorsRef' "$h_config")") || return 1
  h_json harness-workflow "$h_workflow" || return 1
  h_json harness-sensors "$h_sensors" || return 1
  jq -r '.selected.guideRefs[], .selected.skillRefs[], .models.profiles[].capabilitySourceRef' "$h_config" >"$h_area/dependencies.txt"
  jq -r '.stages[] | .skillRefs[], .templateRefs[], .guideRefs[]' "$h_workflow" >>"$h_area/dependencies.txt"
  jq -r '.checks[].handler.descriptionRef' "$h_sensors" >>"$h_area/dependencies.txt"
  while IFS= read -r relative; do h_inventory_ref "$relative" >/dev/null || return 1; done <"$h_area/dependencies.txt"

  jq -n -e --slurpfile c "$h_config" --slurpfile w "$h_workflow" --slurpfile s "$h_sensors" '
    def check($ok;$msg): if $ok then . else error($msg) end;
    $w[0] as $w | $s[0].checks as $checks | $c[0].selected as $selected |
    check(($w.stages|length)==10 and ($w.stages|map(.id)|unique|length)==10; "duplicate SDD stage identity") |
    check(($checks|map(.id)|length)==($checks|map(.id)|unique|length); "duplicate sensor identity") |
    check(($w.transitions|map([.from,.to])|length)==($w.transitions|map([.from,.to])|unique|length); "duplicate transition") |
    ["captured","discovery","proposed","specified","ready","implementing","verifying","delivery-approved","observing","reviewed"] as $stages |
    check(all(range(0;9); . as $i | any($w.transitions[]; .from==$stages[$i] and .to==$stages[$i+1])); "missing common SDD transition") |
    check(all($w.stages[].checkIds[]; . as $id | any($checks[]; .id==$id)); "unresolved workflow check") |
    check(all($w.stages[].skillRefs[]; . as $p | ($selected.skillRefs|index($p))!=null); "workflow skill is not selected") | true
  ' >/dev/null || return 1

  : >"$h_area/agents.jsonl"
  jq -r '.selected.agentRefs[]' "$h_config" >"$h_area/agents.txt"
  while IFS= read -r relative; do
    file=$(h_inventory_ref "$relative") || return 1
    h_json harness-agent "$file" || return 1
    jq -c . "$file" >>"$h_area/agents.jsonl"
  done <"$h_area/agents.txt"
  jq -s -e --slurpfile c "$h_config" '
    $c[0] as $c | . as $agents |
    if (map(.id)|length)!=(map(.id)|unique|length) then error("duplicate agent identity") else . end |
    if all($agents[]; . as $a |
      .bootstrapProfileId==$c.bootstrap.profileId and
      all(.allowedProfileIds[]; . as $id | any($c.models.profiles[]; .id==$id)) and
      ((.toolBindings|map(.id)|length)==(.toolBindings|map(.id)|unique|length)) and
      all(.toolBindings[]; . as $t | $t.repositoryId==$c.repositoryId and any($c.selected.runtimes[]; .id==$t.runtimeId)))
    then true else error("agent profile/tool scope mismatch") end
  ' "$h_area/agents.jsonl" >/dev/null || return 1

  jq -r '.retrieval.exclude[]' "$h_config" >"$h_area/exclusions.txt"
  jq -r '.retrieval.corpora[] | [.path,.sha256] | @tsv' "$h_config" >"$h_area/corpora.tsv"
  while IFS="$(printf '\t')" read -r relative expected; do
    while IFS= read -r pattern; do
      case "$relative" in $pattern) h_fail "Retrieval source matches exclusion: $relative" ;; esac
      case "${relative##*/}" in $pattern) h_fail "Retrieval source matches exclusion: $relative" ;; esac
    done <"$h_area/exclusions.txt"
    file=$(h_inventory_ref "$relative") || return 1
    [ "$(h_sha "$file")" = "$expected" ] || h_fail "Stale retrieval source hash: $relative"
  done <"$h_area/corpora.tsv"

  jq -r '.stores[].path' "$h_config" >"$h_area/stores.txt"
  while IFS= read -r relative; do h_path "$h_consumer" "$relative" future >/dev/null || return 1; done <"$h_area/stores.txt"
  for relative in .exphere/artifacts/accounting .exphere/artifacts/cycles .exphere/state .exphere/cache .exphere/logs .exphere/secrets; do
    [ ! -e "$h_consumer/$relative" ] && [ ! -L "$h_consumer/$relative" ] || h_fail "Fresh reference contains generated or sensitive state: $relative"
  done

  # Native settings are not copied into the harness. Reuse the existing public CLI.
  jq -r '.selected.runtimes[] | [.id,.descriptorRef] | @tsv' "$h_config" >"$h_area/runtimes.tsv"
  while IFS="$(printf '\t')" read -r runtime_id relative; do
    [ "$relative" = ".exphere/runtimes/$runtime_id/schema.json" ] || h_fail "Runtime reference/id mismatch: $relative"
    descriptor=$(h_inventory_ref "$relative") || return 1
    runtime_base=${relative%/schema.json}
    jq -r '.units[].component' "$descriptor" >"$h_area/components.txt"
    while IFS= read -r component; do h_path "$h_consumer" "$component" directory >/dev/null || return 1; done <"$h_area/components.txt"
    jq -r '.terraform.directory, .units[].kubernetes.manifests, (.hooks // {} | .[])' "$descriptor" >"$h_area/native.txt"
    while IFS= read -r native; do h_path "$h_consumer" "$runtime_base/$native" future >/dev/null || return 1; done <"$h_area/native.txt"
    sh "$h_package/cli/ex.sh" --root "$h_consumer" runtime "$runtime_id" validate >"$h_area/runtime.out" || return 1
  done <"$h_area/runtimes.tsv"

  # The reference supports simple local inline Markdown links. They must also be
  # inventoried; unsupported file/absolute/parent-link forms fail rather than fetch.
  jq -r '.entries[].path | select(endswith(".md"))' "$h_inventory" >"$h_area/markdown.txt"
  while IFS= read -r relative; do
    jq -Rrs 'scan("\\[[^]\\n]+\\]\\(([^)\\n]+)\\)") | .[0]' "$h_consumer/$relative" >"$h_area/links.txt"
    while IFS= read -r link; do
      case "$link" in https://*|http://*|\#*) continue ;; esac
      link=${link%%#*}
      case "$relative" in */*) linked="${relative%/*}/$link" ;; *) linked=$link ;; esac
      h_inventory_ref "$linked" >/dev/null || return 1
    done <"$h_area/links.txt"
  done <"$h_area/markdown.txt"
  jq -n --slurpfile c "$h_config" --slurpfile s "$h_sensors" --slurpfile a "$h_area/agents.jsonl" --arg hash "$(h_sha "$h_config")" '
    {formatVersion:1,contract:"valid",referenceVersion:$c[0].referenceVersion,configSha256:$hash,
     executionReady:false,unavailable:(["langgraph","mcp","rag"] + [$s[0].checks[]|select(.required)|.handler.id] + [$a[].id] | unique),
     runtimeVerification:"descriptor-and-local-references-only",financialEnforcement:false}' >"$h_area/result.json"
}
