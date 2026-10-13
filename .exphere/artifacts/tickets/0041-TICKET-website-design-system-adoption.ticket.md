# WEB-DESIGN-01: Adopt the website design-system contract

**Spec:** [SPEC-WEBSITE-BLACK-BRANDING-SEO v1](../specs/0019-SPEC-website-black-branding-seo.spec.md)
**What to build:** Record an app-local `apps/website/DESIGN.md` based on the selected ClickHouse DESIGN.md analysis, adapted for Exphere's pure-black brand and existing architecture.
**Blocked by:** None.
**Status:** in-review
**Approval:** The owner's October 13, 2026 request authorizes this ticket, implementation, commit, branch publication, review, and PR delivery. Merge/deploy remain outside scope.

- [x] REQ-BSEO-01: app-local design contract records source, adaptation, typography, spacing, shapes, surfaces, layout, and black-brand override.
- [x] REQ-BSEO-07: shared `@repo/design`, shader, page content, dependencies, and deployment remain unchanged.
- [ ] REQ-BSEO-08: review and delivery evidence identifies the final snapshot.

## Notes

The design reference is inspiration and a technical UI contract, not ClickHouse affiliation. Do not copy its logo, yellow brand identity, product claims, or marketing content.


## Implementation evidence

- Planning/specification commit: `c0c81fdda7f24d962569968cdf92f78b970450a2`.
- Website design contract commit: `262664b8ec39cf7c2c8b17e39d20d5f230a23c66`.
- Website ownership/readme commit: `75b5feeb425631d1e81ce78bd68b5da16d6ffa4e`.
- `apps/website/DESIGN.md` records the ClickHouse DESIGN.md analysis as a structural reference while explicitly rejecting source-brand yellow and setting Exphere branding to pure black.
- The slice does not modify `packages/design`, the shader, page rendering, dependencies, lockfile, or deployment configuration.
- REQ-BSEO-08 remains open until the final branch snapshot is reviewed and the PR is published.
