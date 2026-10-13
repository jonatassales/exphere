# CLI-RUNTIME-02: Project initialization and prerequisite diagnostics

**Spec:** [SPEC-GO-CLI-FOUNDATION v1](../specs/0032-SPEC-go-cli-foundation.spec.md)
**Plan slice:** T2 of the owner-approved eleven-ticket breakdown.
**What to build:** Initialize consumer project metadata safely and explain prerequisite availability without installing tools.
**Blocked by:** CLI-RUNTIME-01 (T1)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Init preserves existing content and starts no infrastructure.
- [x] Private operational state is specifically ignored without replacing consumer ignore content.
- [x] Doctor reports detected versions, missing tools, readiness gaps, and structured JSON diagnostics.
- [x] Missing prerequisites stay explicit and installation remains a consumer action.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
