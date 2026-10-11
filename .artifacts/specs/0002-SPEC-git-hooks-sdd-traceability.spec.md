# Git hooks and SDD traceability

- ID: `SPEC-GIT-HOOKS-SDD`
- Document number: `SPEC-0002`
- Version: `2`
- State: `draft`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md), draft; no broader product approval is inferred.
- Technical owners: the project owner decides scope and policy; the implementation agent prepares the local tooling. Other owners are unassigned.
- Authorization: on October 11, 2026, the owner requested this specification through `to-spec`. The requested direction includes hooks, build/test before push, an informational harness score, and advisory SDD traceability. Implementation, dependency installation, commits, and remote publication have not been authorized by this specification's creation.

## Contract and composition

- Requirements addressed: `REQ-HOOK-01` through `REQ-HOOK-08`, below.
- Components selected by the consumer: pnpm and Turborepo already used by this repository; Husky, lint-staged, commitlint with its conventional configuration, and harness-score. Reuse Biome for supported staged files. Resolve compatible maintained dependency versions at implementation time, record Node requirements, and pin resolutions in the pnpm lockfile without unrelated upgrades or bypassing package-age policy.
- Environment and executor: local developer Git operations through POSIX shell adapters. The existing pnpm version remains authoritative. No CI service, hosted PR integration, or workflow engine is introduced.
- Extension points and lifecycle: installation configures hooks; pre-commit checks staged changes and reports the harness score; commit-msg validates the message; pre-push checks build/test and emits SDD warnings. The existing SDD lifecycle remains unchanged.
- Configuration, secrets, and ownership: configuration and rule documents belong to the project. Local hooks require no new credentials. Ticket and spec identities come from the existing [artifact tracker](../agents/0006-DD-artifact-tracker.dd.md), not branch-name guesses or a new tracker.

### Problem and current evidence

The repository has no installed hook chain connecting local quality checks, Conventional Commits, and ticket/spec traceability. The existing commitlint configuration extends a dependency that is not declared. Root build and Biome commands refer to unavailable shell helpers. There is no root test command, Turbo test task, or existing test suite. The SDK has a build command, but its availability is not evidence of a successful build.

The current postinstall invokes the existing Exphere user-local command setup. Adding Husky must preserve that behavior. This directory currently has no Git metadata, so installation must distinguish an archive or non-Git checkout from a developer repository; hook presence cannot be reported as active enforcement here.

The owner now wants build and test in pre-push. That is a scoped change from the earlier blanket test prohibition for the requested hook workflow. During implementation, update conflicting agent and Dev workflow instructions to record that exception. It does not authorize running tests while drafting this spec or adding unrelated application test coverage.

### User stories and observable requirements

| ID | User story and acceptance behavior |
| --- | --- |
| REQ-HOOK-01 | As a contributor, I want postinstall to configure Husky while preserving Exphere setup, so a supported local installation activates the hooks without an extra undocumented step. Repeating setup is safe; intentional skips are explicit. |
| REQ-HOOK-02 | As a contributor, I want pre-commit to run lint-staged with the existing linter, so relevant staged changes are checked without accidentally including unrelated edits. Lint failures block the commit. |
| REQ-HOOK-03 | As a reviewer, I want commit messages checked against Conventional Commits, so message structure is consistent. Invalid ordinary messages fail in commit-msg; ticket mapping remains a separate warning. |
| REQ-HOOK-04 | As a maintainer, I want `pnpm harness:score` to invoke `npx harness-score` and report during pre-commit, so I can observe the harness without a minimum score, level, or improvement target. |
| REQ-HOOK-05 | As a contributor, I want pre-push to run the real root build and test commands, so their failures stop a code push. Missing commands or an empty test placeholder cannot be reported as success. |
| REQ-HOOK-06 | As a contributor, I want each commit associated with one ticket and each PR with one spec, so SDD work stays traceable. Missing, conflicting, or unresolved associations warn for now and do not by themselves block commits or pushes. |
| REQ-HOOK-07 | As an agent or reviewer, I want an SDD operating rule and an evidence-based guardrail under `.exphere/`, so the same advisory policy governs the workflow and hooks, including pre-push. |
| REQ-HOOK-08 | As a maintainer, I want the Dev workflow and agent instructions to explain checks, warning behavior, bypass limitations, and the scoped test-policy change, so documentation matches the implemented local controls. |

### Hook and command behavior

