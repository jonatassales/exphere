# CHL-01: Accept a minimal consumer configuration and inventory

**Spec:** [SPEC-CONSUMER-HARNESS-CONTRACTS v1](../specs/0014-SPEC-consumer-harness-contracts.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** None
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

A maintainer can validate a minimal selected consumer configuration and reference installation inventory, with a complete valid/invalid example pair and actionable errors.

## Acceptance criteria

- [ ] Define new-format versioning, mandatory fields, producer/consumer and consumer-root reference semantics without changing runtime v2.
- [ ] Provide a minimal config/inventory fixture whose selected references resolve and whose inventory clearly represents reference input, not a real installation.
- [ ] Reject unsupported versions, unknown required semantics, duplicate identities and escaping or unresolved mandatory references with file/field diagnostics.
- [ ] Select and document a compatible validator at the existing package boundary; checks do not install dependencies, mutate consumer configuration or contact external systems.

## Verification

Validate paired minimal fixtures through the isolated consumer-root seam. Record the versioned validator choice and unchanged runtime schema; do not implement the installer.

Coverage: REQ-CHC-001–002; VER-CHV-001–003,011.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
