# SCAFFOLD-PUBLISH-01: Publish scaffolds into their reserved destination

**Spec:** [SPEC-MICRORUNTIME-CONFIGURATION v2](../specs/0009-SPEC-microruntime-configuration.spec.md#follow-up--local-rag-dependency-pilot)
**Status:** in-progress
**Origin:** Owner-requested local RAG dependency pilot on October 13, 2026.

## Problem

Actual guided runtime initialization fails on macOS when the publication helper renames its completed staging directory over the empty destination it just reserved. The error was reproduced with and without the execution sandbox; no runtime configuration was published and no infrastructure was started.

## Acceptance

- [x] Guided generation publishes the requested runtime configuration successfully.
- [ ] Existing output remains protected; handled failures clean or report only newly owned partial output.
- [ ] Agent and runtime scaffolds retain the shared non-atomic publication contract.
- [ ] Existing Go checks and independent Standards/Spec reviews are recorded without new automated tests.

## Verification and boundaries

Base: `a2b78dcf8ba60724654760018c589fd2aef008e7`. Changes stay in scaffold publication and its documentation. The local Neo4j pilot is a consumer configuration, not a RAG implementation or a new supported persistence API.

Preflight found Docker, kind, and kubectl installed; the Docker daemon is stopped and Terraform is absent from PATH and common installation locations. Missing prerequisites must remain explicit. No paid model, embedding, cloud action, registry publication, or production change is authorized by this ticket.

The shared helper now moves staged entries into its exclusively reserved destination. Failure cleanup checks recorded identities and preserves unrecorded or replaced content. Publication remains non-atomic.

The actual disposable consumer retry generated `knowledge` successfully. After native edits for a single authenticated Neo4j instance with temporary storage, `ex runtime validate knowledge` passed. No infrastructure was started. This observation does not establish persistent database support or a RAG integration.

Formatting, compilation, the existing Go tests, and `go vet` passed. No new test suite or scenario was added. Independent Standards and Spec review remains pending.

FinOps: this source fix changes filesystem publication, not paid consumption; FIN-02/03/06/07 are not applicable to the fix. The separate pilot records local ownership, resource limits, temporary retention, and cleanup intent, with no financial measurements. Twelve-Factor: 12F-03/05 apply to preserving consumer configuration and the generation/execution boundary; the CLI does not install or start the generated service.
