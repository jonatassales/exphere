# Technical specification

- ID: `SPEC-MICRORUNTIME-CONFIGURATION`
- Document: `SPEC-0009`
- Version: `1`
- State: `draft`
- PRD: [PRD-0002 v1 — Local microruntimes](../prd/0002-PRD-local-microruntimes.prd.md). Its accepted product decisions are recorded in that draft; approval of the complete PRD revision is not recorded.
- Technical owners: Exphere project owner for the pilot's consumer decisions; platform implementation and review owners remain to be assigned.
- Approval: the owner invoked `to-spec` on October 11, 2026 and requested two specifications linked to `PRD-0002`: configuration and local lifecycle. Draft synthesis and this split are authorized. Approval of this draft's technical proposals, verification seam, tickets, and implementation is not recorded.

## Implementation decision record — October 11, 2026

The owner's subsequent `Approved` accepted the seven-ticket breakdown, and the explicit `implement && commit separate branch && PR` request authorizes implementation, disposable public-CLI contract fixtures, commits, and PR delivery for this scope. The drafting statements below describe the earlier phase; this record supersedes their pending execution status. They do not authorize a production deployment or establish a completed local pilot.

- DEC-MRC-01: ship the structural JSON Schema with the CLI; use the same shell/jq semantic validator for manual and guided configurations. References must exist and remain within their own boundary. Manual initialization writes only an incomplete v2 descriptor and a README explaining its missing inputs.
- DEC-MRC-02: `init --guided` collects and validates consumer values, reserves a new destination, and copies the descriptor, README, Deployment/Service native JSON, and `main.tf.json`. Handled failures and cancellation remove its new partial output or report retained output; an untrappable process termination may leave partial files that a later invocation refuses to overwrite. Publication is not atomic. Native Terraform uses four explicit context/namespace/kubeconfig/owner variables, a local backend, Terraform 1.16.5, and Kubernetes provider 3.2.1. No application source or image is built. Output is never merged into an existing runtime.
- DEC-MRC-03: keep v1 in its legacy location, expose creation through `init --legacy`, list both versions/paths, refuse ambiguous IDs, and reject raw adapter forwarding for v2. No automatic migration or removal date.
- VER-MRC-01: public commands in disposable consumer directories are the implementation seam. Added checks exercise equivalent manual/guided native semantics, explicit optional hooks, native edits, invalid structure/references, duplicate keys, collisions, interruption, write failures, and legacy behavior.
- Guardrails: FIN-01/04/05 and 12F configuration/build-release boundaries were assessed through source and isolated fixtures. Resource enforcement, actual usage, operational parity, startup/disposal, and economic benefit remain not verified by configuration generation. No paid runtime operation was performed.
- Delivery: implementation review and observed checks are recorded in MRC-01/MRC-02. The companion lifecycle specification is delivered separately under stable ID `SPEC-MICRORUNTIME-LIFECYCLE`.

## Contract and composition

- Requirements addressed: primary ownership of `REQ-MR-001` through `REQ-MR-004` and the installation portion of `REQ-MR-014`; configuration portions of `REQ-MR-005`, `REQ-MR-012`, and `REQ-MR-013`.
- Components selected by the consumer: existing application components, with the website as the first pilot. Each selected unit references its component; no application source is copied or generated.
- Environment and executor selected by the consumer: local Kubernetes, with kind as the reference environment; Terraform prepares namespace and quotas. Consumer-specific images, ports, resources, probes, quotas, context, and namespace remain explicit inputs.
- Extension points and execution lifecycle: optional declared consumer `.sh` hooks; this specification produces configuration for companion `SPEC-MICRORUNTIME-LIFECYCLE v1`, delivered in a separate PR. Generation and validation perform no infrastructure operations or hook execution.
- Configuration, secret references, and data ownership: the descriptor owns identity, references, and target selection. Kubernetes owns workload settings; Terraform owns namespace/quota configuration. Credentials and secret values are not embedded in generated descriptors, examples, or reports.

