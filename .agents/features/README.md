# Exphere feature proposals

- Status: proposed product backlog; implementation and operational acceptance are separate.
- Version: 2.
- Updated: October 13, 2026.
- Scope: thirteen prioritized capabilities for developer-installed microruntimes, governed agentic delivery, and cost-aware execution.
- Authority: the project owner requested this detailed feature register. Recording a feature does not authorize infrastructure changes, paid calls, new test suites, or publication.

## Product outcome

Exphere should turn approved product intent into an inspectable delivery journey whose execution, resource boundaries, and covered costs are visible and governed. People concentrate on the problem, business value, priorities, acceptance criteria, and consequential approvals. The platform handles routine cost planning, budget allocation, consumption tracking, bounded execution, and reporting.

Consumers choose their stack, application components, resource values, and compatible tools. Exphere supplies execution contracts, policy checks, evidence, and reusable automation. Existing portals, catalogs, and delivery systems remain independently owned; adopting a microruntime does not require replacing them.

The three product pillars are:

1. **FinOps:** connect spending and resource decisions to accepted outcomes, with explicit scope and evidence.
2. **Agentic software delivery:** use SDD, selected skills, guides, sensors, and authorized tools to execute work with fewer routine human interventions.
3. **Microruntimes:** provide a reusable, consumer-composed execution boundary around existing application components.

Governance, security, observability, and traceability apply across all three pillars.

## Status and relationship to existing work

The current [workspace overview](../../README.md) and [Go CLI contract](../../packages/cli/README.md) remain the implementation references. The CLI is now a Go scaffold with help/version; initialization and runtime operations are unavailable. The earlier shell CLI, manual/guided generation, setup, and native adapters are retired. Retained schemas/specifications are historical contracts for future implementation. The TypeScript SDK API remains empty. These foundations do not establish a working agent workflow, financial enforcement, or a completed infrastructure lifecycle.

This register extends the product direction beyond [PRD-0002](../../.exphere/artifacts/prd/0002-PRD-local-microruntimes.prd.md), whose local pilot defers monetary enforcement and automatic optimization. It does not silently amend that PRD, approve a new schema, or mark any feature complete. Future implementation must reconcile the selected feature scope with its originating PRD and SPEC.

Feature IDs in this document are local backlog identifiers, not new PRD, SPEC, or ticket identities. Exact APIs, commands, persistence formats, provider choices, and authentication mechanisms remain specification decisions.

## Backstage context and team-funded execution

![Architecture proposal: Backstage and intent artifacts feed RAG, cost allocation, LangGraph orchestration, and microruntime execution; a shared team budget governs every covered paid call, and observed outcomes return to memory.](assets/backstage-context-team-budget.png)

This is a proposed architecture, not an installed integration. The [documentation SPEC](../../.exphere/artifacts/specs/0029-SPEC-backstage-team-budget-proposal.spec.md) and [delivery ticket](../../.exphere/artifacts/tickets/0051-TICKET-backstage-team-budget-proposal.ticket.md) track this refinement. The earlier [factory overview](assets/runtimes-factory.png) remains a broader workflow illustration; this section is authoritative for the updated funding proposal. [Asset provenance](assets/README.md) records the logo source and image-generation method.

**The authorized spending ceiling belongs to a team for a defined period.** Developers, features, tickets, and cycles are attribution and planning dimensions, not independent funding authorities. Complex work can receive a larger allocation than simple work. Agents may redistribute available funds within the existing team policy without requesting routine approval for every ticket.

| Boundary | Proposed responsibility |
| --- | --- |
| Backstage connector | Retrieve component ownership, team references, dependencies, and documentation links through an explicitly configured, authorized read-only MCP connection or API. |
| Artifact sources | Retrieve the referenced PRD, SPEC, ticket, or PR from its authorized source. Catalog links do not imply that Backstage stores every artifact body. |
| RAG and memory | Combine exact references with relevant vector retrieval, relationship traversal, and past execution episodes. Record sources, revisions, relevance, and uncertainty. |
| Cost allocation agent | Use recovered evidence, priority, required quality, prices, and the available team balance to recommend feature allocations and model/effort choices, with an artifact-linked rationale. |
| LangGraph orchestration | Coordinate the proposed execution steps and routing. Model selection, budget enforcement, and the financial ledger remain Exphere responsibilities. |
| Deterministic budget control | Reserve before each covered paid action, reconcile observed usage, and prevent simultaneous runtimes from committing the same team balance. |

Backstage context helps resolve an owning team; a trusted consumer mapping associates that team with its budget account. Catalog metadata and retrieved prose do not authorize spending or redirect charges. Missing, ambiguous, stale, or unauthorized ownership must be surfaced before paid planning or execution. The portal stays independently owned, and this proposal adds no required Backstage replacement, plugin installation, or paid platform subscription.

Read-only access must be enforced by scoped credentials, permissions, and allowed operations. An MCP tool's description is not an access-control boundary. The documented Backstage MCP Actions Backend requires installation and configuration; availability is not assumed for any consumer. A configured API adapter is an alternative transport, not a permission bypass.

### Proposed agents boundary

```text
.exphere/agents/
├── rag/
│   ├── sources.json
│   ├── connectors/
│   │   └── backstage.ts
│   ├── retrieve.ts
│   └── memory.ts
├── allocation/
│   ├── agent.ts
│   └── rationale.ts
├── orchestration/
│   ├── graph.ts
│   └── routing.ts
└── budget/
    └── client.ts
```

This tree describes proposed consumer agent application modules and configuration. It creates no files, automation scripts, generated-layout contract, or supported CLI commands. It must be reconciled with the existing consumer harness specifications before generation is implemented. Database vendors, module APIs, and storage topology remain open.

