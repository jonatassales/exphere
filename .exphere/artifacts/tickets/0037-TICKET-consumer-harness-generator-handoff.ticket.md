# CHL-09: Freeze a reviewed reference for later generator work

**Spec:** [SPEC-CONSUMER-HARNESS-VERIFICATION v1](../specs/0016-SPEC-consumer-harness-verification.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** [CHL-06](0034-TICKET-consumer-harness-failure-scenarios.ticket.md), [CHL-07](0035-TICKET-consumer-harness-portability-retention.ticket.md), [CHL-08](0036-TICKET-consumer-harness-cli-compatibility.ticket.md)
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

The future generator receives one versioned reference with coherent contracts, dependency inventory and verifiable acceptance evidence, or a precise incomplete-gate report.

## Acceptance criteria

- [ ] Reconcile every VER-CHV matrix case with the slice that owns it and an actual observed result for the frozen snapshot.
- [ ] Record reference/schema/asset versions, ownership/timing, available versus unavailable handlers and source/package boundary.
- [ ] Complete Standards and Spec review against the same identified snapshot; resolve actionable findings and refresh changed evidence.
- [ ] Keep missing mandatory evidence inconclusive with a resume condition; approval of planning documents is not acceptance of unimplemented fixtures.
- [ ] Hand off explicit-setup, no-overwrite, partial-recovery, modification-detection, upgrade and packed-consumer requirements without implementing a new command.
- [ ] Keep later LangGraph/MCP/RAG execution, transactional accounting, hard-cap coverage and real cleanup as separate P0 implementation work.

## Verification

Review the full manifest and cross-slice evidence; record gate disposition in the typed artifacts. A document or synthetic receipt alone cannot pass the implementation gate.

Coverage: VER-CHV-001–013; REQ-CHL-007–008.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
