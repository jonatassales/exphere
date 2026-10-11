# Technical specification

- ID: `SPEC-MICRORUNTIME-LIFECYCLE`
- Document: `SPEC-0010`
- Version: `1`
- State: `draft`
- PRD: [PRD-0002 v1 — Local microruntimes](../prd/0002-PRD-local-microruntimes.prd.md). Its accepted product decisions are recorded in that draft; approval of the complete PRD revision is not recorded.
- Technical owners: Exphere project owner for the local pilot; platform implementation/review owners and the actual pilot operator remain to be assigned.
- Approval: the owner invoked `to-spec` on October 11, 2026 and requested configuration and lifecycle specifications. The owner explicitly placed inspection, evidence, failures, and cleanup with lifecycle operations from the start. Draft synthesis is authorized; approval of technical proposals, verification seam, implementation, and pilot execution is not recorded.

## Implementation decision record — October 11, 2026

The owner's subsequent `Approved` accepted the ticket breakdown. The explicit `implement && commit separate branch && PR` request then authorized implementation, harmless disposable public-CLI fixtures, commits, and PR delivery. This record supersedes earlier drafting statements about pending implementation authority. The owner's later instruction, "no Docker validation for now," explicitly defers the real Docker/kind/Terraform pilot beyond this delivery. Live readiness, quota enforcement, and removal remain unverified; that deferred validation does not block the requested commit and PR.

- DEC-MRL-01: public operations are `up`, `inspect`, `down [--recover]`, `logs UNIT`, `connect UNIT LOCAL_PORT SERVICE_PORT`, and explicit `run HOOK --effects none|runtime [-- ARGS...]`. Optional `--timeout SECONDS` precedes positional arguments; default 120, range 1–3600, shared across native calls. A command receives no fresh deadline per stage. Capture is capped at 4 MiB per native stream; truncated output is a failed observation. Hooks have a smaller explicit output cap.
- DEC-MRL-02: reference target is existing local Docker/kind 0.33.0, Kubernetes/kubectl 1.37.0, Terraform 1.16.5, and Kubernetes provider 3.2.1. Verify a Unix container endpoint and the selected numeric-loopback HTTPS server/CA against kind's actual kubeconfig. Record actual versions and access. Images must already be loaded on every selected kind node. Only stateless, unprivileged apps/v1 Deployments and v1 ClusterIP Services are supported, with explicit replicas, resources, and readiness. Up to 64 native objects are accepted. Unsupported kinds, selectors across units, PVC/host use, and arbitrary Terraform roots fail before mutation.
- DEC-MRL-03: private durable state is `.exphere/state/runtimes/ID`; each run has separate ignored evidence under `.audits/evidence/runs/RUN`. Mutation locks record owner process and deadline. Explicit recovery refuses live/reused PIDs and uncertain child ownership. Resource UID plus an unguessable runtime token, prior evidence, retained preparation source/state, and actual target identity govern cleanup. Persist intent before apply; interrupted effects require reconciliation. Do not auto-retry or roll back. Native configuration changes do not erase prior object identities.
- Cleanup removes recorded workloads with UID preconditions and waits for absence, then inventories all namespaced resource types. Foreign, changed, retained, or unobservable contents keep preparation resources. Namespace deletion through the pinned provider has no atomic UID precondition: the pilot therefore requires exclusive namespace mutation during cleanup; inventory/rechecks cannot prove safety against a concurrent external writer. The shared cluster is retained.
- DEC-MRL-04: machine-readable records distinguish configured settings, observed identities/readiness/usage, absent signals, native results, and cleanup dispositions. Metrics and monetary data are unavailable when their source is absent, never zero. Raw credentials/state/manifests/log content are excluded from summaries; transient native outputs are private and removed on normal exit. Records/state are retained until the operator archives/removes them deliberately; no automatic history expiry or production retention policy is claimed.
- DEC-MRL-05: hooks are explicit trusted shell code, never automatic lifecycle bindings or a sandbox. The caller declares no resource effects or effects limited to declared owned workloads. Runtime effects use the mutation boundary, record intents, and reconcile live identities; unsupported or unexplained namespace objects are retained. Logs are explicitly requested, and port forwarding binds only loopback within the operation bound.
- VER-MRL-01: controlled executables at the public CLI boundary cover local proof, versions/access, preparation failure, startup/readiness, composition, quota events, ownership, inspection gaps, cleanup, recovery, and explicit extensions. These tests do not establish successful real provider/Kubernetes operation, throughput, savings, or production readiness. Tickets remain in review; the owner deferred live Docker validation beyond this delivery.
- Review corrections: cluster proof preserves the selected consumer credentials; kind's kubeconfig supplies only server/CA comparison. Inspection checks target/namespace ownership and image availability. An acquisition guard serializes both normal locking and stale-lock recovery; an interrupted guard requires manual reconciliation. Bounded process shutdown waits for its termination and ownership check before releasing the mutation boundary.
- Recovery reconciles interrupted preparation against retained native namespace UID, actual target, and prior run evidence. Confirmed cleanup archives the original ledger and releases the recognized preparation source/target snapshot only after namespace absence and empty native state, retaining state backups and operation history. Log collection follows the Deployment/ReplicaSet/Pod controller UID chain and withholds output when the selected pod identity changes.
- Guardrails: FIN-01 through FIN-05 and applicable Twelve-Factor v1 criteria were assessed for configuration ownership, images, resource boundaries, explicit processes, logs, state isolation, and admin operations. Local fixture evidence supports only the tested contract. Actual capacity, enforcement, consumption, and disposal in the selected pilot remain not verified.

