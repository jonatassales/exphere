# Exphere

Exphere explores developer experience, agent-assisted delivery, and consumer-composed microruntimes. The current workspace uses **Turborepo + pnpm** and contains the SDK with its shell CLI. Workflow contracts and organizational adoption remain proposals.

| Path | Current state |
| --- | --- |
| `packages/exphere/` | SDK with the `ex` shell CLI; TypeScript API remains empty. |
| `apps/` | Placeholder directory; no application is present. |
| `.micro-runtime/<id>/` | Consumer configuration created on demand by the CLI; not a workspace. |
| `.agents/` | Context, rules, guardrails, skills, and templates. |
| `.exphere/workflows/` | Common SDD lifecycle and the Dev, design, operations, SRE, and FinOps workflow documents. |
| `.artifacts/` | Typed PRDs, specs, tickets, research, and design documents in en-US. |
| `.audits/evidence/` | Contract for evidence from authorized execution. |

The tree has no API, web application, or protobuf workspace. Root development, build, start, and lint/format commands still refer to absent helper scripts. They are not verified working commands for this checkout; no missing workspace or helper script is restored by the documentation updates.

## Microruntime CLI

The CLI belongs to `packages/exphere/cli/`. The root manifest pins pnpm **12.4.2** and exposes `pnpm ex`. The CLI requires `sh` and `jq`; individual adapters require `terraform` or `kubectl` only when selected.

```sh
pnpm ex runtime list
pnpm ex runtime billing init
pnpm ex --root /path/to/consumer runtime list
```

`init` creates only `.micro-runtime/<id>/schema.json`, with identity and an empty `components` object. It refuses to overwrite an existing directory. Consumers provide Terraform configuration, Kubernetes manifests, and explicit `.sh` hooks. The CLI validates descriptors and dispatches selected commands; it does not choose the stack or composition.

The root `postinstall` invokes local CLI setup, which installs the command under `~/.local/share/exphere/bin` and configures the zsh or bash PATH. Setup is skipped in CI and with `pnpm install --ignore-scripts`. The source provides `pnpm ex setup` for manual setup; these documentation updates do not execute installation or modify shell configuration.

See the [CLI contract](packages/exphere/cli/README.md) for commands, descriptors, and consumer responsibilities. No deployable example microruntime is included.

## Project documents

- [PRD-0001](.artifacts/prd/0001-PRD-exphere.prd.md): product problem, intended outcomes, scope, and unmeasured hypotheses.
- [DD-0001](.artifacts/design/0001-DD-exphere.dd.md): current boundaries and design direction.
- [Documentation spec](.artifacts/specs/0001-SPEC-documentation-workflows.spec.md): reference review, workflow relocation, and the documented Dev workflow.
- [Artifact tracker](.artifacts/agents/0006-DD-artifact-tracker.dd.md): typed filenames, directories, numbering, and states.
- [Harness](.agents/README.md) and [current workflows](.exphere/workflows/README.md).

## Current limits

YAGNI. No tests, infrastructure provisioning, deployment, or production integration are included in the current work. The CLI adapters do not execute the agent workflow or enforce the proposed quality, resource, and observability contracts. Their presence does not prove successful Terraform or Kubernetes execution.

Biome is declared in the root manifest. Its configuration excludes agent, artifact, and evidence directories. The root lint/format helper is absent, so those task wrappers remain unavailable. Static documentation inspection is not evidence of application behavior.
