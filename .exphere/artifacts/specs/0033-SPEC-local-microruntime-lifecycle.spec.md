# Local microruntime lifecycle

- ID: `SPEC-MICRORUNTIME-LIFECYCLE`
- Document: `SPEC-0033`
- Version: `2`
- State: `implemented`
- PRD: [PRD-GO-LOCAL-RUNTIME-DELIVERY v1](../prd/0009-PRD-go-cli-local-runtime-delivery.prd.md) and [PRD-0002 v1](../prd/0002-PRD-local-microruntimes.prd.md), as amended by its October 13 decision.
- Technical owners: consumer for component/resource choices; Exphere implementers/reviewers for lifecycle mechanisms.
- Identity history: restores stable `SPEC-MICRORUNTIME-LIFECYCLE`, historically associated with unavailable SPEC-0010. This v2 defines the Go delivery; it does not reconstruct absent source or transfer old verification claims.

## Contract and composition

Requirements: REQ-GOL-004 through 010; lifecycle portions of REQ-MR-005 through 014. Companion [configuration v2](0009-SPEC-microruntime-configuration.spec.md) owns the descriptor and native authorities; [foundation](0032-SPEC-go-cli-foundation.spec.md) owns command/process contracts.

### Commands and environment

| Command | Contract |
| --- | --- |
| `ex cluster create` | Explicitly create one project-owned kind cluster and record identity/private kubeconfig. |
| `ex cluster inspect` | Inspect recorded target and its availability without adopting another cluster. |
| `ex cluster load-image <image>` | Load a consumer-built local image; never build or pull an image implicitly as an Exphere build feature. |
| `ex cluster delete` | Remove only the owned project cluster after runtime cleanup and state reconciliation. |
| `ex runtime up <id>` | Revalidate/preflight, prepare namespace and quotas, apply selected units, await readiness/completion. |
| `ex runtime inspect <id>` | Report outcomes, workload readiness, events, configured resources, and available measurements. |
| `ex runtime logs <id> --unit <name>` | Retrieve bounded logs; live follow is explicit. |
| `ex runtime forward <id> --unit <name>` | Foreground localhost-only forwarding until cancellation. |
| `ex runtime down <id> [--recover]` | Reconcile state and explicitly remove recorded owned resources. |
| `ex runtime hook <id> <name>` | Execute only a declared `.sh` extension with a bounded lifetime and recorded result. |

Detect native tools and report missing prerequisites; never install them. Local targets must agree with project-owned cluster state and private kubeconfig. No ambient current-context/default-namespace fallback, cloud provisioning, cluster adoption, or general arbitrary resource support.

### Preparation and workload authority

Terraform owns a runtime's namespace and quota with one root and state per runtime. Accept native `.tf.json` only, with exactly one explicit Kubernetes provider bound to lifecycle kubeconfig/context inputs; reject an implicit provider, HCL `.tf`, modules, data, provisioners, remote backend, and unrelated resources. Kubernetes manifests own images, resources, replicas, probes, scheduling, and the supported workload settings. Do not create an independently editable shadow resource configuration in the descriptor.

Support stateless Deployments, ClusterIP Services, and finite Jobs with a positive active deadline only. Host, persistent, and generic ephemeral volume sources are excluded; workload configuration cannot provision storage outside the owned namespace. Reject unsupported kinds before infrastructure mutation. Apply every selected unit, preserving source ownership and native configuration. Record each unit as completed, failed, or not attempted. Preparation failure prevents application of all workloads. Jobs await completion and surface failure rather than using service readiness. Configured image references must be present in every run record, including failures before successful application; observed image identities are added only when available. Image builds belong to the consumer. Inspection retains events from owned ReplicaSets and their Pods as well as the top-level workload.

### State, correlation, and ownership

- Record mutation intent before external effects. Serialize project/cluster mutations and runtime mutations so cleanup cannot race creation or another mutation.
- Private runtime state is `.exphere/state/runtimes/<id>/state.json`; cluster state/kubeconfig and runtime Terraform state remain within private project state.
- Execution evidence uses `.audits/evidence/runs/<run-id>` and identifies configuration, image references/observed identity when available, environment, operation, units, and outcome. Preserve evidence after cleanup.
- Compare recorded target and observed Kubernetes identities; matching a name alone does not establish ownership. Record observations needed for later reconciliation before claiming successful creation.
- Configuration files remain after execution and removal. Missing state is not permission to discover and destroy objects by matching names.

## Responsibilities

- Consumer: choose components, prebuild/load images, edit native resources and readiness, install tools, explicitly invoke infrastructure commands, and inspect outcomes.
- Platform: validate supported inputs, keep mutations scoped, maintain state/evidence, provide inspection, and refuse unsafe cleanup.
- Service owners: approve resource/quality targets and permission boundaries; namespace labels and quotas are not proof of isolation, compliance, capacity, or cost.

## Operation and limits

### Failures, interruption, and recovery

Cancel and wait for owned processes; retain recoverable state/evidence and report partially completed work. Do not automatically destroy resources after an interrupted preparation/application operation. Recovery is explicit and reconciles live observations with recorded intent/identities. Incomplete observations or conflicting ownership block destruction with actionable diagnostics.