### Problem and intended result

The current CLI creates a version `1` descriptor with an opaque component map and forwards explicitly requested adapter commands. It cannot generate a composition of execution units, guide configuration, or validate the proposed version `2` contract. Developers need both configuration entry points to produce the same inspectable runtime model without moving application code or duplicating native settings.

The delivery is a valid project-local microruntime configuration that a developer can inspect and maintain before choosing to execute it. It is not evidence that the runtime starts, meets resource criteria, or cleans up successfully; those outcomes belong to the companion lifecycle specification.

### User stories

1. As a developer, I want to configure a microruntime manually or through guided questions so that I can choose the entry point appropriate to my project while using the same contract.
2. As a consumer maintainer, I want units to reference my existing components so that installing a runtime preserves application ownership and project structure.
3. As a runtime operator, I want actionable validation and an explicit legacy transition so that an unsupported descriptor or ambiguous target cannot be mistaken for usable configuration.
4. As a technical owner, I want editable native workload and preparation files so that resource, image, readiness, and quota decisions have one authoritative location.

### Configuration artifacts and boundaries

The following paths are public consumer contracts established by the PRD, not prescriptions for internal implementation modules:

| Artifact | Contract |
| --- | --- |
| `.exphere/runtimes/<id>/schema.json` | Version `2` runtime descriptor. Runtime identity matches the directory name. |
| Runtime `README.md` | Explain selected components, native configuration authority, prerequisites, and the handoff to explicit lifecycle operations. Do not claim a generated runtime has been executed. |
| Runtime `terraform/` | One consumer-maintained root for namespace and quotas, with one state per runtime. State storage and isolation are owned by the lifecycle specification. |
| Runtime `units/<component-directory-name>/kubernetes/` | Execution configuration for that selected component. The first pilot unit references `apps/website`; application source stays there. |
| Runtime `hooks/` | Present only when hooks are selected; supplied scripts use `.sh`. No placeholder hooks or speculative capability directories. |

Project-relative component references and runtime-relative configuration references are distinct. References must resolve within their respective boundaries; validation must reject escapes and unresolved or inappropriate targets. No source path is interpreted relative to the process's incidental working directory. Name collisions require an explicit consumer resolution before generation; the generator does not silently rename units.

### DEC-MRC-01 — Proposed version 2 descriptor contract

The semantic contract below refines the accepted PRD responsibilities. Field names and constraints are draft proposals for review; the machine-readable schema and validator are implementation deliverables, not files created by this specification.

| Field | Proposed requirement and authority |
| --- | --- |
| `version` | Required integer `2`; dispatch by explicit version, never by best-effort coercion. |
| `id` | Required lowercase runtime identifier matching its directory; preserve the existing simple identifier contract and validate any stricter target naming rules separately. |
| `environment` | Required `local` for the supported pilot. Declaring it does not prove that a Kubernetes target is local. |
| `owner` | Required nonempty consumer-supplied owner reference; not an authenticated identity or invented organizational role. |
| `units` | Required nonempty map keyed by component directory name. Each unit declares its project-relative `component` reference and runtime-relative `kubernetes.manifests` reference. No opaque resource settings are carried forward from v1. |
| `terraform.directory` | Required reference to the single runtime-owned preparation root. Backend/state selection follows the companion lifecycle contract; it is not duplicated per unit. |
| `kubernetes.context`, `kubernetes.namespace` | Required explicit target selection shared by the preparation and workload adapters. Never fall back to the ambient current context or default namespace. |
| `hooks` | Optional map from simple lowercase names to runtime-relative `.sh` files. Declaration makes an extension available; it does not cause automatic invocation. Lifecycle bindings, if adopted, must be explicit. |

