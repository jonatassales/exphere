# CHL-02: Resolve a selected workflow and its complete dependencies

**Spec:** [SPEC-CONSUMER-HARNESS-CONTRACTS v1](../specs/0014-SPEC-consumer-harness-contracts.spec.md)
**Version:** 1
**Status:** in-review
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

The original planning cycle had no implementation evidence. The implementation observations and remaining gate are recorded below; historical planning authorization is preserved.

## IMP-CHL-02 — Implementation observation, October 12, 2026

The owner explicitly requested implementation of these merged tickets in the current conversation. That request authorizes this bounded local implementation and the specified isolated contract verification. It does not claim that a human independently reviewed the resulting source or authorize live providers, infrastructure, publication or a generator. Baseline: `2865485fece84a39b49d2d28268f692b538bd283`.

Implementation and evidence are summarized in [the source verification contract](../../../packages/cli/scripts/consumer-harness/README.md) and [the candidate handoff record](../../../packages/cli/scripts/consumer-harness/HANDOFF.md). The delivery bundle includes a SHA-256 manifest and raw check output for the examined snapshot. Existing runtime implementation files, runtime v2 schema, package manifest and preexisting test entry remain unchanged.

The substantive slice is implemented and locally checked; the acceptance checkboxes remain open until the required review is satisfied. Dependent slices were prepared and checked together under the same explicit implementation request; this does not manufacture completed blocker states. No prior ticket is silently marked done.

### Standards

Authoring-agent assessment only: shell/jq implementation, explicit roots, no consumer code execution, bounded synthetic input, scoped temporaries, unchanged native ownership, source-only fixtures and en-US documentation were inspected. Self-review corrected input-path edge cases and bounded arithmetic before final verification. Independent parallel Standards review is unavailable and is not reported as passed.

### Spec

Authoring-agent assessment only: the selected contracts, dependencies, scenario interpretation, declared unavailable capabilities and this ticket's verification coverage were checked against its parent scope. No engine, database, provider integration or generator was added. The cross-ticket matrix and observations are in the handoff record. Independent parallel Spec review is unavailable and is not reported as passed.

### Gate disposition

Required independent two-axis review remains `inconclusive`; return to `in-review` after both reviewers examine the exact candidate snapshot and actionable findings are resolved. The source-only implementation is supplied uncommitted. No commit, push, remote PR or merge occurred in this implementation cycle. The candidate is not an accepted generator target until the review gate is complete.
