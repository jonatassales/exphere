# SITE-01: Render the minimal website with shared tokens

**Document number:** `TICKET-0018`

**Spec:** [SPEC-WEBSITE-FOUNDATION v1](../specs/0005-SPEC-website-foundation.spec.md).

**What to build:** Contributors can build and run one minimal English page using the neutral design package and the requested frontend dependencies.

**Blocked by:** DESIGN-01 / TICKET-0016 — Consume generated neutral design tokens. The design exports must build before the website can consume them.

**Status:** done

**Approval:** On October 11, 2026, after the four specifications and proposed verification seams were presented, the owner explicitly invoked `to-tickets` and `implement` together and authorized commits and a push on a separate branch. This ticket is the complete, bounded delivery slice for its parent spec. The request authorizes this execution sequence; no npm publication, deployment, or additional PR is included.

**Dependency evidence:** DESIGN-01 exports, consumer fixtures, and compilation passed before website integration. Both tickets passed the same final review.

## Acceptance criteria

- [x] The private Next.js application declares the requested React, Jotai, Immer, jotai-immer, and Tailwind dependencies with compatible pinned versions.
- [x] The root page visibly consumes public design exports without duplicating editable token values or importing anything from the empty web package.
- [x] App Router ownership, a single alias configuration, Tailwind styling, narrow client boundaries, and domain-owned state rules are documented and followed; no artificial state is created.
- [x] Framework commands use shell adapters and participate in the root workspace task graph. No marketing, authentication, localization, or backend integration is added.
- [x] Type checking and the production build pass. Inspection of generated page/CSS artifacts records token consumption without claiming browser rendering or production readiness; both review axes precede the ticket commit.

## Evidence

Type checking and the production Next.js Webpack build passed. Generated HTML contains lang=en-US, the light theme, the Exphere heading and token-derived Tailwind classes; generated CSS contains the public design variables. Turbopack could not bind its CSS worker port in this execution environment, including an escalated retry; the supported Webpack build option passed. No browser, HTTP/service probe, application test infrastructure, or deployed environment was exercised.

Integration baseline: `300c25cd77f5acfda5f0e35f1b9f99250b411643` on `codex/package-foundations`, with scoped working changes. Pinned pnpm installation, root Biome check, workspace type checking, production builds, and the full hook/CLI/design suite passed on October 11, 2026. User PATH setup was explicitly skipped when verifying Husky activation. Verification ran on Node 26.9.0; the minimum Node version was not separately executed. Standards and Spec reviewers examined snapshot `c5f15b459bfc415172764c4aa16d39fb9ac437207a709e11c0ae471751d3f63d` against the recorded baseline. Standards: zero actionable findings. Spec: one missing-CLI-asset failure was corrected and its public regression passed; follow-up review found zero remaining findings. Unchanged scope retained its first review. Completion is limited to this ticket; runtime browser behavior, real infrastructure, npm release, and production readiness are not claimed.

SDD v1: the ticket-scoped commit must retain its single Ticket trailer. Hosted PR association (SDD-02) remains not-verified because this delivery creates no PR; pre-push checks remain mandatory for the final outgoing revision.
