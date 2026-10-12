# Consumer harness — portable manual reference and synthetic scenarios

- ID: `SPEC-CONSUMER-HARNESS-REFERENCE`
- Version: `1`
- State: `approved`
- Approval scope: delegated acceptance of specification and ticket content; implementation and operational acceptance remain separate.
- PRD: `PRD-0001` is the broad product source; no approved PRD revision for the new AI/FinOps scope is asserted. `PRD-0002 v1` retains its original local-pilot exclusions.
- Technical owners: Exphere project owner and platform maintainer; consumer-specific operators and budgets are not assigned by this document.
- Baseline: `jonatassales/exphere`, `main`, `d315a4249323f62c61c1c6d47e4878ba93269c53`.
- Date: October 12, 2026.

- Parent: [SPEC-CONSUMER-HARNESS-LAYOUT v1](0013-SPEC-consumer-harness-layout.spec.md); approval follows its DEC-CHL-001.
- Contract dependency: [SPEC-CONSUMER-HARNESS-CONTRACTS v1](0014-SPEC-consumer-harness-contracts.spec.md).

## Contract and composition

### Outcome and selected reference

Prepare a manually authored source-only consumer with one synthetic website component, one reusable website-preview microruntime, one selected SDD workflow and planner/retrieval bindings. Maintain scenario records separately. The reference is future generator input/acceptance material, not a second active installation of the repository harness.

Requirements addressed: REQ-CHL-001, REQ-CHL-004–005. Covers LAYOUT-03 and LAYOUT-04. The fixture directory recommendation remains `packages/cli/fixtures/consumer-harness/`, with separate `consumer-harness-scenarios/`; no independent template tree is maintained in this phase.

### Consumer capability map

```text
.exphere/
  README.md
  config.json
  lock.json
  runtimes/website-preview/
    README.md
    schema.json
    terraform/main.tf.json
    units/website/kubernetes/
      deployment.json
      service.json
    hooks/                         # only when explicitly selected
  workflow/definition.json
  skills/<selected-skill>/          # includes required supporting assets
  guides/execution.md
  sensors/checks.json
  agents/planner.json
  agents/diagnostician.json         # only when selected
  artifacts/
    prd/                           # only with authored content
    specs/
    tickets/
    accounting/                    # only with real accounting activity
    cycles/<cycle-id>/              # only with actual cycle creation
      context.json
      plan.json
      events.jsonl
      evidence/
      report.md
```

This map describes supported locations, not mandatory empty folders. Reference fixtures can model selected configuration; simulated execution histories belong in the separate scenario fixture and carry explicit synthetic provenance. A fresh-installation case contains no invented execution, invoice, approval or delivery report.

### Reference requirements

| ID | Required behavior and artifact |
| --- | --- |
| REQ-CHR-001 | The minimal selected consumer is inspectable outside the maintainer checkout; every required reference is local to the fixture or a declared resolvable prerequisite. |
| REQ-CHR-002 | Runtime v2 points to the existing synthetic component rather than copying application source. Unit identity follows the current basename rule; native resource values remain single-authority. |
| REQ-CHR-003 | The fixture's native Terraform/Kubernetes files follow the current configuration contract without changing tool pins, current CLI behavior or descriptor fields. Real images, readiness and cluster execution are not implied. |
| REQ-CHR-004 | The selected workflow includes its required templates/skills/guides/bindings and preserves attribution and available license material. Missing required redistributable material is explicit and blocks distribution readiness, not silently fabricated. |
| REQ-CHR-005 | Optional diagnostician, hooks and unrelated capabilities are absent unless selected; missing required capabilities produce an explicit unresolved result. |
| REQ-CHR-006 | Linked synthetic scenarios cover accepted proposal, unaffordable proposal, missing context, interruption, duplicate event and pending charge, using coherent identities and expected outcomes. |
| REQ-CHR-007 | Paused and resumed scenarios retain consumed budgets, unresolved charges, verification/closure obligations and any remaining infrastructure; fake success or automatic refunds are rejected. |
| REQ-CHR-008 | Authored configuration, selected assets, machine records, evidence and operational secrets have explicit writers, retention and publishability. Test Git and package inclusion separately. |
| REQ-CHR-009 | Existing repository evidence stays in its original location. Consumer cycle evidence is a new isolated reference contract, not a relocation of historical evidence. |
| REQ-CHR-010 | Source-only fixtures are not advertised as packaged assets; the current CLI manifest's `cli` distribution selection is preserved. |

## Responsibilities

The consumer reference owns synthetic scenario choices, with no universal production defaults. Exphere owns reproducible interpretation and verification of the selected contract. Upstream skill attribution remains intact; modifications identify their source and scope. Installation inventory indicates a reference manifest, not a claim that an installer ran.

## Operation and limits

### Materialization and state

| Trigger | Intended materialization |
| --- | --- |
| Package installation | Preserve existing package/install behavior; no new consumer-harness side effect in this initiative. |
| Future explicit harness setup | Selected authored config/assets/bindings, docs, installation inventory and reviewed ignore-file changes. |
| Explicit runtime configuration | Existing v2 descriptor and chosen native files, preserving source and refusing unauthorized overwrite. |
| First bounded planning/execution | Actual cycle/context/plan/events and accounting activity as incurred. |
| Pause, failure, cancellation or completion | Partial/final derived report, with remaining checks, charges and resources visible. |
| Resume | Continuation tied to existing records and parent budgets. |

Keep raw sensitive context, real financial databases, caches/embeddings, graph checkpoints, logs, provider secrets, kubeconfig and Terraform state out of ordinary commits and distribution. Retain `.terraform.lock.hcl` when generated legitimately; it is neither Terraform state nor the proposed harness lock. Do not fabricate checksums or include real maintainer history in examples.

Failures during fixture verification affect only owned disposable directories. Verification must not execute supplied hooks, Terraform, Kubernetes, remote retrieval or model providers. Merely recording unavailable handlers in configuration is acceptable for a contract fixture; it cannot satisfy an executable-readiness assertion.

## Verification and decisions

| Ticket | Requirements / evidence |
| --- | --- |
| [CHL-05](../tickets/0033-TICKET-consumer-harness-runtime-reference.ticket.md) | REQ-CHR-002–003: isolated runtime reference inspection through the existing v2 configuration contract and controlled fixtures. |
| [CHL-06](../tickets/0034-TICKET-consumer-harness-failure-scenarios.ticket.md) | REQ-CHR-006–007: scenario identity, expected state/cost interpretation and failure evidence. |
| [CHL-07](../tickets/0035-TICKET-consumer-harness-portability-retention.ticket.md) | REQ-CHR-001,004–005,008–010: relocation without maintainer fallback, provenance/dependency inventory, source/package exclusions. |

Workflow closure from CHL-02 and planning/accounting contracts from CHL-03/04 are prerequisites only where consumed. This reference does not require the live microruntime lifecycle, actual RAG, operational budget enforcement or a deployment.

Affected future FIN criteria include ownership/allocation, coverage, lifetime/cleanup and truthful measurement; data isolation and external secret references also require the applicable Twelve-Factor review before implementation completion. No real cost, savings, capacity or security outcome is claimed by the fixture.

Approval: DEC-CHL-001 accepts this planning scope. Technical review of the materialized reference remains pending the implementation tickets and [SPEC-CONSUMER-HARNESS-VERIFICATION v1](0016-SPEC-consumer-harness-verification.spec.md).
