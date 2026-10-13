# Go CLI foundation

- ID: `SPEC-GO-CLI-FOUNDATION`
- Document: `SPEC-0032`
- Version: `1`
- State: `implemented`
- PRD: [PRD-GO-LOCAL-RUNTIME-DELIVERY v1](../prd/0009-PRD-go-cli-local-runtime-delivery.prd.md).
- Technical owners: project owner for scope; Exphere implementers and independent reviewers for delivery.

## Contract and composition

Requirements: REQ-GOL-001, 002, 006, 007, 009, 010. Supersedes the scaffold-only limitation for newly implemented behavior while retaining [SPEC-GO-CLI-SCAFFOLD](0025-SPEC-go-cli-scaffold.spec.md) as historical delivery evidence.

Use one Go module, Cobra only, explicit configuration, and manual dependency injection. The package uses `src/cmd/ex` for the process entry and `src/internal` for commands, kernel, domain packages, adapters, and embedded templates. Add packages only when implemented behavior needs them.

The entry point owns signals, composition, and process exit. Commands own arguments, flags, prompts, help, and presentation. Domain packages own use cases and consumed interfaces; adapters own native process/filesystem effects. Kernel is limited to genuinely shared identifiers and outcomes, not a struct dumping ground. Runtime descriptors belong to the runtime domain. Goroutines live with their operation, have cancellation and termination conditions, and are awaited by their caller.

### Command contracts

- No mutable global command registration/configuration, hidden shell fallback, implicit network initialization, or library-level process exit.
- Results use stdout; diagnostics use stderr. Inspection/doctor support JSON. Help/version work without a project, network, or infrastructure tools.
- Exit status: success 0; operational failure 1; invalid usage 2; interruption 130.
- Verbs precede IDs. Unknown commands/arguments/flags fail explicitly. Update repository aliases and build references for the moved entry point.
- Project init creates metadata without overwriting existing files or starting infrastructure. Doctor reports actual tool availability/versions and readiness gaps with installation guidance; it never installs missing tools.
- macOS/Linux initially. Automatic shell-profile/global PATH changes, npm publication, and automatic tool downloads remain outside scope. The later explicit one-time shell setup decision below is the only profile-writing interface.

### Native process and comments

Run native tools with argument arrays, explicit directories, bounded captured output, propagated cancellation, and explicit tool/target selection. Avoid shell interpolation. Foreground streams are deliberate commands rather than unbounded hidden captures. Process cleanup waits for owned workers/processes and reports cancellation as such.

