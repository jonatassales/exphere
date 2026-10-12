# CHL-05: Inspect a manual website microruntime reference

**Spec:** [SPEC-CONSUMER-HARNESS-REFERENCE v1](../specs/0015-SPEC-consumer-harness-reference.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** [CHL-01](0029-TICKET-consumer-harness-configuration.ticket.md)
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

A maintainer can inspect one manually authored consumer runtime whose descriptor and native files reference a synthetic website component while preserving existing CLI contracts.

## Acceptance criteria

- [ ] Use the existing runtime v2 descriptor and current component-basename/reference rules without adding budget, model or graph fields.
- [ ] Keep Terraform responsible for namespace/quota configuration and Kubernetes manifests responsible for workload values; source stays in the referenced component.
- [ ] Create only selected native configuration and documentation; hooks are absent unless explicitly selected.
- [ ] Use current configuration contracts/tool constraints without silently upgrading dependencies or asserting image/cluster readiness.
- [ ] Provide a valid reference and invalid-reference case through existing public configuration validation in disposable consumers.

## Verification

Inspect the current CLI fixture entry before use. Validate references with controlled inputs; do not run Terraform, Kubernetes, consumer hooks or image builds.

Coverage: REQ-CHR-002–003; VER-CHV-001–003,005,012.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