Reject unknown contract fields, wrong types, blank required values, duplicate/ambiguous identities, unsupported versions, and invalid references with the affected field and expected correction. Descriptor files are data, never sourced shell code. Require existing component directories and native configuration targets of the declared kind. Preserve the existing protection against symbolic-link escapes; define canonical path handling consistently for generation and validation.

The descriptor must not repeat image, CPU, memory, ephemeral storage, replicas, probes, volumes, scheduling, or quota values. Guided answers are written to their native authority. Runtime-operation timeouts are distinct from application probe settings and belong to the lifecycle interface. Secret references remain in the relevant native configuration; the descriptor does not become a credential store.

### DEC-MRC-02 — Proposed entry points and safe generation

- Retain the public `ex runtime <id> init` and `validate` concepts; propose explicit `init --guided` for the question-driven path. Manual users author the same descriptor/native files, and unqualified initialization must not silently opt into guided or operational behavior. Exact manual initialization inputs and help wording remain a decision before implementation.
- Guided configuration gathers runtime identity/owner, selected component references, local context/namespace, prebuilt image references, service ports, resource settings, replicas, native readiness criteria, and namespace quotas. Ask only for selected capabilities and required inputs; do not invent resource budgets, images, owners, or readiness targets.
- Both paths use one versioned validator and one effective configuration contract. Equivalence means equivalent component/target/native configuration semantics, not byte-identical formatting.
- Collect and validate inputs before publishing the runtime directory. Refuse existing output, including a partially configured runtime, without silent overwrite, merge, or rename. Cancellation or failure leaves existing files unchanged and reports any newly created partial output that could not be removed.
- Generate initial native files only for the selected supported capabilities. A proposed minimal website composition uses a Deployment and Service, plus Terraform namespace and quota definitions. The supported resource forms and exact tool/provider versions must be agreed with the lifecycle specification before implementation.
- Native configuration remains consumer-maintained after generation. Validation reports inconsistencies; it never rewrites consumer edits to restore hidden generated defaults. Application manifests cannot also claim Terraform-owned namespace/quota resources.

### DEC-MRC-03 — Proposed legacy transition

New initialization targets version `2` at the PRD's new location. Existing version `1` files are neither moved nor rewritten automatically. Propose keeping explicit v1 validation and the existing low-level commands available during the transition, with a clear legacy notice; v2 lifecycle operations require v2 input and do not reinterpret the opaque v1 component map.

Discovery may list both locations with their version and path. If the same ID is present in both locations, ID-only selection must fail with an ambiguity explanation before any mutation. Unsupported location/version combinations fail explicitly. A migration command, compatibility duration, and eventual v1 removal are not assumed; manual recreation can use reviewed references without overwriting the legacy directory. The compatibility policy is proposed, not implemented or approved by this draft.

### Acceptance and handoff

| Requirement | Configuration acceptance | Handoff to lifecycle |
| --- | --- | --- |
| `REQ-MR-001` | Equivalent manual/guided intent passes the same validation and yields equivalent effective configuration. | Operate the accepted configuration through the same lifecycle. |
| `REQ-MR-002` | Units preserve component names and source references; collisions/existing output are explained; no source copies. | Address every selected unit, including nested native files. |
| `REQ-MR-003` | New configuration uses v2/new location; legacy and ambiguous input have documented outcomes. | Reject unsupported descriptors before operational changes. |
| `REQ-MR-004` | Each setting has one editable native or descriptor authority; configuration is inspectable. | Use that authority without introducing shadow operational settings. |
| `REQ-MR-005` | Local structural/reference validation is non-mutating and actionable. | Revalidate the current revision and check live prerequisites before mutation. |
| `REQ-MR-012` | Hooks are optional explicit `.sh` references; unsupported configuration is reported. | Control extension invocation, outcomes, and declared effects. |
| `REQ-MR-013` | Owner and configured resource boundaries are visible without spend/savings claims. | Observe quotas, outcomes, and available measurements. |
| `REQ-MR-014` | Installation changes only the selected local runtime configuration and preserves the surrounding project. | Scope execution and removal to owned resources. |

