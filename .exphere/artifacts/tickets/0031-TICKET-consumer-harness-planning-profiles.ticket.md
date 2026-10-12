# CHL-03: Describe bounded retrieval and model-effort planning profiles

**Spec:** [SPEC-CONSUMER-HARNESS-CONTRACTS v1](../specs/0014-SPEC-consumer-harness-contracts.spec.md)
**Version:** 1
**Status:** draft
**Approval:** Scope and breakdown accepted under [DEC-CHL-001](../specs/0013-SPEC-consumer-harness-layout.spec.md#dec-chl-001--delegated-planning-approval), October 12, 2026. Implementation has not been requested in this documentation cycle.
**Blocked by:** [CHL-01](0029-TICKET-consumer-harness-configuration.ticket.md)
**Readiness:** Record implementation authorization and satisfy the listed blockers before `ready-for-agent`; accepted scope does not require another unchanged planning interview.

## What to build

A planning configuration expresses the feature context sources, eligible execution profiles and planning allowance well enough to reject unsupported or unfunded hypothetical planning.

## Acceptance criteria

- [ ] Keep LangGraph, MCP and RAG as intended P0 capabilities while marking implementation availability explicitly.
- [ ] Provide retrieval scope/freshness/provenance/exclusion contracts and at least two meaningful synthetic execution profiles with declared effort capabilities.
- [ ] Tie model/price data to governed versioned sources; unknown prices or effort support remain unknown or rejected, never invented defaults.
- [ ] Include a bootstrap planning profile/allowance and applicable embedding/retrieval/inference overhead before hypothetical dispatch.
- [ ] Supply valid/invalid profile cases, including missing context, unsupported effort and missing planning allowance, without invoking models or retrieval.

## Verification

Inspect and validate synthetic profile/context examples through the consumer seam. Assert rejection reasons rather than model quality or retrieval relevance.

Coverage: REQ-CHC-005–007; VER-CHV-006–007.

## Boundaries and handoff

Deliver this slice's contract, selected example and checks together. Follow the parent specification and [Dev cycle](../../workflow/dev/CYCLE.md). Preserve unrelated consumer/repository files. No paid API, infrastructure execution, production access, generator implementation or remote publication is authorized by merely reading this ticket.

Implementation and verification evidence: not yet available. On completion, record observed results and separate Standards/Spec findings against the delivered revision; update state only when the ticket's own criteria are satisfied.
