# Exphere Website Design System

Source reference: https://getdesign.md/clickhouse/design-md

This document is the website-specific visual source for Exphere. It adapts the structural language of the ClickHouse design-system analysis—technical density, bold sans display type, mono technical labels, disciplined spacing, small radii, hairline borders, and flat/no-shadow depth. It is not affiliated with ClickHouse and does not reuse ClickHouse logos or the yellow brand accent.

The owner-specific override is mandatory: **all Exphere branding is black**.

## 1. Visual theme and atmosphere

Exphere should read as precise infrastructure software: technical, high-contrast, sparse, and deliberate. Prefer documentation/console clarity over decorative marketing effects. UI should feel engineered rather than ornamental.

- Light-first white canvas.
- Black Exphere identity and primary emphasis.
- Flat surfaces; no gradients, glow, glass effects, or drop shadows.
- Hairline boundaries and compact radii create hierarchy.
- Technical/code moments may use mono typography and data-like labels.
- Do not introduce a chromatic brand accent without a new owner decision.

## 2. Color roles

| Role | Value | Use |
| --- | --- | --- |
| `brand-primary` | `#000000` | Exphere mark, wordmark, primary brand emphasis, primary actions when a black action is appropriate. |
| `canvas` | `#FFFFFF` | Default website and SEO-artwork background. |
| `surface-soft` | `#F7F7F7` | Section separation and low-emphasis technical panels. |
| `surface-card` | `#FFFFFF` | Cards/code frames on the light canvas. |
| `surface-elevated` | `#F2F2F2` | Nested neutral surface; not a brand color. |
| `hairline` | `#D9D9D9` | 1px separators/borders. |
| `ink` | `#000000` | Headlines and primary text. |
| `body` | `#333333` | Running text. |
| `muted` | `#666666` | Captions/secondary text. |
| `muted-soft` | `#8A8A8A` | Tertiary metadata. |
| `on-primary` | `#FFFFFF` | Text/icons on a black interactive surface only. |

Brand assets themselves must not use gray as a substitute for black. Neutral grays belong to interface hierarchy, not the Exphere identity.

## 3. Typography

Reference intent: Inter-like sans hierarchy, bold display, restrained tracking, mono technical content. Do not add a remote font or runtime dependency merely to satisfy this document; use the current typography contract until font loading is separately implemented.

| Role | Size | Weight | Line height | Tracking |
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

Technical/code content should prefer a JetBrains-Mono-compatible monospace stack when that font contract is implemented.

## 4. Spacing and layout

Spacing scale: `4, 8, 12, 16, 24, 32, 48, 96px`.

- Section rhythm uses 96px on wide screens and compresses deliberately on smaller screens.
- Prefer readable technical grids and aligned edges to floating decorative compositions.
- Wide content should cap near 1280px unless the content itself needs a full-bleed technical surface.
- Code/data surfaces may scroll horizontally rather than shrinking code to unreadable sizes.

## 5. Radius and depth

Radius scale: `4, 6, 8, 12px`, with pill/full only for semantics that require it.

- No drop shadows.
- Use 1px hairlines and surface contrast for separation.
- Do not use glow, blur, glassmorphism, bevels, or decorative elevation.

## 6. Components

### Primary actions

- Black fill, white label, 8px radius by default.
- Minimum 40×40px interactive target.
- Hover/active changes remain neutral; do not introduce colored accents.

### Secondary actions

- White/neutral surface, black label, 1px hairline border.

### Cards and code panels

- Flat white/soft-neutral surfaces with 1px boundaries.
- Code panels use mono typography and preserve horizontal scroll on narrow screens.
- Avoid floating cards whose only separation is shadow.

### Badges and technical labels

- Prefer uppercase caption treatment, black text, neutral border/surface.
- Use concise operational vocabulary rather than decorative pills.

## 7. Responsive behavior

- Mobile: `< 768px` — single-column composition, display type reduced, code panels scroll.
- Tablet: `768–1024px` — two-column structures when content supports it.
- Desktop: `1024–1440px` — full technical navigation/composition.
- Wide: `> 1440px` — retain a ~1280px content cap with more surrounding space.

## 8. SEO and brand artwork

- Use a white canvas and pure-black Exphere mark/wordmark.
- Social cards stay flat and technical: black line work, outlined geometry, no gradients/shadows/chromatic accents.
- Favicons/application icons use a black mark on white so the brand itself remains black and legible.
- Preserve source geometry; recolor rather than redrawing the Exphere mark.
- Antialiasing may create neutral gray edge pixels in raster exports. Chromatic pixels are not allowed.

## 9. Guardrails

Do:
- keep the brand black;
- use strong type hierarchy and technical alignment;
- use flat surfaces and hairlines;
- use design roles/tokens rather than one-off values in components;
- update this document first when the website design direction changes.

Do not:
- reintroduce purple or adopt ClickHouse yellow as an Exphere accent;
- copy ClickHouse marks, copy, or product-specific compositions;
- add gradients, glows, or drop shadows to create depth;
- mutate the public `@repo/design` package solely to encode Exphere branding without a separately approved package-level scope;
- infer production SEO facts from visual design.

## 10. Existing motion background exception

The owner explicitly requires preserving the existing `ExphereShader` motion
background on the homepage (October 13, 2026). Its currently implemented
animation and shader colors are a narrowly scoped exception to the general
no-gradients/flat-new-UI guidance above. This does **not** authorize additional
animated layers, shaders, chromatic Exphere brand marks, or a new accent palette.

New homepage content must retain the existing root-layout shader mount and
avoid opaque full-screen overlays that hide the motion. Use simple translucent
white/neutral content surfaces when required for readable black text. The
shared `@repo/web` and `@repo/design` packages are unchanged by this exception.
