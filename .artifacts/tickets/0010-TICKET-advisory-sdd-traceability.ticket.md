# HOOK-04: Warn about missing ticket and spec traceability

**Document number:** `TICKET-0010`

**Spec:** [SPEC-GIT-HOOKS-SDD v1](../specs/0002-SPEC-git-hooks-sdd-traceability.spec.md).

**Requirements:** REQ-HOOK-06, REQ-HOOK-07, and the SDD/review portion of REQ-HOOK-08.

**What to build:** contributors receive actionable, non-blocking SDD diagnostics when committing and pushing, while agents and reviewers use the same rule for one ticket per commit and one spec per PR.

**Blocked by:** HOOK-03 — Gate code pushes on real build and test results. This ticket integrates warnings with that live gate and must preserve its blocking outcomes; HOOK-01 is already a transitive prerequisite. HOOK-02 is not required to resolve SDD associations.

**Status:** draft

**Approval:** Not recorded for this breakdown or implementation. Trailer notation and the verification seam remain proposed decisions in the source spec; drafting is not their acceptance.

## Acceptance criteria

- [ ] One SDD operating rule and one SDD guardrail live under the Exphere directory, grouped by rules and guardrails, and are linked from existing agent guidance, the policy index, and the Dev workflow. They define SDD-01 through SDD-03 without creating another tracker or relocating unrelated policies.
- [ ] The proposed ticket trailer and PR spec declaration resolve stable local artifact IDs independently of filename numbers. Commit-msg uses the prospective committed index; pre-push uses outgoing commit trees. Uncommitted artifacts do not establish a committed association.
- [ ] Each commit maps to one ticket and each PR to one spec; tickets in the PR trace to that spec. Missing, duplicate, conflicting, or unresolved IDs warn. Corrective commits may reuse a ticket; the checker neither requires a completed ticket nor approves or closes it.
- [ ] Commit-msg retains blocking Conventional Commit validation while reporting ticket findings as warnings. Pre-commit guidance reminds contributors of traceability without pretending to inspect a message that does not yet exist.
- [ ] Pre-push inspects supplied outgoing ref updates, deduplicates commits, and handles new branches, multiple updates, deletions, force-updates, and tags without assuming a branch name or checking only the latest commit. Unavailable remote objects or incomplete history produce coverage warnings without implicit fetching.
- [ ] Pre-push warns when outgoing ticket relationships span multiple specs. If actual PR metadata is unavailable, it explicitly reports PR-to-spec verification as unavailable and reminds the contributor to declare the spec; it never claims that local consistency proves an actual PR association.
- [ ] Review and delivery guidance requires the actual PR declaration when available. Semantic agreement between changes, ticket, and spec remains a review responsibility; hooks require no hosting credentials or remote mutation.
- [ ] SDD findings and checker failures are visible before blocking quality checks, but cannot reject a commit/push on their own or hide Conventional Commit, lint, build, or test failures. The initial policy is advisory, not a server-side control or authenticated approval.
- [ ] The guardrail separates evidence state from enforcement severity using the existing policy vocabulary. Missing SDD evidence is not compliance; the warning exception applies only to SDD and does not weaken unrelated guardrails.
- [ ] The shared contract suite observes valid/missing/conflicting associations, index-versus-working-tree differences, outgoing-tree resolution, incomplete ranges, unavailable PR metadata, and coexistence of warnings with a failing build/test gate. Record the examined revision and actual review outcome.

## Verification and handoff

Extend `VER-GIT-HOOKS-SDD` at the proposed public hook boundary after confirmation and implementation authorization. Use disposable artifacts and Git fixtures for failures; no live PR API is required. Review actual PR evidence separately when a PR exists, without making remote publication a completion condition for this local-tooling ticket.

Integrate documentation with the existing SDD cycle instead of creating a final documentation-only ticket. Each predecessor owns its own command and verification evidence; this ticket owns traceability and its interaction with the push gate. Score targets, CI enforcement, application features, unrelated tests, and remote actions remain outside scope.
