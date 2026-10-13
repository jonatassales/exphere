# Deterministic LangGraph agent scaffold

- ID: `SPEC-LANGGRAPH-SCAFFOLD`
- Document: `SPEC-0034`
- Version: `1`
- State: `implemented`
- PRD: [PRD-GO-LOCAL-RUNTIME-DELIVERY v1](../prd/0009-PRD-go-cli-local-runtime-delivery.prd.md).
- Technical owners: consumer for generated source and image; Exphere implementers/reviewers for scaffold and runtime handoff.

## Contract and composition

Requirements: REQ-GOL-003, 005, 008, 009, 010. `ex agent init <name>` creates consumer-editable TypeScript source, package metadata, Dockerfile, and instructions in `.exphere/agents/<name>`. It refuses existing output and does not install dependencies, build images, start containers, or contact model providers.

The generated LangGraph contains a finite deterministic graph with explicit termination. It emits a structured stdout result with runtime ID, run ID, and outcome. Correlation values are provided by execution context, not hardcoded to one repository. Unexpected execution errors fail the Job; the scaffold does not swallow failures or add an unbounded retry loop.

The consumer builds the image and supplies its image reference. A runtime unit references the agent source directory and contains Kubernetes execution configuration only. Use a finite Job with an explicit completion/retry policy and positive active deadline; the lifecycle's Job handling records completion/failure and supports logs/cleanup. Do not copy generated source into units or duplicate application resource settings in the descriptor.

Go remains the CLI language; the TypeScript agent is an independent consumer workload. The separate TypeScript SDK remains unchanged. LangGraph is a graph executor here; this increment has no model calls, API keys, RAG, vector/graph database, MCP connections, shared ledger, persistent server, or financial approval logic. [LangGraph graph model](https://docs.langchain.com/oss/javascript/langgraph/graph-api).

## Responsibilities

- Consumer: own/edit generated source, dependency choices after generation, image build, image version/reference, and resource values.
- Platform: bounded non-destructive generation, a documented finite example, correlation injection, supported Job integration, and accurate outcomes.
- Service owners: approve limits and the environment when actually executing the image; generated files do not authorize execution.

## Operation and limits

Use versioned template inputs and explicit dependencies. Generated application code is not an installation script. Keep configuration, source, image construction, and runtime execution distinct. Preserve generated files after runtime cleanup. Images are loaded explicitly using the cluster command.

For a new Job, assess all Twelve-Factor criteria: 12F-01 source identity and owner; 02 explicit dependencies; 03 runtime/run configuration without credentials; 04 no backing service requirement; 05 consumer image build separate from run; 06 finite disposable work without durable local state; 07 no server/port binding needed; 08 finite Job concurrency policy; 09 completion/deadline/cancellation behavior; 10 local reference environment only, no production-parity assertion; 11 structured stdout result; 12 explicit administrative commands and effects. These are design/source assessments, not observed Kubernetes behavior.

FIN-01/04/05 applies to owner, resource configuration, and Job lifetime. No paid model call means no model-provider bill for those absent calls; it does not mean zero host/cluster/network cost. FIN-02/03/06/07 monetary sourcing, budgets, reports, and savings remain out of scope. Job resources need consumer values, not an invented team budget.


## Delivery tickets

- [CLI-RUNTIME-09](../tickets/0067-TICKET-langgraph-agent-scaffold.ticket.md)
- [CLI-RUNTIME-10](../tickets/0068-TICKET-langgraph-runtime-job.ticket.md)

## Verification and decisions

- Scope authorization: The project owner explicitly requested implementation of the complete “Exphere Go CLI — foundation and local runtime lifecycle” plan on October 13, 2026. That request covers this scope, the four-specification breakdown, and the eleven tickets. It authorizes local implementation and the stated existing checks, not live cluster execution, publication, or paid operations. This record documents conversational authorization; it is not an authenticated approval system.
- Existing checks only: adapt the current CLI tests and surviving contract checks as behavior changes; run formatting, compilation, `go vet`, and applicable existing repository checks. Do not add suites/scenarios or execute infrastructure/application pilot scenarios.
- Technical review: Standards and Spec review must inspect the same identified source snapshot before completion. Initial checks and same-snapshot review findings are recorded in the [integrated delivery record](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md). Final correction checks and refreshed Standards/Spec reviews passed; no operational success is claimed.
- Evidence states: configured, implemented, reviewed, and observed remain distinct. Operational lifecycle/agent integration is `not-verified` until separately authorized execution supplies evidence.
- Remaining scope: no cloud provisioning, paid calls, billing ingestion, RAG/MCP, automatic optimization, or external publication.

Implementation and independent source reviews completed within the authorized verification scope. See [CLI-RUNTIME-11](../tickets/0069-TICKET-go-runtime-integrated-review.ticket.md) for final checks, source identity, and deferred operational verification. This status does not claim a live runtime or authenticated organizational approval.
