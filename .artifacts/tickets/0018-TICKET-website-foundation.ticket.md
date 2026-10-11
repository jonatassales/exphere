# SITE-01: Render the minimal website with shared tokens

**Document number:** `TICKET-0018`

**Spec:** [SPEC-WEBSITE-FOUNDATION v1](../specs/0005-SPEC-website-foundation.spec.md).

**What to build:** Contributors can build and run one minimal English page using the neutral design package and the requested frontend dependencies.

**Blocked by:** DESIGN-01 / TICKET-0016 — Consume generated neutral design tokens. The design exports must build before the website can consume them.

**Status:** in-review

**Approval:** On October 11, 2026, after the four specifications and proposed verification seams were presented, the owner explicitly invoked `to-tickets` and `implement` together and authorized commits and a push on a separate branch. This ticket is the complete, bounded delivery slice for its parent spec. The request authorizes this execution sequence; no npm publication, deployment, or additional PR is included.

**Dependency evidence:** DESIGN-01 exports, consumer fixtures, and compilation passed before website integration. Both tickets await the same final review.

## Acceptance criteria

- [ ] The private Next.js application declares the requested React, Jotai, Immer, jotai-immer, and Tailwind dependencies with compatible pinned versions.
- [ ] The root page visibly consumes public design exports without duplicating editable token values or importing anything from the empty web package.
- [ ] App Router ownership, a single alias configuration, Tailwind styling, narrow client boundaries, and domain-owned state rules are documented and followed; no artificial state is created.
- [ ] Framework commands use shell adapters and participate in the root workspace task graph. No marketing, authentication, localization, or backend integration is added.
- [ ] Type checking and the production build pass. Inspection of generated page/CSS artifacts records token consumption without claiming browser rendering or production readiness; both review axes precede the ticket commit.

## Evidence

Type checking and the production Next.js Webpack build passed. Generated HTML contains lang=en-US, the light theme, the Exphere heading and token-derived Tailwind classes; generated CSS contains the public design variables. Turbopack could not bind its CSS worker port in this execution environment, including an escalated retry; the supported Webpack build option passed. No browser, HTTP/service probe, application test infrastructure, or deployed environment was exercised.

Integration baseline: `300c25cd77f5acfda5f0e35f1b9f99250b411643` on `codex/package-foundations`, with scoped working changes. Pinned pnpm installation, root Biome check, workspace type checking, production builds, and the full hook/CLI/design suite passed on October 11, 2026. User PATH setup was explicitly skipped when verifying Husky activation. Verification ran on Node 26.9.0; the minimum Node version was not separately executed. Standards and Spec review are pending; missing review is not approval.
