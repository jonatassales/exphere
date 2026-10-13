# Exphere Website Design System

Source reference: https://getdesign.md/clickhouse/design-md

This is the website-specific visual contract. Exphere adapts the **dark-only**,
high-contrast, technical system described in the ClickHouse DESIGN.md analysis.
The reference is inspiration, not affiliation. Neither ClickHouse artwork,
product copy nor its electric-yellow brand accent is copied.

The Exphere logo/favicons remain pure black. White UI text and OLX-inspired
purple interface accents are contrast and interaction roles, not a recoloring
of those brand assets. The main purple `#6d0ad6` reuses an earlier Exphere
token value; it is not presented as a verified official OLX brand specification.

## 1. Dark-only visual direction

The website has **no light mode**. Use a near-black canvas, white display
typography, neutral gray body text and subdued charcoal surfaces. Purple is
the single sparingly used action/emphasis accent, replacing the reference's
yellow-lime. Cards are only slightly lighter than the background; use hairline separators
and a flat/no-shadow appearance rather than floating decorative cards.

The existing ExphereShader motion background **must remain active**. Its colors
are adapted to dark purple-on-black via the reusable shader's optional palette input.
Do not remove the animation, install an opaque overlay, or change its motion
algorithm, reduced-motion support, or fallbacks.

## 2. Color roles

| Website role | Hex | Use |
| --- | --- | --- |
| `brand-asset` | `#000000` | Original Exphere logo/icon artwork; never silently recolor. |
| `site-canvas` | `#0a0a0a` | Global background and browser chrome. |
| `site-soft` | `#121212` | Hero reading surface / subtle bands. |
| `site-card` | `#1a1a1a` | Cards and CLI window. |
| `site-elevated` | `#242424` | Inset terminal/code blocks. |
| `site-border` | `#2a2a2a` | Hairline borders and dividers. |
| `site-ink` | `#ffffff` | Headline, primary text and white CTA surface. |
| `site-body` | `#cccccc` | Body copy, details and important labels. |
| `site-muted` | `#888888` | Secondary metadata where contrast permits. |
| `site-accent` | `#6d0ad6` | OLX-inspired primary action surface (white label). |
| `site-accent-hover` | `#8c3bef` | More luminous purple hover surface (white label). |
| `site-accent-readable` | `#ba86ff` | Short purple headings/labels legible on dark cards. |
| `site-on-light` | `#0a0a0a` | Reserved neutral inverse role, not the primary CTA. |

There are **no white cards, white page regions, or light hero panels**.
White is used for text, the purple CTA's label and high-contrast focus
treatment. Purple accent is restricted to primary actions and restrained
emphasis; neutral body text and all card surfaces remain dark. Exphere artwork
itself stays black, with existing opaque white support backgrounds
(favicons/social images) left unchanged.

Expose these website-specific semantic roles using the existing Tailwind
bootstrap. The public `@repo/design` tokens remain generic and unchanged.

## 3. Typography

The ClickHouse reference uses Inter for display/body and JetBrains Mono for
technical code. Favor a confident bold sans hierarchy, tight negative tracking
on display headlines and legible monospace code. Do not introduce remote fonts
or dependencies merely to satisfy this design guideline; keep the existing
website font tokens until font integration is separately approved.

| Role | Size | Weight | Line-height | Tracking |
| --- | ---: | ---: | ---: | ---: |
| display-xl | 72px | 700 | 1.05 | -2.5px |
| display-lg | 56px | 700 | 1.10 | -2px |
| display-md | 40px | 700 | 1.15 | -1.5px |
| display-sm | 32px | 700 | 1.20 | -1px |
| title-lg | 24px | 700 | 1.30 | -0.3px |
| title-md | 18px | 600 | 1.40 | 0 |
| title-sm | 16px | 600 | 1.40 | 0 |
| body-md | 16px | 400 | 1.55 | 0 |
| body-sm | 14px | 400 | 1.55 | 0 |
| caption | 13px | 500 | 1.40 | 0 |
| caption-uppercase | 12px | 600 | 1.40 | 1.5px |
| code | 14px | 400 | 1.55 | 0 |
| button | 14px | 600 | 1.00 | 0 |

## 4. Spacing and layout

Spacing: 4, 8, 12, 16, 24, 32, 48 and 96px. Use approximately 96px
between major desktop sections and tighter proportional spacing on mobile.
Cap wide editorial content at approximately 1280px. The hero is one centered panel, capped at approximately 900px within the page,
with centered copy and one dark command box. There is no right-hand CLI card.

Code panels should scroll horizontally rather than clipping commands. Preserve
comfortable touch targets and visible keyboard focus at all widths.

## 5. Radius, separation and depth

Radii: 4px, 6px, 8px and 12px; full pills only for actual tags/statuses.
Use flat dark panels with 1px `site-border` hairlines. No drop shadows,
glassmorphism, glowing strokes or newly authored gradients. Existing shader
motion is the intentional exception **behind** these surfaces, not card styling.

## 6. Components

### Primary documentation action

A purple (`site-accent`, `#6d0ad6`) filled button with a white
(`site-ink`) label, 8px radius and at least 40px interaction height.
Hover uses `site-accent-hover` (`#8c3bef`); keyboard focus remains a white
high-contrast outline. Both states retain readable white text. This is the
website's OLX-inspired accent replacing the ClickHouse yellow-lime, not a
literal copy of OLX assets or a second brand mark.

### Secondary action

