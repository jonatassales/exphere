# HOOK-02: Check staged changes and report harness maturity

**Document number:** `TICKET-0008`

**Spec:** [SPEC-GIT-HOOKS-SDD v2](../specs/0002-SPEC-git-hooks-sdd-traceability.spec.md).

**Requirements:** REQ-HOOK-02, REQ-HOOK-04, and the pre-commit portion of REQ-HOOK-08.

**What to build:** contributors receive blocking checks for eligible staged changes and an informational harness score before committing, with a manual pnpm command for the same score and no maturity target.

**Blocked by:** HOOK-01 — Activate Conventional Commits through local installation, which supplies the active hook lifecycle and reusable verification seam. The push-gate and SDD tickets do not block this delivery.

**Status:** done

**Approval:** The project owner explicitly invoked `implement` on October 11, 2026 for SPEC-GIT-HOOKS-SDD v1 and this breakdown, after presentation of the disposable Git verification seam. Scoped implementation, dependencies, and hook tests are authorized; project commits and remote publication are not.

## Acceptance criteria

- [x] lint-staged and harness-score are declared as compatible development tools and resolved through pnpm without unrelated upgrades or implicit runtime installation.
- [x] Pre-commit runs lint-staged with check-only Biome behavior for supported staged files, respecting existing exclusions. Repair only the missing linter adapter needed for this behavior; do not replace staged arguments with a repository-wide check.
- [x] Partially staged edits, filenames containing spaces, deleted files, and an empty matching set preserve the contributor's index and unrelated changes. Unsupported file types are outside declared linter coverage, not reported as checked.
- [x] `pnpm harness:score` invokes `npx harness-score` through a shell adapter from the project root. It verifies local tool availability first and does not trigger a download, interactive install, default target argument, or minimum score/level gate.
- [x] Pre-commit reports the scanner once for the project, independently of staged-file argument batching. Its project-wide view is labeled diagnostic rather than proof that only staged content was assessed.
- [x] A valid low score never blocks a commit. An unavailable scanner produces an explicit warning in the hook, while the manual command preserves execution errors for its caller. Missing evidence is not reported as a zero score or a successful scan.
- [x] Lint failure blocks the commit and is not masked by scanner output or warnings. The final commit message remains the responsibility of commit-msg; pre-commit only reminds the author about ticket traceability.
- [x] Dev workflow guidance describes the staged checks, manual score command, informational severity, and limitations. No badge, report tree, target, or unrelated score-improvement work is added.
- [x] The shared hook contract suite covers the above outcomes and preserves staging on failure. Evidence separates actual scanner integration from controlled unavailable-tool cases and records the evaluated revision.

## Verification and handoff

Extend the proposed disposable-repository seam from `VER-GIT-HOOKS-SDD`, after its confirmation and implementation authorization. Cover a lint rejection, successful eligible changes, partial staging, no matches, unusual filenames, low scores, and scanner errors. Do not run tests while preparing this ticket.

This delivery is independently observable through pre-commit and the manual command. It preserves the existing Conventional Commit hook and does not depend on or claim completion of pre-push behavior. Application tests, remote publication, automatic reports, and score thresholds remain outside scope.

## Implementation record

Implemented under the explicit owner authorization. See [VER-GIT-HOOKS-SDD and REV-GIT-HOOKS-SDD](../specs/0002-SPEC-git-hooks-sdd-traceability.spec.md#implementation-evidence--ver-git-hooks-sdd) for the source snapshot, installed versions, real versus controlled fixture outcomes, and limits. Technical review passed on both Standards and Spec axes with no remaining findings. The owner subsequently authorized commits and normal pushes through HOOK-05; force pushes are prohibited. Publication completed through HOOK-05; the spec records verified remote revisions and the actual pre-push outcome.
