# CHL-04: Preserve financial liabilities across cycle records

**Spec:** [SPEC-CONSUMER-HARNESS-CONTRACTS v1](../specs/0014-SPEC-consumer-harness-contracts.spec.md)
**Version:** 1
**Status:** in-review
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

The original planning cycle had no implementation evidence. The implementation observations and remaining gate are recorded below; historical planning authorization is preserved.

## IMP-CHL-04 — Implementation observation, October 12, 2026

The owner explicitly requested implementation of these merged tickets in the current conversation. That request authorizes this bounded local implementation and the specified isolated contract verification. It does not claim that a human independently reviewed the resulting source or authorize live providers, infrastructure, publication or a generator. Baseline: `2865485fece84a39b49d2d28268f692b538bd283`.

Implementation and evidence are summarized in [the source verification contract](../../../packages/cli/scripts/consumer-harness/README.md) and [the candidate handoff record](../../../packages/cli/scripts/consumer-harness/HANDOFF.md). The delivery bundle includes a SHA-256 manifest and raw check output for the examined snapshot. Existing runtime implementation files, runtime v2 schema, package manifest and preexisting test entry remain unchanged.

The substantive slice is implemented and locally checked; the acceptance checkboxes remain open until the required review is satisfied. Dependent slices were prepared and checked together under the same explicit implementation request; this does not manufacture completed blocker states. No prior ticket is silently marked done.

### Standards

Authoring-agent assessment only: shell/jq implementation, explicit roots, no consumer code execution, bounded synthetic input, scoped temporaries, unchanged native ownership, source-only fixtures and en-US documentation were inspected. Self-review corrected input-path edge cases and bounded arithmetic before final verification. Independent parallel Standards review is unavailable and is not reported as passed.

### Spec

Authoring-agent assessment only: the selected contracts, dependencies, scenario interpretation, declared unavailable capabilities and this ticket's verification coverage were checked against its parent scope. No engine, database, provider integration or generator was added. The cross-ticket matrix and observations are in the handoff record. Independent parallel Spec review is unavailable and is not reported as passed.

### Gate disposition

Required independent two-axis review remains `inconclusive`; return to `in-review` after both reviewers examine the exact candidate snapshot and actionable findings are resolved. The source-only implementation is supplied uncommitted. No commit, push, remote PR or merge occurred in this implementation cycle. The candidate is not an accepted generator target until the review gate is complete.
