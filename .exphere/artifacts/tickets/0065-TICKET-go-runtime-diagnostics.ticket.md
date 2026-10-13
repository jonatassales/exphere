# CLI-RUNTIME-07: Multiple units and developer diagnostics

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v2](../specs/0033-SPEC-local-microruntime-lifecycle.spec.md)
**Plan slice:** T7 of the owner-approved eleven-ticket breakdown.
**What to build:** Operate all selected units and provide useful inspection, bounded logs, and explicit local endpoint access.
**Blocked by:** CLI-RUNTIME-06 (T6)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Each selected unit has a completed, failed, or not-attempted outcome.
- [x] Inspect reports readiness, events, configured resources, available measurements, and unresolved operations in human/JSON output.
- [x] Logs are bounded by default and live following is explicit.
- [x] Port forwarding stays foreground, binds localhost only, and stops with cancellation.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
