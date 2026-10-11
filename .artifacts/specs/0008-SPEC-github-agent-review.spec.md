# Technical specification

- ID: `SPEC-GITHUB-AGENT-REVIEW`
- Document: `SPEC-0008`
- Version: `2`
- State: `implemented`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md); product scope approval remains unrecorded.
- Technical owners: project owner as repository consumer; the CI and AI billing operator must be identified before activation.
- Approval: on October 11, 2026, the owner requested the original specification, then explicitly invoked `to-tickets` and `implement` together and authorized a separate branch, commits, push, and PR creation. That request authorizes this complete delivery slice and its presented `VER-CI-01` fixture seam. Version 2 records implementation choices within the same requirements. Paid provider calls, service provisioning, billing changes, and secret configuration remain outside this delivery.

## Contract and composition

- Requirements addressed: `REQ-CI-01` through `REQ-CI-09`; supports `REQ-PRD-005` and `REQ-PRD-006`.
- Entry point: GitHub Actions `.github/workflows/ci.yml`, with the review job identified as `agent-review` and a small `review-scope` job that resolves its concurrency group before scheduling. The installed `code-review` skill defines the review procedure; `to-spec` produces this artifact.
- Execution: a repository-owned `.sh` adapter collects an immutable PR snapshot, loads trusted instructions, starts independent Standards and Spec model invocations in parallel, validates output, and publishes a combined report. There is no general workflow engine or new SDK/CLI command.
- Provider: OpenAI Responses API, with no model tools and separate request contexts. Runner, permissions, operator configuration, and limits are specified below. Credentials remain secret references and are excluded from prompts and reports.
- Delivery: one vertical ticket, [CI-01](../tickets/0020-TICKET-github-agent-review.ticket.md), covers the PR-event-to-report path and local contract verification. Implementation and local verification are complete, with evidence recorded in CI-01; hosted execution and provider behavior remain unverified.

### Problem and intended result

The installed `code-review` skill defines Standards and Spec reviews, but the inspected baseline has no GitHub Actions adapter that executes it. Local hooks provide developer checks and advisory SDD identity diagnostics; they do not run the two-axis review.

Contributors receive a report tied to a PR revision. Both assessments must actually run when inputs are available; missing evidence and technical failures remain explicit. A successful job is neither human acceptance nor proof that the application works.

### User stories

1. Contributors can inspect findings against repository standards and the originating specification before delivery.
2. Reviewers can distinguish the two axes and identify the exact source revision each assessed.
3. The repository operator can bound execution, investigate consumption, and identify skipped or failed work.

### Requirements and acceptance

