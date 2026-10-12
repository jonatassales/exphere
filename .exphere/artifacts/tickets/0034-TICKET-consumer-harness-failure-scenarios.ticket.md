# CHL-06: Explain failure and resume with coherent scenario records

**Spec:** [SPEC-CONSUMER-HARNESS-REFERENCE v1](../specs/0015-SPEC-consumer-harness-reference.spec.md)
**Version:** 1
**Status:** in-review
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

The original planning cycle had no implementation evidence. The implementation observations and remaining gate are recorded below; historical planning authorization is preserved.

## IMP-CHL-06 — Implementation observation, October 12, 2026

The owner explicitly requested implementation of these merged tickets in the current conversation. That request authorizes this bounded local implementation and the specified isolated contract verification. It does not claim that a human independently reviewed the resulting source or authorize live providers, infrastructure, publication or a generator. Baseline: `2865485fece84a39b49d2d28268f692b538bd283`.

Implementation and evidence are summarized in [the source verification contract](../../../packages/cli/scripts/consumer-harness/README.md) and [the candidate handoff record](../../../packages/cli/scripts/consumer-harness/HANDOFF.md). The delivery bundle includes a SHA-256 manifest and raw check output for the examined snapshot. Existing runtime implementation files, runtime v2 schema, package manifest and preexisting test entry remain unchanged.

The substantive slice is implemented and locally checked; the acceptance checkboxes remain open until the required review is satisfied. Dependent slices were prepared and checked together under the same explicit implementation request; this does not manufacture completed blocker states. No prior ticket is silently marked done.

### Standards

Authoring-agent assessment only: shell/jq implementation, explicit roots, no consumer code execution, bounded synthetic input, scoped temporaries, unchanged native ownership, source-only fixtures and en-US documentation were inspected. Self-review corrected input-path edge cases and bounded arithmetic before final verification. Independent parallel Standards review is unavailable and is not reported as passed.

### Spec

Authoring-agent assessment only: the selected contracts, dependencies, scenario interpretation, declared unavailable capabilities and this ticket's verification coverage were checked against its parent scope. No engine, database, provider integration or generator was added. The cross-ticket matrix and observations are in the handoff record. Independent parallel Spec review is unavailable and is not reported as passed.

### Gate disposition

Required independent two-axis review remains `inconclusive`; return to `in-review` after both reviewers examine the exact candidate snapshot and actionable findings are resolved. The source-only implementation is supplied uncommitted. No commit, push, remote PR or merge occurred in this implementation cycle. The candidate is not an accepted generator target until the review gate is complete.
