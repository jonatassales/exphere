# Git hooks and SDD traceability

- ID: `SPEC-GIT-HOOKS-SDD`
- Document number: `SPEC-0002`
- Version: `2`
- State: `done`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md), draft; no broader product approval is inferred.
- Technical owners: the project owner decides scope and policy; the implementation agent prepares the local tooling. Other owners are unassigned.
- Authorization: on October 11, 2026, the owner requested this specification through `to-spec`. The requested direction includes hooks, build/test before push, an informational harness score, and advisory SDD traceability. On October 11, 2026, the owner subsequently invoked `implement` for this spec and HOOK-01 through HOOK-04 after the fixture seam and breakdown were presented. This authorizes scoped implementation, dependency installation, and fixture-based build/test verification; project commits and remote publication were not authorized at that stage; revision 2 below records the subsequent authorization.

## Revision 2 authorization

On October 11, 2026, the owner authorized fixing review findings, creating a feature branch from main, committing and pushing according to the rules, and making code-review mandatory under `.exphere/`. Force pushes are explicitly prohibited. HOOK-05 records this bounded addition. The supplied origin was empty when inspected; baseline preparation preserved the task-start project before publishing the hook implementation. PR creation and deployment remain outside this request.

## Contract and composition

- Requirements addressed: `REQ-HOOK-01` through `REQ-HOOK-09`, below.
- Components selected by the consumer: pnpm and Turborepo already used by this repository; Husky, lint-staged, commitlint with its conventional configuration, and harness-score. Reuse Biome for supported staged files. Resolve compatible maintained dependency versions at implementation time, record Node requirements, and pin resolutions in the pnpm lockfile without unrelated upgrades or bypassing package-age policy.
- Environment and executor: local developer Git operations through POSIX shell adapters. The existing pnpm version remains authoritative. No CI service, hosted PR integration, or workflow engine is introduced.
- Extension points and lifecycle: installation configures hooks; pre-commit checks staged changes and reports the harness score; commit-msg validates the message; pre-push checks build/test and emits SDD warnings. The existing SDD lifecycle remains unchanged.
- Configuration, secrets, and ownership: configuration and rule documents belong to the project. Local hooks require no new credentials. Ticket and spec identities come from the existing [artifact tracker](../agents/0006-DD-artifact-tracker.dd.md), not branch-name guesses or a new tracker.

### Problem and planning baseline

At specification time, the repository had no installed hook chain connecting local quality checks, Conventional Commits, and ticket/spec traceability. At that baseline, the commitlint configuration extended an undeclared dependency, root build and Biome commands referred to unavailable shell helpers, and no root test command, Turbo test task, or test suite existed. The SDK has a build command, but its availability is not evidence of a successful build.

The current postinstall invokes the existing Exphere user-local command setup. Adding Husky must preserve that behavior. At that baseline this directory had no Git metadata, so installation must distinguish an archive or non-Git checkout from a developer repository; hook presence cannot be reported as active enforcement here.

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
| REQ-HOOK-09 | As the owner, I want mandatory two-axis code review in an Exphere rule, correction of review findings, a feature branch from main, ticket-associated commits, and normal pushes to the supplied origin. An empty remote needs an initial project baseline before feature delivery. Force pushes are prohibited. |

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
- Applicability and planned evidence: review manifests/lockfile and shell entry points; observe hook outcomes at the selected revision; retain skip reasons and warnings. Service networking, persistence, capacity, scaling, and availability are not applicable to this local tooling change. The planning baseline was `not-verified`; implementation evidence and remaining limitations are recorded below.
- Cost/consumption impact: local checks add unmeasured developer CPU/time and dependency installation traffic. The scanner documents local static analysis; installation may still need network access. No paid service or AI execution is introduced, and no savings or zero-cost claim is made. FIN paid-resource criteria are not applicable to this scope; reassess if it expands.
- Decisions: the owner subsequently authorized Git initialization on `main` with the supplied SSH origin. Implementation adopts the presented trailer notation and disposable fixture seam; these are new local conventions. Actual versions and remaining verification limits are recorded below.
- Verification plan: `VER-GIT-HOOKS-SDD`, below.
- Trade-offs: fast blocking lint and Conventional Commits checks; more expensive build/test before push; informational scoring and advisory traceability while conventions are adopted. PR evidence is checked where it exists, with an honest local limitation before the PR is created.
- Technical review: completed on HOOKS-02 and the four-commit series, with zero remaining Standards or Spec findings; no broader human acceptance is inferred.

### VER-GIT-HOOKS-SDD

**Proposed primary seam:** the externally visible Git-hook lifecycle in a disposable local repository, through the same shell entry points used by developers. Use a local bare remote for push scenarios; no hosted repository or real project commit is required. The planning baseline had no equivalent test suite. The subsequent explicit implementation request accepts this presented seam for the bounded hook initiative. Fixture Git operations do not authorize commits or pushes in the project.

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

Drafting verification was limited to source inspection, primary-source research, and document consistency. Installation and executable verification occurred only after the subsequent implementation request, as recorded below.

