# Dark-only website and grayscale motion palette

Reference maintenance: successor links below point to the later website refresh, not to the source reviewed in this historical cycle. Original revisions and review hashes remain authoritative.

- ID: `SPEC-WEBSITE-DARK-THEME`
- Document number: `SPEC-0022`
- Version: `1`
- State: `source implemented; in review; runnable checks pending`
- PRD: [PRD-WEBSITE-DARK-THEME](../prd/0004-PRD-website-dark-theme.prd.md)
- Design decision: [ADR-0002](../design/0010-DD-website-design-system-branding.dd.md), amended only for the website dark theme under this request; [current successor and retained provenance](0031-SPEC-website-docs-refresh.spec.md#retained-asset-provenance).
- Existing feature: [SPEC-WEBSITE-HERO-DOCS v2](0021-SPEC-website-hero-documentation.spec.md) — hero/docs and shader preservation remain in force.
- Ticket: [WEB-DARK-01](../tickets/0044-TICKET-website-dark-theme.ticket.md)
- Baseline: `bc9e838b3b0fe3fd5736ce8fcf0ce25930239aa3` (`main`).
- Authorization: owner's October 13, 2026 request asks for ClickHouse dark-only theme, dark shades and white typography, no white cards, and explicit PRD → SPEC → ticket → implementation → commit → PR. Existing motion preservation from the prior instruction is retained. Merge, deploy and SEO release are not authorized.

## Product and technical contract

Only the existing en-US home route is affected. Render the same hero, factual experimental-project text, CLI examples and Docs link while switching to dark-only presentation. Avoid inventing a docs site, API, or production capability.

**Selected palette from the ClickHouse reference:** canvas `#0a0a0a`; soft `#121212`; card `#1a1a1a`; elevated `#242424`; border `#2a2a2a`; headline `#ffffff`; body `#cccccc`; muted `#888888`. Adapt the reference's yellow CTA to **white on black / black on white**, not yellow. The only Exphere logo asset color remains `#000000`. Existing SVG/favicon and social images are not recolored.

App Router root remains a server layout and a single `ExphereShader` wrapper. Select the existing `@repo/design` dark mode with `data-theme="dark"`, dark viewport `colorScheme`, dark `themeColor` and dark manifest colors. Website-only Tailwind semantic tokens expose the dark palette; do not write authored application CSS selectors or change the brand-neutral `@repo/design` sources.

The shared `ExphereShader` gets one optional, typed, **four-color palette** input (`primary`, `primaryHover`, `background`, `surface`). Without that prop it must behave exactly as before with its default light token palette. When supplied, those colors take precedence in both the CSS static gradient and WebGL uniform inputs via CSS custom properties on the decorative layer. The website passes dark neutral shades such as `#303030`, `#484848`, `#0a0a0a`, `#121212`. Do not rewrite animation code, DOM flow, lifecycle, reduced motion, or WebGL fallback. This opt-in API extension expressly supersedes the earlier children-only restriction in `SPEC-EXPHERE-SHADER` solely to support the owner's newly authorized dark consumer; original no-config behavior must remain backward compatible.

## User story

As a visitor, I want Exphere's website and moving background in dark graphite/black shades with high-contrast white text and no white cards, so the design matches the selected reference without losing its motion or documentation entry point.

## Requirements and acceptance

| ID | Contract | Verification |
| --- | --- | --- |
| REQ-DARK-01 | Dark document and browser chrome | `<html data-theme="dark">`, root background dark, color scheme dark, viewport `#0a0a0a`, manifest theme/background dark. |
| REQ-DARK-02 | Dark UI surfaces | All hero cards and code panes use dark semantic site tokens; white only for text/action, not card or hero backgrounds; no colored accent. |
| REQ-DARK-03 | Contrast and responsiveness | White headline; #ccc body; readable muted labels; white/black CTA with visible keyboard focus; unchanged responsive grid and overflow behavior. |
| REQ-DARK-04 | Motion preserved with dark palette | Exactly one root shader mount; WebGL source/lifecycle unchanged; fallback uses same grayscale palette and never reverts to light/purple. |
| REQ-DARK-05 | Shared API compatibility | Optional palette is the only new shared shader prop; default consumer and old tests continue to work; existing consumer fixture checks dark override and fallback. |
| REQ-DARK-06 | SEO/branding continuity | No change to root/page metadata other than viewport; no canonical/sitemap, no indexability, no asset or disabled home-logo change; docs destination and CLI commands unchanged. |
| REQ-DARK-07 | Bounded and reviewable | Planning is committed before implementation; all commits have one Ticket trailer; both review axes inspect identified files; PR body contains `Spec: SPEC-WEBSITE-DARK-THEME`. |

## Allowed change manifest

- `.exphere/artifacts/prd/0004-PRD-website-dark-theme.prd.md`
- this spec
- `.exphere/artifacts/tickets/0044-TICKET-website-dark-theme.ticket.md`
- `.exphere/artifacts/design/0010-DD-website-design-system-branding.dd.md` (historical theme supersession note only)
- the retired website visual contract, `apps/website/README.md`
- `apps/website/src/app/globals.css`, `apps/website/src/app/layout.tsx`, `apps/website/src/app/page.tsx`, `apps/website/src/app/manifest.webmanifest`
- `packages/web/src/react/exphere-shader/exphere-shader.tsx`
- `packages/web/README.md`
- `packages/web/tests/consumer/src/app/page.tsx`
- `packages/web/tests/shader.spec.ts`

Only the already-installed framework, package test seam, and documented tokens may be used; no new files, runtime dependencies, scripts or non-scoped configuration.

## Ownership, operation, limitations

- Website owns dark brand/UI application, palette choice and its document metadata.
- Public `@repo/web` owns a backwards-compatible opt-in shader palette input, not website-specific constants. `@repo/design` remains public and generic.
- No backing service, budget, secret, API, or infrastructure effect. Theme values are static and run locally; no toggle or client state.
- Root and page metadata continue to prevent indexing; accessibility and browser animation cannot be asserted without actual browser evidence.

## Decision log

- **DEC-DARK-01:** Supersede the light-first website surface contract in ADR-0002 and SPEC-WEBSITE-HERO-DOCS; retain black logo master assets.
- **DEC-DARK-02:** Exphere's white text/CTA are neutral interface contrast roles, not an alteration to the black brand mark; clickhouse yellow remains excluded.
- **DEC-DARK-03:** Explicit palette injection into the existing motion component is preferable to an opaque overlay, replacing the shader, global token mutation, or applying CSS brightness filters to the full page.
- **DEC-DARK-04:** Keep current noindex SEO, Docs URL, and CLI truth untouched.

## Verification plan

1. Inspect the source tree/patch and verify every path in the allowed manifest; compare to the pinned baseline.
2. Confirm all page surface classes resolve to dark tokens; verify no white card surfaces or chromatic accents. Check theme variables and dark viewports/manifest.
3. Run the existing `@repo/web` consumer/browser seam with a dark fixture and a WebGL-unavailable fallback; ensure default no-prop behavior remains unchanged and reduced-motion code is untouched.
4. Run `pnpm --filter website typecheck`, `pnpm build --filter=website...`, `pnpm check`, and the relevant pre-push build/test gate when a full installed checkout is available. Missing commands do **not** count as passing.
5. Review same source snapshot on Standards and Spec axes under SDD v1; report independent review limitations explicitly.
6. Open PR with spec declaration; inspect actual changed file list and CI result. No merge or deployment.

### Evidence

### Source snapshot and traceability

- Initial base: `bc9e838b3b0fe3fd5736ce8fcf0ce25930239aa3` (`main` after PR #16).
- Planning commit: `faa097ecb11bd25e0dba4466990fcdcf99155d43`, preceding implementation.
- Implementation commit: `357eac6c9c429c0ab0270d16a40ac12b7635ecc1`.
- Compare against the fixed base: **2 commits ahead, 0 behind, 14 authorized paths changed**; no unrelated paths or dependency/lockfile changes.
- Reviewed source blob identities:
  - Website page: `fff4d977136e3ab826120fb0259c9da9334fc9c8`.
  - Website root layout: `825f6f3662b3b661fb3e5219c4ee0ddef510de7e`.
  - Tailwind site token bridge: `f08de8e8555498025dbaa4c9bf91dbf55f48366f`.
  - Shared shader opt-in adapter: `94d7afbad88db2101a2fa5a38c21989eefec4f5d`.
  - Shared shader consumer regression test: `a99d3dc481920e799a0428870e22e2383132577a`.

### Verified statically

- Page root has `data-theme="dark"`, dark `colorScheme`, viewport `#0a0a0a`; manifest theme/background are `#0a0a0a`. The generic public dark foundation remains unchanged.
- Website exposes semantic `site-*` Tailwind roles matching the recorded palette. All hero/CLI panel background utility classes use `site-soft`, `site-card` or `site-elevated`, and none uses a white/light card background. White is reserved for typography and the documentation action.
- The existing hero heading, docs URL and both documented CLI commands remain. Page-level metadata and the commented-out home logo remain unchanged; original black logos, favicons and social assets were not modified.
- Exactly one `ExphereShader` root mount remains. The site passes four grayscale values; the shader applies them as CSS custom properties on its decorative node. The existing `surface.ts` and `shaders.ts` motion, reduced-motion/visibility handling and WebGL program are unchanged. No-prop consumers retain the light theme; a change in supplied palette reinitializes through the existing cleanup path.
- The existing Playwright consumer seam now tests the default palette, dark override and WebGL-unavailable gradient fallback. These are **authored tests**, not a claim that they ran.
- Contrast arithmetic at the documented opaque color pairs: body `#ccc` on `#121212` 11.67:1; muted `#888` on `#1a1a1a` 4.91:1; code `#ccc` on `#242424` 9.67:1; heading `#fff` on `#121212` 18.73:1; black CTA text on white 19.80:1. These are theoretical token-pair values, **not** observed contrast over animated/translucent composites.

### Standards review (sequential, source-only)

Compared this identified snapshot to `AGENTS.md`, the artifact tracker,
SDD v1, styling/frontend/Next.js/SEO metadata rules, the existing design
decision and the common code-smell baseline. No actionable source-level
violation was found: existing public token sources remain generic, website
classes use the Tailwind integration, the optional shared component input
preserves existing default behavior, and no speculative library or state
mechanism was introduced. The eleven implementation paths are a coherent
theme/motion change rather than an unbounded package refactor.

### Spec review (sequential, source-only)

REQ-DARK-01, -02, -03 and -06 are satisfied at the inspected **source**
level. REQ-DARK-04/-05 are implemented and covered by fixture assertions,
but **runtime continuity and fallback remain unverified** until the existing
Playwright/Next.js commands execute. REQ-DARK-07 awaits actual PR and CI
metadata. No new Docs route, public origin, tracking claim, indexing, source
logo colorway, runtime service, or animation algorithm was added.

### Outstanding required checks

A full installed checkout is not available in this connector-only execution:
the project's TypeScript check, production build, Biome, browser/Playwright
suite and local pre-push hook were **not executed**. The GitHub API does not
execute local hooks. No result is represented as a successful run, and
visual readability over animated frames cannot be certified by source review.

The required code-review skill calls for independent parallel Standards and
Spec agents. Only **separate sequential self-review** occurred here; do not
claim independent approval. Prior CI for this repository has sometimes
reported success while agent-provider execution was skipped, so inspect the
new PR run/report before asserting review completeness. No ticket is marked
done or PR merge-ready merely from these source checks.
