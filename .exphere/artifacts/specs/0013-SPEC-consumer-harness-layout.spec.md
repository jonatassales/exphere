# Consumer harness layout — planning and pre-generation envelope

- ID: `SPEC-CONSUMER-HARNESS-LAYOUT`
- Version: `1`
- State: `approved`
- Approval scope: delegated acceptance of specification and ticket content; implementation and operational acceptance remain separate.
- PRD: `PRD-0001` is the broad product source; no approved PRD revision for the new AI/FinOps scope is asserted. `PRD-0002 v1` retains its original local-pilot exclusions.
- Technical owners: Exphere project owner and platform maintainer; consumer-specific operators and budgets are not assigned by this document.
- Baseline: `jonatassales/exphere`, `main`, `d315a4249323f62c61c1c6d47e4878ba93269c53`.
- Date: October 12, 2026.

## Contract and composition

### Purpose and source

Prepare one shared harness per consumer repository, reusable microruntimes that reference existing application components, and separate execution cycles linked to shared accounting. A future CLI generator must reproduce a reviewed manual reference rather than invent a directory contract while installing it.

Source: the owner-supplied **Exphere Consumer Harness Layout — Pre-Generation Implementation Plan**, supplied as `exphere-consumer-layout-plan(1).md`; SHA-256 `18a6f2ddedf6f3f7e78fc4cb1bd7a694493ee739254841923e7b25651f05fd86`. Sections below decompose that plan, including its six LAYOUT work packages. The source plan's historical lack of a publication grant is superseded only by the current request's explicit planning and PR authorization.

The current delivery creates four specifications and ten local tickets. It implements the documentation deliverable only. Formal schemas, reference fixtures, validators, generators, graph execution, retrieval, and financial enforcement are future ticket outputs, not files delivered by this PR.

### Specifications and source coverage

| Specification | Owned outcome | Source plan sections / work packages |
| --- | --- | --- |
| This envelope | Boundaries, acceptance, approvals, decomposition and publication | 1–3, 9, 11; LAYOUT-01 and planning disposition of LAYOUT-06 |
| [SPEC-CONSUMER-HARNESS-CONTRACTS v1](0014-SPEC-consumer-harness-contracts.spec.md) | Versioned configuration, planning and financial record contracts | 4–7; LAYOUT-02 |
| [SPEC-CONSUMER-HARNESS-REFERENCE v1](0015-SPEC-consumer-harness-reference.spec.md) | Portable manual consumer reference and synthetic records | 3–5, 8; LAYOUT-03 and LAYOUT-04 |
| [SPEC-CONSUMER-HARNESS-VERIFICATION v1](0016-SPEC-consumer-harness-verification.spec.md) | Isolated contract verification and reference freeze | 8–11; LAYOUT-05 and implementation acceptance of LAYOUT-06 |

### Preservation requirements

| ID | Required outcome |
| --- | --- |
| REQ-CHL-001 | Preserve the existing repository composition, removed documents, stable identities, historical review hashes and legacy runtime behavior. |
| REQ-CHL-002 | Define versions, writers, ownership, path bases, selected dependencies and materialization timing before CLI harness generation. |
| REQ-CHL-003 | Keep LangGraph, MCP and RAG in the intended P0 architecture, with bounded model/effort proposals and computational financial authority. |
| REQ-CHL-004 | Prepare one independently inspectable manual consumer reference, with synthetic histories separated from fresh installation content. |
| REQ-CHL-005 | Connect each bounded implementation slice to acceptance criteria and isolated verification without claiming live execution. |
| REQ-CHL-006 | Preserve dependency, approval, implementation, verification and settlement states as distinct concepts. |
| REQ-CHL-007 | Release the future generator handoff only after the versioned reference and selected dependencies satisfy the specified evidence gate. |
| REQ-CHL-008 | Publish this planning change on a feature branch with one governing spec and one documentation ticket, retaining incomplete review evidence visibly. |

