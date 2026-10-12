# CHL-09: Freeze a reviewed reference for later generator work

**Spec:** [SPEC-CONSUMER-HARNESS-VERIFICATION v1](../specs/0016-SPEC-consumer-harness-verification.spec.md)
**Version:** 1
**Status:** blocked
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

The original planning cycle had no implementation evidence. The implementation observations and remaining gate are recorded below; historical planning authorization is preserved.

## IMP-CHL-09 — Implementation observation, October 12, 2026

The owner explicitly requested implementation of these merged tickets in the current conversation. That request authorizes this bounded local implementation and the specified isolated contract verification. It does not claim that a human independently reviewed the resulting source or authorize live providers, infrastructure, publication or a generator. Baseline: `2865485fece84a39b49d2d28268f692b538bd283`.

Implementation and evidence are summarized in [the source verification contract](../../../packages/cli/scripts/consumer-harness/README.md) and [the candidate handoff record](../../../packages/cli/scripts/consumer-harness/HANDOFF.md). The delivery bundle includes a SHA-256 manifest and raw check output for the examined snapshot. Existing runtime implementation files, runtime v2 schema, package manifest and preexisting test entry remain unchanged.

The substantive slice is implemented and locally checked; the acceptance checkboxes remain open until the required review is satisfied. Dependent slices were prepared and checked together under the same explicit implementation request; this does not manufacture completed blocker states. No prior ticket is silently marked done.

### Standards

Authoring-agent assessment only: shell/jq implementation, explicit roots, no consumer code execution, bounded synthetic input, scoped temporaries, unchanged native ownership, source-only fixtures and en-US documentation were inspected. Self-review corrected input-path edge cases and bounded arithmetic before final verification. Independent parallel Standards review is unavailable and is not reported as passed.

### Spec

Authoring-agent assessment only: the selected contracts, dependencies, scenario interpretation, declared unavailable capabilities and this ticket's verification coverage were checked against its parent scope. No engine, database, provider integration or generator was added. The cross-ticket matrix and observations are in the handoff record. Independent parallel Spec review is unavailable and is not reported as passed.

### Gate disposition

Required independent two-axis review remains `inconclusive`; return to `in-review` after both reviewers examine the exact candidate snapshot and actionable findings are resolved. The source-only implementation is supplied uncommitted. No commit, push, remote PR or merge occurred in this implementation cycle. The candidate is not an accepted generator target until the review gate is complete.
