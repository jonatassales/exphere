# PALETTE-01: Apply the basic design palette

**What to build:** make Exphere's seven supplied light-palette roles available through the existing public CSS and JSON design-token exports, preserving foreground compatibility and existing dark colors.

**Spec:** [SPEC-DESIGN-PALETTE v1](../specs/0011-SPEC-design-basic-palette.spec.md)

**Blocked by:** None.

**Status:** in-review
**Approval:** on October 11, 2026, the owner followed the palette draft with `to-tickets && implement && commit separate branch and raise a PR`. This authorizes this single bounded delivery slice, the spec's light-mode and compatibility mapping, existing public-consumer verification, feature-branch commit/push, and a PR. It does not authorize deployment or registry publication.

- [x] All seven exact palette values reach the public light-theme CSS and JSON exports.
- [x] Light `foreground` aliases `text`; existing public imports remain compatible.
- [x] Shared grayscale foundations, existing dark tokens, and non-color categories remain unchanged.
- [x] Package documentation and current consumer descriptions reflect the basic light palette.
- [x] The existing public-consumer fixture verifies the palette, compatibility alias, deterministic builds, invalid-input preservation, and semantic-token watch updates.
- [x] Package build/type checks are recorded for the actual scope; the full build/test delivery gate remains pending push.
- [x] Independent Standards and Spec reviews inspect the same identified snapshot before commit and push.

## Evidence

The feature branch starts from main revision `002fd2462f98ab138991224a21ab93ac6b54358d`. Ticket number 0026 follows the highest local ticket number already allocated in the owner's original checkout; unrelated drafts are excluded.

### Local verification — October 11, 2026

- Environment: macOS local worktree, Node.js `26.8.2`, pnpm `12.4.2`, Turborepo `2.11.7`; existing pinned dependencies installed from the local cache. No resource benchmark or cost measurement was performed.
- Installation: the first offline install populated dependencies but its postinstall refused to replace an existing user CLI installation. Setup was then explicitly skipped with `EXPHERE_SKIP_USER_SETUP=1`; the frozen offline install and separate repository hook initialization completed. No user profile or existing CLI installation was changed.
- Red: the updated public-consumer fixture failed before the token edit because `primary` was absent, with expected value `#6D0AD6`.
- Green: the focused Turborepo run for design `test`, `typecheck`, and `build` passed all three tasks. The consumer fixture verified all seven light values, foreground aliasing, unchanged dark roles, deterministic outputs, invalid-input retention, both exports after a watched light-token edit, and clean watcher shutdown.
- Preservation: a canonical JSON comparison against the base confirmed unchanged grayscale foundations and dark data. A Git comparison confirmed unchanged typography, dimensions, effects, compiler, manifest, and website application source.
- Static checks: Biome checked the changed color data without fixes; whitespace inspection returned no diagnostics.
- Policy assessment: `12F-01` and `12F-05` local v1 have source identity and generated-output evidence for this package scope. FinOps resource/cost criteria and deployable-service factors are not applicable. SDD commit/PR associations remain pending delivery; no general compliance or release-readiness claim is made.
- Limits: no browser rendering, interaction, accessibility, production, or registry checks were performed. The full repository build/test gate will run through the existing pre-push hook on the committed revision.

### Implementation review — October 11, 2026

Two independent reviewers examined the tracked diff and complete spec/ticket additions against base `002fd2462f98ab138991224a21ab93ac6b54358d`. The ordered manifest contains the root README, website README, design README, consumer fixture, color source, palette spec, and this ticket. Both confirmed SHA-256 `26e8d2e61d7aecaff0512af6ec4364ff312fff44c77e128e2a248b4e94df558d` for the ordered per-file SHA-256 listing before this evidence-only update.

- Standards: 0 actionable findings. Scope, artifacts, semantic ownership, authorization, and evidence follow current rules. The owner's accepted spec explicitly reuses the existing public-consumer fixture; its established embedded Node architecture is retained only within that authorized fixture, without introducing a new helper or a general automation exception.
- Spec: 0 actionable findings. All five requirements are covered by the supplied palette, compatibility alias, preserved values, public-export/watch checks, and documentation.

Local implementation is complete. The ticket remains `in-review` for the requested PR review; the delivery gate outcome belongs to the actual outgoing revision and PR validation record.