## Responsibilities

- Consumer: select components and supported native capabilities; supply image, owner, configuration, secret references, and service criteria; inspect generated files and resolve name/output conflicts.
- Platform: define and validate the versioned contract, generate only selected configuration, preserve ownership and path boundaries, explain unsupported inputs, and pass the same configuration to the lifecycle.
- Service owners: approve their actual resource/readiness/retention values. This draft assigns no universal values, numerical productivity target, or organizational approval process.

## Operation and limits

- Resources, isolation, permissions, and capacity: configuration generation writes local files only. Namespace naming is not isolation evidence. Neither a generated quota nor a valid descriptor proves enforcement, capacity, or FinOps compliance.
- Failures, timeouts, cancellation, and cleanup: generation failure/cancellation concerns only newly created configuration; existing content is preserved. Runtime failures and removal are specified by the lifecycle. Configuration deletion must never implicitly destroy infrastructure or discard operational state.
- Installation, updates, and removal: installation here means runtime configuration generation inside an existing project, not package publication, a registry, project scaffolding, or shell-profile modification. Do not introduce automatic migrations or regeneration of edited native files.
- Observability and execution correlation: configuration validation identifies the runtime, version, inspected inputs, and diagnostics. It does not manufacture run evidence. The lifecycle records the effective configuration revision it actually operates.

### Out of scope

Lifecycle orchestration, infrastructure execution, image building, cloud/production support, a general workflow engine, a runtime registry, SDK API expansion, portal migration, automatic optimization, cost/billing enforcement, and support for arbitrary workloads/providers are outside this specification. The companion specification owns preflight, preparation, readiness, inspection, execution evidence, failures, and resource cleanup together.

This phase creates specifications only. It does not create tickets, schemas, runtime directories, tests, or implementation; it does not modify existing runtime files or publish repository changes.

## Verification and decisions

- Affected guardrails: FinOps v1 `FIN-01`, `FIN-04`, and `FIN-05`; Twelve-Factor v1 `12F-01`, `12F-02`, `12F-03`, `12F-05`, `12F-07`, `12F-08`, `12F-09`, and `12F-12`. See the [policy index](../../harness/guardrails).
- Applicability, criteria, owners, and planned evidence: the consumer owns configuration values; platform reviewers assess generation, validation, and ownership boundaries. Paired configurations and file-change inspection address the configuration criteria. Enforcement, capacity, readiness, and shutdown remain `not-verified` until authorized lifecycle observations exist. Backing-service/process-state/parity/logging behavior is not changed by generation; related runtime criteria belong in the lifecycle assessment.
- Cost/consumption impact: this document-only change creates no infrastructure or paid-service consumption; operational FinOps assessment is `not-applicable` to drafting. The future generator records ownership and native limits but does not estimate billing or demonstrate savings. Paid pilot consumption, if any, requires its own assessed scope; local execution is not assumed to have zero cost.
- Open issues and exceptions: review `DEC-MRC-01` through `DEC-MRC-03`, the supported native capability set, formal schema packaging, and the proposed verification seam before implementation. No policy exception or new test authorization is recorded.
- Verification plan: `VER-MRC-01`, below.
- Trade-offs, decisions, and blocking questions: a small versioned reference contract avoids competing configuration authorities. Legacy support avoids destructive migration but adds explicit version/ambiguity handling. The consumer retains native control within supported capabilities, not a guarantee of every native tool feature.
- Technical review: pending for implementation and owner acceptance. Draft review does not approve execution or the proposed seam.

### VER-MRC-01 — Proposed configuration contract seam

