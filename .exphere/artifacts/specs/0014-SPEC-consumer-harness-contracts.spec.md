# Consumer harness — configuration, planning and record contracts

- ID: `SPEC-CONSUMER-HARNESS-CONTRACTS`
- Version: `1`
- State: `approved`
- Approval scope: delegated acceptance of specification and ticket content; implementation and operational acceptance remain separate.
- PRD: `PRD-0001` is the broad product source; no approved PRD revision for the new AI/FinOps scope is asserted. `PRD-0002 v1` retains its original local-pilot exclusions.
- Technical owners: Exphere project owner and platform maintainer; consumer-specific operators and budgets are not assigned by this document.
- Baseline: `jonatassales/exphere`, `main`, `d315a4249323f62c61c1c6d47e4878ba93269c53`.
- Date: October 12, 2026.

- Parent: [SPEC-CONSUMER-HARNESS-LAYOUT v1](0013-SPEC-consumer-harness-layout.spec.md); approval follows its DEC-CHL-001.

## Contract and composition

### Outcome

A maintainer can interpret one consumer harness configuration and its attributable records without guessing which file owns a value, where a reference resolves, or whether a result is merely proposed. This specifies the target of LAYOUT-02; no schema or runtime implementation is delivered by the planning PR.

Requirements addressed: REQ-CHL-002, REQ-CHL-003 and REQ-CHL-006 in the parent. The future implementation surface is the existing CLI package's schema area, source-only fixtures and one isolated verification entry point. Preserve the current formal runtime-v2 schema and descriptor contract.

### File responsibilities

| File/capability | Writer and authority | Required information |
| --- | --- | --- |
| `config.json` | Consumer-owned authored configuration | Layout version, repository identity, selected workflow/agents, capabilities, retrieval configuration, model catalog, policy and store references. |
| `lock.json` | Future explicit installer; reference inventory in fixtures | Distribution/asset versions, origins, integrity inventory, ownership and consumer-modification detection. No billing state or fabricated installation. |
| Runtime descriptor | Consumer | Existing v2 identity, owner, target, component/native configuration and optional hook references only. |
| Native configuration | Consumer | Terraform namespace/quota authority and Kubernetes workload values; no second editable copy in harness config. |
| Workflow definition | Selected versioned asset | Common SDD stages, transitions, evidence, checkpoints, capability references, blocking and resume conditions, explicit executable status. |
| Agent bindings | Consumer-selected configuration | Planner role, bootstrap model profile, retrieval/tool access, output contract and decision scope; not engine source code. |
| Guides and skills | Selected attributed assets | Instructions, context and required supporting files. |
| Sensor bindings | Selected configuration | Check identity, feedforward/feedback direction, computational/inferential type, handler, required evidence and unavailable/failure behavior. |
| Cycle context | Execution-owned snapshot | Runtime/feature/ticket links, code/config/policy revisions, retrieved source identities/hashes, selected assets and graph-state reference. |
| Execution plan | Planner proposal | Task/model/effort selections, alternatives and rationale, estimates and uncertainty, price snapshot, duration/resources and required checks. |
| Accounting records | Controlled accounting writer | Shared financial identities, reservations, liabilities, reconciliation, attribution or authoritative store references. |
| Events/evidence/report | Execution observations and derivation | Performed actions and evidence; report totals derive from accounting, not a second ledger. |

### Contract requirements

| ID | Observable contract outcome |
| --- | --- |
| REQ-CHC-001 | Every new format declares its own version, producer, consumer, mandatory fields and unsupported-version result, separate from runtime v2. |
| REQ-CHC-002 | Resolve new project references against one documented consumer-project base; preserve project-relative components and runtime-relative native/hook references. Canonical containment rejects traversal, escaping symlinks, collisions, duplicate identities and unresolved mandatory references. |
| REQ-CHC-003 | Selected dependency closure is complete: include/rewrite every required skill, template, guide and sensor binding, or declare a resolvable prerequisite. No maintainer-checkout fallback. |
| REQ-CHC-004 | Bindings declare executable availability. A missing required handler prevents operational readiness; fixtures may describe that unavailability without pretending it is resolved. |
| REQ-CHC-005 | RAG configuration identifies authorized corpora, repository/runtime scope, retrieval limits, exclusions, revision freshness and provenance. Synthetic context is not evidence of live retrieval. |
| REQ-CHC-006 | A small catalog contains at least two meaningful candidate execution profiles, explicit supported effort capabilities and adapter mapping requirements. Unknown prices/capabilities never come from model memory. |
| REQ-CHC-007 | A bounded bootstrap planning profile and allowance exist before hypothetical paid retrieval, embedding or inference. Include applicable planning/review/diagnosis/retry/explanation costs. |
| REQ-CHC-008 | Separate AI, infrastructure and combined limits by currency, scope, window, owner, price revision, coverage and failure behavior. Define exact monetary representation and rounding before numerical examples become normative. |
| REQ-CHC-009 | Admission accounts for settled cost, outstanding reservations/liabilities, proposed bounded reservation and protected verification/closure allowance not already reserved, at every applicable parent scope. Protected work does not double-count its allocation. |
| REQ-CHC-010 | Reserve before dispatch; replace a reservation when settling rather than adding both as spend. Timeout/unknown usage retains liability. Duplicate financial identities do not double-count. Unexpected actual overage is recorded, not truncated. |
| REQ-CHC-011 | Infrastructure assumptions include horizon, resource rates/coverage, maximum lifetime, inspection cadence, shutdown authority, residual storage/network cost and cleanup obligations. Unsupported or unbounded charges cannot receive a hard-cap claim. |
| REQ-CHC-012 | Keep workflow stage, ticket state, runtime lifecycle and financial settlement separate. Graph resume, fork or recreation never resets parent consumption or pending liabilities. |
| REQ-CHC-013 | Reference the graph thread/checkpointer and shared accounting store without treating JSONL as either a transactional ledger or a LangGraph checkpoint implementation. |
| REQ-CHC-014 | Declare ownership and timing for authored documents versus machine records before admitting generated cycle/accounting data to the consumer artifact contract. The current repository tracker remains unchanged in this PR. |

