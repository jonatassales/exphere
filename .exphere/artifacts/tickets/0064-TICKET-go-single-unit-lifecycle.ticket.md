# CLI-RUNTIME-06: First complete application runtime lifecycle

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v2](../specs/0033-SPEC-local-microruntime-lifecycle.spec.md)
**Plan slice:** T6 of the owner-approved eleven-ticket breakdown.
**What to build:** Prepare and execute one configured application runtime with inspection and explicit cleanup in the same slice.
**Blocked by:** CLI-RUNTIME-03 (T3), CLI-RUNTIME-05 (T5)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Revalidate and preflight before mutation; record intent and serialize mutations.
- [x] Terraform prepares only namespace/quota before supported workload apply; preparation failure stops workload creation.
- [x] Record readiness/outcomes and target/image/configuration evidence.
- [x] Cleanup preserves source/configuration/evidence and the shared cluster; refuses uncertain ownership.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
