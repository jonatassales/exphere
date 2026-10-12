# WEB-SEO-01: Non-indexable website metadata and social assets

**What to build:** Give the existing home page truthful document and social metadata, prepare static brand-only sharing images, and retain a crawlable noindex state without inventing an origin, entity, sitemap, or launch approval.

**Blocked by:** None. This metadata slice uses the same owner-supplied identity and can be implemented independently of WEB-ID-01. The final PR reviews both slices together.

**Spec:** [SPEC-WEBSITE-IDENTITY-SEO v1](../specs/0013-SPEC-website-identity-seo.spec.md)

**Status:** ready-for-agent
**Approval:** The parent's recorded October 12, 2026 request authorizes this bounded implementation and PR, including scoped auto-approval. Unknown production facts remain unknown.

- [ ] REQ-IDSEO-04: root and page own the appropriate metadata, with en-US product-truth copy and a noindex default.
- [ ] REQ-IDSEO-05: static PNG social images and alt sidecars; image URL activation is deferred without hand-written framework descriptors or preview-origin fallback.
- [ ] REQ-IDSEO-06: crawlable robots, no fabricated canonical/sitemap/entity/profile/localization or AI-crawler policy.
- [ ] REQ-IDSEO-07: no additional page content, generators, helper framework, dependencies, existing-ticket changes, or deployment work.
- [ ] REQ-IDSEO-08: actual validation/review snapshot and PR Spec declaration recorded; unavailable build evidence blocks done and merge readiness.

## Evidence

Not yet implemented. Use VER-IDSEO-01 in the parent spec. Origin-dependent launch metadata is deliberately deferred, not a missing value to replace with a guessed domain.