- `sources.json` declares allowed source references and connection bindings, without credentials.
- `connectors/backstage.ts` would resolve catalog context; `retrieve.ts` would assemble relevant, authorized evidence; `memory.ts` would access vector, relationship, and episodic stores. Vector similarity does not automatically build a relationship graph.
- `allocation/agent.ts` would propose investments; `rationale.ts` would retain a concise decision summary, source references, estimates, alternatives, and uncertainty. This is auditable justification, not a requirement to retain private model reasoning.
- `orchestration/graph.ts` and `routing.ts` would coordinate steps, model/effort choices, fallback, and pause/resume behavior through LangGraph.
- `budget/client.ts` would access a shared, durable budget service or store. It is a deterministic client, not another LLM agent. Independent local balance copies cannot provide shared-team enforcement.

Live balances, reservations, secrets, and memory records stay outside committed source. A local pilot can use local storage with one serialized writer; multi-operator claims require a shared transactional boundary and authenticated account access. Memory retrieval must preserve tenant/team permissions, retention, and provenance. Episodes include failure, retry cost, model/effort, accepted or rejected outcomes, and artifact revisions, rather than storing only successes.

Planning, embeddings, paid retrieval, model review, retries, and LLM-generated reports must declare their financial coverage. Every covered call obtains a reservation before it starts, including the allocator's own calls. Unbounded or unknown liabilities prevent a hard-cap claim. At insufficient balance, the workflow uses an affordable permitted alternative or pauses; it cannot invent more funding or remove required checks.

The optimization target is expected cost per accepted outcome, including failed attempts and rework. Historical similarity supports estimates; it does not prove that a feature will generate revenue or financially pay for itself. Quality requirements and business priority remain explicit inputs. Sparse or stale history produces a stated uncertainty or bounded fallback, not fabricated precision.

## Prioritized feature index

Priority combines demonstrable product value with the effort of a narrow implementation. It is not dependency order or a delivery-time commitment. Effort assumes one local microruntime, one SDD workflow, one controlled LLM provider integration, and a small catalog of allowed models. Production distribution, multiple operators, and multiple providers increase the scope.

| Priority / ID | Feature | Demonstration value | Relative effort | Main prerequisite |
| --- | --- | --- | --- | --- |
| 1 / F-01 | Automatic delivery and cost report | Very high: financial visibility, observability, and explainable outcomes | Medium; report rendering is small after measurement exists | Execution and usage records |
| 2 / F-02 | Resource preflight | Very high: platform boundaries and early prevention of invalid resource requests | Low–medium | Native configuration and an explicit consumer policy |
| 3 / F-03 | Shared team budget guardrail | Very high: autonomy with enforceable spending boundaries | Medium–high | Controlled dispatch, price coverage, and durable team reservations |
| 4 / F-04 | Unproductive-attempt detector | High: less wasted consumption and repeated failure | Low–medium for bounded rules | Attempt and verification events |
| 5 / F-05 | Intent-to-execution traceability | High: auditability and explainable ownership | Low–medium | Stable identities and revision snapshots |
| 6 / F-06 | Execution planner with cost estimates | Very high: agentic delivery connected to affordability | Medium for a bounded catalog | F-03, F-05, and a price snapshot |
| 7 / F-07 | Complete local microruntime journey | Very high: reproducible execution around existing applications | Medium–high | Existing configuration contract and local prerequisites |
| 8 / F-08 | Runtime-installed SDD harness | High: an adoptable Golden Path with executable checkpoints | Medium for one workflow | Versioned skills, explicit workflow transitions, and evidence contracts |
| 9 / F-09 | Team budget allocation and sprint reporting | High: connect priorities, allocations, and actual consumption | Low–medium after the team ledger exists | F-03 and feature/cycle attribution |
| 10 / F-10 | Evidence-based runtime diagnosis | High: actionable troubleshooting with inspectable sources | Medium for read-only diagnosis | F-07 inspection and F-03 for paid diagnosis |
| 11 / F-11 | Minimal context per ticket | Medium–high: context efficiency and reproducibility | Low–medium without a vector database | F-05 and explicit artifact references |
| 12 / F-12 | Bounded replanning and resume | Very high: autonomous recovery without budget resets | High | F-03, F-04, F-05, F-06, and durable execution state |
| 13 / F-13 | Comparable-delivery efficiency analysis | High: evidence of economic and delivery improvement | Medium plus sufficient history | F-01, accepted outcomes, and comparable baselines |

## Shared product contracts

### Human and platform responsibilities

| Decision or activity | Proposed responsibility |
| --- | --- |
| Problem, value, priorities, scope, and acceptance criteria | Product owner and responsible specialists; agents assist with clarification |
| Team funding envelope and execution policy | Authorized budget and policy owners, configured before routine execution; no developer or ticket budgets |
| Feature plan, model/effort recommendation, and allocation proposal | Agent planner, subject to deterministic policy validation |
| Routine execution and authorized reallocations | Workflow executor; no repeated human approval inside the existing grant |
| Metering, reservation, budget checks, and arithmetic | Deterministic software, using declared sources and pricing rules |
| Reports and notifications | Automatically derived from execution records; agents may explain the results |
| Material changes to scope, permissions, risk, or total funding | The authority named by policy; an agent cannot grant itself additional authority |
| Final acceptance and consequential releases | The approval mechanism required for the change's risk and consumer policy |

Approval of a PRD may authorize execution under an existing policy only when that approval explicitly covers execution. A document's wording alone is not an authenticated grant. Existing valid authorization should be reused instead of requesting approval for every ticket or call.

### Team, runtime, feature, sprint, and cycle

- A **team budget** is the shared authorized ceiling for a defined currency, coverage, and funding period. All covered runtimes for that team use the same account and reservation boundary.
- A **microruntime** is reusable execution configuration referencing consumer-owned components. It is not a budget period or a copy of application source.
- A **feature** is an intended outcome, connected to approved intent and its acceptance criteria.
- A **cycle** is one identified workflow execution with a defined scope, runtime reference, configuration revision, and authorization.
- A **sprint** is an optional planning/reporting window within the team's explicit funding policy; it does not create independent spending authority.
- A **ticket** is an execution unit with a plan and required evidence. Multiple attempts may be needed to complete it.
- An **attempt** is a specific action or provider request. Retrying does not erase the earlier attempt or its charge.

