# Exphere CLI

The Go CLI implements project-local microruntime configuration and lifecycle commands. Consumer-owned application and agent source stays outside runtime units. **Cluster, Terraform, Kubernetes, and LangGraph Job execution are operationally unverified in this delivery.** Existing-check and review results are recorded in the [delivery ticket](../../.exphere/artifacts/tickets/0069-TICKET-go-runtime-integrated-review.ticket.md).

The CLI package owns the Go executable and npm `bin` entries. The SDK package depends on it and forwards its local executable without duplicating the CLI implementation. Both packages remain private; no npm registry release is claimed. The website's `npx exphere init` remains preview distribution text. The separate TypeScript SDK API is unchanged.

## Install and direct shell usage

Current source installation requires Go 1.23+ on macOS or Linux. The CLI dependency's postinstall builds a native Go executable with the existing toolchain; it never installs Go or infrastructure tools. Go may fetch pinned module dependencies. Installations that disable dependency scripts must explicitly run the CLI package's `scripts/build.sh` before using it. Release-grade prebuilt platform packages remain future work.

Frontend-only workspace deployments that do not execute Exphere may use `EXPHERE_SKIP_CLI_BUILD=1 pnpm install --frozen-lockfile` to skip only CLI compilation. Other dependency lifecycle scripts still run. This opt-out does not provide a working CLI; unset the variable and run `sh packages/cli/scripts/build.sh` from the repository root before using `ex`. Ordinary installation continues to require Go and build the CLI.

For this repository:

```sh
pnpm install --frozen-lockfile
./node_modules/.bin/ex-shell-setup --shell zsh
source "$HOME/.zshrc"
ex --help
ex version
```

Shell setup is a **one-time, explicit opt-in**. Use `--shell bash` with a Bash interactive profile, or `--profile <file>` when your shell loads a different file. Package installation never modifies personal profiles or PATH. The setup command writes only a marked function block, preserves unrelated profile content, and refuses malformed markers or a symlink profile.

After reloading the selected profile, `ex` resolves the nearest `node_modules/.bin/ex` from the current directory upward. Each project uses its own installed version. Missing or broken local installation returns an error; the function does not fall back to the system editor named `ex`. No `pnpm` prefix is needed for normal CLI use.

Without shell setup, the explicit project-local executable remains available as `./node_modules/.bin/ex`. A standalone developer build is available with `go -C packages/cli build -o dist/ex ./src/cmd/ex`. No global installation or shell-profile change is performed during verification.

Help and version work without a configured Exphere project, network, or infrastructure tools once the package executable is built. A package dependency still needs to be present for the project-aware shell function to find it.

## Commands

| Command | Effect |
| --- | --- |
| `ex init` | Initialize project identity and private-state exclusion, preserving existing content. |
| `ex doctor` | Report prerequisite versions, missing tools, and readiness gaps; never install tools. |
| `ex cluster create` | Explicitly create and record one kind cluster for the project. |
| `ex cluster inspect` | Inspect the project's recorded cluster. |
| `ex cluster load-image <image>` | Load a consumer-built local image. |
| `ex cluster delete` | Delete only the owned project cluster after cleanup and ownership reconciliation. |
| `ex runtime init <id>` | Create an intentionally incomplete manual descriptor and instructions. |
| `ex runtime init <id> --guided` | Collect consumer values and generate editable native configuration. |
| `ex runtime validate <id>` | Validate descriptor v2, paths, component references, and supported native configuration. |
| `ex runtime up <id>` | Prepare namespace/quotas and apply workloads; await readiness or Job completion. |
| `ex runtime inspect <id>` | Inspect readiness, events, resources, available measurements, and recorded outcomes. |
| `ex runtime logs <id> --unit <name>` | Retrieve bounded unit logs; following logs is an explicit option. |
| `ex runtime forward <id> --unit <name>` | Foreground localhost-only port forwarding; interruption ends forwarding. |
| `ex runtime down <id> [--recover]` | Reconcile state and remove owned workload/preparation resources. |
| `ex runtime hook <id> <name>` | Explicitly execute a declared `.sh` extension. |
| `ex agent init <name>` | Generate independent editable TypeScript LangGraph source and build instructions. |

Use command help for supported flags and required inputs. Results go to stdout; diagnostics go to stderr. Doctor and inspection provide JSON output. Exit codes are 0 for success, 1 for operational failure, 2 for invalid usage, and 130 for interruption. When invoked through `go run`, the Go launcher may report the child status through its own launcher exit status; the built binary is the direct CLI contract.

Global flags are `--project <path>` (otherwise discover the nearest project from the current directory), `--json` (structured results), and `--timeout <duration>` (two minutes by default for bounded operations). Use `--project` to initialize a different directory. For slower local cluster preparation, choose a suitable timeout explicitly. Live log following and port forwarding are foreground operations that stop on interruption.

`logs` requires `--unit` and supports `--follow`. `forward` requires `--unit`, defaults its local `--port` to 8080, and accepts `--remote-port` when needed. Guided runtime initialization asks for owner, context, namespace, selected components, prebuilt images, Deployment/Job kind, resources, applicable port/replica/readiness values, and quotas. Generation never silently overwrites an existing destination.

The verb precedes the runtime ID. Retired shell commands, v1 runtime creation/execution, automatic legacy migration, and raw adapter forwarding are not supported.

## Configuration and execution ownership

```text
consumer-project/
├── apps/website/                     # existing application source
├── .exphere/
│   ├── config.json                   # project identity
│   ├── agents/<name>/                # editable generated TypeScript source
│   ├── runtimes/<id>/
│   │   ├── README.md
│   │   ├── schema.json               # descriptor version 2
│   │   ├── terraform/                # namespace/quota configuration
│   │   ├── units/<component-name>/
│   │   │   └── kubernetes/           # execution configuration, no source copy
│   │   └── hooks/                    # optional explicit .sh extensions
│   └── state/                        # private operational state; excluded from Git
└── .audits/evidence/runs/<run-id>/    # execution observations
```

