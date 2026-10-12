# CHL-08: Preserve public CLI compatibility and non-mutating checks

**Spec:** [SPEC-CONSUMER-HARNESS-VERIFICATION v1](../specs/0016-SPEC-consumer-harness-verification.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** [CHL-05](0033-TICKET-consumer-harness-runtime-reference.ticket.md)
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

A maintainer can run the authorized isolated consumer checks repeatedly without changing current manual/guided v2 or explicit legacy v1 configuration behavior.

## Acceptance criteria

- [ ] Inspect the current CLI test entry and reuse the highest existing public-command seam instead of migrating language or framework.
- [ ] Cover valid and invalid v1/v2 inputs, unsupported fields/versions, collisions, reference containment and native-file preservation as applicable.
- [ ] Verify repeated validation, failure and cancellation leave the consumer unchanged and clean only owned temporary output.
- [ ] Use controlled external tools and no real profiles, paid calls, provider operations or consumer-hook execution.
- [ ] Record actual tool versions/platform, commands and results; never claim untested operating-system or operational compatibility.

## Verification

Run scoped public CLI fixtures only after implementation authorization, with disposable consumers and preinspected entry points. Preserve unrelated test behavior.

Coverage: VER-CHV-002–003,011–012; REQ-CHL-005.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
