# CHL-08: Preserve public CLI compatibility and non-mutating checks

**Spec:** [SPEC-CONSUMER-HARNESS-VERIFICATION v1](../specs/0016-SPEC-consumer-harness-verification.spec.md)
**Version:** 1
**Status:** in-review
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

The original planning cycle had no implementation evidence. The implementation observations and remaining gate are recorded below; historical planning authorization is preserved.

## IMP-CHL-08 — Implementation observation, October 12, 2026

The owner explicitly requested implementation of these merged tickets in the current conversation. That request authorizes this bounded local implementation and the specified isolated contract verification. It does not claim that a human independently reviewed the resulting source or authorize live providers, infrastructure, publication or a generator. Baseline: `2865485fece84a39b49d2d28268f692b538bd283`.

Implementation and evidence are summarized in [the source verification contract](../../../packages/cli/scripts/consumer-harness/README.md) and [the candidate handoff record](../../../packages/cli/scripts/consumer-harness/HANDOFF.md). The delivery bundle includes a SHA-256 manifest and raw check output for the examined snapshot. Existing runtime implementation files, runtime v2 schema, package manifest and preexisting test entry remain unchanged.

The substantive slice is implemented and locally checked; the acceptance checkboxes remain open until the required review is satisfied. Dependent slices were prepared and checked together under the same explicit implementation request; this does not manufacture completed blocker states. No prior ticket is silently marked done.

### Standards

Authoring-agent assessment only: shell/jq implementation, explicit roots, no consumer code execution, bounded synthetic input, scoped temporaries, unchanged native ownership, source-only fixtures and en-US documentation were inspected. Self-review corrected input-path edge cases and bounded arithmetic before final verification. Independent parallel Standards review is unavailable and is not reported as passed.

### Spec

Authoring-agent assessment only: the selected contracts, dependencies, scenario interpretation, declared unavailable capabilities and this ticket's verification coverage were checked against its parent scope. No engine, database, provider integration or generator was added. The cross-ticket matrix and observations are in the handoff record. Independent parallel Spec review is unavailable and is not reported as passed.

### Gate disposition

Required independent two-axis review remains `inconclusive`; return to `in-review` after both reviewers examine the exact candidate snapshot and actionable findings are resolved. The source-only implementation is supplied uncommitted. No commit, push, remote PR or merge occurred in this implementation cycle. The candidate is not an accepted generator target until the review gate is complete.