Dark card surface, white text, neutral 1px border.

### Hero cards, feature cards, terminal windows

Use `site-soft` or `site-card` for panels with `site-border` hairlines,
and `site-elevated` for code. Dark semi-opaque panels may reveal restrained
motion while preserving text readability. **Never use a white/cream panel.**

### Technical captions

Use small mono uppercase labels in `site-body`, reserving `site-muted`
for sufficiently contrasting surfaces. Use `site-accent-readable` for a
limited technical label and terminal prompts on dark surfaces; the main accent
`#6d0ad6` is too dark for small purple-on-black text. Do not decorate labels
with badges solely for visual effect.

## 7. Responsive boundaries

- Mobile: <768px; one column, responsive title sizes and code scroll.
- Tablet: 768–1024px; one centered hero panel.
- Desktop: 1024–1440px; a wider centered hero with no secondary card.
- Wide: >1440px; maintain the centered ~1280px content width.

## 8. Existing motion background in dark purple shades

The site continues to use `ExphereShader`, retaining its WebGL2 animation,
visibility pause, reduced-motion handling, resource cleanup and static CSS
fallback. The dark website opts into these four purple-on-black inputs:

| Shader color role | Value |
| --- | --- |
| `primary` | `#36135a` |
| `primaryHover` | `#6d0ad6` |
| `background` | `#0a0a0a` |
| `surface` | `#121212` |

The optional `palette` input affects both WebGL and the CSS fallback; it does
not create a new effect or change the default palette for other consumers.
Purple tones belong to the original shader geometry; do not replace the
shader with an opaque background, add another animated layer, or alter its
lifecycle, reduced-motion and fallback behavior.

## 9. Identity, SEO and compatibility

Preserve the existing **black** SVG mark/wordmark, favicon and social assets.
Existing asset support backgrounds may be white; those are not website cards.
The earlier home logo asset remains source-commented. Masthead text uses
legible white UI typography instead of attempting a black-on-black logo.

The website remains pre-launch/`noindex`: keep `metadataBase: null`, no
canonical/sitemap/entity claims, crawlable robots and inactive social URL
metadata gates. Use the owner-supplied FinOps hero copy and internal `/docs` navigation. The
copyable `npx exphere init` is displayed exactly as requested. Copying does not
execute it; the scaffold and distribution limitations remain documented in the
README without adding an unrequested note to the hero. No new public documentation domain is implied.

## 10. Decisions and source boundaries

- Website-only neutral and purple-accent colors are exposed through the existing Tailwind theme bridge.
- The public `@repo/design` package stays generic.
- The shared shader gains one backwards-compatible optional palette input.
- Do not copy ClickHouse branding, yellow CTAs, product claims, or assets.
- [ADR-0002](../../.exphere/artifacts/design/0010-DD-website-design-system-branding.dd.md)
  retains its black-brand identity decision but the earlier light-first **website
  UI surface** is superseded by the owner's October 13, 2026 dark-only change
  in [SPEC-WEBSITE-DARK-THEME](../../.exphere/artifacts/specs/0022-SPEC-website-dark-theme.spec.md).

## 11. Purple accent amendment (October 13, 2026)

The project owner selected an OLX-inspired purple in place of the reference's
bright yellow/lime accent while keeping this dark-only site and the existing
ExphereShader motion. The accent family is scoped to website UI; the previously
approved **black Exphere logo SVGs and browser/SEO assets are not recolored**.
The shader remains the same WebGL effect and its fallback derives from the
same purple palette via the existing optional palette input.

Source-of-truth requirements: [PRD-WEBSITE-PURPLE-ACCENT](../../.exphere/artifacts/prd/0005-PRD-website-purple-accent.prd.md),
[SPEC-WEBSITE-PURPLE-ACCENT](../../.exphere/artifacts/specs/0023-SPEC-website-purple-accent.spec.md),
and [WEB-PURPLE-01](../../.exphere/artifacts/tickets/0045-TICKET-website-purple-motion.ticket.md).

## 12. Documentation entry amendment (October 13, 2026)

[SPEC-WEB-DOCS](../../.exphere/artifacts/specs/0024-SPEC-website-nextra-getting-started.spec.md)
supersedes the earlier two-column hero, repository-only Docs link and CLI
examples. The hero preserves the dark/purple palette and shader with the exact
owner title and description. Its only action is the dark copy control; the
header's Documentation link reaches the initial Nextra Getting Started page.

Native Orbo elements sit to the left of the header mark (2rem) and footer credit
(1.5rem), in black/gray shades through #666666. They use listening as a decorative
visual state with system reduced motion, without audio or microphone behavior.
The footer credit is `exphere by Grupo OLX © 2026`, with compact accessible
GitHub and organization LinkedIn icons. Brand artwork is unchanged. Nextra
uses a forced dark theme; no light-mode selector is introduced.

### Build compatibility and asset recovery

The documentation build uses native Turbopack with the application MDX provider
alias, preserving server rendering and prelaunch metadata. The completion build
identified corrupt baseline ICO/PNG exports. Their original bytes remain in
`public/brand/`; valid existing SVG/PNG favicon assets remain active, and exact
historical black Apple/512px manifest exports were restored. Social metadata
images remain inactive until valid exports are supplied. [IDENTITY.md](IDENTITY.md)
records exact provenance, checksums and the legacy ICO compatibility limit.
This recovery supersedes earlier claims that all binary assets were valid,
without changing the supplied black vector geometry.