- Section state: `draft`; covers this specification v1 and `PRD-0002` v1.
- Owners of targets and execution: project owner for pilot inputs and verification authorization; platform implementer/reviewers remain to be assigned.
- Execution profile: disposable consumer projects invoking the public CLI, with selected component directories and controlled tool boundaries. No live cluster, Terraform apply, application probe, or real user shell/profile change.
- Prior art: the existing CLI package's disposable consumer fixtures already invoke `ex`, validate v1 descriptors, preserve native exit codes, and control external tools. Reuse that public boundary; previous fixture authorization does not authorize this expanded suite.
- Good checks observe filesystem changes, diagnostics, exit status, and effective configuration. Avoid assertions about internal function layout, prompt wording, or YAML formatting.

| Scenario | Requirements | Criterion and planned evidence |
| --- | --- | --- |
| Paired manual and guided input | `001`, `004` | Same intended configuration passes one validator; compare descriptor references and native semantics, with no duplicate editable resource authority. |
| Two existing components and a name collision | `002`, `014` | Correct unit/source mapping; collision stops publication; before/after source contents remain unchanged. |
| Invalid type, version, target, reference, path escape, or unknown field | `003`, `005` | Actionable failure; no infrastructure command or hook invoked. |
| Existing output, canceled guidance, or interrupted write | `002`, `014` | Preserve preexisting bytes and report any owned partial output; never report successful generation after an incomplete write. |
| Native edits after generation and optional hooks | `004`, `012`, `013` | Edits remain authoritative; hooks are declared but not executed; no unused capability scaffold or measured-spend claim. |
| Legacy-only, new-only, unsupported, and same-ID dual-location inputs | `003` | Explicit behavior under the agreed transition policy; no implicit migration, fallback, or overwrite. |

Requirement suffixes in this table refer to `REQ-MR-*` in the PRD. This seam is proposed and requires confirmation before implementation. No new suite or pilot is executed by drafting it. The configuration comparison supports `MET-MR-004`; journey completion, time to ready, and cleanup metrics belong to the lifecycle.

### Source and decision boundaries

Use the [current CLI contract](../../../packages/cli/cli/README.md), [domain vocabulary](../design/0007-DD-domain-model.dd.md), [proposed ADR-0001](../design/0005-DD-microruntime-architecture.dd.md), and [artifact tracker](../design/0006-DD-artifact-tracker.dd.md). The former evidence README is absent from the current tree. The current SDK API remains empty. These drafts neither accept the broader architecture nor demonstrate production integration. Implementation granularity belongs to later tickets under each specification.

### Draft synthesis review — October 11, 2026

Two independent reviewers assessed the same three untracked additions against base `89e4bd796d3ec8ff76bed414c39f19be2d365b7e`. The supplied PRD text and the owner's two-spec request were the Spec-axis sources. Existing SPEC-0007/SPEC-0008 and unrelated repository content were excluded from the change scope. No commits, application checks, or infrastructure operations were performed.

| Reviewed artifact | SHA-256 before this review record was appended |
| --- | --- |
| PRD-0002 | `3039d104dbd6cdc9e2eee1ef4cf27278a991fdba49d515ac87b3c7d267acbd0c` |
| SPEC-0009 | `351471d05bc2899759290b942d961487c3a5eebe58ff90317d4dd1905c476882` |
| SPEC-0010 | `16243fd27866ca2f7cd18c877c25478585604d5aa25a2a91b8d13574edbb81ea` |

- Standards: **0 findings**. Canonical fields/headings, en-US, identities, draft authority, ownership, optional hooks, and guardrail/evidence distinctions conform to the inspected local guidance.
- Spec: **0 findings**. The supplied PRD is preserved apart from the linked-specification bullet; the two documents cover its 14 requirements and four metrics, with technical proposals and pending decisions identified.
- Static checks: local links resolve, required template sections are present, and whitespace inspection reported no errors for all three additions. These checks do not establish runtime behavior.
- Scope of result: documentary synthesis only. Owner acceptance, seam confirmation, implementation review, and operational evidence remain pending. Only documentary review records were appended after the identified snapshot.

