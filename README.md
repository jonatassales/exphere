# Exphere

Exphere explores developer experience, agent-assisted delivery, and consumer-composed microruntimes. The current workspace uses **Turborepo + pnpm** and contains separate private, versioned SDK and CLI packages. Workflow contracts and organizational adoption remain proposals.

| Path | Current state |
| --- | --- |
| `packages/sdk/` | Private `@exphere/sdk`; TypeScript API remains empty. |
| `packages/cli/` | Private `@exphere/cli`; owns the `ex` shell CLI. |
| `packages/design/` | Public-intent `@repo/design`; neutral tokens with generated CSS/JSON exports. |
| `packages/web/` | Public-intent `@repo/web`; source placeholders and SmoothUI CLI dependency only. |
| `apps/website/` | Minimal private Next.js application consuming design tokens. |
| `.exphere/runtimes/<id>/` | Consumer v2 configuration created on demand; not a workspace. Existing `.micro-runtime/<id>/` descriptors remain legacy v1. |
| `.agents/` | Context, rules, guardrails, skills, and templates. |
| `.exphere/workflows/` | Common SDD lifecycle and the Dev, design, operations, SRE, and FinOps workflow documents. |
| `.artifacts/` | Typed PRDs, specs, tickets, research, and design documents in en-US. |
| `.audits/evidence/` | Contract for evidence from authorized execution. |

The tree has no API or protobuf workspace. The SDK API remains empty. Design and web use versioned public-intent metadata; no package has been published by this work. See the [design contract](packages/design/README.md), [web boundary](packages/web/README.md), and [website commands](apps/website/README.md).

Run `pnpm dev --filter=website` for the website after dependency installation. Turborepo builds its design dependency first. Use `pnpm --filter @repo/design dev` separately when editing tokens. `pnpm build` prepares production outputs; `pnpm start --filter=website` runs the application. Browser appearance, deployment, and production readiness require separate evidence.

## Microruntime CLI

The CLI belongs to `packages/cli/cli/`. The root manifest pins pnpm **12.4.2** and exposes `pnpm ex`. The CLI requires `sh` and `jq`; individual adapters require `terraform` or `kubectl` only when selected.

```sh
pnpm ex runtime list
pnpm ex runtime billing init
pnpm ex --root /path/to/consumer runtime list
```

`init` creates an incomplete v2 descriptor under `.exphere/runtimes/<id>/` for manual editing; `init --guided` asks for consumer choices and writes the descriptor plus native Kubernetes/Terraform files. Existing output is preserved. Components remain in their applications, and resource/image/readiness decisions remain in native files. `validate` checks descriptor structure and local references; it does not prove operational readiness. `init --legacy` explicitly creates the earlier v1 shape.

The root `postinstall` preserves local CLI setup, which installs the command under `~/.local/share/exphere/bin` and configures the zsh or bash PATH, then configures repository-local Husky hooks. CLI setup skips CI; `EXPHERE_SKIP_USER_SETUP=1` explicitly skips the user PATH step while retaining hook setup. `pnpm install --ignore-scripts` runs neither step. Use `pnpm ex setup` for manual CLI setup.

See the [CLI contract](packages/cli/cli/README.md) for commands, descriptors, and consumer responsibilities. No deployable example microruntime is included.

## Project documents

- [PRD-0001](.artifacts/prd/0001-PRD-exphere.prd.md): product problem, intended outcomes, scope, and unmeasured hypotheses.
- [DD-0001](.artifacts/design/0001-DD-exphere.dd.md): current boundaries and design direction.
- [Documentation spec](.artifacts/specs/0001-SPEC-documentation-workflows.spec.md): reference review, workflow relocation, and the documented Dev workflow.
- [Artifact tracker](.artifacts/agents/0006-DD-artifact-tracker.dd.md): typed filenames, directories, numbering, and states.
- [Harness](.agents/README.md) and [current workflows](.exphere/workflows/README.md).

## Developer checks