| Entry point | Required behavior | Failure policy |
| --- | --- | --- |
| Root postinstall | Run the existing Exphere setup and configure Husky through one shell orchestration entry. Install only when Git and the development toolchain are applicable. | Explicit intentional skips; real setup failures remain visible and nonzero. |
| Pre-commit | Run lint-staged on eligible staged files, report harness-score once for the project root, and remind the author of ticket traceability. The final message is not available at this stage. | Lint failures block. Score findings or an unavailable score warn, without a numerical gate. |
| Commit-msg | Pass the actual proposed message to commitlint and inspect its ticket declaration against local artifacts. | Conventional message errors block; SDD association findings warn. |
| Pre-push | Inspect outgoing associations, report PR/spec verification limits, then run `pnpm build` followed by `pnpm test` for the checked revision. | Build/test failures block. SDD findings remain non-blocking. |
| `pnpm harness:score` | Resolve the installed scanner locally and invoke `npx harness-score` from the project root, with no target argument or minimum threshold by default. | Preserve scanner diagnostics and execution errors for the caller. The pre-commit caller explicitly downgrades scanner unavailability to a warning. |

### Implementation decisions

1. **Keep automation in shell.** Package scripts invoke `.sh` adapters. Husky's standard extensionless Git hook entry names are thin delegates to those adapters, not a reason to place orchestration in package-script strings. Tool-native configuration may use its supported declarative format.
2. **Use postinstall as requested.** Husky documents a prepare-based initializer; this project deliberately invokes its setup from the existing postinstall lifecycle instead. Do not overwrite the Exphere setup, add a second automatic setup path, or run the default initializer blindly. Support linked-worktree Git metadata as well as ordinary repositories. Respect `HUSKY=0`, CI, production-only installs, and installs with lifecycle scripts disabled. Missing development dependencies in an intentional production-only install are a skip; missing required tooling in a normal development install is an error. A no-Git checkout skips hook activation without initializing Git or claiming it succeeded.
3. **Make required commands real.** Repair only the missing root adapters needed by lint, build, and test. Preserve the SDK build. Add a meaningful test entry for this hook/traceability contract and route declared workspace tasks through Turborepo; avoid recursive root-task dispatch. An empty runner, unconditional success, or merely declaring a Turbo task does not satisfy the test requirement. Select the smallest compatible test mechanism when implementing the proposed verification seam.
4. **Preserve staging boundaries.** Match Biome-supported files and existing exclusions. Use check-only linting by default; let contributors apply fixes explicitly. Retain lint-staged's protection for partially staged work, quote filenames, and handle spaces, deletions, and no matching files. Do not use repository-wide lint commands that ignore the staged file arguments. Unsupported files are explicitly outside this linter's coverage, not silently claimed as checked. The scanner's separate project-wide view is diagnostic and is not staged-content verification.
5. **Use the correct message hook.** Conventional Commits is the message convention, implemented by the declared commitlint CLI and conventional configuration. Reuse the existing configuration where compatible. Commitlint belongs in commit-msg, because pre-commit does not receive the final commit message. Document upstream ignored-message behavior; do not invent a stricter type taxonomy or rewrite existing history.
6. **Keep the score informational.** Add harness-score as a declared development tool so hooks do not depend on an implicit download. Verify the local executable before invoking `npx`; a missing tool must not trigger an interactive install or network fallback during a commit. No score target, minimum level, baseline-improvement requirement, badge, or automatic report artifact is introduced. A failed scan is unavailable evidence, not a score of zero or a successful scan. Do not change the harness merely to improve its score.
7. **Use explicit associations.** Proposed notation is a `Ticket: <stable-ticket-id>` commit trailer and a `Spec: <stable-spec-id>` declaration in the PR body. Resolve existing IDs independently of artifact filename numbers, using the prospective committed index in commit-msg and the outgoing commit trees in pre-push. Uncommitted artifacts do not establish a committed association. One commit covers one ticket; one PR covers one spec, with its tickets belonging to that spec. Reusing a ticket ID across corrective commits is allowed; the rule does not require rewriting history into a strict one-commit-per-ticket bijection. A linked ticket need not already be marked done, and the checker never closes it or records approval automatically. Missing, duplicate, ambiguous, or nonexistent IDs produce actionable warnings.
8. **Do not infer remote PR state.** Local pre-push has commit/ref information, not authoritative PR metadata. Check outgoing commit-to-ticket links and the tickets' declared parent specs locally. If they span multiple specs, warn. Without actual PR metadata, explicitly report PR-to-spec verification as unavailable and remind the contributor of the PR requirement. A locally coherent candidate spec does not prove that a PR references it. The review/delivery workflow checks the actual PR declaration when available; hooks do not require hosting credentials, network calls, or remote mutations.
9. **Inspect the actual outgoing range.** Use pre-push's supplied ref updates, not only the latest commit or a hardcoded default branch. Handle multiple updates, new branches, deletions, and force-updates. Deduplicate commits. When remote objects or complete history are unavailable, warn about incomplete SDD coverage rather than fetch implicitly or claim an exhaustive result. Deletion-only updates need no source build. Tag updates are identified separately from branch work. Initial support for build/test is the checked-out commit: a code update targeting another revision must stop with a clear verification-scope error rather than label the wrong revision tested. Require a clean tracked source state for that gate; do not stash, switch branches, or discard work automatically.
10. **Keep warning severity independent.** Report SDD findings before blocking quality commands so the contributor can see both. Warnings and checker failures remain visible but do not replace or mask lint/build/test exit codes. Hooks are local conveniences that can be bypassed; no server-side enforcement, authenticated approval, or organizational compliance is claimed.

