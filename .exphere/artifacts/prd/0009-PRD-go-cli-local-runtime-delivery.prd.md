# Go CLI foundation and local runtime delivery

- ID: `PRD-GO-LOCAL-RUNTIME-DELIVERY`
- Document: `PRD-0009`
- Version: `1`
- State: `implemented`
- Product/journey owner: Exphere project owner.
- Sources: owner's October 13, 2026 approved implementation plan; [PRD-0002 v1](0002-PRD-local-microruntimes.prd.md); [Go-only direction](0007-PRD-go-cli-and-native-tooling.prd.md).

## Problem and outcome

Developers need an inspectable local execution environment around existing components without copying application code or repeating manual infrastructure steps. The existing Go scaffold exposes help and version but does not implement the microruntime journey. Earlier shell implementation records are historical evidence, not current Go behavior.

The outcome is a Go CLI that prepares project configuration, generates manual or guided runtime configuration, manages one project-owned kind cluster, operates prebuilt workloads, exposes results, and removes resources whose ownership it can establish. A generated TypeScript LangGraph agent demonstrates a finite orchestration Job without model calls. The business hypothesis is reduced setup friction with explicit resource ownership; setup-time improvement and financial benefit have no measured baseline.

## Scope

### Included

- Cobra commands, explicit composition, Go documentation, and isolated native adapters.
- Non-destructive project initialization and prerequisite diagnostics; tools are detected, never installed automatically.
- Descriptor v2 with application and agent source references; consumer-editable native Kubernetes/Terraform configuration.
- One explicitly created kind cluster per project, a private kubeconfig, and consumer-built image loading.
- Stateless Deployments, ClusterIP Services, and finite Jobs; namespace and quotas prepared by Terraform.
- Readiness/completion, events, logs, resource configuration, available measurements, foreground port forwarding, execution evidence, and explicit cleanup/recovery.
- Editable LangGraph TypeScript scaffolding outside runtime unit directories.

### Constraints and exclusions

Use one Go module and Cobra only for the command framework; manual dependency injection and explicit configuration. Keep source under the agreed `src` layout; no generic goroutine registry or speculative package scaffolds. Support macOS and Linux initially. Keep the separate SDK API unchanged.

Do not install tools, build images, provision cloud resources, replace developer portals, execute paid LLM calls, implement RAG/MCP/billing/financial enforcement, promise cost savings, or restore the retired shell CLI. Adapt existing tests only: no new suites or scenarios, and no live Docker/kind/Terraform/application scenarios during this delivery. Runtime and agent operational reliability remain unverified.

### Subsequent owner decision: direct shell command

The owner required normal usage as `ex --help` after dependency installation and selected explicit one-time project-aware Bash/Zsh setup. CLI and SDK package bins expose the Go executable; the SDK depends on the CLI. Current source installation requires an existing Go toolchain. Package postinstall may compile the CLI but never modifies profiles/PATH. The explicit setup command installs a marked function that resolves the current project's local dependency, without global binary installation or system-editor fallback. Personal shell-profile execution and package publication remain excluded from verification. This extends REQ-GOL-001 and ticket T1; it does not alter runtime permissions or infrastructure scope.

## Consumer journey

Initialize project → inspect prerequisites → manually configure or answer guided questions → validate → explicitly create a project cluster and load prebuilt images → prepare and execute a runtime → inspect readiness/results/logs → remove runtime resources → explicitly remove the empty owned cluster.

Agent scaffolding adds editable source as a consumer component. Image construction remains a consumer action outside the CLI; the runtime references that source and its prebuilt image. No package installation triggers infrastructure changes.

## Requirements and acceptance

| Requirement | Behavior/outcome | Verifiable criterion | Expected evidence |
| --- | --- | --- | --- |
| REQ-GOL-001 | Documented Go command foundation | Thin Cobra commands; independent domain logic/adapters; public contracts explain effects and cancellation. | Source review, build, adapted existing Go checks. |
| REQ-GOL-002 | Safe project setup | Init preserves existing content; doctor distinguishes missing tools and readiness gaps without installation. | Source review and existing applicable checks. |
| REQ-GOL-003 | One configuration authority | Manual and guided paths use descriptor v2 and the same validation; source remains in its original component. | Configuration review; existing checks where applicable. |
| REQ-GOL-004 | Explicit project cluster ownership | Creation/image loading/deletion use recorded project identity and private kubeconfig; deletion refuses unresolved runtime state. | Ownership/cancellation review; operational observation pending. |
| REQ-GOL-005 | Complete runtime lifecycle | Preparation precedes workload apply; inspection and cleanup accompany the initial operational slice. | Lifecycle review; operational observation pending. |
| REQ-GOL-006 | Bounded and recoverable operations | Mutation intent/state is recorded and serialized; interruption preserves evidence; uncertain ownership blocks deletion. | Failure-path review; runtime observation pending. |
| REQ-GOL-007 | Useful developer diagnostics | JSON inspection and bounded logs/events; unavailable measurements remain unavailable; explicit localhost forwarding. | Output/source review; cluster observation pending. |
| REQ-GOL-008 | Finite agent scaffold | Generated TypeScript graph runs as a finite Job, correlates runtime/run results, and has no credentials or model calls. | Generated-source review; image/Job observation pending. |
| REQ-GOL-009 | Honest evidence | Bind execution evidence to configuration, target, image, operation, and observed outcome; never infer monetary cost from quota. | Artifact/schema/source review. |
| REQ-GOL-010 | Traceable limited verification | PRD/spec/ticket links, existing checks, and same-snapshot Standards/Spec review; no new scenarios or live infrastructure checks. | Recorded exact checks and review result. |