| ID | Required behavior | Reviewable acceptance criterion |
| --- | --- | --- |
| REQ-CI-01 | Provide the requested entry point. | Add `.github/workflows/ci.yml` with job key `agent-review`. Declare trigger and eligibility behavior for updated PRs, drafts, forks, and unavailable credentials. No extra build, test, release, or deployment jobs are implied. |
| REQ-CI-02 | Execute the existing review contract. | Read the trusted revision of `.agents/skills/code-review/SKILL.md` and relevant repository context. Start independent Standards and Spec reviewers in parallel on the same snapshot. Printing the skill, substituting lint, or returning one blended response is insufficient. |
| REQ-CI-03 | Pin and record the scope. | Reports identify repository/PR, event, run/attempt, base SHA, head SHA, comparison merge-base, commit list, selected paths, exclusions, skill/policy revision, and executor/model version. Both reviewers receive identical source identities. Account for additions, deletions, renames, unreadable/binary files, limits, and exclusions. |
| REQ-CI-04 | Preserve both review axes. | Standards loads applicable rules, contributing/standards documents when present, and the complete skill smell baseline. Spec checks missing, incorrect, and unrequested behavior. Separate `Standards` and `Spec` sections contain up to 400 words per axis, file/line references where applicable, severity, evidence, and per-axis totals. Heuristics remain distinct from hard violations. |
| REQ-CI-05 | Resolve traceability without an interactive interview. | Inspect the actual PR `Spec:` declaration and every included commit's `Ticket:` relation to local artifacts. Missing, duplicate, ambiguous, unresolved, or mismatched identities remain visible advisory SDD findings. Without an authoritative spec, Standards may proceed while Spec is explicitly `not-verified` or skipped with a reason; do not invent a spec or claim a passing assessment. |
| REQ-CI-06 | Publish inspectable results. | Publish a GitHub job summary and downloadable report artifact containing source identity and per-axis results. Explain non-applicable/no-change cases. Superseded results remain labeled with their original revision. No PR comments, review submissions, approval, or merge. |
| REQ-CI-07 | Separate outcomes. | Distinguish completed review with findings, completed review without findings, unavailable Spec evidence, intentionally ineligible/skipped runs, and executor/output/timeout failures. One failed reviewer cannot become an empty findings list. Informational findings do not suppress technical failures or convert missing evidence into compliance. |
| REQ-CI-08 | Keep execution within its trust boundary. | Workflow, adapter, and skill instructions come from an identified trusted revision. PR files, instruction changes, metadata, and comments are review data. Models cannot edit source, execute contributor scripts, install PR dependencies, publish messages, approve/merge, or obtain repository-write credentials. Collection and model execution receive only required permissions and data. |
| REQ-CI-09 | Bound execution and report consumption. | Before paid activation, record provider/runner, authorized limits, ownership, retention, and cost assumptions. Cancel obsolete local work, terminate both reviewer processes on cancellation, and report available duration/token/request usage. Inputs exceeding the envelope are reported incomplete rather than silently truncated. |

## Implementation decisions

### DEC-CI-01 — Events and trust

A trusted metadata-only `review-scope` job computes concurrency before the `agent-review` job starts. Source updates and relevant Spec/base changes share a PR group; irrelevant title/body edits use an isolated run group and produce a skip without cancelling an active assessment. Before entering the cancelling group, this job reads current PR metadata and isolates already-stale events and old workflow reruns. The adapter rechecks identity before/after model execution; these observations are not an atomic lock with GitHub scheduling. GitHub expressions cannot extract an exact `Spec:` declaration before acquiring the concurrency group, so this small preparatory job is necessary. It has no provider credential, no model call, and no application execution.

Use `pull_request_target` for PRs targeting `main`: opening, reopening, new commits, readiness changes, and relevant `Spec:` metadata changes. Do not add a duplicate `push` trigger. Drafts, forks, and Dependabot PRs are explicitly ineligible for paid review. Disabled runs visibly explain that no model assessment occurred.

Check out `github.sha`, the trusted workflow revision from the default branch, rather than the PR head. Record this revision separately from the PR base and head. Read PR blobs and history as data without checking out or executing head code. Never use PR-controlled script names, endpoints, configuration, or shell fragments. Use minimum source/PR read permissions, disable persisted checkout credentials, and pin executable actions to verified full commit SHAs. See GitHub's [workflow-event reference](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows) and [secure-use guidance](https://docs.github.com/en/actions/reference/security/secure-use).

The repository's Actions policy must allow this event. GitHub's default policy for affected public repositories currently evaluates blocking `pull_request_target`, with enforcement scheduled for November 2, 2026; activation must check the applicable policy. No policy change or unsafe-checkout opt-out is authorized by this implementation. See [secure use of pull_request_target](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target).

Capture the comparison merge-base, complete selected diff, changed-file contents, owning context, and commit list once. Disclose generated/vendor exclusions and files that cannot be assessed. Untrusted instruction changes stay visible as proposed changes; only trusted policy content supplies review instructions. Bind PR metadata to the snapshot and detect a changed head or relevant declaration before publishing the result as current.

### DEC-CI-02 — Independent review execution

Use the `ubuntu-24.04` hosted runner and its shell, Git, GitHub CLI, jq, curl, and iconv tools. Report observed tool and runner-image versions; the image label does not pin every preinstalled binary. Record adapter/skill/policy revision and action pins. No application dependencies, package-manager installation, or agent CLI configuration are needed.

