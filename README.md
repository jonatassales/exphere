# Exphere

Exphere is an experimental DevEX / FinOps platform exploring agent-assisted software delivery and consumer-composed microruntimes. The repository contains a documentation website, an empty TypeScript SDK API, a Go CLI scaffold, developer checks and proposed workflow contracts. It does not demonstrate production automation, infrastructure integration or realized savings.

## Workspace

| Location | Current responsibility |
| --- | --- |
| `apps/website/` | Next.js/Nextra introductory documentation page and Getting Started section; grayscale visual-only Orbo and copyable preview command. |
| `packages/design/` | Design tokens and their TypeScript compiler. |
| `packages/web/` | Shared ExphereShader React surface and public-export contract fixtures. |
| `packages/sdk/` | Separate private `@exphere/sdk` package; TypeScript API remains empty. |
| `packages/cli/` | Private workspace task bridge and dependency-free Go `ex` scaffold. |
| `.exphere/artifacts/` | Typed PRDs, specifications, tickets, research and design decisions. |
| `.exphere/workflow/` | Documentary SDD lifecycle, domain adaptations and AIHero skills. |
| `.exphere/harness/` | Shared SDD, FinOps and Twelve-Factor policies and FinOps/AWS skills. |
| `.agents/` | Local engineering guidance, templates and the 20 requested Go skills. |

## Development

Use Node.js **22.22.1 or newer**, the root manifest's pinned pnpm **12.4.2**, the Go version declared in `packages/cli/go.mod`, Git and `jq` for the retained source-contract checks. Install dependencies with `pnpm install`; the native Husky prepare command configures local Git hooks. Installation no longer installs `ex` globally or changes a shell profile. `HUSKY=0` disables hook installation/execution; `pnpm install --ignore-scripts` skips lifecycle commands.

Use `pnpm dev --filter=website` for the website. Turborepo builds its workspace dependencies first; run `pnpm --filter @repo/design dev` separately while editing tokens. Use `pnpm build` for production output and `pnpm start --filter=website` to run the application. The root entry and `/docs` Getting Started page use Nextra. Documentation content beyond Getting Started is intentionally absent.

The website's `npx exphere init` clipboard command previews the intended interface. No `exphere` npm release or working initialization command is provided by this change. Orbo's `listening` state is a visual presentation and does not request microphone access. The owner supplied the footer attribution `exphere by Grupo OLX © 2026`; this repository does not independently establish organizational endorsement.

## Go CLI

```sh
pnpm ex --help
pnpm ex version
pnpm ex init
```

The first two commands provide the scaffold's usage and version. `init` deliberately returns a nonzero unsupported result and writes no consumer files. Unknown or malformed commands fail explicitly. The implementation lives under `packages/cli/cmd/ex/`.

The previous shell CLI's `runtime`, `setup`, Terraform/Kubernetes adapters, guided generation, legacy compatibility and PATH installation have been retired. JSON schemas under `packages/cli/cli/schemas/` and CLI-owned consumer-harness fixtures remain historical/source contracts; they are not current executable Go capabilities. Read the [CLI README](packages/cli/README.md) for the supported boundary.

## Developer checks

Root task aliases call the native tools; wrapper `scripts/` directories are absent outside `packages/cli/`. Substantive Husky hooks and native test files retain their framework-defined owners.

| Command or hook | Behavior |
| --- | --- |
| `pnpm build` | Turborepo runs declared workspace builds, including Go, SDK, tokens, web and website. |
| `pnpm typecheck` | Declared workspace type checks, after dependency builds. |
| `pnpm test` | Declared native package tests, CLI-owned reference-contract checks and disposable Husky hook contracts through Turborepo. |
| `pnpm check`, `pnpm lint`, `pnpm format` | Biome checks; `format` explicitly writes fixes. |
| `pnpm harness:score` | Informational project harness scan; results are not approvals or production evidence. |
| pre-commit | lint-staged/Biome checks eligible staged files, preserving partial edits; informational harness scan and ticket reminder. |
| commit-msg | Blocking Conventional Commit validation and advisory staged ticket/spec associations. |
| pre-push | Advisory outgoing SDD associations followed by build/test for the clean tracked outgoing source revision. Unsupported revisions and quality failures block. |

Biome does not cover shell, Go or Markdown. Installed skills and typed artifacts are excluded from frontend linting; their validation is separate. Hook contracts use disposable Git repositories and a local bare remote. CLI tests cover scaffold behavior; retained consumer-harness checks inspect source/fixtures and do not prove runtime deployment. Design export/watch fixtures and web fixtures retain their declared test runners. Removed shell CLI installation/runtime fixtures and the shell agent-review provider are no longer executable coverage.

`verifyDepsBeforeRun: false` prevents implicit dependency installation before tasks. Hooks require installed tools. Follow the [SDD rule](.exphere/harness/rules/0001-sdd.rule.md) and [guardrail](.exphere/harness/guardrails/0002-sdd.gr.md): each commit declares one stable `Ticket:` trailer and each actual PR declares one `Spec:`. Advisory findings are not compliance. Hooks can be bypassed and do not authenticate approval or authorize publication.

## CI and review

GitHub Actions uses native dependency installation, checks, type checking, builds and tests. It does not run the retired shell agent-review provider or make paid model requests. Separate Standards and Spec review remains the contributor obligation described in the [code-review skill](.exphere/workflow/skills/code-review/SKILL.md); CI success is not a replacement for that review. Hosted workflow execution and local results must be recorded for the revision actually checked.

## Project documents and limitations

- [Product requirements](.exphere/artifacts/prd/0001-PRD-exphere.prd.md) and [design overview](.exphere/artifacts/design/0001-DD-exphere.dd.md).
- [PR #19 integration specification](.exphere/artifacts/specs/0028-SPEC-pr19-completion.spec.md): requested website, Go, native tooling and skills scope with a requirement-by-requirement checklist.
- [Artifact tracker](.exphere/artifacts/design/0006-DD-artifact-tracker.dd.md), [local guidance](.agents/README.md), and [workflow documentation](.exphere/workflow/README.md).
- [Workflow skill provenance](.exphere/workflow/skills/README.md) and [Go skill provenance](.agents/skills/README.md).

The former skill lock, evidence README, guardrail index and CLI-context ADR remain absent. Retained policy documents and schemas do not establish an executed workflow, organizational adoption, npm publication, indexing, deployment, cost savings or production readiness. The owner-authorized PR #19 verification is bounded to this migration; it does not authorize provisioning or production access.
