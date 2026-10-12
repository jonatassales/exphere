# CHL-04: Preserve financial liabilities across cycle records

**Spec:** [SPEC-CONSUMER-HARNESS-CONTRACTS v1](../specs/0014-SPEC-consumer-harness-contracts.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** [CHL-03](0031-TICKET-consumer-harness-planning-profiles.ticket.md)
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

A maintainer can read a coherent cycle/context/plan/accounting example and determine which costs are estimates, reservations, settled amounts or unresolved liabilities across retry and resume.

## Acceptance criteria

- [ ] Specify context, plan, event and accounting formats with stable attribution, policy/price revisions and authoritative-writer boundaries.
- [ ] Define exact monetary representation and rounding, separate AI/infrastructure/combined scopes and avoid counting alternate valuations twice.
- [ ] Provide bounded admission expectations for consumption, outstanding reservations, proposed reservation and protected allowance at parent limits.
- [ ] Model settlement replacing a reservation, duplicate-event identity, timeout with pending liability and truthful unexpected overage.
- [ ] Include infrastructure horizon/lifetime/shutdown/residual-cost obligations; pausing a graph does not imply resource termination.
- [ ] Separate workflow/ticket/runtime/financial states and graph/store references; resume never resets cumulative consumption.
- [ ] Record the authored-versus-machine contract boundary without silently changing the repository tracker or implementing a database.

## Verification

Validate labeled synthetic records and their deterministic expected interpretation. Record the difference between this fixture proof and transactional/concurrent accounting or real billing.

Coverage: REQ-CHC-008–014; VER-CHV-006,008–009.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
