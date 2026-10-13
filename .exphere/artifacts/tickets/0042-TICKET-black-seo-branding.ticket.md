# WEB-BRAND-01: Rebuild website SEO branding in black

**Spec:** [SPEC-WEBSITE-BLACK-SEO v1](../specs/0020-SPEC-website-black-seo.spec.md)
**What to build:** Add the website-local design source and replace the website-consumed purple/graphite identity with a black-on-white Exphere identity across logo, browser/app icons, and social SEO cards.
**Blocked by:** WEB-BRAND-PLAN must be committed first so implementation follows the approved source contract.
**Status:** in-review
**Approval:** The owner's October 13, 2026 request authorizes scoped implementation, review, feature-branch publication, and PR creation. Merge/deploy/indexing are excluded.

- [x] REQ-BSEO-01: website design source implemented and reviewed.
- [x] REQ-BSEO-02: horizontal brand SVG is monochrome black with supplied geometry preserved.
- [x] REQ-BSEO-03: favicon/Apple/app/maskable assets are regenerated and validated.
- [x] REQ-BSEO-04: Open Graph/Twitter cards are regenerated in flat black-and-white technical style and alt text updated.
- [x] REQ-BSEO-05: semantic/application scope remains bounded; metadata/indexing/shared packages are unchanged.
- [x] REQ-BSEO-06: identity provenance and asset validation evidence recorded.
- [ ] REQ-BSEO-07: implementation review, branch/commit/PR traceability, and CI state recorded without overstating evidence.

## Verification record

Reviewed pre-commit implementation snapshot manifest SHA-256: `43e0fd067fee380090253dbe962680e290445493f764eb16d7bd650ca9db6a04`, relative to main baseline `49ba260e45250172e0e4ea090627b724569d420d`.

Observed locally before publication:

- `public/brand/exphere-logo.svg` contains only `#000000`; supplied mark/wordmark path geometry is preserved and no purple, graphite, or yellow color remains.
- `src/app/icon.svg` contains only `#000000` identity on `#FFFFFF` presentation canvas.
- PNG outputs decode at 96×96, 180×180, 192×192, 512×512, 512×512, 1200×630, and 1200×600 as specified. A full RGB scan found zero chromatic pixels in every generated PNG; antialiasing is neutral grayscale only.
- The ICO reports 16, 32, 48, 64, 128, and 256px frames.
- The maskable icon's furthest non-white pixel is 150.673px from center, inside the 204.8px (40% of width) essential-content radius.
- Visual inspection of both social cards shows black Exphere identity, black positioning text, white canvas, restrained technical line work, and no gradient/shadow/chromatic accent. Text is not clipped at 1200×630 or 1200×600.
- Text-source scan found no trailing whitespace. No executable TS/JS, dependency, manifest, metadata, robots, shader, shared-package, or deployment file is changed by the implementation snapshot.

### Standards

Manual Standards review of the same pre-commit snapshot found no actionable repository-standard violation. Artifact naming/numbering follows DD/PRD/SPEC/TICKET rules; project content is en-US; the website-local design contract does not mutate public `@repo/design`; the change adds no dependency/runtime helper, no forbidden parent import, and no speculative service/configuration. Static brand assets remain under their existing framework/public ownership paths. Baseline smell review found no applicable code smell because there is no executable-code change.

The local executor has no independent sub-agent facility, so this is not represented as the skill's parallel independent review. The repository's pull-request CI includes its own independent Standards and Spec agent-review job; its result must be inspected after PR creation.

### Spec

Manual Spec review of the same snapshot found REQ-BSEO-01 through REQ-BSEO-06 implemented in source/assets and no scope creep beyond the allowed change manifest. The existing home-logo visibility decision, noindex/origin gating, metadata copy, manifest semantics, robots policy, shared tokens, shader, dependencies, and deployment configuration remain unchanged. REQ-BSEO-07 remains open until the feature-branch commits, PR declaration, and CI/review status are observed.

No Next.js build/typecheck is claimed from these static asset checks. The PR CI/review result and final GitHub diff are the remaining delivery evidence.
