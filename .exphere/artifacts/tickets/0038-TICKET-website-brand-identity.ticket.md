# WEB-ID-01: Minimal home and browser identity

**What to build:** Show only the supplied horizontal Exphere logo at the upper left of the home page, retain an accessible heading and the existing shader, and supply browser/application identity through static assets and a manifest.

**Blocked by:** None. The identity was supplied by the owner. WEB-SEO-01 is independently executable; both slices share a delivery review rather than a fabricated dependency.

**Spec:** [SPEC-WEBSITE-IDENTITY-SEO v1](../specs/0017-SPEC-website-identity-seo.spec.md)

**Status:** in-review
**Approval:** The owner's October 12, 2026 request authorizes scoped autonomous planning, implementation, commits, and a PR. The parent spec records scope and limits; missing verification is not waived.

- [x] REQ-IDSEO-02: supplied SVG geometry/colors preserved, raster transformations documented, no font files.
- [x] REQ-IDSEO-03: ICO, SVG/raster/Apple assets and manifest resources pass local format/dimension/opacity/safe-zone inspection.
- [x] REQ-IDSEO-07: source diff is bounded; no preexisting ticket, dependency, shared-package, shader, token, or deployment change.
- [ ] REQ-IDSEO-01: logo/heading and minimal composition implemented in source; actual browser/generated-HTML behavior not verified.
- [ ] REQ-IDSEO-08: required typecheck/build/Biome and independent two-axis review evidence remain unavailable; not done or merge-ready.

## Evidence and handoff

Planning precedes identity commit `433c6e6189048179aeacb1a885bcf742a97e0fb8`. Final source/asset snapshot, checksums, checks, limitations, and both manual review axes are recorded in EVID-IDSEO-01 of the parent spec. Asset checks passed; toolchain commands stopped before execution because pnpm is absent. No independent parallel reviewers ran.

The original filename number 0028 was occupied by concurrent main planning. Only this new ticket was renumbered to 0038; stable ID WEB-ID-01 and its commit trailers are unchanged. Existing tickets are preserved. Resume verification using the project's existing toolchain, then reassess the unchecked criteria; no repeat approval of unchanged scoped implementation is requested.
