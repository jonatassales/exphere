# CHL-02: Resolve a selected workflow and its complete dependencies

**Spec:** [SPEC-CONSUMER-HARNESS-CONTRACTS v1](../specs/0014-SPEC-consumer-harness-contracts.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** [CHL-01](0029-TICKET-consumer-harness-configuration.ticket.md)
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

A selected SDD workflow can be interpreted outside the maintainer checkout with its skills, templates, guides and sensor bindings explicitly accounted for.

## Acceptance criteria

- [ ] Supply contract, selected fixture and checks for common SDD stages/transitions, checkpoints and blocking/resume references.
- [ ] Include, rewrite or explicitly declare every required dependency; missing required templates/skills fail instead of resolving from the checkout.
- [ ] Classify sensor bindings by direction and computational/inferential type independently of directory names.
- [ ] Report missing required handlers as unavailable and not operationally ready; valid documentary shape does not mean an executable workflow.
- [ ] Preserve selected upstream attribution/supporting assets and omit unselected optional capabilities.

## Verification

Relocate the selected fixture to a disposable root, then remove one required dependency. Verify successful declared resolution and explicit failure without handler or hook execution.

Coverage: REQ-CHC-003–004; REQ-CHR-004–005; VER-CHV-004–005,013.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
