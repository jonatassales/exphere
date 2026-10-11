# Separate the SDK and CLI packages

- ID: `SPEC-SDK-CLI-SEPARATION`
- Document number: `SPEC-0006`
- Version: `1`
- State: `implemented; reviewed local scope`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md), draft; no approved product revision is recorded.
- Technical owners: the project owner decides package boundaries and release policy; the implementation agent prepares the authorized migration. Other owners are unassigned.
- Authorization: on October 11, 2026, the owner requested separate private, versioned SDK and CLI packages with the `@exphere/` prefix, invoked `to-spec`, then requested `to-tickets && implement and commit and push on a separate branch`. This authorizes bounded migration, installation/build/type checking, focused public consumer tests in isolated fixtures, and reviewed feature-branch commit/push. It does not record human acceptance of this exact revision or authorize live infrastructure, changes to the real user installation, npm publication, or deployment.
- Ticket: [SPLIT-01](../tickets/0015-TICKET-sdk-cli-separation.ticket.md).
- Context: [DD-0009](../design/0009-DD-web-foundation.dd.md#sdk-and-cli-separation). The future consumer-context contract remains [ADR-0002](../../.agents/adr/0002-cli-context-extension.md).

## Contract and composition

- Requirements addressed: `REQ-SPLIT-01` through `REQ-SPLIT-07`, below; supports REQ-PRD-002, REQ-PRD-005, and REQ-PRD-006.
- Components selected by the consumer: private `@exphere/sdk` in `packages/sdk/` and private `@exphere/cli` in `packages/cli/`, replacing the combined `packages/exphere/` workspace. These identities are separate from the public `@repo/design` and `@repo/web` packages.
- Environment and executor selected by the consumer: retain pnpm 12.4.2, Turborepo, the current Node floor, and POSIX shell entry points. The SDK retains the existing TypeScript compiler configuration and dependency unless a demonstrated compatibility problem requires a scoped change. The CLI retains its existing shell/tool requirements.
- Extension points and execution lifecycle: the SDK owns its TypeScript export surface and generated declarations; the CLI owns the `ex` binary, setup, microruntime handling, adapters, and shell assets. Each manifest carries its own version. Use initial version `0.0.0` for both packages, preserving the migration baseline; no synchronized release scheme or release tool is introduced.
- Configuration, secret references, and data ownership: workspace manifests, lockfile, and shell adapters belong to the repository. Consumer microruntime descriptors and hooks remain consumer-owned. Existing user-local installation links and shell files must not be treated as disposable repository output. No new secret or production connection is required.

### Problem and inspected migration baseline

At discovery, the combined package advertised an SDK import and a command-line binary under one identity. The owner needs explicit library and CLI boundaries with independent manifests. The TypeScript entry exports an empty API, while all executable CLI behavior is shell-based; baseline source inspection found no CLI consumption of the SDK.

The inspected baseline root command, postinstall adapter, workspace dependency, hook fixtures, and active documentation referenced the combined location. The CLI resolved its version from a manifest relative to its shell entry point. Setup accepted a user-local link only when its target exactly matched the current CLI path, so a directory move alone would break repeated setup for existing installations.

### User stories and acceptance requirements

| ID | User story | Observable acceptance |
| --- | --- | --- |
| REQ-SPLIT-01 | As a maintainer, I want distinct SDK and CLI packages so their ownership is explicit. | The workspace discovers the two requested package identities; both are private and explicitly versioned. The combined workspace is retired without leaving a competing package identity. |
| REQ-SPLIT-02 | As an SDK consumer, I want the existing library contract preserved so a packaging change does not invent behavior. | SDK build produces the existing JavaScript and declaration exports. The API remains empty. CLI scripts and user setup are absent from the SDK's intended distribution boundary. |
| REQ-SPLIT-03 | As a CLI user, I want `ex` to retain its command behavior after relocation. | The CLI owns its executable mapping and all required shell assets. Help, version, descriptor handling, adapter dispatch, and explicit consumer-hook behavior retain their contracts; version comes from the CLI's own manifest. No artificial SDK dependency is added. |
| REQ-SPLIT-04 | As a contributor, I want workspace commands and installation to resolve the relocated CLI. | Root `pnpm ex`, postinstall, declared workspace dependencies, lockfile importers, and affected hook fixtures resolve the new CLI. Existing Husky setup and its skip behavior are preserved. SDK dependency edges are added only for actual consumers. |
| REQ-SPLIT-05 | As an existing CLI user, I want a safe path from my current setup to the relocated command. | The selected migration policy handles links to the old location of this checkout, including the environment entry, and repeated setup. Unrelated links, ordinary files, and another checkout's installation are preserved. Failure is actionable and never reported as a successful complete migration. The policy is recorded in DEC-SPLIT below. |
| REQ-SPLIT-06 | As a contributor, I want current instructions to describe the new ownership and commands. | Active README, agent context, package guidance, and relevant current design references resolve to the new packages. Historical verification records retain the source names and revisions they actually examined. The future release draft describes separate packages without changing their current private visibility. |
| REQ-SPLIT-07 | As a reviewer, I want evidence at consumer boundaries so the split does not hide a broken installation. | Verification distinguishes static package resolution, SDK compilation, controlled CLI fixtures, and actual external execution. No provisioning or infrastructure success is claimed from adapter inspection or a fixture. |

### Scope boundaries

This spec does not add SDK APIs, convert the CLI to TypeScript, generate consumer `.exphere/` directories, implement the future root agent-context extension, change microruntime contracts, install infrastructure, publish packages, or add release automation. Existing future context-extension tickets remain separate. No compatibility package for the old workspace name is requested.

## Responsibilities

- Consumer: retain ownership of microruntime composition, descriptor contents, configured adapters, and explicit hooks. Project contributors use the documented workspace entry points.
- Platform: maintain package identities, the CLI entry contract, safe setup behavior, dependency boundaries, shell adapter conventions, and evidence. Preserve the current local quality hooks and advisory SDD semantics.
- Service owners: the project owner approves the migration policy and verification scope. No production service or organizational adoption is introduced by this split.

## Operation and limits

- Resources, isolation, permissions, and capacity: implementation operates on repository source; setup verification uses disposable fixture directories. Real user-local installation changes require separate authorization. No cloud resources, budget, throughput, or availability target is requested.
- Failures, timeouts, cancellation, and cleanup: missing package assets, an unreadable CLI manifest, conflicting links, or setup write failures produce explicit failures. Check ownership of both affected links before mutation; avoid leaving the executable migrated while silently retaining a broken environment entry. Preserve existing setup skip behavior. Temporary verification output must be task-owned and cleaned without touching personal configuration.
- Installation, updates, and removal: preserve the `ex` binary name. Root setup calls the new CLI package; the SDK does not gain a setup side effect. Remove the old source location only after all moved assets and live references are accounted for. Repeated setup is idempotent. CLI removal affects only demonstrably owned links if removal behavior is later provided; a new uninstaller is outside this spec.
- Observability and execution correlation: report the package names and versions, examined source revision, command outcomes, and fixture versus real execution. Logs must distinguish skipped setup from successful activation. Use the containing spec for evidence; do not invent operational telemetry.

## Verification and decisions

- Affected guardrails: Twelve-Factor v1 `12F-01`, `12F-02`, `12F-03`, `12F-05`, `12F-09`, `12F-11`, and `12F-12`; advisory SDD v1 for later delivery. See the [guardrails](../../.agents/guardrails/README.md).
- Applicability, criteria, owners, and planned evidence: package/source identities, dependencies, setup inputs and skips, build/distribution boundaries, setup interruption, diagnostics, and administration ownership require evidence at the identified revision. The SDK is a library and the CLI is not a network service; backing services, port binding, service concurrency, and durability targets are not applicable to this packaging-only change. Existing external adapter contracts are preserved, not re-certified. Behavioral criteria remain `not-verified` until execution evidence is recorded.
- Cost/consumption impact: local builds and disposable fixture work only. No paid service, infrastructure allocation, or measured savings is proposed. Local CPU/time consumption is unmeasured.
- Open issues and exceptions: `DEC-SPLIT` records the selected legacy-link migration and isolated public consumer verification. The current implementation request authorizes this bounded CLI test scope; unrelated tests and real user installation changes remain excluded. Future release policy remains open.
- Verification plan: `VER-SDK-CLI-SEPARATION`, below.
- Execution evidence: [SPLIT-01 evidence](../tickets/0015-TICKET-sdk-cli-separation.ticket.md#evidence) records current command and fixture outcomes; review of the examined source remains pending. Fixture results do not establish real user installation or infrastructure outcomes.
- Trade-offs, decisions, and blocking questions: `DEC-SPLIT`, below. Implementation decisions require technical review and evidence; they do not establish a release policy or prove migration success.
- Technical review: Standards and Spec reviews passed for snapshot `c5f15b459bfc415172764c4aa16d39fb9ac437207a709e11c0ae471751d3f63d` after correction of the missing CLI environment-asset check. See linked ticket evidence for methods, red/green verification, and limits.

### VER-SDK-CLI-SEPARATION

**Authorized primary seam:** the workspace/package consumer boundary in one isolated fixture environment. Build and import the SDK through its public export, and invoke the packaged CLI through its executable entry rather than sourcing private helper functions. Existing root hook fixtures provide prior art for isolated installation checks and postinstall orchestration; extend or reuse that seam where practical instead of introducing another harness.

Good verification observes package ownership and externally visible outcomes: independent manifests and version reporting; SDK exports; CLI help and harmless descriptor validation; root installation delegation; fresh and repeated setup; verified legacy links; unrelated or dangling links; partial setup failure; and CLI assets remaining available outside their original source directory. Adapter behavior can use controlled tool outcomes; no Terraform apply, Kubernetes mutation, consumer production hook, or personal shell modification is needed.

The current implementation request authorizes installation, compilation/type checking, and focused tests at this isolated public consumer seam. No check passed merely because it was authorized; results and examined revisions remain to be recorded. A build pass alone does not prove link migration or package-consumer behavior. Live infrastructure, browser/service probes, personal shell changes, and unrelated tests remain excluded.

### DEC-SPLIT

- **Confirmed direction:** separate `@exphere/sdk` and `@exphere/cli`; both private and explicitly versioned; existing command and library responsibilities remain intact.
- **Initial versions:** `0.0.0` for both, selected under the execution request and preserving the baseline. Future version coordination is outside this migration.
- **Migration policy:** automatically retarget only links whose exact legacy destination belongs to this same checkout, including the executable and environment entry. Preserve the conflict refusal for other installations and ordinary files. Record how partial failure is detected and recovered. Verification uses isolated installations; real personal links are not changed under this scope.
- **Verification:** the authorized consumer seam above, using isolated installation fixtures and no live infrastructure. Outcome evidence remains pending.
- **Delivery boundary:** commit and push reviewed ticket-scoped changes on the requested separate feature branch without force pushes. This direct authorization covers the migration; it does not authorize merging, npm publication, deployment, or unrelated changes.

### Delivery verification

The linked ticket records the completed local implementation and its observed evidence on October 11, 2026. The earlier verification sections describe the planned criteria; results are limited to the installed dependency graph, static review, compilation, and expressly authorized fixture or generated-artifact checks. Production and browser/runtime criteria without execution evidence remain not-verified. No blanket policy compliance or release availability is claimed.
