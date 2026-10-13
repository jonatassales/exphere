# Exphere Website Design System

Source reference: https://getdesign.md/clickhouse/design-md

This is the website-specific visual contract. Exphere adapts the **dark-only**,
high-contrast, technical system described in the ClickHouse DESIGN.md analysis.
The reference is inspiration, not affiliation. Neither ClickHouse artwork,
product copy nor its electric-yellow brand accent is copied.

The Exphere logo/favicons remain pure black. White UI text and black-on-white
actions are contrast treatments, not new colorways for those brand assets.

## 1. Dark-only visual direction

The website has **no light mode**. Use a near-black canvas, white display
typography, neutral gray body text and subdued charcoal surfaces. Cards and
panels are only slightly lighter than the background; use hairline separators
and a flat/no-shadow appearance rather than floating decorative cards.

The existing ExphereShader motion background **must remain active**. Its colors
are adapted to dark grayscale via the reusable shader's optional palette input.
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
| `site-on-light` | `#0a0a0a` | Text on white CTA (same as canvas). |

There are **no white cards, white page regions, or light hero panels**.
White is allowed only for text, high-contrast focus treatment and interactive
action surfaces. Exphere artwork itself stays black, with existing opaque white
asset support backgrounds (favicons/social images) left unchanged.

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
Cap wide editorial content at approximately 1280px. The hero uses an editorial
plus technical 2-column grid on desktop and one column on narrow screens.

Code panels should scroll horizontally rather than clipping commands. Preserve
comfortable touch targets and visible keyboard focus at all widths.

## 5. Radius, separation and depth

Radii: 4px, 6px, 8px and 12px; full pills only for actual tags/statuses.
Use flat dark panels with 1px `site-border` hairlines. No drop shadows,
glassmorphism, glowing strokes or newly authored gradients. Existing shader
motion is the intentional exception **behind** these surfaces, not card styling.

## 6. Components

### Primary documentation action

A white (`site-ink`) filled button with near-black (`site-canvas`) label,
8px radius and at least a 40px interactive height. Use a neutral hover state
and an obvious focus-visible outline. Do not import ClickHouse yellow.

### Secondary action

Dark card surface, white text, neutral 1px border.

### Hero cards, feature cards, terminal windows

Use `site-soft` or `site-card` for panels with `site-border` hairlines,
and `site-elevated` for code. Dark semi-opaque panels may reveal restrained
motion while preserving text readability. **Never use a white/cream panel.**

### Technical captions

Use small mono uppercase labels in `site-body`, reserving `site-muted`
for sufficiently contrasting surfaces. Do not decorate labels with badges
solely for visual effect.

## 7. Responsive boundaries

- Mobile: <768px; one column, responsive title sizes and code scroll.
- Tablet: 768–1024px; two columns where appropriate.
- Desktop: 1024–1440px; full editorial + technical hero.
- Wide: >1440px; maintain the centered ~1280px content width.

## 8. Existing motion background in dark shades

The site continues to use `ExphereShader`, retaining its WebGL2 animation,
visibility pause, reduced-motion handling, resource cleanup and static CSS
fallback. The dark website opts into these four grayscale inputs:

| Shader color role | Value |
| --- | --- |
| `primary` | `#303030` |
| `primaryHover` | `#484848` |
| `background` | `#0a0a0a` |
| `surface` | `#121212` |

The optional `palette` input affects both WebGL and the CSS fallback; it does
not create a new effect or change the default palette for other consumers.
Do not replace the shader with an opaque background, tint it purple or add
an unrelated animation.

## 9. Identity, SEO and compatibility

Preserve the existing **black** SVG mark/wordmark, favicon and social assets.
Existing asset support backgrounds may be white; those are not website cards.
The earlier home logo asset remains source-commented. Masthead text uses
legible white UI typography instead of attempting a black-on-black logo.

The website remains pre-launch/`noindex`: keep `metadataBase: null`, no
canonical/sitemap/entity claims, crawlable robots and inactive social URL
metadata gates. Keep the existing factual copy, README documentation URL
and documented CLI commands. No new public documentation domain is implied.

## 10. Decisions and source boundaries

- Website-only neutral colors are exposed through a minimal Tailwind theme bridge.
- The public `@repo/design` package stays generic.
- The shared shader gains one backwards-compatible optional palette input.
- Do not copy ClickHouse branding, yellow CTAs, product claims, or assets.
- [ADR-0002](../../.exphere/artifacts/design/0010-DD-website-design-system-branding.dd.md)
  retains its black-brand identity decision but the earlier light-first **website
  UI surface** is superseded by the owner's October 13, 2026 dark-only change
  in [SPEC-WEBSITE-DARK-THEME](../../.exphere/artifacts/specs/0022-SPEC-website-dark-theme.spec.md).