### Primary-source notes

Consulted October 11, 2026. Project requirements and proposals above are local decisions; the sources establish tool behavior, not project approval.

- [Husky setup](https://typicode.github.io/husky/get-started.html) uses prepare in its initializer; [Husky operation guidance](https://typicode.github.io/husky/how-to.html) covers skips and POSIX hook entry points. Postinstall is this project's explicit lifecycle choice.
- [lint-staged](https://github.com/lint-staged/lint-staged) documents staged-file tasks, partial-staging protection, recovery, and argument handling.
- [commitlint local setup](https://commitlint.js.org/guides/local-setup.html) places validation in commit-msg; [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) defines the message convention.
- [Git hooks](https://git-scm.com/docs/githooks) defines pre-push arguments, ref-update input, and nonzero rejection behavior. It does not supply PR metadata.
- [harness-score](https://github.com/paladini/harness-score) documents local scanning, a reusable development dependency, and optional minimum-level gating. This project requests no such threshold.

## Implementation evidence — VER-GIT-HOOKS-SDD

- Date and executor: October 11, 2026; implementation agent, with owner authorization for this bounded scope.
- Revision: `HOOKS-01`, the task-owned source manifest SHA-256 `2571bf8d3c9290ac4df664f726bbdcc9e13d25e4cd481a7ddac6e61053a87c0f`. The manifest sorts `path<TAB>sha256(file)<LF>` for changed implementation/guidance files, excluding this spec and HOOK-01..04 completion records. Review captures the full file contents separately. Baseline copies were captured before implementation; no historical Git commit exists.
- Git follow-up: the owner explicitly authorized repository initialization. `main` is initialized, `origin` is `git@github.com:jonatassales/exphere.git`, and `core.hooksPath` is `.husky/_`. Activation was observed through `EXPHERE_SKIP_USER_SETUP=1 sh scripts/postinstall.sh`; personal PATH setup was deliberately skipped. At the first implementation review, no project commit, hosted push, fetch, or PR had been performed. The owner subsequently authorized feature-branch commits and normal pushes; delivery evidence is recorded after execution.
- Installed environment: Node v26.9.0, pnpm 12.4.2, Husky 9.1.7, lint-staged 17.6.0, commitlint CLI/config 21.2.3, harness-score 1.8.1. Node >=22.22.1 is declared for the dependency requirements; execution on that minimum version and other operating systems was not observed. Existing Biome 2.5.15, Turbo 2.11.7, and TypeScript 7.0.2 were retained.
- Installation: exact development dependencies and lockfile resolved under the existing package-age policy. Lifecycle scripts were initially disabled to protect personal setup. An observed pnpm 12 implicit install during script execution led to `verifyDepsBeforeRun: false`; hooks also disable that behavior for build/test. Dependencies were restored successfully from the task-local store with an offline, script-disabled install.

| Requirement / observation | Result and evidence |
| --- | --- |
| REQ-HOOK-01 and REQ-HOOK-03 | `passed`: real Husky/commitlint fixture integration; repeated activation, worktree support, custom-path conflict, missing Husky, valid/invalid messages, no-Git/CI/production/HUSKY skips, and disabled install scripts. Controlled Exphere setup verifies orchestration without writing to a real user's shell configuration. Root activation also observed after authorized Git initialization. |
| REQ-HOOK-02 and REQ-HOOK-04 | `passed`: real lint-staged/Biome rejects staged formatting errors, preserves partial edits and index hashes, and handles spaces, deletion, and no matches. A low fixture scanner result remains successful; an unavailable scanner fails manually but warns in pre-commit. `pnpm harness:score` exited 0 at 67/105 (64%), L2, without a target. This is a local diagnostic, not acceptance or a measurement goal. |
| REQ-HOOK-05 | `passed`: actual `pnpm build` compiled the SDK; later unchanged builds reused the Turbo cache. Actual `pnpm test` passed the original four nonempty shell groups, then Turbo reported no declared workspace test tasks. The root contract suite supplies the real test evidence; no application suite is claimed. |
| Push behavior | `passed`: disposable bare-remote pushes reject build/test failures, a missing test command, dirty tracked source, and another source revision; permit controlled success; handle new refs, multiple refs, deletion, non-fast-forward input, and tags. Quality commands in push fixtures have controlled outcomes and do not recursively run the suite. |
| REQ-HOOK-06 | `passed` at the local seam: missing/duplicate ticket and spec IDs, conflicting parents, staged versus unstaged evidence, outgoing commit-tree resolution, deduplication, incremental ranges, inaccessible bases, shallow history, multi-spec warnings, and unavailable PR metadata. Real commitlint and push failures remain blocking alongside SDD warnings. |
| REQ-HOOK-07 and REQ-HOOK-08 | Local rule/guardrail, agent pointers, setup/command documentation, Dev phases, and the scoped test exception are implemented. Local Markdown target inspection found no missing paths in changed documents; selected JSON passes Biome. Semantic ticket/PR scope remains a review responsibility. |

The initial fixture suite exercised a local force-update before the owner prohibited force pushes. Subsequent runs inspect equivalent hook input without any force push. The red/green fixture cycles observed missing installation, staged checking, push blocking, and SDD diagnostics before their implementation. A later full-suite run exposed a fixture-only symlink ignore issue; the fixture now excludes the dependency symlink from Git and the full suite passed afterward. Temporary fixture repositories and bare remotes are task-owned and cleaned on exit. No service probes or unrelated application tests were run.

### REV-GIT-HOOKS-SDD

- Scope: SPEC-GIT-HOOKS-SDD v1 and HOOK-01..04, including task-owned modified and new files. Exclude dependency trees, generated Husky shims, build/cache output, unrelated existing files, and Git internals.
- Reviewers: separate Standards and Spec agents under the code-review skill examined the same frozen HOOKS-02 snapshot and the cumulative four-commit series. Both axes reported zero remaining findings. The initial P2 finding and correction are recorded below.
- 12F-01/02/05/12 v1: local tooling evidence is `compliant` within the identified snapshot for source identity, declared dependencies, separation of build from delivery, and shell entry points. This is not application or production certification. Local CPU/time and install traffic are unmeasured; paid-resource FIN criteria and service networking/capacity criteria are `not-applicable` to this change.
- SDD v1: local hook behavior has the fixture evidence above. The reviewed project commits each declare their owning ticket and resolve to this spec. Actual PR declaration remains `not-verified`: no PR was created, and pre-push reports that limitation as an advisory warning.
- Human decision: implementation and local Git setup were authorized by the owner. The later user request explicitly authorizes commits and normal pushes to origin. Final artifact acceptance, a remote PR, and deployment remain separate; no broader approval is inferred.

### Review correction and delivery preparation

HOOKS-01 review found no Standards violations or actionable smells. The Spec reviewer found one P2 defect: deletion-only pre-push input resolved HEAD before determining whether source verification was needed, so an unborn HEAD incorrectly failed. The regression fixture observed exit 128 before the correction and exit 0 afterward. HEAD resolution now occurs only for outgoing commit source. The refreshed review includes that correction, the mandatory review/no-force-push rule, and HOOK-05 delivery scope.

Refreshed implementation snapshot: `HOOKS-02`, source manifest SHA-256 `72e24690de2361c5320b65d6a3b90d13e9b2452165a258451efd55cdef1f599e` using the same algorithm, excluding spec/ticket bookkeeping. The full suite now passes five groups, including unborn-HEAD deletion; no force push is executed by the current suite. Formatting-only fixes to commitlint configuration and the workflow definition make the initial project import pass the existing Biome checks.

### Publication evidence — HOOK-05

On October 11, 2026, the owner explicitly approved the first commit directly on main. The separately reviewed initial baseline is `1b21c03753ca9d7614c34254631f593eaf6ce926`, with trailer `Ticket: HOOK-05`. It preserves the task-start source, adding publication scope metadata and formatting-only corrections to commitlint configuration and the workflow definition. Its bootstrap commit passed the installed pre-commit and commit-msg checks. Main predates the versioned hook implementation; its clean baseline checkout had no pre-push gate, and no baseline build/test pass is claimed.

The feature branch `codex/git-hooks-sdd` starts at that main commit:

| Commit | Ticket | Delivery |
| --- | --- | --- |
| `78f330b9f42c44c2a2063c9750e8d3e8ad95a7e0` | HOOK-01 | Hook installation and Conventional Commits |
| `a75aac48358986f3a4a5828c1de3e99d4c6a248a` | HOOK-02 | Staged checks and informational harness score |
| `e49493708b802ace33017493b63d6994768f7c5a` | HOOK-03 | Build/test before push |
| `31485d595690b47bcd4a613a8ae6a81ef04fa092` | HOOK-04 | Advisory SDD checks and mandatory review procedure |

All commits use the configured author and committer, Jonatas Sales <6073626+jonatassales@users.noreply.github.com>, Conventional Commit subjects, and one ticket trailer. Both review axes inspected the cumulative commit slices before commit; intermediate installation, staged-check, and push suites passed. The final source matches HOOKS-02. Each actual feature commit passed the active local commit hooks.

Normal pushes published main and the feature to `git@github.com:jonatassales/exphere.git`. `git ls-remote` independently confirmed both full revisions above. The feature's active pre-push ran `pnpm build` successfully (unchanged SDK build reused Turbo cache) and `pnpm test`, passing all five contract groups; Turbo separately reported no workspace application test tasks. SDD associations resolved and unavailable PR metadata remained a warning. No force push, remote PR, merge, deployment, or package publication was performed during this delivery.

HOOK-01 through HOOK-05 are complete for this bounded implementation and publication scope. This completion record is a follow-up documentation change under HOOK-05; it does not change executable source or imply broader product acceptance. The future ADR-0002 and CTX drafts are separate local planning artifacts and are excluded from this publication.