### Work breakdown and blocking edges

| Ticket | Complete slice | Parent spec | Blocked by |
| --- | --- | --- | --- |
| [CHL-PLAN-01](../tickets/0028-TICKET-consumer-harness-planning.ticket.md) | This specification/ticket decomposition and documentation publication | Layout | None |
| [CHL-01](../tickets/0029-TICKET-consumer-harness-configuration.ticket.md) | Minimal consumer configuration and installation inventory, with fixtures and checks | Contracts | None |
| [CHL-02](../tickets/0030-TICKET-consumer-harness-workflow-closure.ticket.md) | Selected workflow and its complete installed dependency closure | Contracts | CHL-01 |
| [CHL-03](../tickets/0031-TICKET-consumer-harness-planning-profiles.ticket.md) | Retrieval, model/effort and bounded planning profiles with representative cases | Contracts | CHL-01 |
| [CHL-04](../tickets/0032-TICKET-consumer-harness-cycle-accounting.ticket.md) | Cycle and financial record contracts with replay/liability cases | Contracts | CHL-03 |
| [CHL-05](../tickets/0033-TICKET-consumer-harness-runtime-reference.ticket.md) | Manual website microruntime reference preserving v2 authority | Reference | CHL-01 |
| [CHL-06](../tickets/0034-TICKET-consumer-harness-failure-scenarios.ticket.md) | Coherent failed, interrupted and resumed scenario records | Reference | CHL-02, CHL-04, CHL-05 |
| [CHL-07](../tickets/0035-TICKET-consumer-harness-portability-retention.ticket.md) | Reference portability, provenance, retention and packaging boundaries | Reference | CHL-02, CHL-03, CHL-04, CHL-05 |
| [CHL-08](../tickets/0036-TICKET-consumer-harness-cli-compatibility.ticket.md) | Existing public CLI compatibility and non-mutating verification | Verification | CHL-05 |
| [CHL-09](../tickets/0037-TICKET-consumer-harness-generator-handoff.ticket.md) | Reviewed reference version and generator handoff | Verification | CHL-06, CHL-07, CHL-08 |

These are vertical slices: each implementation ticket owns its necessary contracts, representative input/output and checks. CHL-08 and CHL-09 add compatibility and integration acceptance; they do not defer the earlier slices' own verification. Read dependencies by stable ID, not by filename sequence. No GitHub issue tracker is introduced.

## Responsibilities

The consumer retains application source, native resource values and integration choices. The platform maintains the selected contract versions, validation boundary and future enforcement mechanisms. Service and funding owners define actual permitted targets and spending scopes; this documentation supplies none of their credentials or monetary values.

The planning agent synthesizes and reviews the requested artifacts under DEC-CHL-001. It cannot turn a generated plan, a passing review or an empty directory into an operational approval.

### DEC-CHL-001 — Delegated planning approval

On October 12, 2026 the owner explicitly requested decomposition into specs and tickets following the Dev workflow, without additional human interaction, with automatic approval and a remote PR. That request authorizes the agent to choose this bounded breakdown, accept these v1 planning documents on the owner's delegation, record the decision, and publish this documentation PR. No additional interview is required.

The approval covers this specification's requirements and the v1 child specifications and ticket descriptions linked above. Revisions that materially expand that scope require reassessment rather than inheritance of a blanket grant. Approval is an agent-recorded decision under an explicit user delegation, not a claim that a human independently reviewed each file or signed it cryptographically.

Implementation tickets retain `draft` until implementation authorization and their blocking dependencies are satisfied. Their scope/breakdown approval is already recorded and need not be requested again unchanged. This request does not direct execution of those implementation tickets. `CHL-PLAN-01` records the current documentation work separately.

### Workflow application

