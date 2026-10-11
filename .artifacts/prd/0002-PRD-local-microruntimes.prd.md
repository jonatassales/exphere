# Local microruntimes — PRD v1

- ID: `PRD-0002`
- Version: `1`
- State: `draft`
- Product/journey owner: Exphere project owner.
- Date: October 11, 2026.
- Sources: [product requirements](0001-PRD-exphere.prd.md), [microruntime requirements](../design/0002-DD-microruntimes.dd.md), [architecture proposal](../design/0005-DD-microruntime-architecture.dd.md), and the technical references below.
- Parent: [PRD-0001 — Exphere](0001-PRD-exphere.prd.md).
- Authorization: the owner requested this PRD. The agreed pilot scope is recorded below; detailed specification, software implementation, and observed pilot results are separate deliverables.

## Problem and outcome

Developers need a reproducible way to compose an execution environment around existing application components, configure its resource boundaries, inspect its behavior, and remove the resources it creates. Repeating these steps manually increases setup effort and makes ownership and configuration harder to trace.

Exphere will provide developer-installable microruntimes that connect consumer-owned components and native infrastructure configuration through one descriptor. Installation materializes the runtime configuration inside an existing consumer project. Consumers retain decisions about stack, composition, resource settings, and service-specific criteria. Exphere coordinates runtime execution and exposes the applicable limits and evidence.

The first outcome is a complete local journey for `apps/website`, using a prebuilt container image and local Kubernetes. The value hypothesis is lower setup effort with reproducible, inspectable execution and demonstrable resource boundaries. There is no measured baseline or completed pilot yet. Local results will describe the examined conditions, not production capacity or availability.

The consumer's existing portal, catalog, delivery tooling, and infrastructure remain independently owned. Using a microruntime does not require replacing or migrating them. Exphere is adopted within developer projects and can coexist with Backstage or another portal; portal integration is optional future work.

This PRD defines the next microruntime pilot within PRD-0001's broader product direction. The local pilot establishes the first supported execution path, not a universal stack requirement for all consumers.

## Scope

### Included

- Manual and guided configuration, converging on the same runtime model and validation.
- Project-local runtime installation/generation under `.exphere/runtimes/<id>/`, with units referencing existing components.
- Descriptor version `2`, distinct from the current version `1` contract.
- Kubernetes execution against an explicitly selected local context and namespace; kind is the reference environment.
- A Terraform root and state per runtime, preparing its namespace and resource quotas.
- Execution of all selected application units, using images already built by the consumer.
- Readiness, events, logs, configured resources, operation outcomes, and explicit cleanup.
- Optional consumer-provided `.sh` hooks for declared extensions.

### Deferred

Cloud provisioning, production access, real billing ingestion, monetary budget enforcement, automatic optimization, portal integrations, load testing, image building, and general support for every workload or infrastructure provider are later increments. Runtime installation in this version means generating project-local configuration; a runtime registry or remote distribution service is not required. This document defines verification scenarios; it does not create new test suites or execute a pilot.

### Current implementation and dependencies

The [current CLI contract](../../packages/cli/cli/README.md) describes `packages/cli`, a version `1` descriptor at `.micro-runtime/<id>/schema.json`, explicit Terraform/Kubernetes command forwarding, and consumer hooks. Its component map is opaque. The separate SDK API is empty. The runtime generation, guided journey, version `2` contract, and coordinated lifecycle described here are requirements, not existing capabilities.

The pilot requires a working local container environment, kind or the consumer's selected compatible local Kubernetes environment, kubectl, Terraform, access to the selected context, and a prebuilt image available to the cluster. Tool presence alone does not establish environment readiness. Cluster preparation and removal must be explicit; workload cleanup must not implicitly remove a shared cluster.

The subsequent SPEC will define exact tool versions, commands, descriptor validation, image availability/loading, local endpoint access, and cluster lifecycle details. It must explicitly describe the transition from `.micro-runtime` and version `1`, including any compatibility behavior. No existing runtime files are moved or rewritten by this PRD.

### Runtime model and configuration authority

```text
.exphere/runtimes/<id>/
├── README.md
├── schema.json
├── terraform/
│   └── ... shared runtime configuration
├── units/
│   └── website/
│       └── kubernetes/
│           └── ... application manifests
└── hooks/                  # only when used
    └── ... .sh extensions
```

A unit contains execution configuration and references its existing component. `units/website` maps to `apps/website`; application source is not copied into the runtime. Unit names match component directory names. Selecting components with conflicting names requires an explicit resolution before generation.

`schema.json` is the consumer's runtime descriptor. Its responsibilities are identity, environment and owner; unit-to-component references; configuration references; Kubernetes context and namespace selection; and optional hook declarations. Its detailed structure and formal validation schema belong in the linked SPEC.