## Responsibilities

- Consumer: provide the ticket association, prepare the PR's spec declaration, choose implementation scope, and keep local artifacts accurate. Commit and PR contents still require human review for semantic alignment.
- Platform: implement the local hooks and command contracts, preserve user changes, publish the SDD rule and guardrail in the Exphere directory, and report evidence and limitations honestly.
- Service owners: own application-specific test coverage and targets. This initiative introduces no service SLO, score target, production policy, or workload benchmark.

### SDD rule and guardrail

Create one SDD operating rule and one SDD guardrail under `.exphere/`, grouped with rules and guardrails respectively. Link them from the existing agent entry points, policy index, and Dev workflow instead of creating a competing tracker or migrating unrelated policies. The rule describes what contributors and agents do; the guardrail defines the observable criteria below.

| Criterion | Evidence | Initial action |
| --- | --- | --- |
| SDD-01: each commit belongs to one ticket | Message declaration, resolved local ticket identity, and reviewed change scope | Warn for missing, unresolved, or conflicting links. Semantic scope alignment remains a review responsibility. |
| SDD-02: each PR belongs to one spec | Actual PR declaration and the referenced spec; tickets trace to that same spec | Warn for missing or conflicting evidence. Local pre-push reports unavailable PR metadata explicitly. |
| SDD-03: pre-push reports traceability for the outgoing work | Inspected ref range, association findings, and coverage limitations | Emit warnings without making SDD a blocking gate. |

Use the existing policy assessment vocabulary: `compliant`, `non-compliant`, `not-verified`, and `not-applicable`, with rationale and inspected revision. Assessment and enforcement severity are different: missing SDD evidence is not compliance, but this new policy is explicitly advisory for now. This scoped warning mode takes precedence over generic wording that would make missing SDD evidence block delivery; it does not weaken unrelated guardrails or failed quality commands.

The Dev workflow explains pre-commit, commit-msg, and pre-push in execution and delivery; review checks ticket/spec alignment; audit distinguishes tool output from semantic evidence. Update the current test prohibition consistently across affected guidance to allow this requested build/test gate and its scoped verification once implementation is authorized. Other phases and external effects retain their authorization boundaries.

## Operation and limits

- Resources, isolation, permissions, and capacity: local CPU, storage, and process execution only. Keep checks bounded to the project and staged/outgoing scope as appropriate. Do not add cloud services, model calls, telemetry, or a hosted dependency for traceability.
- Failures, timeouts, cancellation, and cleanup: preserve actual command exit status and report cancellation as incomplete. Clean only task-owned temporary files. Preserve lint-staged recovery behavior and user changes; no blanket reset or stash deletion. A hook error is not permission to bypass checks automatically.
- Installation, updates, and removal: use pnpm and its lockfile, retain Exphere setup, and make repeated hook setup safe. Do not replace a custom existing hooks path without detecting the conflict and reporting it. Do not modify a consumer's Git hooks through an SDK dependency-install side effect; this spec configures the repository's developer workflow.
- Observability and execution correlation: show check name, outcome, examined revision or range, and warning reason. Record verification in this spec or its eventual tickets. Do not create reports under untyped artifact names or treat a console score as approval.
- Out of scope: package publication, remote PR creation or editing, CI/branch protection, automatic project-directory generation, a workflow executor, score targets, application feature work, unrelated test suites, and changes to existing microruntime behavior.

## Verification and decisions