The adapter performs the installed skill's source discovery and delegation steps. It supplies the full trusted skill to two isolated OpenAI Responses requests launched concurrently, with the same source identity and separate axis briefs. Standards receives applicable trusted standards and the complete smell baseline. Spec receives the resolved originating specification as evidence. Neither reviewer receives the other's findings before both finish. The only interactive adaptation is to report unavailable Spec evidence instead of asking a person during CI; the local skill is unchanged.

Require an explicitly configured dated model snapshot; do not silently choose or upgrade an alias. Requests have no tools, no conversation linkage, `store: false`, disabled truncation, and a strict JSON output schema. Validate transport success, completed response status, absence of refusal/incomplete output, output structure, axis/snapshot identity, and the 400-word report bound before aggregation. A syntactically valid empty result cannot substitute for an unexecuted reviewer. See the [Responses API reference](https://developers.openai.com/api/reference/resources/responses/methods/create) and [structured output guide](https://developers.openai.com/api/docs/guides/structured-outputs).

Only the model execution step receives the provider credential. Keep secrets out of source context, prompts, diagnostics, and artifacts. Input remains data even when it contains instructions. Output remains report data and is never evaluated as shell code or workflow commands. `store: false` does not promise zero provider retention; applicable abuse-monitoring and caching behavior must be accepted before activation, following the [provider data controls](https://developers.openai.com/api/docs/guides/your-data).

### DEC-CI-03 — Activation, limits, and cost

Paid review is opt-in. Require `AGENT_REVIEW_ENABLED=true`, `AGENT_REVIEW_MODEL`, `AGENT_REVIEW_OWNER`, `AGENT_REVIEW_BUDGET_REF`, `AGENT_REVIEW_BUDGET_EXPIRES`, `OPENAI_PROJECT_ID`, and the `OPENAI_API_KEY` secret. Expiration is a valid, unexpired UTC date in `YYYY-MM-DD` format. Missing configuration after opt-in is a visible technical failure before provider calls where detectable. The budget reference identifies an approval record by URL or repository path; a configured string does not verify the record or actual provider billing settings.

The activation record identifies the operator and billing project; exact model and dated input/output prices; currency; approved budget and expiration; expected PR/rerun volume across the repository; runner minutes for both metadata and review jobs, artifact storage, and relevant network costs; uncertainty; project hard-limit configuration; and the response to deviations. These facts remain unassigned or unverified until recorded by the operator. The delivery request authorizes no paid calls or billing/secret configuration.

| Control | Fixed delivery limit |
| --- | --- |
| Request input | 262,144 bytes per complete serialized reviewer request; reject oversized input without silent truncation |
| Model output | 4,096 output tokens per reviewer, including provider-counted reasoning tokens |
| Provider duration | 300 seconds per curl request |
| Workflow duration | 2 minutes for metadata scope; 15 minutes for the review job |
| Model calls | At most two concurrent calls per eligible run; one when Spec is unavailable; zero automatic retries |
| PR concurrency | One active review per PR; relevant superseding events cancel older reviews; irrelevant edits use separate skip-only groups |
| Report artifacts | Seven-day retention |

Per-PR concurrency is not a repository-wide spending cap. OpenAI supports project/organization hard spend limits that reject requests when tracked spend reaches the limit, with possible small overage while enforcement propagates. Require the configured project's budget control and aggregate PR-volume plan before activation; do not describe alerts, configuration references, byte limits, or timeouts as an exact monetary cutoff. See [provider spend limits](https://developers.openai.com/api/docs/guides/spend-limits) and GitHub's [workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax).

Cancellation terminates local reviewer children and cleans temporary inputs. Synchronous HTTP cancellation does not prove immediate provider-side termination or cessation of billing. The [Responses cancellation endpoint](https://developers.openai.com/api/reference/resources/responses/methods/cancel) applies to background responses; this delivery does not add background storage or polling. Residual provider work and unavailable usage remain explicit limitations.

### DEC-CI-04 — Outcomes and publication

Substantive findings are informational: a technically complete review can succeed while reporting defects. Transport errors, timeouts, refusal, invalid output, incomplete input, and unexpectedly missing axes fail the execution check. An intentionally unavailable Spec is `not-verified`, never a passing Spec. SDD identity findings remain advisory.

Publish separate axis sections, totals, coverage limits, source/metadata identity, and available consumption in the summary and artifact. Preserve sanitized partial results where possible. Cancelled, stale, disabled, ineligible, and no-change outcomes cannot represent completed current assessments. No branch-protection change, required check, PR comment/review, automatic approval, or merge is introduced.

## Responsibilities and operation

- Consumer: the project owner authorized this implementation and local verification. Operator assignment, model/budget approval, event-policy compatibility, and paid activation remain separate decisions.
- Adapter: preserve the skill contract, immutable source identity, independent contexts, bounds, secret boundary, and distinct outcomes. Evidence does not replace human review or authenticated acceptance.
- Operator: own credentials, approved consumption, retention, failures, model/action updates, and usage investigation. Required `AGENT_REVIEW_OWNER` records assignment; this document invents no organizational team, billing account, or SLA.
- Lifecycle: run on an ephemeral hosted runner, remove temporary source/request material, retain sanitized reports for seven days, and stop new paid calls when disabled or approval expires. Disabling does not erase existing artifacts or prove remote generation stopped; cancellation and expiration remain separate actions.
- Observability: report run/attempt, source/trusted revisions, start/end/duration, axis outcome, dispatched request attempts (including failures/cancellation), and available input/output/total tokens. Attempts do not prove provider acceptance or exact billing. Missing usage or delayed billing remains unknown. Do not print raw provider responses that may echo input or credentials.
- Updates/removal: review pins, model changes, permissions, and cost assumptions before updating. Removing the workflow stops future event handling; no persistent service or background sync is created.

### Out of scope

Paid API verification or provisioning; secrets/billing/event-policy administration; extra lint/build/test/deploy jobs; application tests or fixes; agent-generated commits; PR comments/reviews or merge actions; branch protection; organization-wide workflow adoption; and SDK/CLI or microruntime redesign. The owner's contributor commits, normal branch push, and PR creation are authorized. Existing local Git hooks remain independently applicable.

## Verification and guardrails

The 18-group local contract suite and actionlint v1.7.11 have passed. Both implementation review axes identified the invalid-date defect; Spec also identified irrelevant-edit cancellation and missing request-attempt reporting. These defects were corrected and regression fixtures passed. The second Spec assessment found no remaining issues; Standards additionally found that an old workflow rerun could cancel a newer review. A freshness check during scoping and an old-event regression now address that case. Final independent reassessment found zero unresolved Standards findings and zero Spec findings, as recorded with the source manifest in CI-01; live GitHub event delivery, actual provider authentication/model quality, budget enforcement, and billable consumption are `not-verified`. No paid calls or service configuration have been performed for this delivery.

| Policy / criteria | Adaptation and evidence required | Current assessment / owner |
| --- | --- | --- |
| FinOps v1 FIN-01 | CI/AI operator and provider project; allocation of shared runner/storage costs. | `not-verified`; project owner assigns operator before activation. |
| FIN-02 / FIN-03 | Dated model/runner/storage estimate, PR/rerun scenarios, approved envelope/expiry, project hard limit, deviation response. Configuration is not approval or provider-state verification. | `not-verified`; operator must supply activation evidence. |
| FIN-04 | Two bounded workers, input/output/time limits, repository-wide volume assumptions. Fixtures verify local bounds; live capacity/consumption needs observed evidence. | `compliant` for the local two-worker/input/output/time controls demonstrated by contract fixtures; live capacity and total spend remain `not-verified`. |
| FIN-05 / FIN-06 | Ephemeral inputs, seven-day reports, cleanup, request/token/duration reporting, billing delay, investigation owner. | `compliant` for local cleanup, request-attempt/token/duration reporting, and declared retention; hosted lifecycle and billing remain `not-verified`. |
| FIN-07 / FIN-08 | No savings comparison or cost-optimization outcome is claimed. Security/quality remain required regardless of price. | `not-applicable` to economic comparison in this delivery. |
| Twelve-Factor v1 12F-01 / 12F-02 / 12F-05 | Source/skill/adapter/action identities and runner/tool versions; distinguish authored workflow from installed/executed revision. | `compliant` for inspected source/action identities and tool-version reporting; hosted image execution remains `not-verified`. |
| 12F-03 / 12F-04 | Environment configuration and secret references; explicit Responses compatibility and fail-before-call checks. | `compliant` for declared configuration and controlled failure paths; real authentication/model compatibility remain `not-verified`. |
| 12F-06 / 12F-08 / 12F-09 | Disposable job, bounded parallel workers, cancellation cleanup, artifact lifecycle, remote-cancellation limitation. | `compliant` for local parallelism and both-child cancellation fixtures; hosted/provider lifecycle remains `not-verified`. |
| 12F-07 | Outbound API client job with no listening service. | `not-applicable`; no port-binding contract. |
| 12F-10 | Local controlled transport versus hosted runner/live API; fixtures prove neither model quality nor platform parity. | `not-verified`; differences declared, live pilot excluded. |
| 12F-11 / 12F-12 | Sanitized correlated reports, versioned shell entry points, separately authorized operator actions. | `compliant` for sanitized fixture reports and scoped shell entry points; hosted observability remains `not-verified`. |
| SDD v1 SDD-01 / SDD-02 / SDD-03 | CI-01 relation per contributor commit, actual PR declaration, outgoing-range evidence, and independent code-review axes before completion/commit/push. | `compliant` for implementation commit `33cfeaf3`, its CI-01 relationship, [PR #4](https://github.com/jonatassales/exphere/pull/4) and its actual Spec declaration, and observed pre-push inspection. Historical warnings are disclosed in CI-01. Main reconciliation received independent Standards and Spec reassessment with zero findings on the identified snapshot recorded in CI-01 before commit. |

Update these states with identified evidence rather than inferring compliance from YAML syntax or green fixtures. No policy exception is requested. Unknown spend is not zero; local implementation can proceed while paid activation remains disabled.

### VER-CI-01 — PR-to-report contract seam

The owner's combined implementation request authorizes the presented seam: a PR event and immutable repository snapshot enter the adapter; independent axis results, a report, and an execution outcome leave it. Use disposable local Git fixtures and controlled provider/metadata responses, without paid calls or application execution.

Verify identical snapshot identities and independent contexts; additions/deletions/renames/binary coverage; actual PR/ticket/spec relation parsing; unavailable Spec; separated findings; failed/timed-out/refused/malformed worker outcomes; changed head or relevant metadata; ineligible/disabled zero-call behavior; input/output limits; cancellation of both local children; credential exclusion; and contributor scripts remaining data. Tests observe the public adapter contract, not model phrasing or private helper structure.

Inspect workflow syntax and trusted source/permission/pin configuration. Record the exact implementation snapshot and both Standards and Spec outcomes before completion, commit, or push. A later separately authorized paid pilot is needed to establish actual model behavior, authentication, billable usage, and hosted cancellation; fixtures cannot establish those outcomes. Root hooks remain independent delivery checks.

### Related local contracts

- [Code-review skill](../../.agents/skills/code-review/SKILL.md) and [Dev review workflow](../../.exphere/workflows/dev/02-review.md): required behavior and boundaries.
- [SDD rule](../../.exphere/rules/sdd.md) and [SDD guardrail](../../.exphere/guardrails/sdd.md): advisory diagnostics and mandatory contributor review.
- [FinOps](../../.agents/guardrails/finops.md), [Twelve-Factor](../../.agents/guardrails/twelve-factor.md), [artifact tracker](../agents/0006-DD-artifact-tracker.dd.md), and [evidence contract](../../.audits/evidence/README.md): unchanged policies.
- The imported rule corpus in PR #2 is separate scope. Load whichever trusted rule revision exists when this workflow executes; do not import that PR as part of this delivery.

Official GitHub and OpenAI documentation was consulted on October 11, 2026. It establishes supported platform contracts and limits, not observed execution of this implementation.
