# CHL-07: Make the selected reference portable and safe to retain

**Spec:** [SPEC-CONSUMER-HARNESS-REFERENCE v1](../specs/0015-SPEC-consumer-harness-reference.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** [CHL-02](0030-TICKET-consumer-harness-workflow-closure.ticket.md), [CHL-03](0031-TICKET-consumer-harness-planning-profiles.ticket.md), [CHL-04](0032-TICKET-consumer-harness-cycle-accounting.ticket.md), [CHL-05](0033-TICKET-consumer-harness-runtime-reference.ticket.md)
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

The complete selected consumer reference can be moved outside the checkout while retaining dependency provenance and excluding real state, secrets and unintended distribution assets.

## Acceptance criteria

- [ ] Inventory every selected skill/supporting asset and record origin/version/attribution and any missing required license material.
- [ ] Verify complete dependency closure after relocation with no maintainer-checkout fallback or duplicate live harness authority.
- [ ] Declare authored/generated writers, lifecycle, retention and publishability; fresh setup has no fabricated execution histories.
- [ ] Check Git inclusion and package inclusion separately for synthetic fixtures versus real accounting, checkpoints, logs, caches, kubeconfig and Terraform state.
- [ ] Preserve legitimate provider lock files and selective repository ignore rules; do not fabricate checksums or broaden ignores to all of .exphere.
- [ ] Keep fixtures source-only under the current CLI packaging boundary; do not implement generation or a second template tree.

## Verification

Relocate and inspect the selected reference, review asset/retention inventory and package-manifest implications. Any actual pack command requires inspecting its scripts and preserving no-publication behavior.

Coverage: REQ-CHR-001,004–005,008–010; VER-CHV-004–005,010,013.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
