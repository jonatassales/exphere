#!/bin/sh
# Offline interpretation of synthetic records. No dispatch, persistence or pricing API.
h_jsonl() {
  source_file=$1; schema_name=$2; output_file=$3
  : >"$output_file"
  line_number=0
  while IFS= read -r line || [ -n "$line" ]; do
    line_number=$((line_number + 1))
    [ "$line_number" -le 1000 ] || h_fail "$schema_name: more than 1000 events."
    [ -n "$line" ] || h_fail "$schema_name: blank JSONL line $line_number."
    printf '%s\n' "$line" >"$h_area/line.json"
    h_json "$schema_name" "$h_area/line.json" || h_fail "$schema_name: invalid event on line $line_number."
    jq -c . "$h_area/line.json" >>"$output_file" || return 1
  done <"$source_file"
}
h_check_scenario() {
  manifest=$(h_file "$h_scenario" scenario.json) || return 1
  h_json harness-scenario "$manifest" || return 1
  context=$(h_file "$h_scenario" "$(jq -r '.contextRef' "$manifest")") || return 1
  plan=$(h_file "$h_scenario" "$(jq -r '.planRef' "$manifest")") || return 1
  ledger=$(h_file "$h_scenario" "$(jq -r '.accountingRef' "$manifest")") || return 1
  events=$(h_file "$h_scenario" "$(jq -r '.eventsRef' "$manifest")") || return 1
  expected=$(h_file "$h_scenario" "$(jq -r '.expectedRef' "$manifest")") || return 1
  report=$(h_file "$h_scenario" "$(jq -r '.reportRef' "$manifest")") || return 1
  h_json cycle-context "$context" || return 1
  h_json execution-plan "$plan" || return 1
  h_jsonl "$ledger" accounting-event "$h_area/accounting.jsonl" || return 1
  h_jsonl "$events" cycle-event "$h_area/events.jsonl" || return 1
  jq -n -e --slurpfile cfg "$h_config" --slurpfile ctx "$context" --slurpfile plan "$plan" \
    --slurpfile manifest "$manifest" --slurpfile ledger "$h_area/accounting.jsonl" \
    --slurpfile events "$h_area/events.jsonl" --slurpfile sensors "$h_sensors" \
    --arg configHash "$(h_sha "$h_config")" '
    def check($ok;$msg): if $ok then . else error($msg) end;
    def protected: .purpose=="verification" or .purpose=="cleanup";
    def units: tonumber;
    def dimensions($rows;$field;$onlyProtected):
      reduce $rows[] as $row ({ai:0,infrastructure:0,combined:0};
        if ($onlyProtected|not) or ($row|protected) then
          .[$row.category]+=$row[$field] | .combined+=$row[$field]
        else . end);
    def ancestors($accounts;$id):
      [$accounts[]|select(.id==$id)][0] as $a |
      if $a==null then error("unknown account: "+$id)
      else [$id] + (if $a.parentId then ancestors($accounts;$a.parentId) else [] end) end;
    $cfg[0] as $c | $ctx[0] as $x | $plan[0] as $p | $manifest[0] as $m | $m.request as $q |
    check($c.synthetic and $x.synthetic and $p.synthetic; "scenario accepts synthetic input only") |
    check($x.repositoryId==$c.repositoryId and $x.configSha256==$configHash and
      $x.policyRevision==$c.budget.policyRevision and $x.priceRevision==$c.models.priceRevision;
      "context repository/config/policy/price revision mismatch") |
    check($p.cycleId==$x.cycleId and $p.priceRevision==$x.priceRevision; "plan/context identity mismatch") |
    check(any($c.selected.runtimes[]; .id==$x.runtimeId); "context runtime is not selected") |
    check(any($c.budget.accounts[]; .id==$x.accountId and .kind=="cycle" and .parentId==$x.featureId);
      "context account/feature attribution mismatch") |
    check($x.graph.storeId==$c.stores.graph.id; "unknown graph store") |
    check($q.accountId==$x.accountId; "request account is outside cycle") |
    check(($x.sources|length)<=$c.retrieval.maxDocuments and ($x.sources|map(.id)|length)==($x.sources|map(.id)|unique|length);
      "context document limit or duplicate source") |
    check(all($x.sources[]; . as $s | any($c.retrieval.corpora[]; .==$s)); "context source provenance mismatch") |
    check(($p.tasks|map(.id)|length)==($p.tasks|map(.id)|unique|length); "duplicate plan task") |
    check(all($p.tasks[]; . as $t | any($c.models.profiles[]; .id==$t.profileId and (.supportedEfforts|index($t.effort))!=null and $t.maxOutputTokens<=.maxOutputTokens) and
      all($t.alternatives[]; . as $a | any($c.models.profiles[]; .id==$a)) and
      all($t.requiredCheckIds[]; . as $id | any($sensors[0].checks[]; .id==$id)));
      "plan profile, effort, limit, alternative or required check is unsupported") |
    check($p.infrastructureHorizonSeconds<=$c.infrastructure.maxLifetimeSeconds; "plan exceeds infrastructure lifetime") |
    check((try ($x.observedAt|fromdateiso8601|strftime("%Y-%m-%dT%H:%M:%SZ")) catch "invalid")==$x.observedAt; "invalid context calendar timestamp") |
    check($x.observedAt>=$c.budget.window.start and $x.observedAt<$c.budget.window.end; "context outside budget window") |
    check(all($ledger[]; .synthetic and .currency==$c.budget.currency and .priceRevision==$c.models.priceRevision);
      "accounting currency/provenance/revision mismatch") |
    check(all($ledger[]; . as $e | any($c.budget.accounts[]; .id==$e.accountId and .kind=="cycle" and .parentId==$e.featureId) and
      any($c.selected.runtimes[]; .id==$e.runtimeId) and
      (if .cycleId==$x.cycleId then .accountId==$x.accountId and .featureId==$x.featureId and .runtimeId==$x.runtimeId else true end));
      "invalid accounting attribution") |
    # Multiple cycles may retain liabilities at the same account; graph state never owns them.
    (reduce $ledger[] as $e ({seen:{},attempts:{},duplicates:0};
      if .seen|has($e.eventId) then
        check(.seen[$e.eventId]==$e; "conflicting duplicate financial event") | .duplicates+=1
      else
        .seen[$e.eventId]=$e |
        .attempts[$e.attemptId] as $old |
        ($e|{accountId,cycleId,featureId,runtimeId,ticketId,category,purpose,currency,priceRevision}) as $identity |
        check($old==null or $old.identity==$identity; "financial attempt attribution changed") |
        if $e.eventType=="reserved" then
          check($old==null and $e.evidence=="synthetic-reservation"; "attempt was already reserved or lacks reservation evidence") |
          .attempts[$e.attemptId]=($identity+{identity:$identity,status:"reserved",reserved:($e.amountMicros|units),consumed:0,initial:($e.amountMicros|units)})
        elif $e.eventType=="pending" then
          check($old!=null and ($old.status=="reserved" or $old.status=="pending") and
            $e.evidence=="synthetic-timeout" and ($e.amountMicros|units)==$old.reserved;
            "pending charge must retain the full unresolved reservation") |
          .attempts[$e.attemptId].status="pending"
        elif $e.eventType=="metered" then
          check($old!=null and ($old.status=="reserved" or $old.status=="pending") and $e.evidence=="synthetic-usage";
            "usage requires a prior reservation and usage evidence") |
          .attempts[$e.attemptId]+={status:"metered",reserved:0,consumed:($e.amountMicros|units)}
        elif $e.eventType=="reconciled" then
          check($old!=null and $old.status!="released" and $old.status!="reconciled" and $e.evidence=="synthetic-invoice";
            "reconciliation requires an unresolved attempt and invoice evidence") |
          .attempts[$e.attemptId]+={status:"reconciled",reserved:0,consumed:($e.amountMicros|units)}
        else
          check($old!=null and ($old.status=="reserved" or $old.status=="pending") and
            $e.evidence=="synthetic-confirmed-no-charge" and $e.amountMicros=="0";
            "release requires confirmed no-charge evidence; timeout is not a refund") |
          .attempts[$e.attemptId]+={status:"released",reserved:0,consumed:0}
        end
      end)) as $state |
    check(($state.attempts|has($q.attemptId)|not); "new request repeats an existing financial attempt") |
    ($state.attempts|to_entries|map(.value+{attemptId:.key})) as $attempts |
    ([$attempts[]|select(.cycleId==$x.cycleId)]) as $current |
    (if any($current[]; .status=="pending" or .status=="reserved") then "pending"
     elif any($current[]; .status=="metered") then "metered"
     elif any($current[]; .status=="reconciled") then "reconciled" else "none" end) as $financialState |
    check($x.state.financialState==$financialState; "scenario financial snapshot disagrees with accounting observations") |
    check(($events|length)>0 and all($events[]; .synthetic and .cycleId==$x.cycleId); "cycle event provenance mismatch or missing observations") |
    check(($events|map(.eventId)|length)==($events|map(.eventId)|unique|length); "duplicate cycle event") |
    check(all(range(0; $events|length); . as $i | $events[$i].sequence==$i+1); "cycle event sequence must be contiguous") |
    (reduce $events[] as $e ({paused:false,resources:{},ended:false};
      check((.ended|not); "event after ended cycle") |
      if $e.eventType=="paused" then .paused=true
      elif $e.eventType=="resumed" then check(.paused; "resume requires a preceding pause") | .paused=false
      elif $e.eventType=="ended" then .ended=true else . end |
      reduce $e.resourceObligations[] as $r (.;
        check($r.maxLifetimeSeconds<=$c.infrastructure.maxLifetimeSeconds and $r.shutdownAuthority==$c.infrastructure.shutdownAuthority;
          "resource obligation exceeds declared authority/lifetime") |
        .resources[$r.resourceId]=$r))) as $cycle |
    [$c.budget.accounts[] | . as $account |
      [$attempts[]|select((ancestors($c.budget.accounts;.accountId)|index($account.id))!=null)] as $rows |
      dimensions($rows;"consumed";false) as $used |
      dimensions($rows;"reserved";false) as $held |
      dimensions($rows;"consumed";true) as $protectedUsed |
      dimensions($rows;"reserved";true) as $protectedHeld |
      {id:$account.id,consumed:$used,reserved:$held,
       protectedRemaining:(reduce ["ai","infrastructure","combined"][] as $k ({}; .[$k]=([0,($account.protected[$k]|units)-$protectedUsed[$k]-$protectedHeld[$k]]|max))),
       caps:($account.caps|with_entries(.value|=units))}] as $balances |
    ancestors($c.budget.accounts;$q.accountId) as $parents |
    ($q.reservationMicros|units) as $proposed |
    [$c.models.profiles[]|select(.id==$q.profileId)][0] as $profile |
    ([$attempts[]|select(.purpose=="planning" and .featureId==$x.featureId)|.consumed+.reserved]|add//0) as $planningUsed |
    # Product bounds guarantee exact integer arithmetic below 2^53. Reject before multiplying.
    (if $profile==null or $profile.inputMicrosPerToken==null or $profile.outputMicrosPerToken==null then null
     elif ($profile.inputMicrosPerToken|units)>((4000000000000000/$q.maxInputTokens)|floor) or
          ($profile.outputMicrosPerToken|units)>((4000000000000000/$q.maxOutputTokens)|floor) then null
     else ($profile.inputMicrosPerToken|units)*$q.maxInputTokens+($profile.outputMicrosPerToken|units)*$q.maxOutputTokens end) as $priceBound |
    (if $cycle.ended then "cycle-ended"
     elif $cycle.paused then "cycle-paused"
     elif ($x.sources|length)==0 then "missing-context"
     elif $q.currency!=$c.budget.currency then "currency-mismatch"
     elif ($q.bounded|not) then "unbounded-request"
     elif $q.category=="infrastructure" then "infrastructure-hard-cap-unavailable"
     elif $profile==null then "unknown-profile"
     elif ($profile.supportedEfforts|index($q.effort))==null then "unsupported-effort"
     elif $q.maxOutputTokens>$profile.maxOutputTokens then "output-limit-exceeded"
     elif $q.maxInputTokens>$c.retrieval.maxContextTokens then "context-limit-exceeded"
     elif $priceBound==null or $priceBound>9000000000000000 then "missing-or-unbounded-price"
     elif $proposed<$priceBound then "under-reserved-request"
     elif $q.purpose=="planning" and ($q.profileId!=$c.bootstrap.profileId or $q.effort!=$c.bootstrap.effort or
       $planningUsed+$proposed>($c.bootstrap.allowanceMicros|units)) then "bootstrap-allowance-exceeded"
     elif any($balances[]; . as $b | ($parents|index($b.id))!=null and
       any(["ai","infrastructure","combined"][]; . as $k |
         (if $k==$q.category or $k=="combined" then $proposed else 0 end) as $new |
         (if ($q|protected) then [0,$b.protectedRemaining[$k]-$new]|max else $b.protectedRemaining[$k] end) as $protected |
         $b.consumed[$k]+$b.reserved[$k]+$new+$protected>$b.caps[$k])) then "budget-exceeded"
     else "covered-synthetic-proposal" end) as $reason |
    {formatVersion:1,synthetic:true,id:$m.id,cycleId:$x.cycleId,currency:$c.budget.currency,
     decision:(if $reason=="covered-synthetic-proposal" then "admitted-simulation" else "rejected" end),reason:$reason,
     dispatchPerformed:false,duplicateEvents:$state.duplicates,
     accounts:[$balances[]|{id,consumedMicros:(.consumed|with_entries(.value|=tostring)),reservedMicros:(.reserved|with_entries(.value|=tostring)),protectedRemainingMicros:(.protectedRemaining|with_entries(.value|=tostring))}],
     pendingChargeIds:[$attempts[]|select(.status=="pending" or .status=="metered")|.attemptId],
     overageIds:[$attempts[]|select(.consumed>.initial)|.attemptId],
     resourceObligations:($cycle.resources|to_entries|map(.value)),
     checks:[$events[]|{eventId,result}],financialEnforcement:false}
  ' >"$h_area/summary.json" || return 1
  # Expected data is an independent, checked-in fixture oracle, not regenerated here.
  jq -n -e --slurpfile actual "$h_area/summary.json" --slurpfile expected "$expected" \
    '($expected|length)==1 and $actual[0]==$expected[0]' >/dev/null || h_fail 'Scenario result differs from expected.json.'
  h_render_report "$h_area/summary.json" >"$h_area/report.md" || return 1
  cmp -s "$h_area/report.md" "$report" || h_fail 'Scenario report differs from deterministic records.'
  jq --slurpfile s "$h_area/summary.json" '. + {scenario:$s[0]}' "$h_area/result.json" >"$h_area/next-result.json" || return 1
  mv "$h_area/next-result.json" "$h_area/result.json"
}
h_render_report() {
  jq -r '
    "# Synthetic delivery receipt — " + .id + "\n\nSimulation only. No provider dispatch, invoice verification or infrastructure execution occurred.\n",
    ("Cycle: " + .cycleId + "\nDecision: " + .decision + "\nReason: " + .reason + "\nCurrency: " + .currency + " (integer microcurrency units)\n"),
    "| Account | Consumed AI / infrastructure / total | Reserved AI / infrastructure / total | Protected remaining AI / infrastructure / total |\n| --- | --- | --- | --- |",
    (.accounts[] | "| " + .id + " | " + ([.consumedMicros.ai,.consumedMicros.infrastructure,.consumedMicros.combined]|join(" / ")) + " | " + ([.reservedMicros.ai,.reservedMicros.infrastructure,.reservedMicros.combined]|join(" / ")) + " | " + ([.protectedRemainingMicros.ai,.protectedRemainingMicros.infrastructure,.protectedRemainingMicros.combined]|join(" / ")) + " |"),
    ("\nDuplicate financial events ignored: " + (.duplicateEvents|tostring) + "\nPending charges: " + (if .pendingChargeIds|length==0 then "none" else .pendingChargeIds|join(", ") end) + "\nObserved overages: " + (if .overageIds|length==0 then "none" else .overageIds|join(", ") end)),
    "\n## Outstanding resource obligations",
    (if .resourceObligations|length==0 then "None recorded in this synthetic scenario." else .resourceObligations[] | "- " + .resourceId + ": " + .status + "; owner=" + .owner + "; shutdown=" + .shutdownAuthority + "; maximum lifetime=" + (.maxLifetimeSeconds|tostring) + "s; " + .reason end),
    "\n## Observation results",
    (.checks[] | "- " + .eventId + ": " + .result),
    "\nConsumed amounts include metered or reconciled observations, never both valuations. Pending reservations remain liabilities. No acceptance, savings, live cleanup or hard financial cap is established."
  ' "$1"
}
