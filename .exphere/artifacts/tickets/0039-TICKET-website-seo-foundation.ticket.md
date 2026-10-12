# WEB-SEO-01: Non-indexable website metadata and social assets

**What to build:** Add truthful document and home metadata, prepare static brand-only social images, and retain crawlable noindex behavior without inventing an origin, entity, sitemap, or launch approval.

**Blocked by:** None. This slice uses the same owner-supplied identity and is independently executable from WEB-ID-01. The final PR reviews both slices together.

**Spec:** [SPEC-WEBSITE-IDENTITY-SEO v1](../specs/0017-SPEC-website-identity-seo.spec.md)

**Status:** in-review
**Approval:** The parent's recorded October 12, 2026 request authorizes bounded autonomous implementation and PR creation. It does not approve unknown production facts or waive missing verification.

- [x] REQ-IDSEO-05: valid 1200x630 PNGs and alt sidecars prepared; explicit source gates defer image URLs without duplicating framework descriptors.
- [x] REQ-IDSEO-07: no added visible page content, generators, helper framework, dependencies, existing-ticket edits, or deployment work.
- [ ] REQ-IDSEO-04: root/page metadata and product-truth copy implemented; generated metadata not verified.
- [ ] REQ-IDSEO-06: noindex and crawlable robots implemented with no fabricated origin/entities; actual framework resolution not verified.
- [ ] REQ-IDSEO-08: required build/typecheck/Biome and independent two-axis review evidence unavailable; no done or merge-ready claim.

## Evidence and handoff

SEO source commit `ea7bc05e1f82e65dc19822639170aa2d94c6b0d8` follows the initial spec/tickets. EVID-IDSEO-01 records source/asset checks, hashes, manual review axes, and toolchain failures. Images are prepared assets, not active large-image sharing metadata. Canonical, sitemap, and entity data remain intentionally deferred under DEC-IDSEO-02.

The original filename number 0029 was occupied by concurrent main planning. Only this new ticket was renumbered to 0039; stable ID WEB-SEO-01 and its trailers are unchanged. Existing tickets are preserved. Resume required verification with the existing toolchain before accepting delivery; the scoped implementation authorization remains valid.
