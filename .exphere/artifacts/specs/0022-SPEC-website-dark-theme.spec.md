# Dark-only website and grayscale motion palette

- ID: `SPEC-WEBSITE-DARK-THEME`
- Document number: `SPEC-0022`
- Version: `1`
- State: `approved for scoped implementation; verification pending`
- PRD: [PRD-WEBSITE-DARK-THEME](../prd/0004-PRD-website-dark-theme.prd.md)
- Design decision: [ADR-0002](../design/0010-DD-website-design-system-branding.dd.md), amended only for the website dark theme under this request; [website DESIGN.md](../../../apps/website/DESIGN.md).
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
- `apps/website/DESIGN.md`, `apps/website/README.md`
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

Pending. Record observed checks, source snapshots and remaining gaps before PR publication.
