# CHL-06: Explain failure and resume with coherent scenario records

**Spec:** [SPEC-CONSUMER-HARNESS-REFERENCE v1](../specs/0015-SPEC-consumer-harness-reference.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** [CHL-02](0030-TICKET-consumer-harness-workflow-closure.ticket.md), [CHL-04](0032-TICKET-consumer-harness-cycle-accounting.ticket.md), [CHL-05](0033-TICKET-consumer-harness-runtime-reference.ticket.md)
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

A reader can follow synthetic failed, paused and resumed deliveries and see their incomplete checks, financial liabilities and remaining resource obligations without mistaking them for real runs.

## Acceptance criteria

- [ ] Keep scenarios separate from fresh consumer installation and label each record and expected outcome as simulated.
- [ ] Cover accepted proposal, unaffordable proposal, missing context, interrupted execution, duplicate financial event and pending charge.
- [ ] Link scenario runtime/feature/cycle/ticket/attempt identities and code/config/policy revisions coherently.
- [ ] Preserve spent/reserved/protected amounts and resource/cleanup obligations across pause/resume without duplicate totals or automatic uncertain refunds.
- [ ] Reports derive from the same records and retain failed/skipped/inconclusive checks; no acceptance or invoice is fabricated.

## Verification

Validate scenario structure, relationships and expected deterministic interpretation. Document which behaviors still need a live engine or charge source to prove.

Coverage: REQ-CHR-006–007; VER-CHV-006–010.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
