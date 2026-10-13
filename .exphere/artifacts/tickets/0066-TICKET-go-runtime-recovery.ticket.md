# CLI-RUNTIME-08: Interruption and owned-resource recovery

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v2](../specs/0033-SPEC-local-microruntime-lifecycle.spec.md)
**Plan slice:** T8 of the owner-approved eleven-ticket breakdown.
**What to build:** Recover from interrupted or partial lifecycle operations without destroying resources of uncertain ownership.
**Blocked by:** CLI-RUNTIME-06 (T6)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Cancel and wait for owned processes; report interruption and preserve partial state/evidence.
- [x] Explicit recovery reconciles observed target/resource identities with recorded intent.
- [x] Remove workloads before namespace/quota resources; foreign objects or incomplete observations block cleanup.
- [x] Cluster deletion requires reconciled runtime state and preserves foreign resources through refusal.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
