# Exphere CLI

This Go module implements project-local microruntime configuration,
an explicitly invoked kind/Terraform/Kubernetes lifecycle, and editable finite
LangGraph agent scaffolds. It is a local development candidate, not a published
package or a claim of production readiness.

## Build and checks

Use an existing Go 1.23 or newer toolchain on macOS or Linux:

```sh
GOTOOLCHAIN=local go build -o dist/ex ./src
./dist/ex --help
GOTOOLCHAIN=local go test ./...
GOTOOLCHAIN=local go vet ./...
```

The module retains its standalone identity, `github.com/exphere/ex`, and is
integrated here as the private workspace package `@exphere/ex`. This does not
imply a published release. Native Go commands own the build and checks. Building does not install infrastructure tools, alter shell
profiles, or change PATH. Use `./dist/ex` to avoid invoking the unrelated system
editor also named `ex`.

## Workspace package

The package holds only the Go module, its source, and `build.sh`. Installing
the workspace runs `build.sh`, which builds `dist/ex` with an existing Go
toolchain, never installs Go or tools, and never changes shell profiles. Set
`EXPHERE_SKIP_CLI_BUILD=1` to skip it. From the workspace root,
`pnpm --filter @exphere/ex build` rebuilds the executable.

This package declares no npm bin. The separate `@exphere/sdk` package exposes
`ex` through its bridge, which runs this package's built `dist/ex`. Inside this
repository, run `packages/ex/dist/ex` directly. The former shell-setup command,
package bridge, historical schemas, and consumer-harness fixtures were removed
on October 17, 2026; Git history retains them.

## Commands

In the commands below, `ex` means this tree's compiled `./dist/ex` executable.

| Command | Behavior |
| --- | --- |
| `ex version` | Print the version; `--version` and `-V` are equivalent. |
| `ex init` | Create project identity and ignored private state; reuse existing valid identity. |
| `ex doctor` | Inspect tools and project readiness without installing anything. |
| `ex runtime init <id>` | Create editable configuration; `--guided` collects explicit workload and resource choices. |
| `ex runtime validate <id>` | Validate the descriptor and supported native configuration without provisioning. |
| `ex cluster create` | Explicitly create a project-owned local kind cluster. |
| `ex cluster inspect` | Inspect the recorded cluster and its availability. |
| `ex cluster load-image <image>` | Load an already-built local image into that cluster. |
| `ex runtime up <id>` | Prepare the namespace and quotas, create configured resources, and await workloads. |
| `ex runtime inspect <id>` | Record ownership, workload, event, resource, and available usage observations. |
| `ex runtime logs <id> --unit <name>` | Read bounded logs; `--follow` streams until interruption. |
| `ex runtime forward <id> --unit <name>` | Forward a Service to localhost until interruption. |
| `ex runtime hook <id> <name>` | Explicitly run a declared trusted `.sh` extension and record its outcome. |
| `ex runtime down <id> [--recover]` | Remove recorded owned resources; preserve source, configuration, evidence, and the shared cluster. |
| `ex cluster delete` | Delete the owned cluster only after cleanup and complete ownership reconciliation. |
| `ex agent init <name>` | Generate editable TypeScript LangGraph source, dependencies, Dockerfile, and instructions. |

Global flags are `--project <directory>`, `--json`, and `--timeout <duration>`.
Without `--project`, the nearest parent project is discovered. The default
finite-operation timeout is two minutes. Guided prompts, log following, and
port forwarding remain cancellable foreground operations. Forwarding binds
only `127.0.0.1`, defaults `--port` to 8080, and accepts `--remote-port` when the
Service has more than one port. Native logs reject `--json`.

Exit codes are 0 for success, 1 for operational errors, 2 for invalid usage,
and 130 for interruption. Results use stdout; diagnostics use stderr.

## Source boundaries

```text
src/main.go, src/wiring.go   Process entry and concrete dependency wiring
src/presentation/cli/        Commands, flags, prompts, output, exit codes
src/application/             Use cases and the interfaces they consume
src/domain/                  Identity, configuration, ownership, lifecycle rules
src/infrastructure/          Files, storage, native tools, embedded scaffolds
```

The domain does not import the CLI, filesystem, or native process adapters.
Application use cases own orchestration; the entry point wires concrete
adapters. These boundaries are a convention: without an `internal` directory,
the Go compiler does not stop other modules from importing the packages. The
module is private and unpublished, so only this repository builds it.

## Configuration and recovery

Consumer configuration lives in `.exphere/runtimes/<id>/schema.json` with native
Terraform JSON and Kubernetes manifests. Source stays outside runtime units.
Only the documented local supported subset is accepted: Terraform prepares a
namespace and quotas; manifests describe supported namespaced workloads and
their resources. Tools and images are supplied by the consumer.

Project and runtime identity, private kubeconfig, and operation ledgers live in
`.exphere/state`. Evidence lives in `.audits/evidence/runs`. Preserve private
state until cleanup succeeds. Never delete or edit ownership records merely
to bypass a rejected cleanup operation.

The refactor retains the existing CLI's persisted ownership contracts and
configuration fingerprint. It also recognizes the reviewed standalone draft's
explicit record format and exact fingerprint. Compatibility never substitutes
for matching the recorded project, cluster, namespace, object UIDs, and current
configuration. Unsupported or contradictory evidence is rejected.

Hooks execute trusted consumer shell code; they are not sandboxed and are
never invoked implicitly. Agent generation does not install dependencies,
build images, run agents, or call model providers.

## Tests and verification limits

`go test ./...` runs the suites kept beside the code they cover: the domain
rules; every use case through in-memory fakes of its ports, including a
Kubernetes fake that imitates the controllers a runtime relies on; the file,
storage, configuration, and scaffold adapters in disposable directories; the
kubectl, kind, Terraform, toolchain, and hook adapters against recorded
command invocations; and the composed CLI. The process runner starts only
local `sh` processes. No test runs Docker, kind, kubectl, Terraform, or an
agent application.

Measure coverage across package boundaries, and use the race detector where a
C toolchain is available:

```sh
GOTOOLCHAIN=local go test -coverpkg=./... -coverprofile=coverage.out ./...
GOTOOLCHAIN=local go tool cover -func=coverage.out
GOTOOLCHAIN=local go test -race ./...
```

Tests, static checks, and source reviews do not establish successful live
cluster startup, readiness, cleanup, or production integration. Those outcomes
require separately authorized execution and recorded observations.
