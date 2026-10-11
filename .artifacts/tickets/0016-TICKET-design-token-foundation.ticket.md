# DESIGN-01: Consume generated neutral design tokens

**Document number:** `TICKET-0016`

**Spec:** [SPEC-DESIGN-TOKENS v1](../specs/0003-SPEC-design-token-foundation.spec.md).

**What to build:** A consumer imports deterministic CSS and canonical JSON generated from one replaceable neutral token foundation.

**Blocked by:** None.

**Status:** in-review

**Approval:** On October 11, 2026, after the four specifications and proposed verification seams were presented, the owner explicitly invoked `to-tickets` and `implement` together and authorized commits and a push on a separate branch. This ticket is the complete, bounded delivery slice for its parent spec. The request authorizes this execution sequence; no npm publication, deployment, or additional PR is included.

## Acceptance criteria

- [ ] The public-intent design package is explicitly versioned and exposes the accepted CSS and JSON imports without a JavaScript runtime API.
- [ ] Four typed source categories supply neutral values; JSON preserves aliases and type metadata while generated CSS preserves validated variable references.
- [ ] Invalid aliases, cycles, duplicate identities, unsupported types, and malformed values fail with useful diagnostics and do not masquerade as a successful partial generation.
- [ ] Finite build and development watch regenerate usable outputs; stopping watch releases its resources. Light and dark selectors are available without a theme UI or persistence.
- [ ] Public-output tests follow red/green cycles, type checking passes, and both review axes examine the final source before its ticket commit.

## Evidence

Public-export fixtures passed for deterministic CSS/JSON, preserved aliases/types, invalid graphs and values, retained outputs after failure, source edits, and watch shutdown. These checks followed failing consumer cases before implementation. Exact declared Node type definitions passed TypeScript checking. Native file watchers hit the host watcher limit; four-file polling with explicit cleanup passed the watch seam.

Integration baseline: `300c25cd77f5acfda5f0e35f1b9f99250b411643` on `codex/package-foundations`, with scoped working changes. Pinned pnpm installation, root Biome check, workspace type checking, production builds, and the full hook/CLI/design suite passed on October 11, 2026. User PATH setup was explicitly skipped when verifying Husky activation. Verification ran on Node 26.9.0; the minimum Node version was not separately executed. Standards and Spec review are pending; missing review is not approval.
