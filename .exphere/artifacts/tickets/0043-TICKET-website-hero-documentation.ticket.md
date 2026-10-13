# WEB-HERO-01: Introduce Exphere and link to documentation

**Spec:** [SPEC-WEBSITE-HERO-DOCS v2](../specs/0021-SPEC-website-hero-documentation.spec.md)
**What to build:** Turn the empty home page into a responsive, accessible Exphere hero with one truthful project introduction, a documentation CTA linking to the existing repository README, and a small code-style CLI preview using documented commands. Respect the approved black-branded ClickHouse-derived design language while keeping the existing animated shader visible and without restoring the previously disabled SVG logo.
**Blocked by:** None. The approved [website DESIGN.md](../../../apps/website/DESIGN.md) is already present on main.
**Status:** ready-for-agent
**Approval:** The owner's October 13, 2026 request authorizes the scoped hero implementation and explicitly corrects the unimplemented v1 plan to **retain the motion background**; the preceding same-repository PR workflow instruction provides feature-branch/PR delivery authorization. This does not authorize deployment or merge.

- [ ] REQ-HERO-01: One accessible visible h1 and factual experimental-project copy.
- [ ] REQ-HERO-02: One prominent, keyboard-focusable documentation anchor to the existing GitHub README.
- [ ] REQ-HERO-03: Black/white/neutral ClickHouse-derived hero styling, with legible static translucent content surfaces and no *new* chromatic branding, gradients, or shadows; existing motion shader is exempt.
- [ ] REQ-HERO-04: Responsive 1-column/mobile and 2-column/desktop hero without layout overflow.
- [ ] REQ-HERO-05: Static technical card shows only documented CLI commands, no invented results.
- [ ] REQ-HERO-06: Website **retains the existing animated shader mount and visible motion**, with shared package, layout, and dependencies unchanged.
- [ ] REQ-HERO-07: Existing metadata, SEO launch gate, icon/manifest assets and home SVG visibility are preserved.
- [ ] REQ-HERO-08: Review, static and runnable verification evidence, and PR identity recorded.

## Verification

Not yet executed. New documentation hosting and production indexing remain outside scope.
