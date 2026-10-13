# BCTX-DOCS-01: Explain Backstage context and shared team funding

**Spec:** [SPEC-BACKSTAGE-TEAM-BUDGET-DOCS v3](../specs/0029-SPEC-backstage-team-budget-proposal.spec.md)
**What to build:** A reviewable feature proposal with a new whiteboard diagram highlighting Backstage and its logo, the proposed agents directory tree, shared team funding, artifact-informed allocation, and the learning loop. Update the feature register and root README, link the existing feature images, and deliver the documentation through a PR.
**Blocked by:** None for documentation. Implementing the proposed integrations requires separate specification and authorization.
**Status:** in-review
**Approval:** The owner's October 13, 2026 request explicitly authorizes the diagram, feature documentation update, one SPEC, one ticket, and a PR; the follow-up confirms `.agents/features/`. No deployment or merge is authorized.
The subsequent same-day request authorizes a polished root README before publication, using the supplied Platform README Expert role and existing feature images.

- [x] REQ-BCTX-01/02: Backstage logo and context boundary are prominent, with configured read-only access and artifact sources distinguished.
- [x] REQ-BCTX-03/04: Shared team funding, adjustable feature allocations, deterministic reservations, and paid planning coverage agree across prose and image.
- [x] REQ-BCTX-05/06: Proposed agents tree and evidence-based memory/rationale are documented without executable scaffolding.
- [x] REQ-BCTX-07: All thirteen feature IDs, existing assets, runtime schema, and portal/consumer ownership are preserved.
- [x] REQ-BCTX-08: en-US content, local links, provenance, and independent review are verified; actual delivery traceability is assessed in the published PR.
- [x] REQ-BCTX-09: Root README provides a factual overview and quick start, reuses the feature images, distinguishes proposed capabilities, and preserves contributor navigation.

## Verification

Base: `e969af6892a7d355f806d9b458eb134b7925d912` on `origin/main`. Reconciled with the current Go CLI and native-tooling migration before publication.

Reviewed source tree: `5335671fe510aeb7aad7f8e5ffd0eb9e38eec462`. Both independent reviewers inspected this same seven-file snapshot against SPEC v3:

- Standards review: zero actionable violations; documentation, current Go capabilities, native tooling, consumer ownership, and artifact conventions agree.
- Spec review: zero actionable findings across missing requirements, scope creep, or incorrect implementation. All 55 local Markdown file targets resolve and all thirteen feature IDs remain.
- Author checks: `git diff --check` passed; `pnpm check` checked 114 files without fixes; `pnpm ex --help` and `pnpm ex version` succeeded with the Go scaffold. Dependencies installed with the frozen lockfile and no source changes.
- Root README rendered successfully through GitHub's Markdown API. This checks rendered HTML generation, not visual behavior across browsers, themes, or narrow screens.
- Diagram inspected visually; its SHA-256 is `4d454dce5b98870538f17232184cfebe55c55c3421d2922d4b12577e9f20b9ea`. The official logo and previous factory illustration remain unchanged from their reviewed versions.
- Author/committer identity and GitHub account resolve to `jonatassales`. The proposed commit carries `Ticket: BCTX-DOCS-01`; actual commit/PR associations and native pre-push build/test results are publication-stage evidence, to be recorded in the PR.

SDD v1: SDD-01 has reviewed scope and prepared identity, with committed-object verification pending publication; SDD-02 and SDD-03 remain `not-verified` until actual PR and push evidence exists. These evidence-only updates follow the reviewed source snapshot without changing the proposal.

No integration execution, database connection, billing access, runtime provisioning, or savings measurement is claimed. Hosted CI and product acceptance are separate from local documentation review.
