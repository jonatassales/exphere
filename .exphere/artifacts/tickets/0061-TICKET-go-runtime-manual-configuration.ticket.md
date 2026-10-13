# CLI-RUNTIME-03: Descriptor v2 and manual runtime scaffolding

**Spec:** [SPEC-MICRORUNTIME-CONFIGURATION v2](../specs/0009-SPEC-microruntime-configuration.spec.md)
**Plan slice:** T3 of the owner-approved eleven-ticket breakdown.
**What to build:** Generate manual configuration and validate a typed descriptor plus native references through one shared Go contract.
**Blocked by:** CLI-RUNTIME-02 (T2)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Manual initialization generates an incomplete descriptor with actionable completion guidance, not invented infrastructure values.
- [x] Validation rejects unsupported versions/fields, ambiguous IDs, collisions, invalid references, and path escapes.
- [x] Units reference original source; native resources have one editable authority.
- [x] Retired legacy locations receive explicit errors without migration or shell fallback.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
