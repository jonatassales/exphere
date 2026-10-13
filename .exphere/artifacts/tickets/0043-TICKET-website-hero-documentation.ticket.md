# WEB-HERO-01: Introduce Exphere and link to documentation

**Spec:** [SPEC-WEBSITE-HERO-DOCS v2](../specs/0021-SPEC-website-hero-documentation.spec.md)
**What to build:** Turn the empty home page into a responsive, accessible Exphere hero with one truthful project introduction, a documentation CTA linking to the existing repository README, and a small code-style CLI preview using documented commands. Respect the approved black-branded ClickHouse-derived design language while keeping the existing animated shader visible and without restoring the previously disabled SVG logo.
**Blocked by:** None. The approved [website DESIGN.md](../../../apps/website/DESIGN.md) is already present on main.
**Status:** in-review
**Approval:** The owner's October 13, 2026 request authorizes the scoped hero implementation and explicitly corrects the unimplemented v1 plan to **retain the motion background**; the preceding same-repository PR workflow instruction provides feature-branch/PR delivery authorization. This does not authorize deployment or merge.

- [x] REQ-HERO-01: One accessible visible h1 and factual experimental-project copy.
- [x] REQ-HERO-02: One prominent, keyboard-focusable documentation anchor to the existing GitHub README.
- [x] REQ-HERO-03: Black/white/neutral ClickHouse-derived hero styling, with legible static translucent content surfaces and no *new* chromatic branding, gradients, or shadows; existing motion shader is exempt.
- [x] REQ-HERO-04: Responsive 1-column/mobile and 2-column/desktop hero without layout overflow.
- [x] REQ-HERO-05: Static technical card shows only documented CLI commands, no invented results.
- [x] REQ-HERO-06: Website **retains the existing animated shader mount and visible motion**, with shared package, layout, and dependencies unchanged.
- [x] REQ-HERO-07: Existing metadata, SEO launch gate, icon/manifest assets and home SVG visibility are preserved.
- [ ] REQ-HERO-08: Review, static and runnable verification evidence, and PR identity recorded.

## Verification

The spec's evidence section records source-level inspection at
`eab6e044ccbba6ecd4ba0004fe6ec8de7b02d0dd`: a single accessible hero
heading, documentation link, two truthful CLI command examples, responsive
styling, and preserved `ExphereShader` root mount and visible-layout contract.
No dependencies, shader source, app layout, metadata, icon, or SEO configuration
were changed. No production docs host or indexing is implied.

The manual Standards and Spec review found no actionable source findings.
Independent parallel-agent review, project typecheck/build/Biome, and rendered
browser behavior remain unverified. REQ-HERO-08 stays unchecked and this ticket
remains `in-review`. The final PR reference belongs in delivery metadata and
does not retroactively convert missing checks into passes.
