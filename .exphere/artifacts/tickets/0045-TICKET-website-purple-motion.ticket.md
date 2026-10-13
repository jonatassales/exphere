# WEB-PURPLE-01: Add OLX-inspired purple accent and motion

**Spec:** [SPEC-WEBSITE-PURPLE-ACCENT v1](../specs/0023-SPEC-website-purple-accent.spec.md)
**What to build:** Keep the ClickHouse-derived dark website and existing ExphereShader while replacing neutral/bright-reference accent treatment with a single OLX-inspired purple family. Apply purple to the Docs CTA, restrained hero/CLI labels and background motion; do not recolor the previously approved black logo artwork.
**Blocked by:** None. [SPEC-WEBSITE-DARK-THEME](../specs/0022-SPEC-website-dark-theme.spec.md) has been implemented and merged through PR #17.
**Status:** in-review
**Approval:** The owner's October 13, 2026 request authorizes the dark-on-purple visual refinement. Existing project SDD feature-branch/PR authorization carries forward for this scope; merge/deploy remain excluded.

- [x] REQ-PURPLE-01: dark-only canvas and existing charcoal surfaces unchanged.
- [x] REQ-PURPLE-02: `site-accent`, hover and readable accent tokens belong to website only.
- [x] REQ-PURPLE-03: Docs CTA is purple, retains original URL/label and visible focus, and has white text with adequate contrast at rest/hover.
- [x] REQ-PURPLE-04: heading/technical labels use restrained readable accent without recoloring body copy.
- [x] REQ-PURPLE-05: existing root animation preserved and dark purple motion palette supplied through existing optional shader API.
- [x] REQ-PURPLE-06: no SEO, logo, dependency, shared package, route, or docs changes.
- [ ] REQ-PURPLE-07: review, scoped commit history, and PR evidence recorded.

## Evidence

Source implementation commit: `425f58ac0fcb82a4426b68c7b2d8b354ee557088`
following PRD/spec/ticket planning commit
`226ea9875410b2764a9881c597f9b9f1767ee6cc`.

The parent spec records the two-axis source review, inspected Git blob IDs,
nine-path scoped diff, token contrast calculations and original black brand/
SEO/Docs preservation. Six criteria are checked only as **source-level
implementation**, not runtime acceptance.

REQ-PURPLE-07 is pending actual PR/CI inspection and required executable
evidence. Independent parallel-agent review, Next.js build/typecheck/Biome,
Playwright and visual motion/contrast verification have not run here. Ticket
remains `in-review`; no merge/deploy approval is inferred.