| Configuration | Authority and boundary |
| --- | --- |
| Runtime identity, component references, context, namespace selection, and extension bindings | Runtime descriptor. Source references resolve from the consumer project; runtime-owned configuration has its own runtime-relative boundary. |
| Image, container resources, replicas, probes, volumes, and scheduling | Consumer-maintained Kubernetes manifests. Guided setup writes initial values to these files without retaining a second editable copy in the descriptor. |
| Namespace, quotas, and their lifecycle | One Terraform root/state per runtime in this pilot. The namespace selected by the descriptor is an input to this configuration. Kubernetes enforces the resulting quotas. |
| Additional supported tuning | Native configuration or explicit consumer `.sh` hooks. Unsupported capabilities and missing prerequisites must be reported before the affected operation. |

Terraform and the workload adapter must not independently manage the same resource. Terraform owns the namespace and quotas; the Kubernetes adapter owns the application's manifests in this pilot. This is an Exphere design choice: Terraform can also manage application resources.

Full access to the supported native configuration is preserved. Kubernetes already provides CPU, memory, and ephemeral-storage requests/limits, and node placement controls. Adjustments beyond a selected executor's capabilities require a concrete extension capable of applying them. A descriptor declaration cannot create unavailable hardware or prove that a setting was enforced.

Only selected capabilities produce files or directories. Hooks remain optional. Terraform state, credentials, and generated execution evidence are not versioned as authored runtime configuration; evidence follows the [existing evidence contract](../../.audits/evidence/README.md).

### Technical references