- Affected guardrails: proposed SDD v1 criteria above; existing 12F-01 for revision identity, 12F-02 for declared tools, 12F-05 for build versus delivery, and 12F-12 for versioned local automation. Existing [policy criteria](../../.agents/guardrails/README.md) remain authoritative outside the explicit SDD warning scope.
- Applicability and planned evidence: review manifests/lockfile and shell entry points; observe hook outcomes at the selected revision; retain skip reasons and warnings. Service networking, persistence, capacity, scaling, and availability are not applicable to this local tooling change. All behavioral evidence is currently `not-verified`.
- Cost/consumption impact: local checks add unmeasured developer CPU/time and dependency installation traffic. The scanner documents local static analysis; installation may still need network access. No paid service or AI execution is introduced, and no savings or zero-cost claim is made. FIN paid-resource criteria are not applicable to this scope; reassess if it expands.
- Open issues and exceptions: no Git metadata exists in the working directory; do not initialize it as a drafting side effect. Exact dependency versions and Node compatibility remain implementation-time verification. The proposed trailer notation and test mechanism are draft decisions, not historical conventions.
- Verification plan: `VER-GIT-HOOKS-SDD`, below.
- Trade-offs: fast blocking lint and Conventional Commits checks; more expensive build/test before push; informational scoring and advisory traceability while conventions are adopted. PR evidence is checked where it exists, with an honest local limitation before the PR is created.
- Technical review: pending; reviewers, examined revision, and evidence to be recorded after authorized implementation.

### VER-GIT-HOOKS-SDD

**Proposed primary seam:** the externally visible Git-hook lifecycle in a disposable local repository, through the same shell entry points used by developers. Use a local bare remote for push scenarios; no hosted repository or real project commit is required. The current project has no prior equivalent test suite. Confirmation of this proposed seam is required before implementation under the invoked skill; drafting does not execute it.

Good tests assert accepted/rejected operations, warning content, preserved staging, and artifact associations. They do not mirror helper internals. Use controlled tool outcomes for failure cases, and record real installed-tool integration separately. Fixture operations must not recursively invoke the verification suite. No production or service probes are needed.

| Scenario | Observable acceptance |
| --- | --- |
| Development install, repeated setup, and supported Git worktree | Husky is active once and existing Exphere setup is preserved; setup is not duplicated. |
| Non-Git, CI, production-only, disabled Husky, or disabled lifecycle scripts | Activation is skipped or unavailable with the documented reason; no Git repository or shell state is fabricated as verified. |
| Supported staged files, partial staging, spaces, deletions, and no matches | Only eligible staged content is linted; unrelated edits remain intact; lint failure prevents commit. |
| Valid and invalid Conventional Commit messages | commit-msg evaluates the actual message; invalid ordinary messages fail. Missing ticket links warn independently. |
| Valid, missing, duplicate, and unresolved ticket/spec identities | Findings match the local records and remain warnings; references do not auto-approve or close artifacts. |
| Low harness score or unavailable scanner | No score target blocks a commit; failed scanning is reported as unavailable. Manual command errors remain distinguishable from valid low scores. |
| Build failure, test failure, missing command, and real success | Code push fails on quality errors; success requires real checks rather than placeholders. |
| New branch, multiple refs, deletion, force-update, incomplete history, and non-checked-out source | Range and verification scope are correct or explicitly limited; no unrelated revision is declared tested. |
| PR missing or unavailable before push; later PR references the wrong spec | Pre-push warns without claiming remote verification; delivery review records the actual mismatch when metadata is available. |

Drafting verification is limited to source inspection, primary-source research, and this document's consistency. No dependency was installed and no hook, build, test, score scan, commit, or push was executed to produce this spec.

### Primary-source notes

Consulted October 11, 2026. Project requirements and proposals above are local decisions; the sources establish tool behavior, not project approval.

- [Husky setup](https://typicode.github.io/husky/get-started.html) uses prepare in its initializer; [Husky operation guidance](https://typicode.github.io/husky/how-to.html) covers skips and POSIX hook entry points. Postinstall is this project's explicit lifecycle choice.
- [lint-staged](https://github.com/lint-staged/lint-staged) documents staged-file tasks, partial-staging protection, recovery, and argument handling.
- [commitlint local setup](https://commitlint.js.org/guides/local-setup.html) places validation in commit-msg; [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) defines the message convention.
- [Git hooks](https://git-scm.com/docs/githooks) defines pre-push arguments, ref-update input, and nonzero rejection behavior. It does not supply PR metadata.
- [harness-score](https://github.com/paladini/harness-score) documents local scanning, a reusable development dependency, and optional minimum-level gating. This project requests no such threshold.

## Revision 2 — reviewed publication authorization

On October 11, 2026, the owner authorized Git initialization on main, supplied origin, and then requested correction of review findings, a feature branch from main, commits and normal pushes, and mandatory code-review in an Exphere rule or guardrail. Force pushes are prohibited. HOOK-05 records this delivery work; a remote PR and deployment are not authorized.

REQ-HOOK-09: establish the initial project baseline, require Standards and Spec review before completion/commit/push, preserve one ticket per commit, and publish the reviewed feature branch through normal pushes to the supplied origin. The hook implementation and its execution evidence will be delivered on the feature branch. This baseline imports the project state captured before that implementation; it does not claim the planned hook behavior is already present.
