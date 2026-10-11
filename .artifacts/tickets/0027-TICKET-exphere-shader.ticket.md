# SHADER-01: Reproduce the Codex background with Exphere colors

**Spec:** [SPEC-EXPHERE-SHADER v2](../specs/0012-SPEC-exphere-shader.spec.md)

**What to build:** A children-only React wrapper consumed through the web package that reproduces the Codex background's composition and motion with softened Exphere tokens, covering the viewport without adding document overflow. Deliver the package, graceful static states, and verification through a disposable Next.js consumer together.

**Blocked by:** None.

**Status:** in-review
**Approval:** The owner's October 11, 2026 combined `to-tickets` and `implement` request authorizes execution of the preceding spec, including its proposed disposable Next.js/browser seam. This single vertical slice preserves the entire requested scope without an additional decomposition decision. The later instruction to proceed directly to a PR authorizes commit, push, and PR delivery. Production website integration remains outside this authorization.

- [x] Public package export and types accept only children and render server content without hydration errors.
- [x] The motion surface reproduces Codex forms, composition, and movement using softened public design tokens, with no grain.
- [x] Empty, short, and long content retain their dimensions, natural scrolling, and interaction on desktop and mobile.
- [x] Reduced motion, hidden presentation, context failure, remount, and teardown preserve content and bound graphics resources.
- [x] The disposable public consumer passes the scoped checks and visual evidence records remaining fidelity limits.
- [x] Standards and Spec reviews cover the same final implementation snapshot, including uncommitted changes.

**Delivery:** [PR #8](https://github.com/jonatassales/exphere/pull/8) is open and not a draft. The owner's follow-up authorizes reviewing and completing that existing PR. The initial handoff had one visual-fidelity finding under REQ-SHADER-03; the final revision review below supersedes that snapshot.

**Revision evidence:** Corrected immediate WebGL program disposal and the package test's missing own-build dependency. Added no-JavaScript server-content verification and console-error observation. The disposal regression failed before the fix and passed afterward; all eight consumer checks passed. The final visual comparison and two-axis review assess the delivered revision recorded in the spec.

**Final review outcome:** Standards: zero actionable findings. Spec: zero actionable findings. Both axes verified the same 28-file manifest, SHA-256 `bc8067cfe43b001e242044b44329a59b0e09cae1ae574738b9d70ba0a684e3b3`. The final curvature, lighting, overlap, and mobile-framing changes resolve the earlier fidelity finding. Implementation and local verification are complete; the ticket remains in-review for owner visual acceptance and PR disposition. This does not claim pixel-identical output or authorize merging.

**Website integration authorization:** The owner's subsequent request to import the component into the `apps/website` layout authorizes the v2 consumer integration, superseding the earlier exclusion above. The application imports the public entry and supplies layout children; deployment and page-content changes remain excluded. Validation uses the existing website type-checking, production compilation, and generated-artifact seam.

- [x] The existing website root layout wraps children once with the public component, declares the workspace dependency, and passes the existing compilation/type-checking seam with the expected server HTML and packaged styles.

**v2 review outcome:** Standards and Spec each reported zero actionable findings against the same 31-file manifest, SHA-256 `ea38d274a157f5848b3aa9d1e8b4bb2f0c84166381dfcda59d5838dc4cd40bdc`. The unchanged component retains its preceding consumer verification and visual review. Website integration is complete; PR and owner visual disposition remain in-review.
