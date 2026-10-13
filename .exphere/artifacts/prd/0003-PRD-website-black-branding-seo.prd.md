# PRD — website black branding and SEO identity

- ID: `PRD-WEBSITE-BLACK-BRANDING-SEO`
- Document number: `PRD-0003`
- State: `approved for this scoped implementation`
- Product/journey owner: project owner
- Sources: owner's October 13, 2026 instruction; [ClickHouse DESIGN.md analysis](https://getdesign.md/clickhouse/design-md); supplied `exphere-identity-seo(1).zip`; [SPEC-WEBSITE-IDENTITY-SEO](../specs/0017-SPEC-website-identity-seo.spec.md); [SPEC-WEBSITE-HOME-LOGO-VISIBILITY](../specs/0018-SPEC-website-home-logo-visibility.spec.md)
- Baseline: `49ba260e45250172e0e4ea090627b724569d420d` on `main`

## Problem and outcome

The website's current SEO/browser identity still carries the earlier purple and graphite Exphere palette, while the owner has selected the ClickHouse DESIGN.md analysis as the website's design-system reference and required all Exphere branding to be black.

The expected outcome is a single, documented website design direction plus rebuilt brand/SEO assets whose Exphere mark and wordmark are pure black. The website remains origin-neutral and non-indexable until a production origin and launch policy are separately accepted.

The value hypothesis is consistency: future website work receives one app-local visual contract, while browser, application, and social identity stop presenting a superseded purple brand. No product capability, production launch, or indexing improvement is claimed by this change.

## Scope

- Included:
  - Record the ClickHouse DESIGN.md analysis as the website design reference and adapt its technical typography, spacing, shape, and flat-elevation principles for Exphere.
  - Override the reference palette for Exphere branding: the brand mark, wordmark, favicon foregrounds, application-icon foregrounds, and social-card identity are `#000000`.
  - Rebuild the currently consumed browser/application/social assets from the supplied Exphere geometry.
  - Keep supporting canvases white or transparent where needed for legibility; those surfaces are not additional Exphere brand colors.
  - Keep the home logo source commented out as required by WEB-ID-02.
  - Preserve the existing noindex/origin-neutral SEO launch gate.
- Out of scope:
  - New marketing sections, navigation, copy, product UI, animations, or restoring the visible home logo.
  - Changing the generic public `@repo/design` package to carry Exphere-specific branding.
  - Production origin, canonical URL, sitemap, structured entity data, deployment, indexing, analytics, or Search Console.
  - Copying ClickHouse logos, trademarks, product content, or its yellow brand color.
- Dependencies and constraints:
  - Next.js App Router conventions and existing metadata ownership remain unchanged.
  - Static assets must remain dependency-free and preserve the supplied Exphere geometry.
  - This request authorizes the scoped artifacts, implementation, commits, review, branch publication, and PR; it does not authorize merge or deployment.

## Requirements and acceptance

| Requirement | Behavior/outcome | Verifiable criterion | Expected evidence |
| --- | --- | --- | --- |
| REQ-BSEO-01 | Canonical website design direction | `apps/website/DESIGN.md` records the source, adaptation, typography, spacing, surfaces, shapes, and black-brand override | Source review |
| REQ-BSEO-02 | Black Exphere identity | Every consumed SVG/raster brand foreground is `#000000`; purple and graphite brand foregrounds are absent | SVG inspection and raster color inspection |
| REQ-BSEO-03 | Browser/application identity | Favicon, app icons, Apple icon, manifest references, and theme color resolve to rebuilt black-brand assets | Asset decode/dimension/manifest checks |
| REQ-BSEO-04 | Social identity | Open Graph and Twitter prepared assets show only black Exphere identity on a neutral support surface and retain correct dimensions | Image inspection |
| REQ-BSEO-05 | Safe SEO behavior | Existing noindex, crawlable robots, null metadata base, and inactive social-image URL gates remain intact | Source diff and metadata review |
| REQ-BSEO-06 | Bounded architecture | No Exphere brand values are added to `@repo/design`; home content, shader, dependencies, lockfile, and deployment configuration remain unchanged | Diff review |
| REQ-BSEO-07 | Traceable delivery | ADR, spec, tickets, verification evidence, two-axis review, and PR traceability identify the delivered snapshot and any evidence gaps | Artifact and PR review |

## Metrics and decision

- Success metrics: all scoped static-asset checks pass; no purple/graphite branding remains in consumed website identity assets; no new runtime dependency or production-origin claim is introduced.
- Targets not yet approved: search performance, social engagement, Core Web Vitals, conversion, indexing, or launch metrics.
- Scope approval: approved by the project owner in the October 13, 2026 request for PRD, ADR, specs, tickets, implementation, review, and PR delivery.
- Implementation decisions: [ADR-0002](../design/0010-DD-website-design-system.dd.md) and [SPEC-WEBSITE-BLACK-BRANDING-SEO](../specs/0019-SPEC-website-black-branding-seo.spec.md).
