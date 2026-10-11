# ex — Exphere SDK CLI

Shell CLI for the private `@factory/exphere` package. The `ex` binary points to `cli/ex.sh`; the SDK's TypeScript API remains empty. The consumer supplies components, configuration, and hooks. The CLI selects the microruntime and invokes the requested tool.

Requirements: `sh` and `jq` on PATH. `terraform` or `kubectl` is required only for the selected adapter. The CLI does not install tools or load environment files.

## Local installation

The root `postinstall` hook invokes local setup after `pnpm install`. Setup creates links to this checkout at `~/.local/share/exphere/bin/ex` and `~/.local/share/exphere/env.sh`, then adds a line to the zsh or bash configuration to prioritize the command on PATH. It does not modify the system's `ex` and refuses to replace links or files from another installation.

Open a new terminal, or activate it in the current terminal:

```sh
. "$HOME/.local/share/exphere/env.sh"
```

Then use `ex` directly. Running `pnpm ex setup` again keeps the same links and does not duplicate the configuration line. If you move the checkout, remove both old links before running setup again. Other shells require manual PATH configuration.

The hook belongs to this monorepo's root; installing the SDK as a dependency does not automatically change the consumer's shell. Automatic setup is skipped in CI and with `pnpm install --ignore-scripts`; `pnpm ex setup` remains available as an explicit command.

## Commands

```text
ex [--root DIR] --help|--version
ex setup
ex [--root DIR] runtime list
ex [--root DIR] runtime ID init
ex [--root DIR] runtime ID validate
ex [--root DIR] runtime ID terraform COMMAND [--] [ARGS...]
ex [--root DIR] runtime ID kubernetes diff|apply|delete|status
ex [--root DIR] runtime ID run HOOK [--] [ARGS...]
```

The CLI discovers the project root by walking up from the current directory until it finds `.micro-runtime`, `pnpm-workspace.yaml`, or `.git`; without those markers, it uses the current directory. `--root` explicitly selects another project.

`init` creates only `.micro-runtime/<id>/schema.json`, containing `version: 1`, the identifier, and `components: {}`. It refuses an existing microruntime directory and does not generate infrastructure. `list` creates no files and returns an empty list when `.micro-runtime` does not exist. `validate` checks the descriptor and its local paths; it does not validate providers, connectivity, or operational readiness.

## Consumer descriptor

Location: `.micro-runtime/<id>/schema.json`. This is a documentation example; the consumer must supply the declared files and directories:

```json
{
  "version": 1,
  "id": "billing",
  "components": { "api": { "kind": "go-service" } },
  "terraform": { "directory": "terraform" },
  "kubernetes": {
    "context": "my-explicit-context",
    "namespace": "billing",
    "manifests": "kubernetes"
  },
  "hooks": { "prepare": "hooks/prepare.sh" }
}
```

`version`, `id`, and `components` are required; `id` matches the directory name. `terraform`, `kubernetes`, and `hooks` are optional. Keys outside the contract are rejected, except within the opaque objects in `components`. Hooks have simple lowercase names and point to `.sh` files.

The objects in `components` belong to the consumer: the CLI does not render or inject them, or interpret them as CPU, memory, or quality policies. Declared paths are relative to the microruntime directory and must remain within it; target files cannot be symbolic links. Descriptors are JSON data, never shell code loaded with `source`.

## Adapters

**Terraform:** supports `init`, `validate`, `plan`, `apply`, `destroy`, `output`, `show`, `fmt`, and `workspace`. It runs in the declared directory and forwards native arguments. State, workspaces, providers, credentials, and variables remain under the consumer's and Terraform's configuration, including inherited `TF_VAR_*` and `TF_WORKSPACE` values. There is no implicit initialization, apply, destroy, or `-auto-approve`.

**Kubernetes:** requires `context`, `namespace`, and `manifests`. `diff`, `apply`, and `delete` use the declared file or directory with `-f`; `status` uses `get -f`. This version does not accept additional Kubernetes arguments or offer Kustomize. Context and namespace are explicit; a namespace is not a sandbox and does not block cluster-scoped resources.

Native exit codes are preserved: `terraform plan -detailed-exitcode` can return `2` when there are changes; `kubectl diff` can return `1` when there are differences.

## Inversion of control

`run HOOK` runs only the selected `.sh` hook, with the microruntime directory as its working directory. Arguments and environment are inherited, with these additional variables:

| Variable | Content |
| --- | --- |
| `EX_PROJECT_ROOT` | Consumer project root |
| `EX_RUNTIME_DIR` | Microruntime directory |
| `EX_RUNTIME_ID` | Microruntime identifier |
| `EX_RUNTIME_SCHEMA` | Descriptor path |
| `EX_CLI_PATH` | Path to `cli/ex.sh` in the SDK |

The consumer decides composition and order. A hook can delegate to the CLI using:

```sh
sh "$EX_CLI_PATH" --root "$EX_PROJECT_ROOT" runtime "$EX_RUNTIME_ID" terraform plan
```

Hooks are trusted consumer code and run with the process's permissions. The CLI does not impose a lifecycle sequence, automatic rollback, or a sandbox. The proposed testing, observability, resource, and evidence contracts remain under development: see [the requirements](../../../.artifacts/design/0002-DD-microruntimes.dd.md) and [the proposed architecture decision](../../../.artifacts/design/0005-DD-microruntime-architecture.dd.md), which retains the legacy ID `ADR-0001`.

## Current state

No deployable microruntime is included. No tests, hooks, or infrastructure commands were run for this delivery; the presence of adapters does not demonstrate operation against Terraform or Kubernetes.
