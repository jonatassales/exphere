# SHADER-01: Reproduce the Codex background with Exphere colors

**Spec:** [SPEC-EXPHERE-SHADER v1](../specs/0012-SPEC-exphere-shader.spec.md)

**What to build:** A children-only React wrapper consumed through the web package that reproduces the Codex background's composition and motion with softened Exphere tokens, covering the viewport without adding document overflow. Deliver the package, graceful static states, and verification through a disposable Next.js consumer together.

**Blocked by:** None.

**Status:** in-review
**Approval:** The owner's October 11, 2026 combined `to-tickets` and `implement` request authorizes execution of the preceding spec, including its proposed disposable Next.js/browser seam. This single vertical slice preserves the entire requested scope without an additional decomposition decision. The later instruction to proceed directly to a PR authorizes commit, push, and PR delivery. Production website integration remains outside this authorization.

- [x] Public package export and types accept only children and render server content without hydration errors.
- [ ] The motion surface reproduces Codex forms, composition, and movement using softened public design tokens, with no grain.
- [x] Empty, short, and long content retain their dimensions, natural scrolling, and interaction on desktop and mobile.
- [x] Reduced motion, hidden presentation, context failure, remount, and teardown preserve content and bound graphics resources.
- [x] The disposable public consumer passes the scoped checks and visual evidence records remaining fidelity limits.
- [x] Standards and Spec reviews cover the same final implementation snapshot, including uncommitted changes.

**Review outcome:** Standards: zero actionable findings. Spec: one remaining visual-fidelity finding under REQ-SHADER-03, despite improved curved lighting and diagonal folds. Final six browser checks passed. Per the owner's direction to proceed directly to the PR, hand off as a draft; keep this ticket in-review and the visual acceptance criterion open.