Use the [Dev entry point](../../workflow/dev/README.md), [cycle](../../workflow/dev/CYCLE.md), [planning](../../workflow/dev/00-planning.md), [review](../../workflow/dev/02-review.md) and [audit](../../workflow/dev/03-audit.md). Existing conversation and source plan supply discovery context. Specification and ticket preparation are explicitly authorized. Review and audit cover the resulting documentation snapshot; software execution and operational observation are not fabricated as earlier or later stages.

## Operation and limits

### Current repository versus future consumer

Preserve `.agents/` for local guidance, templates and writing-for-agents; `.exphere/harness/` for shared skills and numbered policies; `.exphere/workflow/` for workflow documents; and `.exphere/artifacts/` for typed authored documents. Retain `.audits/evidence/runs/` as the repository's existing generated evidence destination. The flat consumer skills/guides/sensors/agents layout is isolated reference input, not a root migration.

Keep `schema.json` runtime descriptor v2 unchanged. Application source remains in consumer components. The former skill lock, evidence README, shared guardrail index, CLI-context ADR and Design workflow remain unavailable; a future installation `lock.json` is a separately specified contract, not a restoration.

Keep current manual/guided initialization and explicit v1 compatibility. Retain selective Biome/Vercel handling; no blanket `.exphere/` exclusion. No SDK API, new service, Go/Node migration, duplicate template tree or cloud integration is introduced just to store this plan.

### Out of scope

This PR does not change application code, CLI behavior, dependencies, hook configuration, repository-wide approval rules or the artifact tracker. Future tickets prepare contracts and fixtures only; paid providers, real billing, transactional ledger implementation, hardware shutdown, LangGraph/MCP/RAG execution, CLI harness generation, deployment, package publication and merge remain separately scoped work. A source-only fixture is not an installable distribution.

## Verification and decisions

### VER-CHL-PLAN — Documentation acceptance

| Criterion | Required documentary evidence |
| --- | --- |
| Source coverage | Every source work package maps to a spec and one or more complete ticket slices. |
| Naming and identity | Four new SPEC and ten new TICKET filenames continue the inspected sequences; identities are unique. |
| Relationships | Every ticket has one resolving parent spec; all blocking links resolve and the graph is acyclic. |
| Approval scope | DEC-CHL-001 is linked and distinguishes approved planning content from execution readiness. |
| Preservation | Only the fourteen new Markdown artifacts are proposed; existing files and historical records remain unchanged. |
| Publication | Actual commit trailer, feature branch, PR governing spec, changed-file inventory and review limitations are inspected. |

Affected policies: [SDD rule](../../harness/rules/0001-sdd.rule.md) and [FinOps v1](../../harness/guardrails/0001-finops.gr.md). Documentary work has no direct infrastructure or paid-API consumption change; FIN-01–08 are retained as future design criteria, not reported as operational compliance. Future resource/configuration work also assesses the surviving Twelve-Factor policy at its then-current version.

Technical review and current evidence belong in [CHL-PLAN-01](../tickets/0028-TICKET-consumer-harness-planning.ticket.md). Scope acceptance under DEC-CHL-001 does not waive missing mandatory review evidence. Independent parallel reviewer execution is a distinct requirement from a same-agent two-axis assessment. Where unavailable, preserve that gap and keep the publication a draft rather than claiming full delivery approval.

For this documentation PR, the actual implemented ticket is CHL-PLAN-01 and its parent is this umbrella. The other nine tickets and three child specifications are documentation outputs, not additional implementation claims. Use `Spec: SPEC-CONSUMER-HARNESS-LAYOUT` in the PR body and `Ticket: CHL-PLAN-01` in its commit trailer.

### Remaining implementation decisions

The actual schema-validator dependency, accounting driver, graph checkpointer and executable provider integrations are not selected here. Validator selection is bounded to the existing supported environment and the isolated verification seam. Accounting and graph-driver selection belongs to the subsequent engine work. An absent choice cannot be represented as installed, supported or production-ready.