References consulted October 11, 2026: [Kubernetes resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/), [ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/), [probes](https://kubernetes.io/docs/concepts/workloads/pods/probes/), [node placement](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/), [Terraform's Kubernetes provider tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider), and [kind quick start](https://kind.sigs.k8s.io/docs/user/quick-start/).

## Consumer journey

1. **Choose configuration entry.** The CLI offers manual configuration or guided questions. Manual users supply their descriptor and native configuration; guided users select components and provide the image, port, resources, readiness criteria, context, and namespace. Neither path builds an image.
2. **Review generated configuration.** The consumer can inspect and tune the native files. Generation alone does not apply Terraform or Kubernetes resources.
3. **Validate.** Both paths use the same contract. Validate names, component references, configuration paths, supported capabilities, and prerequisites before infrastructure changes. Missing inputs produce an actionable explanation.
4. **Prepare.** An explicit execution action targets the selected local environment. Terraform prepares the runtime-owned namespace and quotas. Preparation failure prevents subsequent workload application and identifies partial changes.
5. **Execute.** Apply every selected unit's manifests and evaluate its declared readiness criteria. A timeout, rejected resource, or unavailable image is visible as a failure or inconclusive outcome, never a successful run.
6. **Inspect.** Show unit readiness, events, logs, configured resources, and operation results. Distinguish configuration from measured consumption. Record the image identity actually used, configuration revision, environment, and relevant tool versions.
7. **End the runtime.** Explicitly remove owned workload resources, then runtime-owned preparation resources in the appropriate order. Report leftovers or retained resources. Shared resources and the application source remain outside this cleanup scope.

## Requirements and acceptance

The criteria below define future delivery acceptance. Their expected evidence is not yet available.

| Requirement | Behavior/outcome | Verifiable criterion | Expected evidence |
| --- | --- | --- | --- |
| REQ-MR-001 | Equivalent configuration entry points. | Manual and guided inputs representing the same intent pass the same validation and produce semantically equivalent effective configuration. | Paired configuration samples and comparison record. |
| REQ-MR-002 | Runtime-only units. | Generated units preserve component directory names, reference existing source paths, and contain execution configuration without application source copies. Conflicting names and existing output are not silently overwritten. | Generated tree and reference inspection. |
| REQ-MR-003 | Versioned, explicit runtime contract. | New runtimes use descriptor version `2` under `.exphere/runtimes/<id>/`. Legacy location/version behavior is documented; unsupported input is reported clearly. | Linked SPEC and validation observations. |
| REQ-MR-004 | Consumer configuration authority. | Native Kubernetes and Terraform configuration remains editable by the consumer. No resource setting has two competing editable authorities. | Descriptor-to-native configuration ownership review. |
| REQ-MR-005 | Preflight before infrastructure changes. | Invalid references, names, paths, missing tools, or unsupported prerequisites stop the affected execution before mutation. Context and namespace are explicit. | Validation results and evidence of which stages ran. |
| REQ-MR-006 | Terraform environment preparation. | One runtime Terraform root/state manages its namespace and quotas. Preparation failure stops workload application and exposes any partial result. | Terraform operation results and runtime resource inventory. |
| REQ-MR-007 | Execute the selected composition. | Every selected application unit is addressed explicitly, using its prebuilt image and declared readiness criteria; nested manifests are not silently skipped. | Applied resource identities, observed image identities, and readiness results. |
| REQ-MR-008 | Inspectable runtime behavior. | Readiness, events, logs, configured resources, and failures are attributable to the runtime and its units. Unavailable usage measurements remain unavailable. | Inspection output and associated execution record. |
| REQ-MR-009 | Demonstrable resource boundaries. | Consumer-defined quotas are present in the cluster. A workload exceeding them is reported as rejected or unable to become ready, rather than a successful delivery. | Quota configuration, cluster events, and workload outcome. |
| REQ-MR-010 | Explicit, scoped cleanup. | Cleanup removes runtime-owned workloads before their preparation resources and reports remaining resources. It does not remove shared infrastructure or source files. | Before/after inventory and cleanup outcome. |
| REQ-MR-011 | Traceable evidence. | An execution record links the runtime, unit/image identities, code/configuration revision, environment, tool versions, performed actions, and outcome. | Record under `.audits/evidence/runs/<run-id>/`, following the existing contract. |
| REQ-MR-012 | Explicit extensions and limits. | Optional hooks are declared `.sh` scripts. Supported native tuning remains accessible; unsupported tuning is reported rather than silently ignored or simulated as applied. | Configuration review and supported-capability documentation. |
| REQ-MR-013 | Honest FinOps interpretation. | Ownership and resource limits are inspectable; quotas are not presented as currency budgets, and configuration is not presented as measured spend or savings. | Documentation and inspection-output review. |
| REQ-MR-014 | Incremental adoption in existing projects. | Installing a microruntime adds its local configuration without replacing the consumer's portal, catalog, existing infrastructure, or delivery workflow. Execution is explicit and scoped to the configured runtime. | Installation diff and resource ownership review. |

### Planned verification scenarios

| Scenario | Expected result |
| --- | --- |
| Valid manual and guided configurations | Equivalent effective configuration; the prebuilt website image reaches its declared readiness condition in the chosen local environment. |
| Invalid component or configuration reference | Actionable validation failure before infrastructure changes. |
| Conflicting unit names or existing generation target | Explicit conflict; no silent rename, merge, or overwrite. |
| Workload exceeds a declared quota | Cluster rejection or readiness failure is surfaced and connected to the quota; the run is not reported as successful. |
| Terraform preparation fails | Later workload stages do not run; partial resources and the failed stage are visible. |
| Runtime ends | Owned resources are removed in the appropriate order; retained or failed-to-remove resources are listed, with shared resources preserved. |

These scenarios are documented for the subsequent SPEC and authorized pilot verification. No new automated test suites are introduced in this documentation phase. Passing the local scenarios would not prove production SLOs, leak absence, or cost savings.

## Metrics and decision

| Metric | Definition and observation window | Owner and acceptance use |
| --- | --- | --- |
| MET-MR-001 — Journey completion | Per attempted run: configuration accepted, environment prepared, all selected units ready, inspection available, cleanup outcome recorded. | Project owner evaluates the completed local pilot; absent evidence cannot count as success. |
| MET-MR-002 — Time to ready | From explicit runtime execution to all selected units meeting readiness, recording preparation and image availability conditions. Image build time is outside this prebuilt-image pilot. | Project owner records a baseline; no numerical productivity target is set yet. |
| MET-MR-003 — Cleanup completeness | Inventory after explicit cleanup: owned resources removed, intentionally retained, or unresolved. | Pilot operator explains every remaining owned resource; unexplained leftovers prevent a complete-cleanup claim. |
| MET-MR-004 — Reproducibility and traceability | Compare runs using the same declared inputs and relevant environment conditions; preserve effective configuration and observed image identity. | Project owner reviews differences and whether evidence can explain them. |

The documentation change itself has no infrastructure-consumption effect. Future implementation and execution must assess the applicable [FinOps](../../.agents/guardrails/finops.md) and [Twelve-Factor](../../.agents/guardrails/twelve-factor.md) criteria, particularly ownership, resource boundaries, cleanup, configuration, artifact identity, readiness, and logs.

- **Accepted product decisions:** developer-installed runtimes in existing projects; coexistence with existing portals and infrastructure; local execution pilot; kind reference environment; prebuilt image; manual and guided entry points; native configuration authority with explicit extensions; Terraform namespace/quota preparation; runtime-only units; descriptor version `2` and the `.exphere/runtimes` location. Product scope confirmed by the project owner on October 11, 2026.
- **Document status:** draft v1. The owner authorized writing this document; no operational result or external organizational acceptance is recorded.
- **Linked specifications:** the owner requested two draft specifications through `to-spec` on October 11, 2026: [SPEC-MICRORUNTIME-CONFIGURATION v1](../specs/0009-SPEC-microruntime-configuration.spec.md) for the contract and configuration, and [SPEC-MICRORUNTIME-LIFECYCLE v1](../specs/0010-SPEC-local-microruntime-lifecycle.spec.md) for local operations, including inspection, evidence, failures, and cleanup from the start. Implementation granularity belongs to tickets within each specification. The later implementation/PR request and verification scope are recorded in their decision sections; no completed live pilot is claimed.
- **SPEC decisions to resolve:** detailed descriptor/validation schema, CLI commands and guided prompts, native-file aggregation, prerequisites and versions, cluster lifecycle and image loading, state storage, legacy transition, evidence format, and failure/cleanup behavior.
- **Consumer inputs:** actual image, paths, context, namespace, owner, ports, readiness conditions, resources, and quotas. Their values are not universal Exphere defaults or assumed organizational requirements.
- **Pilot completion condition:** a reproducible, inspectable local journey with resource boundaries demonstrated and cleanup accounted for. Measured outcomes remain pending implementation and execution.
