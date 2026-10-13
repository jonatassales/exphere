# Website design-system and monochrome branding decision

- ID: `DD-0010`
- Decision ID: `ADR-0002`
- Status: `accepted for the website scope`
- Responsible owner: project owner
- Decision date: October 13, 2026
- Artifacts assessed: `PRD-WEBSITE-DESIGN-BRANDING` v1, `SPEC-WEBSITE-DESIGN-SYSTEM` v1, `SPEC-WEBSITE-BLACK-SEO` v1, supplied identity pack, and the ClickHouse design-system analysis.

## Context

The website needs a durable design language before broader UI work proceeds. The owner selected the ClickHouse analysis at `https://getdesign.md/clickhouse/design-md` as the design reference and explicitly required all Exphere branding to be black. The reference emphasizes high-contrast technical presentation, bold sans-serif display typography, mono code treatment, compact radii, fixed spacing, hairline borders, and flat/no-shadow depth. Its yellow brand accent conflicts with the Exphere direction and therefore cannot be adopted literally.

The current website identity artifacts use purple and graphite. The home logo is temporarily commented out, but its underlying asset, favicons/app icons, and prepared social cards remain part of the website identity surface.

## Options

| Option | Expected benefit | Cost/risk | Evidence |
| --- | --- | --- | --- |
| Keep the current purple identity and generic website styling | No migration work. | Conflicts with the owner's new brand decision and allows future visual drift. | Current website assets and identity record. |
| Copy the ClickHouse palette including yellow | Strong visual similarity to the reference. | Violates the explicit black-brand requirement and risks imitating source branding rather than adapting its system. | ClickHouse design-system analysis. |
| Adopt the structural ClickHouse language but transform the Exphere brand to monochrome black | Preserves the selected technical rhythm while creating a distinct Exphere identity. | Requires regenerated identity assets and a documented local adaptation. | Owner direction plus the reference's typography/layout/elevation rules. |

## Actual decision

Adopt the third option.

1. The former website visual contract recorded the website-specific design source for this historical cycle. It adapts the selected ClickHouse design language; it does not assert affiliation or copy ClickHouse marks.
2. Exphere brand primary is `#000000`. Brand marks, wordmarks, favicon/app marks, and social-card identity use black. White is the presentation canvas/background, not a second brand accent.
3. Preserve the reference's technical principles: bold display hierarchy, mono treatment for technical/code content, 4/8/12/16/24/32/48/96 spacing, 4/6/8/12 radii, hairline borders, and no drop shadows. The website remains light-first until a separately approved dark-mode implementation exists.
4. Do not update shared `@repo/design` tokens in this cycle. This decision governs the website and its SEO identity; package-level token migration requires its own implementation scope because the shared package is public and intentionally independent of Exphere branding.
5. The SEO truth boundary remains unchanged: no production origin, indexability, canonical, sitemap, entity facts, or deployment decision is inferred from the design change.

## Consequences

- Existing purple/graphite website identity assets are superseded by monochrome black versions while preserving geometry.
- Current website UI changes follow SPEC-WEBSITE-DOCS-REFRESH; the earlier separate visual contract is retired.
- The current commented-home-logo decision remains intact; restoring visibility is a separate owner action.
- Reversal is source-level: restore the previous assets and remove/replace the website design adaptation in a separately reviewed change.
- Review when the owner changes the design reference, allows non-black brand accents, or authorizes a shared-token migration.

## Scoped amendment: dark-only website theme (October 13, 2026)

The project owner superseded the **light-first website UI surface** decision
(point 3 above) with the ClickHouse dark-only appearance. The active website
palette now uses near-black `#0a0a0a`, dark surfaces `#121212`,
`#1a1a1a`, `#242424`, border `#2a2a2a`, white headings and neutral body
text. The documentation action is white/black rather than ClickHouse yellow;
**no white cards** are permitted.

The previous decision that all Exphere logo and identity artwork remains
pure black is **unchanged**. White interface text is a contrast role, not
a new logo colorway. Keep the existing motion effect but feed its WebGL
renderer and fallback a website-selected neutral dark palette through one
optional shared shader input; other consumers retain the previous default.
The noindex/origin-neutral SEO boundary and brand-neutral public design package
are unchanged.

This recorded owner decision is implemented under
[PRD-WEBSITE-DARK-THEME](../prd/0004-PRD-website-dark-theme.prd.md) and
[SPEC-WEBSITE-DARK-THEME](../specs/0022-SPEC-website-dark-theme.spec.md).

## Scoped amendment: OLX-inspired purple UI accent (October 13, 2026)

The owner has now selected a single purple action/emphasis accent in place
of the ClickHouse design reference's bright yellow-lime accent, while
keeping the dark-only website surface and the existing ExphereShader
background motion. Website-level semantic roles use `#6d0ad6` for the
action, `#8c3bef` for its hover state and readable `#ba86ff` for
small purple text on dark surfaces. The historical Exphere token value
`#6d0ad6` is an **OLX-inspired choice**, not an independently certified
official OLX brand specification.

This decision supersedes the prior UI-only prohibition on purple accents,
but **does not supersede the black-logo/SEO identity decision**. The
existing Exphere black logo, favicon and social assets remain unchanged.
The site retains `#0a0a0a` background and neutral dark panels. The
same WebGL motion and static fallback receive dark-purple colors through
the existing optional `ExphereShader` palette prop; no animation or
public-package implementation changes are authorized.

The implementation follows
[PRD-WEBSITE-PURPLE-ACCENT](../prd/0005-PRD-website-purple-accent.prd.md)
and [SPEC-WEBSITE-PURPLE-ACCENT](../specs/0023-SPEC-website-purple-accent.spec.md).
