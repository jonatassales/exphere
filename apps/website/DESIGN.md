# Exphere website design system

This file is the app-local design contract for `apps/website`.

## Reference and adaptation

The canonical external reference is the public [ClickHouse DESIGN.md analysis](https://getdesign.md/clickhouse/design-md), sourced from the [VoltAgent DESIGN.md collection](https://github.com/VoltAgent/awesome-design-md). It is used as a structural design reference only. Exphere is not affiliated with ClickHouse, and this application does not copy ClickHouse logos, product claims, or its yellow brand identity.

Exphere adopts the reference's technical, developer-focused composition and overrides its brand palette with the owner's current direction:

- **Exphere brand color:** `#000000` only.
- **Support canvas:** `#FFFFFF` where contrast, raster export, or platform-icon requirements need an opaque background.
- **Transparent support:** allowed for SVG/PNG assets when the platform accepts alpha.
- **Retired from Exphere branding:** `#6D0AD6`, `#5408A5`, `#27262A`, and ClickHouse's yellow accent.
- White/transparent pixels are support surfaces, not additional Exphere brand colors.

The generic public `@repo/design` package remains brand-neutral. Do not put Exphere-specific brand values there. Website-specific presentation can bridge semantic roles locally when visible UI work is authorized.

## Visual character

Use a high-contrast, engineered, documentation-adjacent visual language:

- confident sans-serif hierarchy;
- compact technical density rather than soft marketing spacing;
- flat surfaces with hairline separation;
- code and runtime evidence treated as first-class visual material;
- restrained radii;
- no decorative drop shadows, glassmorphism, gradients, glow, or ornamental blur;
- strong alignment and explicit grid structure;
- motion only when it communicates system state or preserves the existing shader behavior.

## Typography

Use the reference hierarchy as the website target:

| Role | Family | Weight | Guidance |
| --- | --- | ---: | --- |
| Display | Inter, sans-serif | 700 | Tight tracking, approximately -1px to -2.5px as size increases |
| Titles | Inter, sans-serif | 600-700 | Compact line height and direct hierarchy |
| Body | Inter, sans-serif | 400 | Approximately 1.5-1.6 line height |
| Labels/navigation | Inter, sans-serif | 500-600 | Small, precise, no decorative casing |
| Code/data | JetBrains Mono, ui-monospace, monospace | 400 | Use for commands, identifiers, logs, and runtime evidence |

Do not derive product typography from the outlined Exphere wordmark. The current website still consumes the generic package's existing font token until a separate visible-UI implementation is authorized.

## Spacing and layout

Use a 4px base rhythm.

| Token | Target |
| --- | ---: |
| xxs | 4px |
| xs | 8px |
| sm | 12px |
| md | 16px |
| lg | 24px |
| xl | 32px |
| xxl | 48px |
| major section | 96px |

- Maximum editorial width: approximately 1280px, centered.
- Prefer explicit grid composition; 12 columns are the reference model.
- Desktop feature areas may use 3-up composition, tablet 2-up, mobile 1-up.
- Preserve readable whitespace but keep the surface engineering-dense rather than oversized and airy.
- Touch targets must remain usable when density increases.

## Shapes and elevation

| Role | Radius |
| --- | ---: |
| Small controls | 6px |
| Standard controls | 8px |
| Cards/panels | 12px |
| Pills | fully rounded, only for actual tags/status badges |

Depth is expressed through surface contrast and 1px hairlines, not shadows. Avoid cards that look detached from the system with heavy elevation.

## Color roles

This contract deliberately separates **brand color** from future **UI semantic colors**.

### Brand

- Brand foreground: `#000000`.
- Brand-on-light support surface: black on white.
- Brand SVG masters should prefer black fills; use `currentColor` only when the consuming context explicitly fixes that color to black.
- Do not introduce purple, graphite, yellow, gradients, or multicolor treatments into Exphere logos, favicons, app icons, or social identity.
- A future inverse/white logo requires a separate brand decision; it is not implied by a dark section.

### UI surfaces

The ClickHouse reference's near-black technical surfaces may inform future UI, but visible website palette work is not part of the current SEO/branding cycle. When implemented, semantic UI colors must be documented separately from the black Exphere brand so status/error/success colors are not mistaken for identity colors.

## Brand asset rules

- Preserve the supplied Exphere geometry and proportions.
- Horizontal wordmark minimum practical height: 28px.
- Do not stretch, skew, rotate, glow, outline, or selectively recolor the orbit/module geometry.
- Browser/application icons may use a white support canvas so the black mark remains legible across platform chrome.
- Social images use a white support canvas and black Exphere identity only.
- The currently commented home logo remains commented until separately restored.

## SEO and metadata presentation

Branding does not change launch state:

- `metadataBase` remains unset/null until a production origin is explicitly accepted.
- The home remains `noindex` while pre-launch.
- Robots remains crawlable so page-level noindex can be observed.
- Do not invent canonical URLs, sitemap entries, structured organization data, social handles, or deployment claims.
- Prepared Open Graph/Twitter images remain URL-gated until origin approval.
- Browser/theme color uses black as the current brand signal.

## Implementation guardrails

- Use App Router conventions directly.
- Keep framework metadata assets under `src/app/`.
- Keep the website-specific design contract in this application.
- Do not add a UI framework, CSS abstraction, metadata helper layer, or design dependency solely to express this file.
- Tailwind remains the application styling mechanism when visible UI is added.
- Preserve the existing shader and current minimal page unless a separate ticket changes them.

## Current implementation state

This design contract is broader than the currently rendered page. In the present cycle only the branding/SEO identity is rebuilt. Typography, card, navigation, and marketing-layout rules above guide future website work; their presence here is not evidence those components already exist.
