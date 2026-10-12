# WEB-01: Prepare the web package and SmoothUI tooling

**Document number:** `TICKET-0017`

**Spec:** [SPEC-WEB-PACKAGE v1](../specs/0004-SPEC-web-package-foundation.spec.md).

**What to build:** Contributors have the requested public-intent web package structure and installed development tooling, without acquiring or implementing components.

**Blocked by:** None.

**Status:** done

**Approval:** On October 11, 2026, after the four specifications and proposed verification seams were presented, the owner explicitly invoked `to-tickets` and `implement` together and authorized commits and a push on a separate branch. This ticket is the complete, bounded delivery slice for its parent spec. The request authorizes this execution sequence; no npm publication, deployment, or additional PR is included.

## Acceptance criteria

- [x] The package uses the requested public identity and all five source boundaries contain only their placeholder files.
- [x] The official SmoothUI CLI is an exact development dependency recorded in the workspace lockfile. No init or add command runs.
- [x] No entry point names missing implementation, and no React, animation, design, or SDK dependency is introduced without actual consumption.
- [x] Workspace and manifest inspection confirms the intended boundary; no test suite is invented for placeholders.
- [x] The source and evidence pass both review axes before the ticket commit; package publication remains outside this delivery.

## Evidence

Workspace discovery and manifest inspection confirmed @repo/web 0.0.0 with public-intent metadata, exact smoothui-cli 1.1.3 development dependency and lockfile entry, five .gitkeep-only boundaries, and no invented exports or runtime dependencies. The SmoothUI binary was not executed. No placeholder test suite was created.

Integration baseline: `300c25cd77f5acfda5f0e35f1b9f99250b411643` on `codex/package-foundations`, with scoped working changes. Pinned pnpm installation, root Biome check, workspace type checking, production builds, and the full hook/CLI/design suite passed on October 11, 2026. User PATH setup was explicitly skipped when verifying Husky activation. Verification ran on Node 26.9.0; the minimum Node version was not separately executed. Standards and Spec reviewers examined snapshot `c5f15b459bfc415172764c4aa16d39fb9ac437207a709e11c0ae471751d3f63d` against the recorded baseline. Standards: zero actionable findings. Spec: one missing-CLI-asset failure was corrected and its public regression passed; follow-up review found zero remaining findings. Unchanged scope retained its first review. Completion is limited to this ticket; runtime browser behavior, real infrastructure, npm release, and production readiness are not claimed.

SDD v1: the ticket-scoped commit must retain its single Ticket trailer. Hosted PR association (SDD-02) remains not-verified because this delivery creates no PR; pre-push checks remain mandatory for the final outgoing revision.