The reporting hierarchy is team/funding period → feature → cycle → ticket/step → attempt; a sprint is an optional aggregation view. A runtime is referenced by its cycles and can be reused by different features. One feature can span multiple cycles or runtimes. Reopening work or starting another cycle must not reset the team's cumulative spending. Feature allocations are adjustable planning targets, not independently authorized budgets.

### Financial terminology and coverage

| Term | Meaning |
| --- | --- |
| Budget | Authorized team spending ceiling for a defined coverage and period |
| Feature allocation | Adjustable planning target within the team's available funds; not a charge or a separate funding grant |
| Estimate | Predicted consumption and cost under stated assumptions, potentially expressed as a range |
| Reservation | Balance held for an action that may incur charges; it is not yet an additional settled charge |
| Metered usage cost | Cost calculated from observed usage and the applicable price snapshot; invoice reconciliation may still be pending |
| Reconciled cost | Amount matched to the authoritative charge source for the stated coverage and window |
| Remaining balance | Uncommitted allowance after applicable consumption and reservations |
| Savings | A supported reduction against an explicit, comparable baseline; unused budget alone is not savings |
| Execution credits | Optional display units with an explicit monetary conversion and version; independent of relative effort/story points |

The first enforceable financial scope should cover LLM calls routed through Exphere's controlled dispatcher, including planning, review, diagnosis, retries, and explanatory reports that use an LLM. Cloud infrastructure, subscriptions, CI, storage, network, and external tool charges must be marked included, excluded, estimated, or unknown. Missing data never becomes zero cost.

Artifacts attribute intent and spending. Usage events and authoritative charge sources measure consumption. A generated PRD, ticket, or report does not establish what a provider charged. A single attempt has one financial identity even when several artifacts link to it.

No fixed model prices, conversion rates, budget amounts, service targets, or organizational defaults are established by this document. Numerical examples below are illustrative only.

### Proposed generated consumer harness

The proposed consumer distribution groups harness capabilities under `.exphere/`:

```text
.exphere/
├── runtimes/     # consumer runtime descriptors and native execution configuration
├── artifacts/    # intent, plans, tickets, and attributable execution/report records
├── skills/       # selected, versioned skills and required attribution
├── workflow/     # selected SDD execution definition and mandatory checkpoints
├── guides/       # instructions and references supplied before actions
├── sensors/      # checks and observations that report execution feedback
└── agents/       # bounded agent roles, tool permissions, and integration bindings
```