### Computational and inferential boundaries

The theoretical source retained from the supplied plan is Birgitta Böckeler's [Harness engineering for coding agent users](https://martinfowler.com/articles/harness-engineering.html#ComputationalVsInferential). Apply its independent feedforward/feedback and computational/inferential axes as the plan specifies; the Exphere financial protocol is a product extension, not a protocol supplied by that article. Schema/path validation and financial arithmetic are computational. Context interpretation and model/effort proposals are inferential. A guide can include deterministic tooling and a sensor can include semantic review; directory names do not choose an execution type.

MCP supplies the configured context/tool boundary, not unrestricted authorization or the financial authority. Retrieved material and tool output remain data, not permission to alter policy. Host/server controls must enforce allowed operations independently of prompts when an executor is later implemented.

## Responsibilities

The planner proposes alternatives and expected cost for a valid delivery, not simply the lowest token price. Computational components own price arithmetic, financial admission and authoritative accounting. Consumers own resource settings and component composition. The funding owner supplies real budgets, supported coverage and permitted responses. None are synthesized as actual values in this specification.

## Operation and limits

Secrets are external references, never inline credentials, kubeconfig or retained raw prompts by default. Exclude real financial state, checkpoints and sensitive retrieval caches from ordinary commits and package output; labeled synthetic examples are a deliberate exception.

A local hardware allocation estimate is not a cloud invoice. Quotas are resource constraints, not currency ceilings. Pausing an agent does not prove resource termination. Estimates, reservations, metered cost and invoice-reconciled cost remain distinct; unused allowance is not demonstrated savings. Report data freshness, missing coverage and pending obligations explicitly.

The proposed package schemas include configuration, lock, workflow, agent, sensors, cycle context, execution plan and accounting event formats. Exact fields and validator implementation are delivered by the linked slices with paired valid/invalid examples, not invented as currently accepted APIs. A transactional store is a recommendation for the later executable pilot; the actual driver/checkpointer remains outside this contract phase.

## Verification and decisions

| Ticket | Requirements and bounded proof |
| --- | --- |
| [CHL-01](../tickets/0029-TICKET-consumer-harness-configuration.ticket.md) | REQ-CHC-001–002: inspect a valid minimal config/inventory and rejected versions/paths without mutation. |
| [CHL-02](../tickets/0030-TICKET-consumer-harness-workflow-closure.ticket.md) | REQ-CHC-003–004: resolve selected dependencies outside the checkout; identify missing handler/readiness separately from valid declarative shape. |
| [CHL-03](../tickets/0031-TICKET-consumer-harness-planning-profiles.ticket.md) | REQ-CHC-005–007: validate synthetic retrieval/model/effort/bootstrap cases with no paid call. |
| [CHL-04](../tickets/0032-TICKET-consumer-harness-cycle-accounting.ticket.md) | REQ-CHC-008–014: validate financial/context record examples and deterministic expected interpretation, including uncertainty and replay. |

Affected future criteria: FIN-01–08, particularly attribution, estimates/coverage, permitted spend, lifetime, metering and quality-preserving optimization. Current review assesses documentary completeness only. Future verification uses the highest useful isolated consumer-contract seam defined in [SPEC-CONSUMER-HARNESS-VERIFICATION v1](0016-SPEC-consumer-harness-verification.spec.md); no infrastructure, provider calls or consumer hooks are needed to establish fixture behavior.

Approval: DEC-CHL-001 accepts this v1 scope and ticket descriptions. Technical review of implemented schemas and semantic checks remains pending their implementation. Live RAG relevance, provider pricing coverage, concurrency safety and hardware enforcement remain explicitly unverified.