Reference versions were checked against the [Terraform release index](https://releases.hashicorp.com/terraform/), [Kubernetes provider 3.2.1 release](https://github.com/hashicorp/terraform-provider-kubernetes/releases/tag/v3.2.1), and [kind 0.33.0 release](https://github.com/kubernetes-sigs/kind/releases/tag/v0.33.0). The reference node image is `kindest/node:v1.37.0@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5`; cluster preparation remains an explicit consumer action.

## Contract and composition

- Requirements addressed: primary ownership of `REQ-MR-005` through `REQ-MR-011` and operational portions of `REQ-MR-012` through `REQ-MR-014`; consumes configuration accepted under `REQ-MR-001` through `REQ-MR-004`.
- Components selected by the consumer: all selected application units, starting with the existing website and its consumer-provided prebuilt image. No application build or source relocation occurs.
- Environment and executor selected by the consumer: explicitly selected local Kubernetes context and runtime namespace; kind is the reference environment. One Terraform root/state owns namespace and quotas; the Kubernetes adapter owns application manifests.
- Extension points and execution lifecycle: the CLI coordinates preflight, preparation, application, readiness, inspection, evidence, and explicit cleanup. Consumer `.sh` extensions are optional and declared; no filename convention implicitly authorizes their execution.
- Configuration, secret references, and data ownership: consume [SPEC-MICRORUNTIME-CONFIGURATION v1](0009-SPEC-microruntime-configuration.spec.md). Native files retain technical authority. Terraform state, credentials, and execution outputs are operational data, not versioned authored runtime configuration.

### Problem and intended result

The current CLI forwards individual Terraform/Kubernetes commands and runs a hook only when explicitly selected. It has no coordinated lifecycle, readiness evaluation, resource inventory, or generated execution evidence. A successful tool invocation alone cannot explain whether every selected unit became ready or what remains after failure.

The delivery is an inspectable local journey: a valid configuration passes preflight, Terraform prepares the runtime's namespace and quotas, every selected unit is accounted for, declared readiness is assessed, and explicit cleanup reports each remaining owned resource. Inspection and evidence accompany successful and failed operations from their beginning. Local observations do not establish production availability, capacity, or economic benefit.

### User stories

1. As a developer, I want prerequisites and target selection checked before mutation so that a missing image, invalid configuration, or unsuitable environment has an actionable outcome.
2. As a runtime operator, I want preparation and all selected units coordinated so that partial failures and readiness are visible at the correct stage.
3. As a service owner, I want configured limits, observed outcomes, events, logs, and available measurements distinguished so that I can explain resource-boundary failures.
4. As a developer, I want explicit cleanup with a remaining-resource inventory so that I can end a local runtime while preserving shared infrastructure and application source.
5. As a reviewer, I want correlated evidence from the actual execution so that I can trace the result to its inputs, tools, environment, and actions.

### DEC-MRL-01 — Proposed operation interface and stage contract

Propose `ex runtime <id> up`, `inspect`, and `down` as the public lifecycle operations. These are planned commands, not currently available features. `up` coordinates preflight through readiness, `inspect` reads runtime/unit state without reconciling infrastructure, and `down` explicitly ends owned resources. Detailed flags, timeout values, confirmation behavior, and output encoding must be resolved before implementation. Existing low-level v1 adapter commands remain governed by the companion transition policy; they do not silently acquire v2 lifecycle behavior.

| Stage | Required behavior | Failure and evidence boundary |
| --- | --- | --- |
| Begin operation | Allocate a run identity, identify the selected runtime/configuration, and establish writable evidence/state destinations before infrastructure mutation. | If mandatory recording cannot begin, stop without mutation and explain the failed prerequisite. |
| Preflight | Revalidate v2 configuration; check supported capabilities, tools/versions, local target/access, namespace ownership, image availability path, and operation prerequisites. | Record each result and stages not attempted; failure prevents the affected mutation. A binary on PATH or successful JSON parsing is insufficient. |
| Prepare | Initialize/validate the supported Terraform root as needed, inspect its planned resource scope, and explicitly apply namespace/quota preparation to the same context/namespace. | Capture actual outcomes and partial inventory. Failed preparation blocks all workload application. Tool initialization may write/download dependencies and belongs to the explicit operational action. |
| Apply units | Enumerate the complete selected native resource set, including nested manifests; apply every unit or record why it was not attempted. | Record each attempted object and unit result. Never silently skip nested files or represent partial application as a successful composition. |
| Readiness | Evaluate supported workload readiness against native consumer criteria within explicit finite operation bounds. | Rejected resources, unavailable images, unhealthy units, and timeouts prevent a passed startup. Missing observation produces an inconclusive result. |
| Inspect and finalize | Collect unit/resource state, events, logs, configured requests/limits and quotas, actual image identities, action results, and available metrics. | Collection also runs after partial failure where possible. Collection failures remain visible and cannot erase the original failure or manufacture success. |
| Explicit cleanup | Observe current ownership, remove owned workloads, then eligible Terraform preparation resources, and inspect leftovers. | Record removed, retained, unresolved, and unobservable resources. Cleanup failure must not be reported as a complete teardown. |

The proposed bounded MVP applies units in a documented deterministic order and stops further mutations after a failed stage; all later units are marked not attempted. It does not infer a dependency graph from component names. Separate stage results from the overall `passed`, `failed`, or `inconclusive` evidence outcome. Confirmed violations are failed; required observations that cannot be obtained are inconclusive unless a known failure already determines the result. Cancellation is recorded explicitly and cannot yield passed. Successful `up` is not completion of the full PRD journey until inspection and cleanup outcomes are also recorded.

### DEC-MRL-02 — Target, prerequisites, images, and native authority

- Use the descriptor's explicit context/namespace throughout Terraform, Kubernetes, hooks, inspection, and cleanup. Never switch the user's global current context. A context name or `environment: local` declaration is not proof of a local target; define an explicit supported local-target check before permitting mutation.
- Propose an already prepared local cluster as the MVP prerequisite. Document explicit consumer cluster preparation and removal outside workload `up`/`down`; do not create or delete a shared cluster implicitly. Support kind first, and report other environments as unsupported until their compatibility checks are defined.
- Declare and pin the reference versions of the CLI prerequisites, Terraform, its Kubernetes provider, kubectl, kind, Kubernetes node image, and container environment before implementation/pilot verification. Record actual versions at execution. This draft does not guess a compatibility matrix from installed binaries.
- Image building is excluded. Confirm that each prebuilt image is reachable by the selected cluster, or define an explicit image-loading step for kind with recorded image identity and result. Registry credentials remain external. A local host image listing is not evidence that the cluster can use it.
- Specify the pilot's local endpoint mechanism before implementation; propose an explicit bounded port-forward to the native Service. It must identify address/port, process ownership, and shutdown behavior. Do not silently edit application ports or claim an endpoint is available without observation.
- Native manifests remain authoritative for workload image, resources, replicas, probes, volumes, and scheduling. Propose an initial supported Deployment/Service composition, with explicit support decisions for any additional resource forms. Reject unsupported cluster-scoped objects, mismatched namespaces, Terraform-owned resources, and unresolved manifest aggregation before applying any selected unit. Do not present a namespace flag as a sandbox.
- Terraform namespace/quota ownership is exclusive. The selected namespace is an input to the preparation root, not a second editable target. Restrict the pilot to a reviewed root/provider/resource scope; do not claim to infer the safety of arbitrary consumer Terraform code or arbitrary native extensions.

### DEC-MRL-03 — State, failures, interruption, and cleanup

One state belongs to one runtime, independent of individual run evidence. Propose a local Terraform backend with state and provider working data excluded from version control, stable across CLI invocations and process interruption. Exact storage, locking, and recovery behavior must be specified before implementation. Do not inherit an ambient workspace/backend/target that silently changes runtime ownership. Competing mutating operations for the same runtime must be rejected or serialized; read-only inspection must identify incomplete operations.

Do not automatically destroy resources after a failed startup: preserve inspection and the partial inventory, then expose explicit cleanup. Do not automatically retry mutating stages or claim rollback. An interrupted subprocess may have changed resources; a subsequent inspect/cleanup must reconcile actual state rather than trust a completed-command ledger alone. Repeated cleanup distinguishes already absent objects from lookup or permission failures. Native tool exit meanings must be interpreted per operation, not reduced to a universal success/failure rule; retain the original result in evidence.

Before deletion, establish resource identity and ownership from the runtime/configuration, Terraform state, recorded operations, and live inventory. Never infer deletion authority from a familiar resource name alone. Track resources from earlier partial runs even if the latest configuration removed their declaration; ambiguous ownership blocks destructive action and is reported.

Cleanup removes owned workloads first and waits for or records their removal before destroying preparation resources. Inspect the namespace for foreign, retained, or unknown resources before destroying it. If namespace deletion would erase resources outside the runtime's authorized cleanup scope, retain the namespace/preparation resources and report the blocker. Do not cascade through a failed workload cleanup by deleting its namespace. Preserve shared clusters, unrelated namespaces, consumer source, native configuration, and evidence. Persistent data needs an explicit retention/removal decision; unsupported stateful cases are rejected before startup rather than silently discarded later.

On cancellation, attempt to stop owned child processes, retain available records, and report uncertain remote outcomes. Use finite documented bounds for readiness, evidence collection, hooks, and cleanup. Expiry reports failure or uncertainty with remaining resources; it does not silently extend indefinitely or imply automatic expiration enforcement.

### DEC-MRL-04 — Inspection and evidence from the first operation

Use the existing `.audits/evidence/runs/<run-id>/` contract. Propose a machine-readable operation summary plus bounded diagnostic outputs; the precise encoding is open. Each operation receives its own identity and links related startup, inspection, and cleanup operations for the same runtime. Evidence is local and ignored by default; publishing sanitized evidence is a separate action.

| Evidence group | Required content |
| --- | --- |
| Identity and inputs | Initiative/spec/requirement IDs, runtime and unit identities, owner reference, component references, code revision or explicit unavailable state, dirty/untracked configuration identification, effective input hashes, declared images and observed image identities. |
| Environment and conditions | Actual context/cluster identity and namespace, tools/providers and policy versions, resource configuration, image availability/loading conditions, local endpoint details where used, and a load profile explicitly recording that no load test ran. |
| Actions and timing | Start/end, stage/command/check performed, native result, every selected unit's attempted/not-attempted/readiness state, interruption and timeout information, and links to diagnostic artifacts. |
| Observation | Resource identities and ownership, configured quotas/requests/limits, readiness/events/logs, available measurements with source/window, and explicit unavailable signals. |
| Result and disposition | Overall passed/failed/inconclusive outcome, known failures and observation gaps, cleanup inventory, intentional retention, unresolved resources, and suggested next operator action. |

Do not invent timestamps, revisions, digests, or usage values. Declared image tags are distinct from observed image identities. If required observation is unavailable, record the gap and its acceptance consequence. Treat state, logs, environment values, native outputs, and manifests as potentially sensitive; capture only necessary fields, redact secret values, and avoid copying credentials or Terraform state into published evidence. Define local retention and size bounds before the pilot without pretending the existing contract has already selected shared storage or authentication.

Inspection must label configured limits, observed usage, and monetary information separately. A quota is not a currency budget; missing metrics remain unavailable, not zero. Show the original workload failure together with quota events when observed rather than infer quota causality from every readiness timeout.

### DEC-MRL-05 — Optional extensions

Hooks remain trusted consumer `.sh` code with process permissions; the CLI is not a sandbox. Proposal: retain explicit hook selection and add no automatic lifecycle binding until named stages, arguments/environment, timeout, failure propagation, and cleanup ownership are specified. A hook cannot replace mandatory preflight/readiness/evidence with an unexplained success flag. Consumer-declared extension effects must be covered by the operation inventory or explicitly remain unsupported; no cleanup guarantee follows merely from having a hook declaration.

## Responsibilities

- Consumer: supply the prebuilt image, supported local environment, native configuration, credentials through appropriate references, targets and timeout/retention decisions; authorize operations affecting that environment.
- Platform: coordinate the declared composition, preserve target and ownership boundaries, fail transparently, correlate evidence, and expose partial or retained resources. Do not certify a native tool or arbitrary hook as safe simply because it ran.
- Service owners: define readiness/resource criteria and permitted data retention/removal for their service. The pilot operator owns responding to unresolved resources; this specification invents no production authority or organizational commitment.

## Operation and limits

- Resources, isolation, permissions, and capacity: local runtime-owned namespace/quotas/workloads only. Consumer limits are not universal recommendations. Check permissions for the requested stages and report unavailable observation; do not provision cloud resources or expand access to complete the pilot.
- Failures, timeouts, cancellation, and cleanup: governed by `DEC-MRL-01` and `DEC-MRL-03`, including partial preparation, failed readiness, interrupted execution, deletion ordering, and foreign-resource protection.
- Installation, updates, and removal: the companion specification owns configuration generation and v1 transition. `up` does not reinstall tools or rebuild images. `down` ends resources while retaining authored configuration and evidence; uninstalling configuration/CLI is a separate concern.
- Observability and execution correlation: governed by `DEC-MRL-04`; inspection and evidence are part of every stage, including failure. Evidence records outcomes, not authenticated approval.

### Out of scope

Cloud provisioning, production access, image building, portal/catalog integration or replacement, general workload/provider support, arbitrary dependency scheduling, automated rollback, load/stress/soak testing, memory-leak guarantees, production SLO certification, billing ingestion, monetary budget enforcement, automatic optimization, remote runtime distribution, and a general workflow engine are excluded. This phase creates no tickets, implementation, new test suite, cluster, execution evidence, or remote publication.

## Verification and decisions

- Affected guardrails: FinOps v1 `FIN-01`, `FIN-04`, `FIN-05`, and `FIN-06`; conditional `FIN-02`/`FIN-03` if selected dependencies incur paid consumption. Twelve-Factor v1 `12F-01`, `12F-02`, `12F-03`, `12F-05`, `12F-07`, `12F-08`, `12F-09`, `12F-10`, `12F-11`, and `12F-12`; `12F-04`/`12F-06` require explicit assessment if backing services or durable workload state enter the selected composition.
- Applicability, criteria, owners, and planned evidence: the project owner defines pilot criteria/authorization; the operator records observations; reviewers assess the actual implementation and evidence. Operational compliance is `not-verified`. Versioned inputs, native configuration review, stage records, image identity, readiness/events/logs, quota observation, and cleanup inventory are the planned evidence for the affected criteria.
- Cost/consumption impact: documentation itself has no infrastructure-consumption effect. Before a pilot, identify local compute/storage/network, downloads/registry use, duration, retention, and owner; assess paid dependencies when selected. `FIN-07` savings comparison and `FIN-08` optimization are `not-applicable`: no savings or optimization claim is proposed. Quotas and cleanup support resource accountability but do not enforce a currency budget.
- Open issues and exceptions: resolve `DEC-MRL-01` through `DEC-MRL-05`, exact version/compatibility matrix, supported manifests, local-target proof, operation time bounds, state/locking, image availability/loading, endpoint handling, and evidence encoding/retention before dependent implementation. Confirm the proposed seam and authorize live pilot operations separately; prior hook/package fixtures do not cover infrastructure execution. No exception is recorded.
- Verification plan: `VER-MRL-01`, below.
- Trade-offs, decisions, and blocking questions: a single local lifecycle keeps failures, observability, and cleanup attached to the operations they control. A bounded supported composition makes ownership inspectable; native extensibility does not imply universal support. Manual cleanup after failure preserves diagnosis but leaves an explicit operator responsibility.
- Technical review: pending for implementation and owner acceptance; documentary review cannot establish runtime success or complete cleanup.

### VER-MRL-01 — Proposed public lifecycle seam

- Section state: `draft`; covers this specification v1 and `PRD-0002` v1, using configuration from the companion specification.
- Owners of targets and execution: project owner and the named pilot operator; their actual operational values and authorization remain pending.
- Execution profile: invoke the public CLI against a disposable consumer configuration. Reuse existing CLI subprocess/tool-boundary fixture conventions for deterministic failures. After separate authorization, use the same public commands against the selected real local Kubernetes/Terraform environment and prebuilt website image.
- Good checks observe stage/tool actions, per-unit outcomes, resource ownership, evidence, and cleanup. Controlled tool responses verify coordination but cannot prove Kubernetes enforcement, real readiness, actual image use, or Terraform cleanup. Internal function assertions and unrequested application test infrastructure are unnecessary.

| Scenario | Requirements | Criterion and planned evidence |
| --- | --- | --- |
| Invalid input, unsupported capability, missing tool/image, nonlocal or inaccessible target | `003`, `005`, `012`, `014` | Actionable preflight result, stage record, and proof that affected infrastructure mutations did not run. |
| Preparation failure or interruption after partial changes | `006`, `010`, `011` | No workload application; preparation result, reconciled inventory, and explicit cleanup path remain available. |
| Valid composition including more than one unit and nested manifests | `001`, `007`, `008`, `011` | Every selected unit accounted for, native image/readiness authority preserved, actual image identities and endpoint conditions recorded. |
| Failed unit, missing image at execution, readiness timeout, canceled operation, or failed hook | `007`, `008`, `011`, `012` | No passed composition; failed/not-attempted units and collection gaps are explicit; partial resources remain inspectable. |
| Workload exceeds native quota | `009`, `013` | Real cluster quota/event observation and rejected/unready outcome; no claim that a stubbed tool result demonstrates enforcement. |
| Normal and repeated cleanup | `010`, `011`, `014` | Owned workloads removed before preparation resources; before/after inventory distinguishes absence, retention, failure, and unknown state. |
| Foreign/retained resource, ownership ambiguity, failed workload deletion, or changed configuration | `010`, `014` | No destructive namespace fallback; earlier owned resources accounted for, shared/source/configuration resources preserved, blockers reported. |
| Interrupted evidence write, unavailable metrics/logs, or sensitive native output | `008`, `011`, `013` | Missing evidence prevents an unsupported success claim; signals stay unavailable, configured values remain distinct, and secret values are excluded/redacted. |

Requirement suffixes refer to `REQ-MR-*`. The seam is proposed and requires confirmation before implementation; live environment use also requires authorization for those operations. No automated suite or pilot has run in this drafting phase.

| PRD metric | Planned observation and acceptance use |
| --- | --- |
| `MET-MR-001` | Correlate configuration acceptance, preparation, all-unit readiness, inspection, and cleanup for each attempted journey; absent evidence cannot count as completion. |
| `MET-MR-002` | Record elapsed time from explicit execution until all units are ready, including preparation/image conditions; no invented productivity threshold. |
| `MET-MR-003` | Inventory after cleanup and explain every remaining owned resource; unresolved/unobserved resources prevent a complete-cleanup claim. |
| `MET-MR-004` | Compare declared inputs, actual image identities, configuration revisions, versions, and relevant local conditions across authorized runs. |

### Source and decision boundaries

The [current CLI contract](../../packages/cli/cli/README.md), [proposed ADR-0001](../design/0005-DD-microruntime-architecture.dd.md), [domain vocabulary](../agents/0007-DD-domain-model.dd.md), [evidence contract](../../.audits/evidence/README.md), and [local guardrails](../../.agents/guardrails/README.md) constrain this draft. The SDK API remains empty; no workflow engine, policy certification, production integration, or organizational adoption is implied. Implementation granularity belongs to later tickets within these two specifications, not separate specifications per tool.

### Draft synthesis review — October 11, 2026

The [shared review record](0009-SPEC-microruntime-configuration.spec.md#draft-synthesis-review--october-11-2026) identifies the base and SHA-256 snapshot of this specification, the configuration specification, and PRD-0002. Two independent reviewers assessed that same scope before these documentary review records were appended.

- Standards: **0 findings**. The draft preserves canonical structure, local policy boundaries, scoped cleanup, native ownership, and honest evidence states.
- Spec: **0 findings**. Inspection, evidence, failure handling, and cleanup remain attached to local execution from the start; every PRD requirement and metric is accounted for across the two specifications.
- Static checks: local links resolve, canonical template sections are present, and whitespace inspection reported no errors. No runtime checks were performed.
- Scope of result: draft synthesis only. Open technical decisions and proposed verification still require resolution before implementation; no operational success, owner acceptance, or authorization to execute follows from this review.

### Implementation review and verification — October 11, 2026

Reviewed against configuration commit `26d21c538cd56ba68e8cfd1932cdbd7a60328100` on feature branch `codex/local-microruntime-lifecycle`. The manifest below identifies the final 32-file lifecycle delta before this review record was appended. Configuration is delivered separately in PR #6. MRL-01 through MRL-05 belong to this specification; MRL-02 is the commit's primary lifecycle ticket.

#### Standards

Pass: zero outstanding actionable findings in the identified implementation snapshot. Bounded shutdown now completes termination/reconciliation before releasing its mutation lock, and uncertain process ownership remains explicit. Repository policies and evidence limits were assessed independently from specification fidelity.

#### Spec

Pass: zero outstanding actionable findings. Corrections cover interrupted preparation identity, absent-resource cleanup and snapshot retirement, inspection preflight, competing recovery locks, owned-pod log selection, and preservation of consumer credentials. Both axes verified the same 32-file hash manifest, whose SHA-256 is `d3dc4a167fee401c37b4a3e9c431c76fbb88a71323245bad19c8f5e235895a92`.

Validation: public CLI contract fixtures passed for preparation, observation, composition, recovery, access, concurrent lock acquisition, and a TERM-resistant child process. The process-boundary fixture requires observable process state and passed outside the restricted tool sandbox. Workspace checks and typechecking passed; the owner subsequently deferred further test execution as technical debt, including the final complete suite. Reviewers performed no infrastructure operations. The owner's explicit deferral of real Docker validation governs this delivery: live readiness, quota enforcement, capacity, and cleanup remain unverified.

```text
ec5590408645b0f94c18d64d315adf0596657d5cfe00ef4bca57f05cc4f0d35c  .artifacts/prd/0002-PRD-local-microruntimes.prd.md
704195149af6f7f728288636366d69cc905349c27c52c523f7b9972fe7e87b13  .artifacts/specs/0010-SPEC-local-microruntime-lifecycle.spec.md
a866d9b76b30df44bd0a5aa863b4f2e0e065f162f804c6f9bae6400149840400  .artifacts/tickets/0023-TICKET-local-microruntime-preflight.ticket.md
2dfd08a5907006b208a834d0ecd1c2c6130d23b5a0ba0ec7488425b855b3e34f  .artifacts/tickets/0024-TICKET-single-unit-local-lifecycle.ticket.md
7d31979e928182f78d4b4d4c7c6eeed63265f1a1a0f77a05ed855544a0b5f59b  .artifacts/tickets/0025-TICKET-composed-local-microruntimes.ticket.md
b21f1a7482de3fe8e299c8943c42262f473280bddb0c632c648e5ae917e57ad5  .artifacts/tickets/0026-TICKET-interrupted-microruntime-recovery.ticket.md
5892876247c467d52f103db53d1ac3ca1b01f5d2b0e95e270ab2ef655fd9f064  .artifacts/tickets/0027-TICKET-explicit-microruntime-hooks.ticket.md
19e251ad334518e7fc483b592ce855fd30a98c9d40dc8f65dec4588c7ec36c2e  AGENTS.md
96fcf178b61b84a69d092f435e16bb25f258f2d9ccc0755837152ef69a61b1b9  README.md
ffc5e399bc8de252022d4cb3599d36c4b05fb35169d536fc3659c1dabb27fe9e  packages/cli/README.md
7d7e58377c3c19da733bdd6a9e1611c29b0e2e194bf6d23def78037355921956  packages/cli/cli/commands/help.sh
52027375bc30293dd3ef4f2e8b96ada58fe20796af7cee18e3b068d5584732e6  packages/cli/cli/commands/lifecycle.sh
6a877993d384f19de31b90a6b988c8550e3d870f506274efcacf89dc9ab7ef93  packages/cli/cli/core/access.sh
601fbdc43e962f7c6f776e47a9a100b8661825c4b8272d14bd2da8da44941534  packages/cli/cli/core/observation.sh
6c2166f2bb05857697d8cbc5e4faa7209c27b9cb5c7663705d43142ef145fc82  packages/cli/cli/core/operation.sh
051c378bf155228e872292a9bfec508ab65a9613424e776a308179d7042210ff  packages/cli/cli/core/preflight.sh
5799968cb736ba473a7c869902bb020d98d476be5d3efda44202c4f2b6c1e909  packages/cli/cli/core/recovery.sh
669ec32b19c670b22f423d7f25dc0a3098baf3c6173de7690bead76890f4a1cc  packages/cli/cli/core/terraform-runtime.sh
c839252889290d0e8506ebbcfdf192f5402eb895a997c66445ba191e40e4e56d  packages/cli/cli/core/workloads.sh
a54cc67242ad443ab25d61d26d32a6ffb804af2357de3b541519640593da1a70  packages/cli/scripts/test.sh
bab8fa3af4f89fe60883b627f620ea22dc69ff1566bea433e5ae25e0389008aa  packages/cli/scripts/tests/access.sh
5e1ab92bab2dca087daff9f1ce360318ccc181ff8af9d3a493111707a5b3e299  packages/cli/scripts/tests/composition.sh
a50dd5d6c62a1c150f0f9654500205c7a027e9bc7adb493d8e671af94776db97  packages/cli/scripts/tests/concurrency.sh
1285673cc6d3ea823874ed1a220dc0a1b598539fd16ae84634858a8b7448b1db  packages/cli/scripts/tests/fixture-kubectl.sh
d8245d5d191b98786e0296f280b7f0a9d6fd4c85a93a4185c29e7818bad7c4fa  packages/cli/scripts/tests/fixture-terraform.sh
257dd497af040e822bd362f1832f7973cbacc64d51cb7568d710534927341629  packages/cli/scripts/tests/lifecycle-fixture.sh
d27a40f40d67fb50f38bca656aff221504c9663c183acb11572e777d3b730431  packages/cli/scripts/tests/lifecycle.sh
8db0151b809722f23d90c5e3358bbcb5f5fc8745e0c9c90d2e0018c17d58a3de  packages/cli/scripts/tests/observation.sh
6d31fbfb65e1ca6cbc51df463221393a58bc541ab0608946429b996c15c12435  packages/cli/scripts/tests/preflight.sh
3135c0306259492ca99eac6ce3864fd4c99eeb639b3f072c9fdd1f0bd57c2835  packages/cli/scripts/tests/process-boundary.sh
f943b7e3fe70629440a4361aa880c0378898282436549fd37586598bbedc0c98  packages/cli/scripts/tests/recovery.sh
5b21c2f6b5e6f27e066f8ccfab86a421c6d1716cf9d43114e0018b0fa172a0b4  packages/cli/scripts/tests/terraform-runtime.sh
```

### Deferred validation debt — October 11, 2026

The owner subsequently instructed: "defer tests as tech debt, focus on implementation." Further test development and execution are deferred beyond this delivery, including the final full-suite run at the outgoing lifecycle commit. Existing fixtures are preserved, and earlier observed passes remain evidence only for their tested revisions. This scoped instruction overrides the repository's pre-push test requirement for this delivery; it does not claim those tests passed or change the shared hook policy.

Outstanding validation debt: run the complete suite against the delivered revision and exercise the real Docker/kind/Terraform journey, including actual readiness, quota enforcement, interruption/recovery, and cleanup. Scheduling and ownership of that follow-up remain with the project owner; no due date or operational acceptance is invented. Commit and PR delivery proceed with the reviewed implementation.
