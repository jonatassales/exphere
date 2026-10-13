# CLI-RUNTIME-05: Owned project cluster and image loading

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v2](../specs/0033-SPEC-local-microruntime-lifecycle.spec.md)
**Plan slice:** T5 of the owner-approved eleven-ticket breakdown.
**What to build:** Explicitly create, inspect, load prebuilt images into, and safely delete one project-owned kind cluster.
**Blocked by:** CLI-RUNTIME-02 (T2)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Persist cluster intent/identity and private kubeconfig before permitting dependent operations.
- [x] Image loading accepts an already-built local image and does not build source.
- [x] Delete refuses active/unresolved runtime state, uncertain ownership, and foreign resources.
- [x] No automatic installation, ambient target fallback, cloud provisioning, or live cluster verification.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
