# Website black branding and SEO rebuild

- ID: `SPEC-WEBSITE-BLACK-BRANDING-SEO`
- Document number: `SPEC-0019`
- Version: `1`
- State: `approved; implementation authorized`
- PRD: [PRD-WEBSITE-BLACK-BRANDING-SEO](../prd/0003-PRD-website-black-branding-seo.prd.md)
- ADR: [ADR-0002](../design/0010-DD-website-design-system.dd.md)
- Technical owners: project owner for brand/design/launch decisions; implementing agent for scoped implementation and evidence
- Authorization: the owner's October 13, 2026 request explicitly authorizes PRD, ADR, specification, tickets, implementation, review, a feature branch, commits, publication, and opening a PR. Merge and deployment remain excluded.
- Baseline: `49ba260e45250172e0e4ea090627b724569d420d` on `main`
- Tickets: [WEB-DESIGN-01](../tickets/0041-TICKET-website-design-system-adoption.ticket.md), [WEB-BRAND-02](../tickets/0042-TICKET-website-black-branding-seo.ticket.md)

## Contract and composition

The website remains the existing Next.js App Router application. The current home route, shader, dependencies, generated-token consumption, and commented home logo stay unchanged.

Add `apps/website/DESIGN.md` as the app-local visual contract. It adapts the selected ClickHouse DESIGN.md analysis rather than copying the source brand: structural typography, spacing, shapes, layout, code styling, and flat elevation are retained; Exphere branding is pure black.

Rebuild only the consumed identity assets already owned by the website. SVG geometry comes from the supplied Exphere identity pack. Raster assets are deterministic exports of black Exphere artwork on transparent or white support surfaces. No fonts, generators, runtime libraries, or client code are added.

### Requirements and acceptance

| ID | Required behavior | Acceptance criterion |
| --- | --- | --- |
| REQ-BSEO-01 | Website design contract | `apps/website/DESIGN.md` cites the selected source and defines the Exphere black adaptation without asserting ClickHouse affiliation. |
| REQ-BSEO-02 | Pure-black identity | `public/brand/exphere-logo.svg` and `src/app/icon.svg` use `#000000` for Exphere geometry; raster identity contains black foreground and neutral support pixels only. |
| REQ-BSEO-03 | Browser/application assets | `favicon.ico`, 96px icon, opaque 180px Apple icon, 192/512 app icons, and 512 maskable icon decode at their declared dimensions and retain the Exphere mark. |
| REQ-BSEO-04 | Manifest/browser chrome | Manifest icon paths continue resolving to packaged files; `theme_color` and Next.js viewport theme color are black. `display: "browser"` and white support background remain unchanged. |
| REQ-BSEO-05 | Social assets | Open Graph and Twitter PNGs remain 1200x630, use the black horizontal Exphere logo on white, and have matching alt sidecars. |
| REQ-BSEO-06 | SEO safety | `metadataBase: null`, noindex/follow behavior, crawlable robots, absent canonical/sitemap/entity claims, and explicit inactive social-image lists are unchanged. |
| REQ-BSEO-07 | Scope boundary | `packages/design`, shader source, page content, lockfile, dependencies, deployment files, and home-logo visibility are unchanged. |
| REQ-BSEO-08 | Traceability and review | Planning precedes implementation; commits use one Ticket trailer; both review axes inspect the same branch diff; PR body declares `Spec: SPEC-WEBSITE-BLACK-BRANDING-SEO`. |

### Allowed change manifest

Planning artifacts:
- `.exphere/artifacts/prd/0003-PRD-website-black-branding-seo.prd.md`
- `.exphere/artifacts/design/0010-DD-website-design-system.dd.md`
- this spec
- `.exphere/artifacts/tickets/0041-TICKET-website-design-system-adoption.ticket.md`
- `.exphere/artifacts/tickets/0042-TICKET-website-black-branding-seo.ticket.md`

Website:
- `apps/website/DESIGN.md`
- `apps/website/README.md`
- `apps/website/IDENTITY.md`
- `apps/website/src/app/layout.tsx`
- `apps/website/src/app/manifest.webmanifest`
- `apps/website/src/app/favicon.ico`
- `apps/website/src/app/icon.svg`
- `apps/website/src/app/icon1.png`
- `apps/website/src/app/apple-icon.png`
- `apps/website/src/app/opengraph-image.png`
- `apps/website/src/app/opengraph-image.alt.txt`
- `apps/website/src/app/twitter-image.png`
- `apps/website/src/app/twitter-image.alt.txt`
- `apps/website/public/brand/exphere-logo.svg`
- `apps/website/public/icons/app-192.png`
- `apps/website/public/icons/app-512.png`
- `apps/website/public/icons/maskable-512.png`

