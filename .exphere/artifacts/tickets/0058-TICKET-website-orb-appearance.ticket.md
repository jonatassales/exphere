# ORB-01: Give Home and Docs distinct orb appearances and align the header

**Spec:** [SPEC-WEBSITE-DOCS-REFRESH v1](../specs/0031-SPEC-website-docs-refresh.spec.md)
**What to build:** Implement REFRESH-11: Home's white star palette and glow, Docs' existing black-hole palette, a shared exact 2px downward offset, and Home's Docs label reduced from 20px to 16px.
**Blocked by:** None.
**Status:** in-review
**Approval:** The owner explicitly requested implementation of the complete orb plan and PR delivery on October 13, 2026, then added the 20% Docs-label reduction in the same conversation. This ticket was drafted from those decisions and advanced to execution.

- [x] Apply the two appearances and remove Docs' duplicate offset.
- [x] Preserve orb sizes, animation, reduced-motion behavior, accessibility, and navigation target.
- [x] Complete VER-ORB-01 and record evidence.
- [x] Resolve independent Standards and Spec findings on the same snapshot.
- [ ] Publish a ticket-linked commit and PR against main.

## Evidence

Scoped formatting, production build, website types, and desktop/mobile visual checks passed; see VER-ORB-01. Exact 2px offsets, Home-only glow, dark Docs palette, 16px Docs label and 44px click target were observed. Evidence is retained under `.audits/evidence/runs/orb-appearance/`. Independent Standards and Spec reviews both passed with zero findings against manifest `be60a3be9da55cbcaa6b36293e8f25bc44d929af29e7fdb0959cd6dc74672888`; only review-closure text changed afterward. Publication remains pending. The original checkout and unrelated CLI edits remain outside this ticket. Production deployment is outside this delivery scope.