Use Node.js **22.22.1 or newer**, the pinned pnpm version, Git, and a POSIX shell. Run `pnpm install` to install the declared developer tools and execute postinstall. Husky activation is idempotent, supports linked worktrees, and skips CI, `HUSKY=0`, production-only installs, and directories without Git metadata. A missing development tool in a normal development install or a conflicting `core.hooksPath` is an error. Existing custom hook configuration is not overwritten. Dependency consumers do not receive this repository's root hooks as an SDK install side effect.

| Command or hook | Behavior |
| --- | --- |
| `pnpm build` | Run declared workspace builds through Turborepo, including SDK compilation, token generation, and the website production build. |
| `pnpm test` | Run shell hook-contract and agent-review contract suites in disposable Git repositories, then declared workspace test tasks through Turborepo. CLI fixtures verify public command/setup behavior; design fixtures verify generated exports and watch behavior. No application suite is added. |
| `pnpm typecheck` | Run declared workspace type checks through Turborepo after dependency builds. |
| `pnpm check`, `pnpm lint`, `pnpm format` | Run the existing Biome configuration; `format` writes fixes explicitly. |
| `pnpm harness:score` | Invoke locally installed `npx harness-score` from the root, without a target or threshold. Execution errors remain nonzero. |
| pre-commit | Check eligible staged files with lint-staged/Biome, preserving partial edits; report one project-wide harness scan and a ticket reminder. Lint failures block; score findings or scanner failures do not. |
| commit-msg | Validate the proposed message with commitlint's conventional configuration and emit advisory ticket/spec findings from the index. |
| pre-push | Report outgoing SDD associations and PR-metadata limitations, then run build followed by test for the clean tracked, checked-out outgoing revision. Quality errors and unsupported source revisions block. |

Biome checks supported JS/TS variants, JSON/JSONC, and CSS using the staged configuration. Shell, Markdown, and other unsupported formats are outside this linter's coverage. Existing agent, artifact, and evidence exclusions remain. The harness scanner reads the project working tree; its diagnostic is not staged-content validation. A low score is not a failure or an instruction to expand project scope.

`verifyDepsBeforeRun: false` disables pnpm's implicit installation before run/exec. Hooks require tools already installed; the scanner uses offline npx with installation disabled. Missing tools produce explicit failures/warnings according to the table. Commitlint retains its upstream ignored-message behavior, including merge/revert and fixup/squash messages; ticket associations are evaluated separately.

Follow the [SDD rule](.exphere/rules/sdd.md) and [guardrail](.exphere/guardrails/sdd.md): `Ticket: HOOK-01` is a commit trailer; `Spec: SPEC-GIT-HOOKS-SDD` belongs in the actual PR body. Stable artifact IDs are independent of filename numbers. Unavailable PR metadata warns locally; review must inspect the real PR declaration when it exists. Hooks can be bypassed and do not constitute CI enforcement or authorization to publish.

## GitHub agent review

The [agent-review workflow](scripts/agent-review/README.md) reviews immutable PR snapshots against the trusted code-review skill using separate Standards and Spec model requests. It publishes a job summary and report artifact, with explicit skipped, incomplete, stale, and failed outcomes. Findings are informational; provider execution is disabled until its documented model, credentials, owner, and budget configuration is supplied.

The authorized local fixtures run with `sh scripts/tests/agent-review.sh` and are included in `pnpm test`. They use controlled responses with no paid API calls. Hosted event delivery and real model behavior remain unverified until a separately authorized pilot.

## Current limits

YAGNI. The hook initiative authorizes its bounded fixture tests and build/test push gate. The package initiative additionally authorizes isolated SDK/CLI and design-token consumer checks plus website type checking, compilation, and generated-artifact inspection. Browser probes and application test infrastructure remain outside this cycle. No infrastructure provisioning, deployment, or production integration is included. The CLI adapters do not execute the agent workflow or enforce the proposed resource and observability contracts. Their presence does not prove successful Terraform or Kubernetes execution.