The final evidence update may revise this spec and its tickets only.

## Responsibilities

- Consumer/project owner: selected the design reference and black brand direction; retains future production-origin, indexing, inverse-logo, and launch decisions.
- Website: owns app-local design guidance and consumed SEO/browser identity.
- `@repo/design`: remains generic and unchanged.
- Platform/services: no external service, secret, infrastructure, runtime, or paid provider is introduced.

## Operation and limits

No runtime execution path is added. Static assets increase repository bytes only. Existing application build/typecheck/Biome commands remain the verification path; no new test framework or helper script is introduced. The change must not weaken gates if the executor cannot run them.

## Verification and decisions

- Affected rules: SDD v1, styling, Next.js structure, SEO metadata, and frontend ownership.
- FinOps: no cloud resource, paid API, model call, or recurring service is introduced; no financial budget behavior changes.
- Twelve-Factor: no service configuration, backing service, process model, dependency boundary, or deployment contract changes.
- Verification plan:
  1. Decode every rebuilt raster and assert dimensions/mode/opacity expectations.
  2. Inspect SVG fills and raster colors for absence of the retired purple/graphite brand values.
  3. Validate manifest icon paths against repository files and inspect layout/metadata behavior for unchanged noindex/origin gating.
  4. Compare the feature branch to baseline and verify the allowed change manifest.
  5. Run available project checks or CI without weakening the existing toolchain.
  6. Review the same branch snapshot on Standards and Spec axes; record any limitation if independent sub-agents are unavailable.
  7. Open a PR with the required spec declaration and verify published changed paths and commit status.

### DEC-BSEO-01 — Raster treatment

- State: selected.
- Decision: use pure black Exphere foregrounds. Transparent favicon-style output may use alpha; Apple/app/maskable icons use an opaque white support canvas for cross-platform contrast. Social images use a white canvas and black horizontal logo.
- Consequence: support surfaces include white pixels, but the Exphere identity color itself is only black.

### DEC-BSEO-02 — Website design ownership

- State: selected.
- Decision: keep the ClickHouse-derived adaptation in `apps/website/DESIGN.md`; do not modify `@repo/design`.
- Consequence: future website implementation can evolve independently while shared packages stay reusable.

### DEC-BSEO-03 — Launch state

- State: unchanged from SPEC-0017.
- Decision: branding changes do not authorize indexing or a production origin.
- Consequence: no canonical, sitemap, Open Graph URL, structured entity data, or active absolute social-image metadata is introduced.

### Evidence

Pre-PR implementation snapshot: `706d6dae3eb7a95f68738448ae28e36fefd291a3`.
Fixed comparison base: `49ba260e45250172e0e4ea090627b724569d420d`.

- GitHub compare reports five commits ahead, zero behind, and 22 changed paths.
  Every changed path is inside this spec's allowed change manifest; `packages/design`,
  `apps/website/src/app/page.tsx`, shader code, dependencies, lockfiles, deployment,
  robots, and production-origin/indexing configuration are absent from the diff.
- Static asset verification decoded the delivered source set before publication.
  The PNG identity assets are their declared 96, 180, 192, 512, or 1200x630 sizes;
  delivered PNG pixels are one-bit black/white, and the ICO contains 16x16 and
  32x32 frames. The horizontal and icon SVGs use `#000000` for Exphere geometry.
- Manifest and layout inspection confirms a black `theme_color`; browser display,
  white support background, `metadataBase: null`, noindex/follow, and the explicit
  inactive Open Graph/Twitter image lists remain unchanged.
- Commit inspection confirms the scoped branch commits carry exactly one `Ticket:`
  trailer each and planning preceded implementation.
- **Standards axis:** no documented-standard breach was found in the branch diff.
  App Router metadata ownership is retained, no application CSS or speculative
  dependency was added, the public design package stays brand-neutral, and no
  baseline code smell was identified in the changed runtime source.
- **Spec axis:** REQ-BSEO-01 through REQ-BSEO-07 are implemented as specified.
  No requested runtime/page/deployment behavior was added, and no required
  branding/SEO asset is missing from the allowed manifest.
- Project build/typecheck/Biome were not claimed as local passes because this
  connector execution does not provide a repository checkout. No existing gate
  was weakened or replaced.
- Independent parallel sub-agents are unavailable in this execution surface.
  The repository's `.github/workflows/ci.yml` is configured to run independent
  Standards and Spec agent reviews on the pull-request snapshot. REQ-BSEO-08
  remains pending until the PR is published and that review status is inspected.

