# WEB-BRAND-02: Rebuild SEO and browser identity in black

**Spec:** [SPEC-WEBSITE-BLACK-BRANDING-SEO v1](../specs/0019-SPEC-website-black-branding-seo.spec.md)
**What to build:** Re-export the website's consumed Exphere logo, favicon, application icons, Apple/maskable resources, and social cards using pure-black Exphere geometry; update identity documentation and black browser theme color while preserving origin-neutral noindex SEO.
**Blocked by:** WEB-DESIGN-01 establishes the website-level visual decision before the asset rebuild.
**Status:** in-review
**Approval:** The owner's October 13, 2026 request authorizes this scoped implementation, commit, publication, review, and PR creation. Merge, deployment, and indexing remain excluded.

- [x] REQ-BSEO-02: consumed identity foreground is pure black and retired purple/graphite brand values are absent.
- [x] REQ-BSEO-03: rebuilt favicon/application assets decode at expected dimensions and icon purposes remain valid.
- [x] REQ-BSEO-04: manifest and browser theme color are black without changing browser-display semantics.
- [x] REQ-BSEO-05: prepared social assets are black identity on white at 1200x630 with accurate alt text.
- [x] REQ-BSEO-06: noindex, crawlability, null origin, and inactive social-image gates are preserved.
- [x] REQ-BSEO-07: bounded diff preserves page content, shader, dependencies, lockfile, deployment, and shared design package.
- [ ] REQ-BSEO-08: verification, review, commit, and PR evidence are recorded.

## Implementation evidence

The rebuilt PNG set was decoded before publication. The 96, 180, 192, and 512
pixel assets and both 1200x630 social cards contain exactly two luminance values:
black and white. The ICO contains 16x16 and 32x32 frames. The supplied geometry
is retained while legacy purple/graphite colors are intentionally superseded.

Final review and published-PR traceability remain pending.