Use Go doc comments on exported declarations and package boundaries. Start declaration comments with their names, explain contracts and effects, and document cancellation, ownership, and important failure behavior. Inline comments explain non-obvious reasoning, not obvious statements. JSDoc tags are not a Go documentation requirement. References: [Go module layout](https://go.dev/doc/modules/layout), [Go doc comments](https://go.dev/doc/comment), [os/exec](https://pkg.go.dev/os/exec), and [Cobra](https://github.com/spf13/cobra).

### Subsequent decision — direct project-local `ex`

After approving the implementation plan, the owner required direct `ex --help` following dependency installation and selected one-time shell setup that resolves the current project's executable. This explicitly extends T1's distribution boundary; it does not authorize publishing packages or changing the user's real profile during verification.

- The CLI npm package declares `ex` and `ex-shell-setup` bins. A small executable `.sh` bridge delegates all CLI behavior to compiled Go. A separate explicit setup script handles the chosen profile integration.
- The SDK declares its actual CLI dependency and forwards both bins through package-relative resolution, supporting hoisted and isolated dependency layouts. Its TypeScript API stays unchanged.
- Current private/source installation uses an existing Go toolchain to build the native executable during CLI postinstall. Disable automatic toolchain installation; normal pinned module fetching remains possible. Ship source rather than a misleading cross-platform host binary. If dependency scripts were disabled, report the explicit build remedy.
- One-time setup accepts Bash/Zsh and a selected profile. It preserves unrelated content, uses a marked idempotent function block, refuses ambiguous markers/symlink profiles, and requires the consumer to reload the profile. Installation never invokes setup automatically.
- The function searches upward from the current directory for the nearest project-local executable. It preserves arguments and exit status, errors when the local binary is missing/broken, and never invokes the system editor also named `ex`. It does not mutate PATH or install a global executable.
- Public examples use `ex` after explicit setup. Local package-bin invocation remains available when profile integration is undesired. Prebuilt release packages and npm publication are deferred.
- Verification remains static shell checks and existing authorized checks only. No personal profile execution or new installation test scenarios.

### Website-only installation follow-up

The October 13 deployment report exposed an integration regression: Vercel's website dependency installation ran the workspace CLI postinstall without Go available, before the website build could start. The website has no runtime dependency on the CLI.

- `EXPHERE_SKIP_CLI_BUILD=1` explicitly skips the source-build helper before toolchain lookup and filesystem changes. An unset variable or another value preserves the required Go build. The skip reports that the CLI must be built separately before use.
- `apps/website/vercel.json` scopes this opt-out to the website's install command. Other lifecycle scripts remain enabled, the lockfile stays frozen, and the website build selects `website` with the existing root-owned Turbo executable. The existing `^build` task edges include the shared design/web builds. Avoid the broader package-graph `website...` selection, which also selected the root's CLI dependency in the installed Turbo version.
- No automatic Go installation, shell profile change, global CI opt-out, runtime behavior change, or blanket lifecycle-script bypass is introduced.
- Normal developer/source installation remains the existing contract. An explicitly skipped build does not establish CLI availability.
- Verification uses the existing checks and actual website install/build path; no new suites or scenarios are added. Hosted readiness is recorded only after an observed successful deployment.

Delivery: [CLI-INSTALL-01](../tickets/0070-TICKET-website-cli-install-isolation.ticket.md).

### Subsequent decision — package identity

The owner's October 13 naming decision replaces the CLI package `@exphere/cli` with `@exphere/ex` and moves its directory from `packages/cli` to `packages/ex`. The SDK remains `@exphere/sdk` in `packages/sdk`; the executable remains `ex`.

- Align the Go module/imports, workspace dependency links, SDK bin resolution, Turbo task keys, CI Go path, and current documentation with the new identity.
- Preserve the source-build and explicit shell-setup contracts, private versions, and website-only install opt-out. Do not publish packages or introduce compatibility aliases for the retired package name.
- Move the package contents without changing runtime behavior or the retained inner `cli/schemas` layout. Preserve dated verification records and historical command transcripts as evidence of their original snapshots.
- Adapt existing checks only; no new suites, live infrastructure execution, or personal shell-profile changes.

Delivery: [EX-PACKAGE-01](../tickets/0071-TICKET-cli-package-identity.ticket.md).

## Responsibilities

- Consumer: explicitly invoke commands and supply supported inputs; install required native tools separately.
- Platform: stable command/error contracts, dependency composition, guarded process execution, and accurate documentation.
- Service owners: own operational targets and source configuration; CLI scaffolding does not grant infrastructure permission.

## Operation and limits

Private operational files use `.exphere/state`; credentials/state stay out of version control. Human-readable configuration and application source keep their existing owners. Project init may add only the specific ignore entry needed for private state, preserving existing content. Native operations are invoked by explicit commands, never installation/import/help.

Library code returns errors and outcomes. The command boundary classifies usage versus operation failures; cancellation reaches native work and is not reported as success. A failed diagnostic must identify unavailable data rather than manufacturing readiness.

FinOps FIN-01/05 applies to identifying operational ownership and lifetime; FIN-02/03/06/07 paid/financial controls are deferred. Twelve-Factor 12F-01/02/03/05/09/11/12 applies to code/dependencies, explicit configuration, cancellation, logs, and administrative actions. Configured/documented criteria are not operational evidence.


## Delivery tickets

- [CLI-RUNTIME-01](../tickets/0059-TICKET-go-cli-foundation.ticket.md)
- [CLI-RUNTIME-02](../tickets/0060-TICKET-project-initialization-diagnostics.ticket.md)
- [CLI-RUNTIME-11](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md)

## Verification and decisions

- Scope authorization: The project owner explicitly requested implementation of the complete “Exphere Go CLI — foundation and local runtime lifecycle” plan on October 13, 2026. That request covers this scope, the four-specification breakdown, and the eleven tickets. It authorizes local implementation and the stated existing checks, not live cluster execution, publication, or paid operations. This record documents conversational authorization; it is not an authenticated approval system.
- Existing checks only: adapt the current CLI tests and surviving contract checks as behavior changes; run formatting, compilation, `go vet`, and applicable existing repository checks. Do not add suites/scenarios or execute infrastructure/application pilot scenarios.
- Technical review: Standards and Spec review must inspect the same identified source snapshot before completion. Initial checks and same-snapshot review findings are recorded in the [integrated delivery record](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md). Final correction checks and refreshed Standards/Spec reviews passed; no operational success is claimed.
- Evidence states: configured, implemented, reviewed, and observed remain distinct. Operational lifecycle/agent integration is `not-verified` until separately authorized execution supplies evidence.
- Remaining scope: no cloud provisioning, paid calls, billing ingestion, RAG/MCP, automatic optimization, or external publication.

Implementation and independent source reviews completed within the authorized verification scope. See [CLI-RUNTIME-11](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md) for final checks, source identity, and deferred operational verification. This status does not claim a live runtime or authenticated organizational approval.
