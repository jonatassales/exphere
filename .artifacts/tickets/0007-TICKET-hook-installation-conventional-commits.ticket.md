# HOOK-01: Activate Conventional Commits through local installation

**Document number:** `TICKET-0007`

**Spec:** [SPEC-GIT-HOOKS-SDD v2](../specs/0002-SPEC-git-hooks-sdd-traceability.spec.md).

**Requirements:** REQ-HOOK-01, REQ-HOOK-03, and the installation/message-validation portion of REQ-HOOK-08.

**What to build:** a contributor performs the normal development installation and receives active Husky hooks with Conventional Commit validation, while existing Exphere command setup remains intact. Unsupported or intentionally skipped activation is reported honestly.

**Blocked by:** None.

**Status:** done

**Approval:** The project owner explicitly invoked `implement` on October 11, 2026 for SPEC-GIT-HOOKS-SDD v1 and this breakdown, after presentation of the disposable Git verification seam. Scoped implementation, dependencies, and hook tests are authorized; project commits and remote publication are not.

## Acceptance criteria

- [x] Husky, the commitlint CLI, and its conventional configuration are declared as development dependencies with compatible Node requirements and pnpm lockfile resolutions. Existing pnpm and package-age policies remain intact; unrelated dependencies are not upgraded.
- [x] Root postinstall orchestrates existing Exphere setup and Husky configuration once through shell adapters. Repeated installation is safe, and no competing prepare-based initializer or SDK consumer hook-install side effect is introduced.
- [x] Ordinary repositories and linked worktrees activate supported hooks. A non-Git directory is reported as skipped without initializing it. A conflicting custom hooks location is detected rather than overwritten.
- [x] Disabled Husky, CI, production-only installs, and disabled lifecycle scripts have explicit activation outcomes. A normal development install with missing required tooling or a real setup failure cannot be reported as successful.
- [x] Commit-msg passes the actual proposed message to commitlint, reusing the existing conventional configuration where compatible. Invalid ordinary messages fail; valid messages pass. Upstream ignored-message behavior is documented without rewriting history or adding an unrelated type taxonomy.
- [x] Standard hook entry names delegate to versioned `.sh` adapters, and package scripts invoke those adapters. Setup and hook execution do not silently download missing tools.
- [x] Once implementation and the verification seam are approved, a small, nonempty contract suite verifies installation and message-validation outcomes at the public hook boundary. It is reusable by the later root test gate, without requiring application feature tests or recursively triggering itself.
- [x] Agent and Dev workflow guidance records the scoped exception to the prior test prohibition for this hook initiative, while retaining unrelated restrictions and external-effect authorization. Documentation explains installation, skips, message validation, and local-hook bypass limitations.
- [x] Verification records identify the examined revision, actual tool versions, pass/fail/skip outcomes, and remaining gaps. No hook file is treated as proof of active enforcement in a directory without Git.

## Verification and handoff

Use the proposed `VER-GIT-HOOKS-SDD` seam: disposable local Git fixtures, with isolated setup effects and the real developer entry points. Observe repeated setup, missing-tool and skip cases, a linked worktree, and accepted/rejected messages. Distinguish controlled failure fixtures from real installed-tool integration. The subsequent explicit implementation request authorized this seam; ticket creation alone did not authorize execution.

The delivered hook installation and reusable contract suite enable staged-file checks and the later push gate independently. Lint-staged, harness scoring, build/test before push, and SDD association warnings are owned by the following tickets rather than being claimed as complete here. No project commit, hosted push, or package publication is included. During implementation, the owner separately authorized initializing Git on main and configuring origin; that local setup is recorded in the spec.

## Implementation record

Implemented under the explicit owner authorization. See [VER-GIT-HOOKS-SDD and REV-GIT-HOOKS-SDD](../specs/0002-SPEC-git-hooks-sdd-traceability.spec.md#implementation-evidence--ver-git-hooks-sdd) for the source snapshot, installed versions, real versus controlled fixture outcomes, and limits. Technical review passed on both Standards and Spec axes with no remaining findings. The owner subsequently authorized commits and normal pushes through HOOK-05; force pushes are prohibited. Publication completed through HOOK-05; the spec records verified remote revisions and the actual pre-push outcome.
