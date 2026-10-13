# Website design system and black-brand adaptation

- ID: `DD-0010`
- Decision ID: `ADR-0002`
- Status: `accepted for website branding and future website UI`
- Owner: project owner
- Date: October 13, 2026
- Scope: `apps/website` only
- Sources: [ClickHouse DESIGN.md analysis](https://getdesign.md/clickhouse/design-md), the public [VoltAgent DESIGN.md collection](https://github.com/VoltAgent/awesome-design-md), and the owner-supplied Exphere identity pack.

## Context

The website needs one visual reference that agents can use consistently. The selected ClickHouse analysis describes a technical, developer-focused system with strong sans-serif hierarchy, dense but readable spacing, restrained radii, flat surfaces, code-oriented typography, and no decorative shadow system. Its original yellow-and-black palette is ClickHouse-specific and is not an Exphere brand contract.

The current Exphere identity pack uses purple and graphite. The owner explicitly superseded that color direction and required all branding to be black.

The repository also treats `@repo/design` as a public, brand-neutral package. Putting Exphere-specific brand values into that package would violate its existing ownership decision.

## Decision

1. **Canonical website reference.** `apps/website/DESIGN.md` is the app-local design contract. It records the ClickHouse analysis as the reference and the Exphere-specific adaptation.
2. **Structure over trademarked palette.** Preserve the reference's visual principles: Inter-led hierarchy, JetBrains Mono for code, compact technical density, 4px spacing basis, 8/12px radii, 96px major-section rhythm, approximately 1280px content width, and flat/no-shadow elevation.
3. **Black Exphere branding.** Exphere brand foregrounds use pure black `#000000`. Purple `#6D0AD6`, purple hover `#5408A5`, and graphite `#27262A` are retired from consumed website brand assets. White and transparent pixels may be used only as support surfaces/backgrounds needed for contrast, alpha, or platform icon requirements.
4. **App-local ownership.** Do not change `packages/design` for this brand decision. Future website UI can bridge app-specific semantic roles through the website boundary when visible product work is authorized.
5. **SEO launch gate remains separate.** Branding does not approve a production origin or indexing. `metadataBase` remains null, the page remains noindex, robots remains crawlable, canonical/sitemap/entity data remain absent, and file-based social images remain prepared but URL-gated.
6. **Current home visibility remains separate.** The previously approved home-logo visibility correction remains in force; this cycle rebuilds the source asset but does not uncomment it.

## Consequences

- SEO/browser/application identity becomes monochrome and consistent with the owner's current brand direction.
- Future UI work has a concrete website design source without coupling the generic design package to Exphere.
- ClickHouse's yellow accent is not copied into Exphere branding.
- A future dark marketing surface must place the black brand mark on an explicit light/neutral brand surface or use a separately approved inverse treatment; this ADR does not silently authorize a white Exphere logo.
- Existing production-origin and indexing decisions remain open.

## Alternatives considered

- **Copy the ClickHouse palette literally:** rejected because the owner requires black branding and ClickHouse yellow is source-brand-specific.
- **Change `@repo/design` tokens:** rejected because the package is intentionally public and brand-neutral.
- **Keep the purple identity and only document the new design system:** rejected because it fails the explicit black-brand requirement.
- **Restore the visible home logo while rebuilding assets:** rejected because WEB-ID-02 deliberately keeps that block commented out and the current request does not reverse it.

## Verification

Verification is defined in [SPEC-WEBSITE-BLACK-BRANDING-SEO](../specs/0019-SPEC-website-black-branding-seo.spec.md). This decision records a design direction; it does not itself prove rendered output, deployment, indexing, or brand clearance.
