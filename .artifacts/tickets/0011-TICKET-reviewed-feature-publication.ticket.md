# HOOK-05: Establish a reviewed baseline and publish the hook feature

**Document number:** `TICKET-0011`

**Spec:** [SPEC-GIT-HOOKS-SDD v2](../specs/0002-SPEC-git-hooks-sdd-traceability.spec.md).

**Requirements:** REQ-HOOK-09; preserve the verified behavior of REQ-HOOK-01 through REQ-HOOK-08.

**Status:** in-progress

**Approval:** On October 11, 2026, after authorizing local Git initialization and supplying origin, the owner explicitly authorized fixing review findings, creating a feature branch from main, committing, and pushing under the project rules. The owner prohibited force pushes and required code-review to be mandatory in a rule or guardrail under `.exphere/`. This does not authorize deployments or a remote PR.

**Blocked by:** HOOK-01 through HOOK-04 for publication of their implementation. Initial baseline preparation can proceed independently.

## Acceptance criteria

- [ ] The empty repository receives an identifiable main baseline representing the project before the hook implementation, with any necessary bootstrap metadata/formatting stated explicitly. Preserve the current working implementation while creating that baseline.
- [ ] An Exphere rule requires both Standards and Spec review of the same snapshot before completion, commit, or push, with re-review after material changes. It distinguishes procedural obligations from automatic hook enforcement.
- [ ] The identified deletion-only/unborn-HEAD defect is corrected and verified. No force push is performed during this delivery; non-fast-forward hook input may be tested without rewriting any remote ref.
- [ ] A feature branch is based on main, and commits have Conventional Commit messages with one resolvable ticket trailer each. Use the existing configured identity and do not include unrelated generated files or secrets.
- [ ] Relevant checks and both review axes pass for the published source. Publish using normal pushes only to the user-supplied origin; verify the remote branch revision afterward.
- [ ] Evidence records the base, feature branch, commit identities, actual publication outcome, and any remaining limitations. No deployment or PR creation is implied.

## Evidence

The remote was inspected with `git ls-remote` and was empty. The task-start source snapshot is retained locally as the baseline for the initial import. Detailed implementation and review evidence belongs to [VER-GIT-HOOKS-SDD](../specs/0002-SPEC-git-hooks-sdd-traceability.spec.md#implementation-evidence--ver-git-hooks-sdd).