### Implementation review and verification — October 11, 2026

Reviewed against `002fd2462f98ab138991224a21ab93ac6b54358d` on feature branch `codex/microruntime-configuration`. The following manifest identifies the final reviewed 17-file snapshot before this review record was appended. Other than this record, the reviewed scope was unchanged at commit preparation. Stable tickets MRC-01/MRC-02 belong to this specification; PRD-0002 is included as requested.

#### Standards

Pass: zero outstanding findings. Generated guidance was corrected to distinguish configuration commands from separately delivered lifecycle support. Shell automation, consumer ownership, en-US artifacts, publication failure boundaries, test scope, and final numbering/evidence were reviewed.

#### Spec

Pass: zero outstanding findings. An unsupported atomic-publication claim was corrected; the original contract requires prevalidated inputs, preserving existing output, and cleaning/reporting owned partial output. No atomic guarantee or live-runtime result is claimed.

Validation: the CLI package suite (legacy/setup, manual, guided) passed; `pnpm check` and `pnpm typecheck` passed. Reviewers did not execute infrastructure. Build/test push hooks provide additional delivery checks. Full runtime pilot evidence is outside configuration acceptance.

```text
c22121142506898893a17538b8c02d29e19f67a4d439b8546dc400cd603fab29  .artifacts/prd/0002-PRD-local-microruntimes.prd.md
a64a8331b93ae80c485936f0425f254dde99212a7f801db415d7abf98a2bfb4c  .artifacts/specs/0009-SPEC-microruntime-configuration.spec.md
c349fce9d0bfb7412941f118ce9bb85e6eee7a07c8a75e9b4f1aaeaab0899197  .artifacts/tickets/0021-TICKET-manual-microruntime-configuration.ticket.md
9ab50a7a50f368364566d2ce3edde69ea2517d0137d05732cb278af22bdc29b3  .artifacts/tickets/0022-TICKET-guided-microruntime-configuration.ticket.md
1d719294b95e24dd11e6bb7799f5c1576ede3cbd9ba98484474b7f7d236166bb  AGENTS.md
141ff7480178c76dd13847f4276631e94b9a7e5f1e1026bd8f79ba259a0b1ad2  README.md
fa80b364025f0c1dc017a4b1d355a1361e4566cc58938283ca1fc68c95d07a47  packages/cli/cli/README.md
90a5de648ca5a6ae65a8f9f6ecb04194e6a32470f71de68a636e96c13c27b0cd  packages/cli/cli/commands/help.sh
ca06874c46a11880c6faa0ff9032c81e2f2650c9b8014b4ebe76531c519a94e0  packages/cli/cli/commands/runtime.sh
e25e2c6e73fe408ecbfadfbc2eea677357ee5f25c54929857dbfd7901d256f10  packages/cli/cli/core/common.sh
8d04042108318b914b3da693605c780f55d7e82f661c84f76d0057ba4d5cf8be  packages/cli/cli/core/configuration.sh
d206d4fcfa68e2c19e1818a6fa034b15cddf933b26a5139ef88ff2296f5c79c4  packages/cli/cli/core/guided.sh
bda2758d01e284924717c0df978758f20743c19d8865f48270856ce31cbaf86c  packages/cli/cli/core/runtime.sh
53034c8ac62b51434a47fe45287f8fdbf151471446b9d43868d83e069a488845  packages/cli/cli/schemas/runtime-v2.schema.json
7c3550d15cddba182e37ad4626987b33a8a2a3de5cae856d9330bc91c1797fd1  packages/cli/scripts/test-configuration.sh
a732d29305f04834a558f0213d5ceffd02bd90b10c9cbc2b2a9e74d4aebb2754  packages/cli/scripts/test-guided-configuration.sh
6491b2ae816d95d3ecb8b9958d0d108de80a94e318c0f232bf615c6e3a9be9fd  packages/cli/scripts/test.sh
```