## Metrics and decision

- MET-GOL-001: observed local journey outcome, per runtime/run. Not measured in this delivery.
- MET-GOL-002: resources remaining after cleanup, including uncertain/foreign resources. Not measured without authorized cluster execution.
- MET-GOL-003: failures and unresolved operations reported by inspection; no target or baseline invented.
- MET-GOL-004: source/documentation review plus existing-check results, recorded for the changed revision. This measures delivery verification, not operational success.
- Monetary costs, savings, availability targets, and performance improvements are unknown without appropriate sources and authorized observations.
- Scope approval: The project owner explicitly requested implementation of the complete “Exphere Go CLI — foundation and local runtime lifecycle” plan on October 13, 2026. That request covers this scope, the four-specification breakdown, and the eleven tickets. It authorizes local implementation and the stated existing checks, not live cluster execution, publication, or paid operations. This record documents conversational authorization; it is not an authenticated approval system.

Implementation is coordinated by [Go foundation](../specs/0032-SPEC-go-cli-foundation.spec.md), [configuration v2](../specs/0009-SPEC-microruntime-configuration.spec.md), [local lifecycle](../specs/0033-SPEC-local-microruntime-lifecycle.spec.md), and [LangGraph scaffold](../specs/0034-SPEC-langgraph-scaffold.spec.md).

Implementation and the independent Standards/Spec source reviews are complete. The [integrated delivery record](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md) records resolved findings and verification results. Unexecuted runtime scenarios stay explicitly unverified.

## Delivery sequence

| Slice | Local ticket | Blocking edges |
| --- | --- | --- |
| T1 | [CLI-RUNTIME-01: Cobra foundation and documented Go contracts](../tickets/0059-TICKET-go-cli-foundation.ticket.md) | None. |
| T2 | [CLI-RUNTIME-02: Project initialization and prerequisite diagnostics](../tickets/0060-TICKET-project-initialization-diagnostics.ticket.md) | CLI-RUNTIME-01 (T1) |
| T3 | [CLI-RUNTIME-03: Descriptor v2 and manual runtime scaffolding](../tickets/0061-TICKET-go-runtime-manual-configuration.ticket.md) | CLI-RUNTIME-02 (T2) |
| T4 | [CLI-RUNTIME-04: Guided runtime configuration](../tickets/0062-TICKET-go-runtime-guided-configuration.ticket.md) | CLI-RUNTIME-03 (T3) |
| T5 | [CLI-RUNTIME-05: Owned project cluster and image loading](../tickets/0063-TICKET-go-project-cluster.ticket.md) | CLI-RUNTIME-02 (T2) |
| T6 | [CLI-RUNTIME-06: First complete application runtime lifecycle](../tickets/0064-TICKET-go-single-unit-lifecycle.ticket.md) | CLI-RUNTIME-03 (T3), CLI-RUNTIME-05 (T5) |
| T7 | [CLI-RUNTIME-07: Multiple units and developer diagnostics](../tickets/0065-TICKET-go-runtime-diagnostics.ticket.md) | CLI-RUNTIME-06 (T6) |
| T8 | [CLI-RUNTIME-08: Interruption and owned-resource recovery](../tickets/0066-TICKET-go-runtime-recovery.ticket.md) | CLI-RUNTIME-06 (T6) |
| T9 | [CLI-RUNTIME-09: Editable finite LangGraph scaffold](../tickets/0067-TICKET-langgraph-agent-scaffold.ticket.md) | CLI-RUNTIME-02 (T2) |
| T10 | [CLI-RUNTIME-10: LangGraph Job lifecycle integration](../tickets/0068-TICKET-langgraph-runtime-job.ticket.md) | CLI-RUNTIME-07 (T7), CLI-RUNTIME-09 (T9) |
| T11 | [CLI-RUNTIME-11: Integrated documentation and existing checks](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md) | CLI-RUNTIME-04 (T4), CLI-RUNTIME-08 (T8), CLI-RUNTIME-10 (T10) |

Implementation and independent source reviews completed within the authorized verification scope. See [CLI-RUNTIME-11](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md) for final checks, source identity, and deferred operational verification. This status does not claim a live runtime or authenticated organizational approval.
