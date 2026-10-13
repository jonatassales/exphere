# EX-PACKAGE-01: Rename the CLI package to @exphere/ex

**Spec:** [SPEC-GO-CLI-FOUNDATION v1](../specs/0032-SPEC-go-cli-foundation.spec.md#subsequent-decision--package-identity)
**Status:** done
**Origin:** Owner's October 13, 2026 package naming decision and instruction to apply it.

## Acceptance

- [x] CLI directory and package become `packages/ex` and `@exphere/ex`; Go module/imports match.
- [x] `@exphere/sdk` stays separate, with both bin bridges resolving its renamed dependency.
- [x] Workspace, lockfile, Turbo, CI, and current guidance use the new identity; the command remains `ex`.
- [x] Source installation and website-only opt-out retain their existing behavior.
- [x] Existing applicable checks and independent Standards/Spec review pass.

## Boundaries

Preserve private versions, runtime behavior, inner `cli/schemas`, dated evidence, fixtures, and the explicit shell-setup opt-in. No compatibility package, registry publication, new tests/scenarios, live infrastructure execution, or production deployment is included. Correct stale CLI availability text only in the current references touched by this rename.

## Verification

- Base: `c73d8b7106f813ec18c945f7bf2aa3d4a8ff8766`.
- Workspace installation built the renamed CLI; the subsequent frozen-lockfile installation passed. Only local package links changed in the lockfile.
- Formatting/lint and all seven existing typecheck/build prerequisite tasks passed, including Go vet.
- Project-local help, SDK-forwarded version, and SDK-forwarded shell-setup help passed without modifying a profile.
- The website build graph contains only design, web, and website tasks, preserving deployment isolation.
- All 148 former CLI files moved; fixture, schema, and historical handoff contents are unchanged.
- Independent Standards and Spec reviews passed the same 170-path snapshot `de4f8651639068f86f21c02b84ead2d5dbdf945fa21a7aab2400317d28e9f8b3` against the base above. The only initial finding was a ticket state label, corrected before both final reviews. Subsequent edits to this record are verification bookkeeping only.
- Go formatting, shell syntax, and Git whitespace checks passed. The existing full pre-push build/test gate is pending at commit preparation; its result will be reported in the PR before delivery.
- No new tests or live infrastructure scenarios were added or executed. Source completion does not establish operational runtime reliability.
