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

1. `apps/website/DESIGN.md` is the website-specific design source for future UI work. It adapts the selected ClickHouse design language; it does not assert affiliation or copy ClickHouse marks.
2. Exphere brand primary is `#000000`. Brand marks, wordmarks, favicon/app marks, and social-card identity use black. White is the presentation canvas/background, not a second brand accent.
3. Preserve the reference's technical principles: bold display hierarchy, mono treatment for technical/code content, 4/8/12/16/24/32/48/96 spacing, 4/6/8/12 radii, hairline borders, and no drop shadows. The website remains light-first until a separately approved dark-mode implementation exists.
4. Do not update shared `@repo/design` tokens in this cycle. This decision governs the website and its SEO identity; package-level token migration requires its own implementation scope because the shared package is public and intentionally independent of Exphere branding.
5. The SEO truth boundary remains unchanged: no production origin, indexability, canonical, sitemap, entity facts, or deployment decision is inferred from the design change.

## Consequences

- Existing purple/graphite website identity assets are superseded by monochrome black versions while preserving geometry.
- Future website UI changes should consult `apps/website/DESIGN.md` before introducing new website-specific visual values.
- The current commented-home-logo decision remains intact; restoring visibility is a separate owner action.
- Reversal is source-level: restore the previous assets and remove/replace the website design adaptation in a separately reviewed change.
- Review when the owner changes the design reference, allows non-black brand accents, or authorizes a shared-token migration.
