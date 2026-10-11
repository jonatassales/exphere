# RULE-01: Import and integrate the agent rule corpus

**Spec:** [SPEC-AGENT-RULE-IMPORT v1](../specs/0007-SPEC-agent-rule-import.spec.md)

**What to build:** contributors can reach the complete engineering and frontend rule corpus through the local index, with four-digit Markdown identities, readable applicability, pinned provenance, and explicit adaptations that preserve Exphere's existing contracts.

**Blocked by:** None.

**Status:** in-review
**Approval:** on October 11, 2026, the owner requested `to-tickets`, `implement`, and commit/push on a separate branch after receiving SPEC-AGENT-RULE-IMPORT v1. This single ticket delivers that same complete scope and its static verification seam; there are no added slices, dependencies, or product decisions requiring separate approval.

- [x] All ten source rules and the source index are accounted for at one pinned revision.
- [x] All four frontend guardrail references have local coverage across twelve numbered Markdown rules.
- [x] Descriptions, applicability, naming, provenance, and active references are complete and valid.
- [x] Local shell, configuration, stack ownership, evidence, and test-authorization contracts remain authoritative; every substantive source adaptation is visible.
- [x] The index preserves existing FinOps, Twelve-Factor, SDD, and authorization guidance; unrelated files remain unchanged.
- [x] Standards and Spec reviews assess the same complete snapshot and actionable findings are resolved.
- [ ] The authorized branch is committed under the configured identity and pushed after required local gates pass.

## Verification and delivery

Use the specification's document-corpus seam. Application tests and probes are not introduced. Existing pre-commit, commit-msg, and pre-push gates remain required for the authorized publication.

Branch: `codex/agent-rule-import`, based on `origin/main` at `300c25cd77f5acfda5f0e35f1b9f99250b411643`.

Implementation review: Standards — 0 findings; Spec — 0 findings. Both reviewed all fifteen scoped files against the same hash manifest (`cbe9befa82ed6d90e8de41c34c03ebc453e25928e904d0a99e229425f149a2e3`). Static coverage, naming, local links/anchors, and preservation checks passed. The parent specification records the reviewed source, corpus digest, and limitations. Subsequent edits to this record only report evidence and state.

Delivery evidence: commit and push pending; the ticket remains in review until publication succeeds.