Cleanup requires the configuration revision recorded for the active operation; changed configuration must be restored/reconciled before deletion, rather than being silently used as a new deletion target. Remove owned workloads first. Inspect namespace contents, preserve foreign resources, and refuse namespace deletion if ownership cannot be established. Delete the recorded namespace with a UID precondition before reconciling Terraform state, preventing replacement-by-name deletion. Namespace-scoped preparation must not destroy unrelated Terraform-managed/cloud resources. Keep the shared project cluster until separately requested deletion. Before cluster deletion, compare observed identities against the creation baseline across all namespaces and cluster-scoped resources, not only the default namespace. Added/changed foreign resources, incomplete inventories, active runtimes, or unresolved operations block deletion.

Port forwarding binds localhost, has an explicit unit/port target, and remains in the foreground. Logs and native diagnostics may contain consumer data; avoid copying credentials into durable evidence. Measurements absent from the cluster stay unavailable; configured requests/limits and quotas must be labeled as configuration.

### Guardrails

FIN-01/04/05/06 covers runtime owner/target, declared resource limits, explicit shutdown, and sourced observations. FIN-02/03/07 economic budgeting/results are unimplemented; no financial zero-cost or savings claim follows from a local cluster or zero model calls. FIN-08 quality must not be silently reduced to achieve a resource setting.

12F-01/02/03/05/07/08/09/11/12 covers source/image identity, tools, configuration, ports, concurrency, readiness/disposal, logs, and controlled administrative actions. Local-only 12F-10 parity remains an explicit limitation; supported stateless workloads/finite Jobs address 12F-06 without claiming support for arbitrary stateful applications. 12F-04 external backing services are consumer-owned and outside this pilot's provisioning.

### Documented acceptance scenarios, not new tests

Keep configuration validity, invalid references, name collisions, quota rejection, preparation failure, readiness/Job failure, interruption/recovery, and cleanup in acceptance review. None becomes a new executable scenario in this delivery. Source review cannot demonstrate live quota enforcement, successful recovery, resource removal, or cluster availability.


## Delivery tickets

- [CLI-RUNTIME-05](../tickets/0063-TICKET-go-project-cluster.ticket.md)
- [CLI-RUNTIME-06](../tickets/0064-TICKET-go-single-unit-lifecycle.ticket.md)
- [CLI-RUNTIME-07](../tickets/0065-TICKET-go-runtime-diagnostics.ticket.md)
- [CLI-RUNTIME-08](../tickets/0066-TICKET-go-runtime-recovery.ticket.md)
- [RUNTIME-ENDPOINTS-01](../tickets/0073-TICKET-controller-endpoint-cleanup.ticket.md)

### Follow-up — disposable dependency execution

On October 13, 2026, the owner requested an actual local runtime pilot while selecting Neo4j for RAG exploration, then explicitly authorized installing Terraform and starting Docker. This permits the bounded disposable dependency startup, inspection, connectivity, interruption/recovery, and cleanup journey. It does not authorize new automated suites, persistent production storage, paid model calls, cloud provisioning, or publication. The earlier delivery's unverified records remain historically accurate.

The pilot exposed a cleanup defect: the Kubernetes endpoint controller creates legacy `Endpoints` without an owner-reference chain. The lifecycle must recognize these only through a live, UID-verified recorded Service, its selector, matching runtime ownership labels, controller metadata, and verified Pod references when addresses exist. Empty controller endpoints are valid when that Service has no available Pods. Names alone or a generic kind allowlist must not establish ownership. After workload deletion, these derived objects must disappear before namespace cleanup; the pre-deletion exception does not waive the final inventory check.

The initial image-loading operation also encountered kind's documented multi-platform Docker image-store incompatibility. A consumer-operated single-platform archive import may unblock the pilot; that workaround does not constitute an implemented Exphere adapter fix.

## Verification and decisions

- Scope authorization: The project owner explicitly requested implementation of the complete “Exphere Go CLI — foundation and local runtime lifecycle” plan on October 13, 2026. That request covers this scope, the four-specification breakdown, and the eleven tickets. It authorizes local implementation and the stated existing checks, not live cluster execution, publication, or paid operations. This record documents conversational authorization; it is not an authenticated approval system.
- Existing checks only: adapt the current CLI tests and surviving contract checks as behavior changes; run formatting, compilation, `go vet`, and applicable existing repository checks. Do not add suites/scenarios or execute infrastructure/application pilot scenarios.
- Technical review: Standards and Spec review must inspect the same identified source snapshot before completion. Initial checks and same-snapshot review findings are recorded in the [integrated delivery record](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md). Final correction checks and refreshed Standards/Spec reviews passed; no operational success is claimed.
- Evidence states: configured, implemented, reviewed, and observed remain distinct. Operational lifecycle/agent integration is `not-verified` until separately authorized execution supplies evidence.
- Remaining scope: no cloud provisioning, paid calls, billing ingestion, RAG/MCP, automatic optimization, or external publication.

Implementation and independent source reviews completed within the authorized verification scope. See [CLI-RUNTIME-11](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md) for final checks, source identity, and deferred operational verification. This status does not claim a live runtime or authenticated organizational approval.
