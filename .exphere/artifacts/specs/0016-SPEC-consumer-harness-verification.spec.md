# Consumer harness — isolated verification and generator handoff

- ID: `SPEC-CONSUMER-HARNESS-VERIFICATION`
- Version: `1`
- State: `approved`
- Approval scope: delegated acceptance of specification and ticket content; implementation and operational acceptance remain separate.
- PRD: `PRD-0001` is the broad product source; no approved PRD revision for the new AI/FinOps scope is asserted. `PRD-0002 v1` retains its original local-pilot exclusions.
- Technical owners: Exphere project owner and platform maintainer; consumer-specific operators and budgets are not assigned by this document.
- Baseline: `jonatassales/exphere`, `main`, `d315a4249323f62c61c1c6d47e4878ba93269c53`.
- Date: October 12, 2026.

- Parent: [SPEC-CONSUMER-HARNESS-LAYOUT v1](0013-SPEC-consumer-harness-layout.spec.md); approval follows its DEC-CHL-001.
- Inputs: [SPEC-CONSUMER-HARNESS-CONTRACTS v1](0014-SPEC-consumer-harness-contracts.spec.md) and [SPEC-CONSUMER-HARNESS-REFERENCE v1](0015-SPEC-consumer-harness-reference.spec.md).

## Contract and composition

### Outcome and verification seam

A maintainer can validate a selected manual consumer reference and its scenarios repeatedly without changing consumer files or contacting paid/live systems, while preserving existing public CLI v1/v2 behavior. Evidence identifies exactly which reference version is suitable as the later generator target.

Requirements addressed: REQ-CHL-005–008. Covers LAYOUT-05 and the implementation gate of LAYOUT-06. Prefer one consumer-root verification seam with a package-owned `.sh` entry point and paired positive/negative cases. Inspect the current CLI test entry point before modifying or executing it. Preserve its supported shell dialect and existing toolchain; new dependencies require explicit selection and compatibility review, not automatic installation during validation.

Each implementation slice supplies its own representative fixture checks. Final verification adds cross-slice interpretation, compatibility and evidence reconciliation rather than treating schema acceptance as a proof of operational correctness.

### Verification matrix

| ID | Case | Required result |
| --- | --- | --- |
| VER-CHV-001 | Valid manual reference | Structural/semantic checks pass for selected contracts; operational availability is reported separately. |
| VER-CHV-002 | Unknown field, unsupported format or runtime version | Rejection with file/field diagnostic, without descriptor edits. |
| VER-CHV-003 | Duplicate ID, invalid reference, traversal or escaping symlink | Rejection before any affected action or outside access. |
| VER-CHV-004 | Missing required skill/template/handler | Explicit unresolved dependency; no checkout fallback or readiness claim. |
| VER-CHV-005 | Unselected optional diagnostician/hook | No placeholder and no artificial mandatory dependency. |
| VER-CHV-006 | Missing price, incompatible currency or unsupported effort | Rejection or explicitly unknown coverage; never automatic zero-cost admission. |
| VER-CHV-007 | Paid planning/retrieval without bootstrap allowance | Synthetic admission rejection before hypothetical dispatch. |
| VER-CHV-008 | Timeout, duplicate usage or resumed cycle | Expected liabilities and attribution preserved without double-counting. |
| VER-CHV-009 | Paused cycle with remaining infrastructure | Report retains ongoing-resource and cleanup obligations. |
| VER-CHV-010 | Fresh setup | No fabricated history, approval, invoice or completed receipt. |
| VER-CHV-011 | Repeat validation and cancellation/failure | Stable result for same input; no consumer mutation, paid API, infrastructure command or consumer-hook execution; only owned temporary output cleaned. |
| VER-CHV-012 | Existing public v1/v2 configuration cases | Existing behavior retained; no implicit migration or resource-value rewrite. |
| VER-CHV-013 | Relocated reference and source/package boundary | Complete selected dependency closure; no secrets, real state, maintainer history or unintended assets. |

## Responsibilities

The implementing agent records tools/versions, commands, fixture identity, inspected revision, expected and observed results, and limitations. The platform maintainer owns validator compatibility and package boundaries. The project owner retains scope authority; automatic planning approval does not waive missing verification evidence.

Use the [Dev review](../../workflow/dev/02-review.md) and [audit](../../workflow/dev/03-audit.md) with Standards and Spec assessments of the same snapshot. Review records remain in the originating typed artifacts, with raw authorized generated evidence in the established repository evidence destination. No parallel report hierarchy is introduced.

## Operation and limits

Select a compatible schema validator during the first contract implementation, recording the version and applicable semantics. Verification must parse configuration as data rather than source it as shell. Bound fixture access to its declared consumer root; prevent fallback to installed maintainer assets. Run public CLI checks in disposable consumers, without real shell-profile changes or infrastructure execution.

This specification proposes future isolated fixture verification, not immediate execution of all project scripts. Application tests, browser/service probes, paid calls, provider tools and deployment remain outside this planning PR. Existing approved hook/CLI checks may be reused at their unchanged seam when implementation is authorized; their prior results cannot be claimed for a changed snapshot.

A check can be `passed`, `failed` or `inconclusive`; a declaration or skipped handler is not a pass. Fixture accounting expectations do not prove durable transactions, concurrency safety, invoice coverage, actual RAG quality, model quality, cluster admission, hardware cleanup or production security.

## Verification and decisions

### Ticket ownership

[CHL-08](../tickets/0036-TICKET-consumer-harness-cli-compatibility.ticket.md) owns compatibility and non-mutation regression. [CHL-09](../tickets/0037-TICKET-consumer-harness-generator-handoff.ticket.md) reconciles the complete verification matrix, reference inventory and review evidence. CHL-01 through CHL-07 provide the narrower contract/scenario evidence on which these depend.

### Generator handoff gate

Accept a versioned target only when its contract versions, file ownership/timing and selected dependency closure are explicit; all applicable matrix cases have observed results; current runtime compatibility is preserved; and actionable Standards/Spec findings are resolved against that same snapshot. Missing mandatory results keep the gate incomplete and name a resume condition.

The handoff records the accepted reference version, schema versions, asset inventory/provenance, available versus unavailable capabilities, source/package distinction and verification revision. Approval of this specification is not approval of an unimplemented reference.

Later CLI generation has separate requirements: explicit setup entry points, collision/no-overwrite behavior, partial publication/recovery, consumer modification detection, upgrade/migration behavior, packed-package consumer verification and honest unsupported cases. Do not add an unreviewed public command now.

Later LangGraph/MCP/RAG execution and financial enforcement retain P0 priority but require their own implementation and observed evidence. Driver/checkpointer selection and hard-cap guarantees are not inferred from the reference freeze.

### Policy assessment

Apply the current SDD rule to commits/PRs and relevant FIN/Twelve-Factor criteria to configuration, retention and cost claims. Current documentation impact is non-applicable to real paid consumption. Future quality/financial assertions remain unverified until the linked evidence exists. Local hooks and a static document cannot authenticate approval or enforce organization-wide policy.

Approval: DEC-CHL-001 accepts this v1 verification approach as planning content. Execution of the implementation checks remains part of the later authorized implementation cycle.
