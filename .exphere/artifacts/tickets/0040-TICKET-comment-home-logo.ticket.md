# WEB-ID-02: Comment out the home logo

**Spec:** [SPEC-WEBSITE-HOME-LOGO-VISIBILITY v1](../specs/0018-SPEC-website-home-logo-visibility.spec.md)
**What to build:** Temporarily disable the home logo with a source comment, preserving its artwork, SEO, and shader, and publish a separate PR.
**Blocked by:** None; the logo implementation is already present on the recorded main baseline.
**Status:** ready-for-agent
**Approval:** The October 12, 2026 owner request to comment out the home logo and create a PR authorizes this specification v1 and single-ticket correction. Merge and deployment are excluded.

- [ ] REQ-HOMELOGO-01: The complete logo heading and its unused image import are commented out; no replacement content is rendered.
- [ ] REQ-HOMELOGO-02: Metadata and all other SEO, brand, layout, and shader resources remain unchanged.
- [ ] REQ-HOMELOGO-03: The website README explains the disabled logo and restoration; existing tickets/specs remain untouched.
- [ ] REQ-HOMELOGO-04: Review, verification limits, and the separate PR are recorded against the changed snapshot.

## Verification record

Planning precedes implementation. Source checks, execution results, and separate Standards/Spec observations will be recorded here before implementation publication. No build, browser behavior, or independent review is claimed from this planning record.