The descriptor owns identity, environment, owner, unit references, and the selected context/namespace. Kubernetes owns image, resources, replicas, probes, scheduling, and supported workload configuration. Terraform owns namespace and quotas. Guided answers are written to those native authorities; native files remain editable.

Units follow their component directory names and reference application or agent source by project-relative path. Runtime configuration references are runtime-relative. Existing output, escaping/symlink paths, invalid input, and ambiguous legacy/new IDs are rejected; generation never merges into an existing runtime.

The native pilot supports stateless Deployments, ClusterIP Services, and finite Jobs with a positive active deadline. Host, persistent, and generic ephemeral volume sources are unsupported. Terraform input is a bounded native `.tf.json` subset for namespace/quota preparation and requires exactly one explicit Kubernetes provider bound to the selected kubeconfig/context. No implicit provider, HCL `.tf`, modules, data sources, provisioners, remote backend, unrelated resources, or non-Kubernetes provider is accepted. This is not an arbitrary Terraform/Kubernetes executor.

## Local journey

1. Run `ex init` at the consumer root and `ex doctor`; install missing tools separately.
2. Create a runtime manually or with `--guided`. Manual output is intentionally incomplete and fails validation until required consumer values/native files are supplied.
3. Review the configuration and run `ex runtime validate <id>`. Supply explicit owner, source references, prebuilt images, resource/readiness settings, and quotas.
4. Explicitly create the project cluster, use its recorded context, and load each prebuilt image. The CLI neither builds application images nor installs Docker/kind/kubectl/Terraform.
5. Run `up`, then inspect readiness/completion and logs. Use foreground port forwarding when local HTTP access is needed.
6. Run `down` to remove owned runtime resources. Delete the project cluster separately after all runtimes and pending operations are reconciled.

The cluster has a private kubeconfig. The lifecycle does not fall back to the ambient current Kubernetes context or adopt an unrelated cluster. Runtime cleanup preserves the shared project cluster.

## Failure, recovery, and evidence

Mutations record intent and serialize operations. Evidence identifies the configuration, target, configured image references, available observed image identity, run, units, and result. Configured image references remain in failure records even when preparation/application fails before image observation. Preparation failure prevents workload application; unit reports distinguish completed, failed, and not attempted work.

Interruption stops and waits for owned processes. It can leave infrastructure present; inspect the result and use explicit recovery. State is required for ownership and cleanup: do not discard `.exphere/state` while resources or unresolved operations remain. Cleanup compares recorded targets and observed identities; matching resource names is insufficient.

Uncertain ownership, foreign resources, missing observations, or unresolved runtime operations block destructive cleanup. Cleanup requires unchanged configuration relative to the recorded active operation; restore/reconcile edited configuration before removal. Workloads are removed first, then the owned namespace is deleted with a UID precondition before Terraform state reconciliation. Cluster deletion compares resource identity across all namespaces and cluster-scoped resources against its creation baseline; unknown or foreign changes block deletion. Runtime configuration, consumer source, and evidence remain available after removal. Deleting configuration directories is not resource cleanup.

Resource requests/limits/quotas are configuration, not measured usage or monetary budget enforcement. Measurements unavailable from the cluster remain unavailable. The CLI does not calculate financial spend or savings. Logs may contain application data; publish evidence deliberately.

## LangGraph scaffold

`ex agent init <name>` generates an editable TypeScript graph, explicit dependencies and lockfile, Dockerfile, and README under `.exphere/agents/<name>`. It does not install dependencies, build an image, execute the graph, or create a runtime automatically.

The graph runs finite deterministic steps and emits structured runtime/run/outcome output. It has no model calls, credentials, RAG, MCP connections, persistent server, or backing database. Zero model calls does not imply zero infrastructure cost.

Build the supplied image separately, load it explicitly, and select the agent directory as a Job unit when configuring a runtime. The lifecycle supplies correlation and observes Job completion/failure using the same evidence and cleanup paths as other units. Generation and compilation do not prove Kubernetes execution.

## Go implementation

The entry point is `src/cmd/ex`; implementation lives in `src/internal`:

- `commands` owns Cobra parsing, help, prompts, presentation, and use-case calls.
- `core` owns project, cluster, runtime, and agent behavior.
- `adapters` owns native process, kind, Terraform, and Kubernetes effects.
- `kernel` contains small genuinely shared contracts; domain types stay with their owner.
- `templates` embeds versioned generation inputs.

Dependencies are composed explicitly. Goroutines belong to their operation and must terminate and be awaited. Go doc comments explain purpose, ownership, cancellation, and important failure behavior; inline comments explain decisions rather than restating code.

## Verification boundary

Existing Go and surviving contract checks may be adapted and run. No new test suites/scenarios or live Docker/kind/Terraform/application scenarios were authorized for this delivery. Build/static success does not establish runtime recovery, quota enforcement, deletion correctness, production suitability, or a completed local pilot.

Initial builds, type checks, current Go checks, and generated-agent TypeScript compilation passed. The adapted existing consumer-contract checks also passed. Final review corrections are still being verified; see the delivery ticket for exact results and snapshot boundaries. No LangGraph graph or infrastructure was executed.

The [coordinating PRD](../../.exphere/artifacts/prd/0009-PRD-go-cli-local-runtime-delivery.prd.md) links the four current specifications and eleven tickets. Earlier shell-era tests and review hashes remain historical records rather than Go acceptance evidence.