This is a proposed generated-consumer layout, not a request to reorganize this repository. The current project uses `.agents/` for local guidance and Go skills, `.exphere/artifacts/` for typed artifacts, `.exphere/harness/` for policies and FinOps/AWS skills, and singular `.exphere/workflow/` for workflow documents and AIHero skills. Generated evidence keeps `.audits/evidence/runs/`. A future specification must define adoption, migration or coexistence, generated-file ownership, and any tool-specific entry points. The former evidence README is unavailable. Surviving [evidence ownership guidance](../rules/0090-test-ownership.rule.md#evidence-ownership) and artifact formats remain applicable within their stated scope, without asserting a replacement contract.

The intended runtime model remains `.exphere/runtimes/<id>/`, with shared Terraform configuration and units containing native execution configuration. For example, `units/website/` references `apps/website`; it does not copy the application. Kubernetes owns container resources, images, probes, replicas, volumes, and scheduling. Terraform owns the pilot's namespace and quota preparation. The descriptor connects those authorities rather than duplicating their editable values.

Generated directories are created only for selected capabilities. Installing a package does not itself authorize paid execution or infrastructure mutation. Secrets, raw sensitive prompts, kubeconfig, and Terraform state must not become ordinary publishable artifacts. Retention, redaction, access, and ignored generated outputs belong in the implementing specification.

## F-01 — Automatic delivery and cost report

**Outcome:** every attempted delivery produces an understandable receipt without someone manually collecting costs, failures, and verification results.

**Problem.** Spend dashboards disconnected from work cannot explain which feature benefited from a call, why attempts repeated, or whether the result was accepted. Handwritten summaries can conceal incomplete execution or missing usage.

**Smallest useful behavior**

1. Collect normalized action and usage events from one controlled provider integration and the workflow executor.
2. Attribute each event to its team account, runtime, feature, cycle, ticket, and step when those identities are available. Surface unassigned events.
3. Aggregate budget, estimated cost, metered cost, outstanding reservations, and remaining allowance separately.
4. Produce a readable report and structured record containing completed work, failed or skipped checks, retries, unresolved charges, and cleanup status.
5. Optionally generate a concise explanation from those records. The explanation cannot change totals, fabricate reasons, or turn missing evidence into a passing result.

**Minimum report content:** source artifact revisions; code/configuration revision; environment; executed image identity when applicable; model/provider; price snapshot; billable usage; attempt reasons; action timings; verification results; approval references; cost coverage; outcome; and outstanding obligations. Store references or sanitized summaries rather than automatically retaining full prompts or logs.

**Acceptance criteria**

- Rebuilding the report from the same records produces the same financial totals and evidence links.
- Duplicate delivery of the same usage event does not double-count cost.
- A failed or paused cycle receives a report with its partial cost and incomplete outcome.
- Missing usage remains unknown or pending reconciliation, with associated reservations visible.
- A report distinguishes configured resources, measured resource usage, metered monetary cost, and invoice-reconciled cost.
- No accepted-delivery claim appears without the required acceptance evidence; generating the report does not approve the work.
- An optional LLM explanation is charged to the same budget coverage and can be omitted in favor of deterministic rendering when funds are unavailable.

**Demonstration:** inspect a feature receipt showing which step consumed most of the budget, the evidence for its retries, and which delivery criteria passed.

**Dependencies and boundaries:** event collection, stable attribution from F-05, and F-03 when budget reservations are displayed. A structured local receipt is sufficient; a SaaS dashboard, billing connector, or natural-language summary is not required.

**Useful measures:** attribution coverage, report completeness, unresolved-cost count, and cost per accepted delivery once acceptance data exists. This feature is not a complete DORA or SPACE implementation.

## F-02 — Resource preflight

**Outcome:** developers receive actionable feedback about invalid or policy-incompatible runtime configuration before the affected infrastructure operation.

**Problem.** Syntax-valid manifests can still lack ownership, exceed a consumer's resource envelope, reference the wrong target, or omit required readiness configuration. Discovering these issues after mutation creates avoidable work.

**Smallest useful behavior**

1. Reuse descriptor and reference validation; do not create a second source of truth for native settings.
2. Inspect one supported workload shape and its namespace/quota configuration for ownership, explicit target, CPU, memory, replicas, storage settings where relevant, and readiness criteria.
3. Compare supported effective resource requests against the declared policy, including the selected replica count and known rollout assumptions.
4. Report the exact unit, native file, check, observed value, and required correction. Unsupported workload kinds or calculations remain explicitly unverified.
5. Separate static preflight from live cluster quota enforcement and from measured resource use.

**Acceptance criteria**

- An invalid reference or required missing field prevents the affected operation before mutation.
- A supported configuration that conflicts with the selected resource policy identifies the conflict without silently rewriting consumer values.
- Resource quantities retain their native units; CPU, memory, and storage are not conflated.
- Unknown existing namespace usage, admission defaults, sidecars, or unsupported workload behavior prevent a claim of guaranteed schedulability.
- Live quota rejection is still surfaced during execution; a preflight pass does not override Kubernetes admission decisions.
- Reports do not turn resource quotas into a monetary budget or claim savings from smaller declarations alone.

**Demonstration:** show a valid descriptor whose workload requests exceed the chosen resource envelope, with a precise diagnostic before apply.

**Dependencies and boundaries:** existing native configuration and an explicit consumer policy. Full admission simulation, automatic rightsizing, load testing, and production capacity certification are deferred.

**Useful measures:** invalid configurations detected before mutation, actionable diagnostic coverage, and observed runtime failures missed by preflight. Initial thresholds come from consumer policy, not invented universal defaults.

## F-03 — Shared team budget guardrail

**Outcome:** covered billable actions cannot start unless their bounded cost fits the team's shared authorized budget and execution policy. Every cycle uses that same balance.

**Problem.** Observing costs after execution does not prevent a retry loop or concurrent agents from consuming the same apparent remaining balance.

**Smallest useful behavior**

1. Route covered provider requests through one controlled dispatcher with a persistent ledger. Start with serialized execution if that makes the accounting boundary smaller and reliable.
2. Before dispatch, derive a conservative reservation from the actual request, the price snapshot, enforced output limits, and all supported billable categories.
3. Atomically verify and reserve funds against the team account and funding period, retaining feature/cycle attribution. Estimates allocated to tickets are not funding authorization.
4. Reconcile the reservation with returned usage, retaining an explicit pending balance when the charge is uncertain.
5. Deny uncovered calls with an actionable reason and pause or replan according to policy. A report-only or simulated mode must be labeled accordingly.

For ordinary work, the admission invariant is:

```text
settled ledger charges
+ outstanding reservations
+ proposed request reservation
+ protected verification/closure balance not already reserved
<= authorized team spending cap for the funding period
```

The same shared team account governs all covered runtimes and developers. Protected work draws from its designated reserve without counting that allocation twice. Reservations represent potential liabilities; conversion to a settled charge replaces the corresponding reservation. The agent can revise feature allocations within policy, but only an authorized budget owner can change the team ceiling.

**Acceptance criteria**

- An unaffordable request is rejected before provider dispatch.
- Two competing requests cannot both reserve the same balance; unsupported concurrent writers are rejected rather than silently allowed.
- Retries, child agents, planning, and resume retain their parent budget attribution.
- A timeout or missing usage response does not automatically refund a potentially charged request.
- Model effort is not treated as a monetary cap; request limits and pricing coverage determine the reservation.
- Unsupported pricing categories or an unbounded maximum charge prevent a hard-cap claim for that action.
- Unexpected reconciliation above a reservation is recorded truthfully, triggers the defined response, and is never hidden by truncating the ledger.
- Restarting the executor preserves reservations and costs; starting a new cycle or runtime cannot reset the team's consumed allowance.
- Catalog ownership resolves through a trusted team-account mapping; ambiguous ownership cannot silently charge another team.

**Demonstration:** reject a new call that would consume protected verification funds, while showing spent, reserved, protected, and available amounts.

**Dependencies and boundaries:** provider adapter, durable ledger, validated price snapshot, and authenticated execution policy for the intended trust boundary. A local demonstration covers cooperative use through Exphere; it is not tamper-resistant organization-wide enforcement. Cloud bills, independent IDE assistants, and MCP tools with unmetered external charges are not silently covered.

**Useful measures:** calls rejected before dispatch, unresolved liabilities, uncovered actions, reconciliation variance, and violations of the accounting invariant.

## F-04 — Unproductive-attempt detector

**Outcome:** the workflow stops repeated failure or switches to an authorized alternative before a bounded retry loop wastes the remaining budget.

**Smallest useful behavior**

- Record attempts, input/configuration revisions, tool or check results, and a normalized failure signature.
- Apply consumer-defined limits to repeated identical failures, unchanged failed checks, and total attempts per step.
- Pause or invoke a predefined fallback after a threshold, recording what triggered the decision.
- Reserve LLM judgment for ambiguous cases when needed; simple repetition counting does not require another paid agent.

**Acceptance criteria**

- Repeating the same failure under equivalent inputs reaches the configured limit and stops further identical attempts.
- A material input change can justify another attempt under policy, while preserving the total budget and history.
- A transient error can use its permitted retry policy without being automatically described as lack of progress.
- The recorded result identifies the repeated signal and the chosen response.
- Skipping a required check or reducing acceptance criteria does not count as progress.
- No report claims exact avoided financial loss from attempts that never happened.

**Demonstration:** a deliberately failing check produces bounded retries and a clear pause instead of an endless loop.

**Dependencies and boundaries:** attempt events and workflow stop/fallback controls. Universal semantic proof of progress and arbitrary autonomous remediation are outside the initial implementation.

**Useful measures:** repeated attempts per failure signature, stop reasons, recovery after a permitted alternative, and incorrectly interrupted productive work.

## F-05 — Intent-to-execution traceability

**Outcome:** an operator can move from a requirement to its execution and cost, or from a failed action back to the intent that justified it.

**Smallest useful behavior**

- Capture immutable references or content hashes for the relevant PRD, SPEC, tickets, runtime configuration, policy, and code revision.
- Link approvals to the reviewed revision and authorized scope using the available trustworthy approval mechanism.
- Propagate feature, cycle, ticket, step, and attempt identities into records and supported tool integrations.
- Record relationships once and reuse them in reports, without cloning application source into runtime units.

**Acceptance criteria**

- A cycle identifies the exact intent and configuration revisions it used, including uncommitted snapshots when relevant.
- Editing the PRD later does not rewrite the history of a completed cycle.
- Broken or ambiguous required references produce a visible diagnostic.
- An approval for one revision is not silently reused for material changes outside its scope.
- One attempt can link to several artifacts while retaining one cost identity.
- A traceable chain does not automatically prove semantic conformance; acceptance checks and approvals remain separate evidence.

**Demonstration:** select a failed call in a receipt and follow its references to the originating ticket, acceptance criterion, configuration, and approved intent.

**Dependencies and boundaries:** stable identifiers and a snapshot mechanism. Git history can support traceability but does not itself authenticate every approval. Remote issue creation, portal integration, and semantic drift scoring are deferred.

**Useful measures:** execution attribution coverage, unresolved artifact links, stale approval references, and actions without a declared purpose.

## F-06 — Execution planner with cost estimates

**Outcome:** the developer approves intended work and receives a proposed execution plan that fits the available policy and budget without manually pricing each ticket.

**Inputs:** approved intent; required checks; runtime capabilities; allowed models and effort settings; price snapshot; available team balance; Backstage ownership/component context; retrieved artifact revisions; and comparable execution history when available.

**Smallest useful behavior**

1. Identify work units and mandatory verification from linked intent artifacts.
2. Recommend a model and supported effort level for each step, explaining its needs, uncertainty, and relevant source artifacts.
3. Estimate request volume and token or billable-unit ranges. A deterministic calculator converts assumptions into monetary ranges.
4. Propose allocations, retry limits, protected verification funds, and permitted fallbacks within the policy.
5. Validate the structured proposal before dispatch. If no affordable valid plan exists, return a bounded alternative or an explicit pause.

**Plan content:** team account; feature/ticket/step; purpose; source versions; model/effort; usage assumptions; estimate range; adjustable feature allocation; retry policy; mandatory checks; fallback options; uncertainty; and reason for the selection. These are conceptual fields, not additions to the current runtime descriptor. The team ceiling and pre-dispatch reservation are the spending controls.

**Acceptance criteria**

- Invalid or out-of-policy model/effort choices are rejected independently of the planner's prose.
- Allocations fit the available team allowance, including the planning cost and required reserves, without assigning equal budgets to individual developers.
- Unknown history or uncertain task complexity is disclosed rather than replaced with invented precision.
- The actual request is checked again before dispatch; a planning estimate is not spend authorization.
- The planner cannot remove required security or quality checks to make a proposal fit.
- Product-scope changes become proposals for the appropriate approval boundary; they are not silently executed.
- Untrusted instructions in artifacts or tool results cannot increase funding, permissions, or accepted model choices.

**Demonstration:** approve a bounded SPEC and inspect an automatically produced plan with different model choices, transparent rationales, and a verified allocation total.

**Dependencies and boundaries:** F-03, F-05, a small provider catalog, and a deterministic proposal validator. Start with one planning agent; a multi-agent cost council, learned optimizer, and calibrated forecasting model are not required.

**Useful measures:** estimate error on completed comparable steps, invalid-plan rate, planning overhead, and accepted outcomes within allowance. Evaluate cheap plans by their accepted outcomes, not price alone.

## F-07 — Complete local microruntime journey

**Outcome:** a developer prepares, executes, inspects, and ends an environment around an existing application through one reproducible local journey.

**Smallest useful behavior**

1. Use manual or guided v2 configuration and validate all selected units and prerequisites.
2. Confirm the explicit local context, namespace, image availability, tool versions, ownership, and operation authorization.
3. Prepare the namespace and quotas through the runtime's Terraform root/state.
4. Apply every selected unit's native Kubernetes manifests and evaluate declared readiness.
5. Collect events, logs, configured resources, observed image identities, and execution outcomes.
6. Explicitly end owned workloads and preparation resources in dependency order, reporting retained resources and failed cleanup.

The reference pilot is a prebuilt `apps/website` image on local Kubernetes, with kind as the reference environment. The source stays in the application. Infrastructure preparation, workload execution, and lifecycle evidence are separate from merely generating configuration.

**Acceptance criteria**

- Invalid inputs prevent the affected mutation, and the selected context is never inferred from an unrelated current shell default.
- Preparation failure prevents later workload stages and exposes partial resources.
- All selected units have explicit readiness outcomes; a command returning successfully is not sufficient proof of readiness.
- The image identity and relevant environment/configuration versions are recorded.
- Cleanup targets only resources within the demonstrated ownership boundary; shared clusters, unrelated namespaces, and consumer source remain intact.
- Remaining resources and retention decisions are visible even when the main execution fails.
- Repetition under the same declared conditions produces comparable evidence; local success does not certify production capacity or availability.

**Demonstration:** run the prebuilt application, inspect it, trigger a controlled quota failure in a separate authorized scenario, and account for resources after shutdown.

**Dependencies and boundaries:** [PRD-0002](../../.exphere/artifacts/prd/0002-PRD-local-microruntimes.prd.md), its configuration contract, and the separately scoped lifecycle specification. Cloud provisioning, image building, load tests, production access, and portal replacement remain outside this pilot.

**Useful measures:** journey completion, time to readiness under stated conditions, cleanup completeness, and reproducibility. Consumer hooks remain declared `.sh` scripts with explicit effects and permissions.

## F-08 — Runtime-installed SDD harness

**Outcome:** an existing project gains a usable, versioned path from intent to evidence through selected skills and executable workflow checkpoints.

**Smallest useful behavior**

- Generate only the selected consumer harness capabilities under the proposed `.exphere/` layout, with an inventory of generated paths and versions.
- Start with one Dev-oriented SDD workflow; domain adaptations remain later work under the same lifecycle.
- Package selected Pocock skills and other approved skills with source, version, required attribution, and their role in the workflow.
- Supply guides before actions and sensors after actions. Distinguish deterministic checks from inferential reviews.
- Require declared evidence before advancing mandatory checkpoints. Skills describe how to work; executable transitions enforce the contract.
- Expose unresolved product decisions and consequential approvals to people while routine steps proceed under existing authorization.

**Acceptance criteria**

- Generation preserves existing consumer files or reports conflicts; it does not silently overwrite a custom harness.
- The installation manifest identifies which files and skill versions belong to the generated capability.
- A mandatory missing or failed check prevents the corresponding transition, with a clear result.
- Selecting a different tool does not remove required evidence or redefine the approved lifecycle implicitly.
- Merely installing Markdown does not claim workflow enforcement or successful discovery by every coding assistant.
- A tool-specific entry point, if needed outside `.exphere/`, references the canonical guidance and is explicit to the consumer.
- Updates and removal preserve consumer source and locally owned modifications; exact update behavior is specified before implementation.

**Demonstration:** install a narrow SDD harness into an existing project, inspect its versioned skills and checkpoints, and show an execution stopping on missing required evidence.

**Dependencies and boundaries:** workflow execution, F-05, evidence contracts, and selected skills. A web console, skill marketplace, universal workflow designer, or mandatory organizational rollout is not required. LangGraph is the proposed orchestration direction for this refinement; no dependency, executable graph, or integration is installed by this register.

**Useful measures:** adoption/setup effort, generated-file conflicts, checkpoint evidence completeness, and routine human interventions per accepted delivery.

## F-09 — Team budget allocation and sprint reporting

**Outcome:** the platform automatically allocates the team's available funds across features and reports consumption by cycle and optional sprint, without requiring people to price each ticket or developer.

**Smallest useful behavior**

- Resolve the authorized team account, funding window, total allowance, currency, owner, validity period, and automatic allocation rules established for F-03.
- Aggregate the same underlying attempt records by feature and cycle; do not create a second set of charges.
- Let the planner propose and adjust feature allocations using retrieved evidence, priorities, complexity, outcomes, and the available team balance. Feature allocations create no independent budget authority.
- Display spent, reserved, protected, unallocated, and remaining amounts, with clear definitions that prevent double counting.
- Optionally expose execution credits using a recorded conversion. Keep credits independent of story points and model-specific token prices.

**Acceptance criteria**

- Summing attributed feature charges plus explicitly unallocated charges reconciles with the window's total.
- Allocating money to a feature does not itself count as spending it.
- Reservations and allocations cannot allow competing cycles to overcommit the same authorized balance.
- Reopening a ticket, changing runtimes, or creating a new cycle does not erase cumulative consumption.
- Moving work to another funding window follows an explicit transfer policy and preserves original liabilities and history.
- An agent can redistribute permitted free allowance but cannot mint credits, increase the total grant, or change its conversion rate.
- Work crossing the window end follows a declared rule; expiration does not erase pending charges.

**Demonstration:** show multiple feature allocations, an automatic within-policy adjustment, and a refused allocation that would exceed the remaining grant.

**Dependencies and boundaries:** F-03, F-05, and F-06 for agent allocation. The first financial pilot already uses one team account, even with only one cycle; F-09 adds richer allocation and reporting, not the first shared funding boundary. Multi-team chargeback, ERP integration, and workforce productivity scoring are deferred.

**Useful measures:** budget utilization, forecast-versus-consumption variance, unallocated cost, and accepted delivery outcomes. A large unspent balance is not automatically a success or savings.

## F-10 — Evidence-based runtime diagnosis

**Outcome:** developers get a grounded explanation of a runtime failure without manually assembling scattered operational evidence.

**Smallest useful behavior**

1. Collect supported readiness, events, sanitized logs, and configuration from the explicit runtime target.
2. Resolve runtime/unit/resource identity before sending context to the model.
3. Use deterministic signals for known failures where possible, then ask one bounded agent to distinguish observations, hypotheses, and suggested next steps.
4. Link each conclusion to the evidence supporting it and expose missing information.
5. Keep the initial integration read-only; route any later remediation through a separate authorized execution boundary.

**Acceptance criteria**

- A quota rejection diagnosis points to the actual event and relevant resource policy.
- Missing logs or inaccessible resources produce an incomplete diagnosis, not an invented root cause.
- Tool access is scoped by credentials and permissions, not merely by an instruction to stay within a namespace.
- Raw secrets and unrelated sensitive log content are not automatically included in prompts or reports.
- Paid diagnosis respects the same covered budget and attempt policy as implementation.
- Suggested commands are distinguished from performed actions; no destructive action follows from explanatory text alone.

**Demonstration:** explain a controlled readiness failure with a cited event, the affected unit, and a next-step recommendation.

**Dependencies and boundaries:** F-07 inspection, F-05 attribution, and F-03. Native adapters or an appropriately scoped MCP connection may provide evidence. An MCP connection does not itself implement least privilege, attribution, or cost control. Many simultaneous integrations and autonomous production remediation are deferred.

**Useful measures:** evidence-backed findings, unresolved diagnoses, operator usefulness feedback, diagnosis cost, and incorrect confident claims evaluated against known scenarios.

## F-11 — Minimal context per ticket

**Outcome:** each agent receives the information relevant to its current task, with traceable selection and a bounded context allowance.

**Smallest useful behavior**

- Follow explicit links from ticket to SPEC, PRD, runtime, applicable rules, and required evidence.
- Enrich selected context with authorized Backstage team/component relationships and relevant execution episodes; retrieve artifact bodies from their actual source.
- Select relevant sections and record versions, omitted sources, and selection reasons.
- Always preserve mandatory policies and acceptance criteria, or stop when they cannot fit the supported context budget.
- Validate the final request size and charge reservation after context assembly.
- Start with file references and deterministic selection; evaluate retrieval infrastructure only if observed corpus size and access patterns require it.

**Acceptance criteria**

- The context manifest identifies the sources and revisions actually sent to the model.
- Changes to a source invalidate stale selections where relevant.
- Truncation or summarization cannot silently discard mandatory constraints or turn untrusted source text into policy authority.
- Omitted or unavailable evidence is reported rather than filled in by the model.
- Claimed token reductions compare measured payloads under stated conditions; reduced context alone does not prove equivalent quality.
- Context assembly respects access restrictions and does not read every repository or document by default.

**Demonstration:** inspect a ticket's context manifest, understand why each source was included, and compare its measured request size with a clearly defined broader-context baseline.

**Dependencies and boundaries:** F-05 and integration with request assembly. A vector database, embeddings pipeline, cross-repository index, and heavy RAG service are not required for the first pilot.

**Useful measures:** request context size, source selection coverage, stale-context incidents, omitted-required-context failures, and accepted outcomes.

## F-12 — Bounded replanning and resume

**Outcome:** the workflow can recover from a failed or unaffordable strategy while preserving work, evidence, permissions, and budget history.

**Smallest useful behavior**

- Persist successful steps, pending actions, unresolved charges, failed checks, and configuration/intent revisions.
- Choose only policy-approved alternatives, such as another allowed model, revised task decomposition, or narrower context.
- Revalidate projected spending and mandatory checks before continuing.
- Resume the same cycle when continuing the same authorized scope. Material changes require an explicit new or amended authorization with preserved parent liabilities.
- Pause with a concrete unresolved decision when no valid affordable alternative exists.

**Acceptance criteria**

- Resume does not repeat an already completed external mutation simply because a process restarted.
- Actions with uncertain external completion are reconciled or escalated before replay; idempotency is verified for each supported side effect.
- The original cycle's costs, reservations, attempts, and protected balance survive process interruption.
- Model or strategy changes cannot weaken required quality/security criteria or silently change product scope.
- Budget exhaustion pauses the cycle; it does not delete the reusable runtime or falsely mark the feature delivered.
- Cancellation is an explicit terminal decision, with resource cleanup or retention handled according to the authorized lifecycle policy.
- Pausing agent calls does not imply that infrastructure has stopped accruing cost. Cleanup and TTL behavior require an active executor and explicit resource ownership.

**Demonstration:** interrupt a bounded workflow after a completed step, resume without duplicating that step, and show a permitted strategy change with preserved spend history.

**Dependencies and boundaries:** F-03, F-04, F-05, F-06, and durable orchestration. LangGraph is a candidate for persistence and orchestration, not a substitute for financial invariants, operation idempotency, or permissions. Distributed recovery and general exactly-once execution are not initial claims.

**Useful measures:** successful resumes, duplicate side effects, unresolved operations, additional recovery cost, and acceptance preservation after replanning.

## F-13 — Comparable-delivery efficiency analysis

**Outcome:** teams can evaluate whether a changed model, workflow, or runtime strategy improves cost efficiency while preserving the required delivery outcome.

**Smallest useful behavior**

- Select an explicit baseline and candidate set with compatible scope, acceptance criteria, environment, coverage, volume, and time window.
- Include planning, retries, failures, review, and rework within the declared cohort and cost scope.
- Separate provider price changes from usage changes when the data supports that distinction.
- Report observed differences and their limitations; do not infer causal savings from unrelated runs.
- Refuse a savings statement when the baseline, coverage, or outcome equivalence is inadequate.

**Acceptance criteria**

- Remaining budget is labeled remaining budget, not savings.
- A hypothetical cheaper plan is labeled estimated improvement against a named alternative.
- A completed comparison reports its inputs, baseline, included costs, volume, and acceptance outcomes.
- Fewer checks or incomplete delivery cannot be presented as equivalent efficiency improvement.
- Cost per accepted delivery uses the total covered cost of the defined cohort, including unsuccessful attempts, divided by accepted deliveries in that cohort.
- If there are no accepted deliveries, the unit metric is unavailable rather than zero.
- Local usage estimates do not become cloud invoice savings without the corresponding charge evidence and comparison method.

**Demonstration:** compare two clearly bounded strategies that met the same criteria, or explain explicitly why the available evidence cannot yet support a savings claim.

**Dependencies and boundaries:** F-01, reliable attribution, acceptance records, and history. A dashboard can be simple; obtaining a valid comparison is the substantive work. Revenue attribution, universal model rankings, and performance ratings for individual developers are outside scope.

**Useful measures:** cost per accepted delivery, retry/rework share, comparison coverage, and outcome-quality differences. These supplement later DevEx measurement rather than replacing DORA, SPACE, or team feedback.

## Recommended implementation dependency order

The priority table expresses value/effort. The following sequence describes a possible technical progression, subject to separate scope approval:

1. Establish a narrow F-05 identity/event contract and the smallest F-07 local execution path, building on existing configuration.
2. Add F-02 resource preflight and ownership-aware inspection so infrastructure behavior is demonstrable.
3. Introduce one controlled provider adapter, metering, and the F-03 shared team ledger/dispatcher. Generate F-01 reports from those records.
4. Add F-04 bounded retry detection and F-06 planning with deterministic proposal validation.
5. Package the supported path through F-08, using F-11 context selection as needed.
6. Extend to F-09 team allocation/sprint reporting and F-10 diagnosis after their evidence sources exist; team funding is already required by F-03.
7. Add F-12 durable recovery after action replay and reservation reconciliation are designed.
8. Evaluate F-13 only when sufficient comparable accepted-outcome evidence exists.

The first integrated demonstration should emphasize F-01, F-02, F-03, and F-06 over a single F-07 journey. F-05 provides traceability underneath. If time is constrained, reduce the number of actions and integrations rather than presenting simulated enforcement as real behavior.

## Demonstration contract

An intended demonstration narrative is:

1. A person supplies and approves a bounded SPEC with clear acceptance criteria under an existing execution policy.
2. Exphere generates a costed execution proposal and validates its allocations.
3. Resource preflight checks the selected microruntime configuration before mutation.
4. Authorized local execution prepares and runs the prebuilt application.
5. Controlled agent steps consume a measured allowance; an intentionally unaffordable additional call is refused before dispatch.
6. Required verification produces evidence, and the report identifies delivery status, costs, limitations, and remaining obligations.
7. Explicit cleanup accounts for owned resources and any retained state.

A valid demonstration distinguishes live results, fixtures, projections, and unsupported paths. A fixture can demonstrate a control contract but does not establish live billing, provider behavior, production safety, or economic benefit. This register defines future acceptance scenarios; it does not create or authorize new test suites or execute the demonstration.

## Deferred capabilities and open decisions

| Topic | Current proposal / decision still needed |
| --- | --- |
| SaaS console | Future configuration/reporting surface; not required for the first local workflow |
| Provider coverage | Choose one provider and supported billable categories before claiming enforcement |
| Budget persistence | Select a shared team-account store and serialization/transaction model that survives failures and prevents double reservation across runtimes |
| Organizational trust boundary | Define authenticated grants, policy distribution, tamper resistance, and concurrent operators before organization-wide claims |
| Model and effort routing | Begin with a small allowed catalog; supported effort parameters and fallback behavior are provider-specific |
| Infrastructure financial data | Select a source, attribution method, delay model, and coverage before reporting actual cloud cost |
| Infrastructure estimates | Native resource requests and quotas are inputs, not a price; monetary estimates require usage, duration, rate, and allocation assumptions |
| Existing portal integration | Backstage is the highlighted context adapter in this proposal; preserve independently owned portals and require configured, authorized access |
| MCP and agent orchestration | Read-only Backstage MCP/API and LangGraph orchestration are proposed; transport, deployment, credentials, and executable integration remain unimplemented |
| Retrieval and memory | Vector search, relationship traversal, and episodic memory are logical capabilities; select stores and ingestion, freshness, access, and retention policies before implementation |
| Skills | Select exact sources/versions, required attribution, review method, update policy, and tool-discovery adapters |
| Consumer harness layout | Reconcile proposed `.exphere/workflow/` with current repository `.exphere/workflow/` and evidence/artifact conventions in a separate specification |
| Evidence retention | Define redaction, access, storage, deletion, and publication boundaries before persisting sensitive provider or runtime data |
| Cross-sprint continuation | Define which account funds work after a window closes, preserving pending charges and prior allocations |
| Human approval points | Name the authority for product scope, final acceptance, risky mutations, and funding exceptions; routine actions reuse the existing grant |

## References and local policy alignment

These proposals use the following references. External documentation supports specific mechanisms and concepts; it does not certify this product or prove implementation.

- [FinOps Foundation — Budgeting](https://www.finops.org/framework/capabilities/budgeting/): funding ownership, estimates versus budgets, reserves, and responses to spending thresholds. Consulted October 11, 2026.
- [Kubernetes — Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/): native resource admission and namespace quotas. Consulted October 11, 2026.
- [Birgitta Boeckeler — Harness engineering for coding agent users](https://martinfowler.com/articles/harness-engineering.html): guides, sensors, computational versus inferential controls, and directing human attention toward important decisions. Consulted October 11, 2026.
- [Backstage — Software Catalog](https://backstage.io/docs/features/software-catalog/): ownership and software metadata as context. Consulted October 13, 2026.
- [Backstage — MCP Actions Backend](https://backstage.io/docs/ai/mcp-actions/): separately installed/configured actions exposed through MCP; access must be authorized and constrained. Consulted October 13, 2026.
- [LangGraph — Overview](https://docs.langchain.com/oss/javascript/langgraph/overview): orchestration of stateful agent steps; Exphere's funding and allocation rules are separate application responsibilities. Consulted October 13, 2026.
- [Local FinOps guardrails](../../.exphere/harness/guardrails/0001-finops.gr.md): ownership, estimates, authorized envelopes, resource sizing, cleanup, cost observation, valid comparisons, and preserved quality.
- [Local Twelve-Factor guardrails](../../.exphere/harness/guardrails/0003-twelve-factor.gr.md): source identity, configuration, dependencies, build/run separation, lifecycle, logs, and administrative effects.
- [Local evidence ownership guidance](../rules/0090-test-ownership.rule.md#evidence-ownership): execution context, methods, outcomes, and handling of retained output; the former general evidence contract is unavailable.
- [Current SDD workflow](../../.exphere/workflow/README.md): shared lifecycle and documentary domain adaptations.

For this documentation-only change, additional infrastructure or provider consumption is **not applicable**. Proposed future paid actions must assess FIN-01 through FIN-08 as relevant. Lifecycle implementation must assess the applicable Twelve-Factor criteria. None of the feature descriptions establishes compliance or authorizes a paid action by itself.
