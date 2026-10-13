# PRD — ClickHouse-derived dark-only website theme

- ID: `PRD-WEBSITE-DARK-THEME`
- Document number: `PRD-0004`
- State: `approved for the requested implementation scope`
- Product/journey owner: project owner
- Sources: owner's October 13, 2026 dark-theme request, the [ClickHouse design analysis](https://getdesign.md/clickhouse/design-md), [Exphere design contract](../../../apps/website/DESIGN.md), and [website hero spec](../specs/0021-SPEC-website-hero-documentation.spec.md).
- Baseline: `bc9e838b3b0fe3fd5736ce8fcf0ce25930239aa3` on `main`.

## Problem and expected outcome

Exphere's existing hero implements an incorrect white/light interpretation of the selected ClickHouse design reference. White hero cards, light document chrome, and purple-tinted light motion conflict with the owner's explicit dark-only direction.

The user should encounter a cohesive near-black canvas, dark charcoal surfaces, restrained borders, readable white/neutral typography and a documentation CTA. The previously approved motion background must continue animating, but with dark grayscale rather than a light/purple background. This is a visual/theme correction, not a new feature or launch.

## Scope

**Included:** dark-only website canvas and hero, dark cards and CLI panes, white-on-dark text and keyboard affordances, neutral documentation CTA, dark browser/manifest chrome, dark WebGL and CSS fallback palette for the existing motion background, updated website design/identity guidance, a non-breaking palette override on the reusable shader, and regression coverage through its existing consumer test seam.

**Excluded:** dark/light toggle, additional pages or marketing sections, new colors inspired by ClickHouse yellow, new fonts/frameworks, new animation algorithm, removing the motion, changing the pure-black Exphere logo/favicons/SEO artwork, public docs hosting, production launch, indexability, deployment and unrelated packages.

**Dependencies:** existing Next.js App Router + Tailwind, `@repo/design` neutral dark foundational tokens, `@repo/web` shader's current four CSS color inputs, and the root README documentation URL. Preserve the previous PR's factual copy, commands and URL.

## Requirements and acceptance

| Requirement | User-visible outcome | Acceptance evidence |
| --- | --- | --- |
| REQ-DARK-01 | Site is dark-only. | `data-theme="dark"`, dark viewport theme, a near-black canvas, and no user toggle. |
| REQ-DARK-02 | The hero is readable. | White headings; neutral body/muted labels; dark cards, code panes and hairlines; no white/light card background. |
| REQ-DARK-03 | Documentation CTA remains accessible. | The link and destination are preserved, focus is visible, and the neutral white CTA has readable black type. |
| REQ-DARK-04 | Motion continues in dark shades. | Same `ExphereShader` animation, reduced-motion and fallback behavior; grayscale palette supplied to its renderer and CSS fallback. |
| REQ-DARK-05 | Other shader consumers are unaffected. | Optional palette retains the existing no-prop default and adds no additional global theme or dependency. |
| REQ-DARK-06 | Identity and SEO are untouched. | Black logo assets stay black, commented SVG stays disabled, `noindex`/origin-neutral metadata remain, no new SEO claim. |
| REQ-DARK-07 | SDD quality and bounded delivery. | Linked spec/ticket, review of committed snapshot, available tests reported accurately, a branch and a PR with traceability. |

## Decisions, value and measurement

- Exphere's logo artwork remains black; white type and a white action surface are **UI contrast roles**, not a recoloring of the logo/brand asset.
- The visual correction supersedes the light-first **website theme** portion of ADR-0002 and SPEC-WEBSITE-HERO-DOCS; the original black-identity and motion-preservation decisions remain.
- Success can be judged by dark CSS roles, resolved shader palette, preserved behavior and the existing browser fixture. Conversion, indexing, production performance and accessibility in a live browser are unmeasured until verified.
- Scope approval: owner's explicit October 13, 2026 request authorizes PRD, spec, ticket, implementation, commits and PR. Merge/deploy remain unauthorized.
- Technical plan: [SPEC-WEBSITE-DARK-THEME](../specs/0022-SPEC-website-dark-theme.spec.md).
