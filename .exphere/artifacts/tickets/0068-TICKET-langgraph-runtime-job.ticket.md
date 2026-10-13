# CLI-RUNTIME-10: LangGraph Job lifecycle integration

**Spec:** [SPEC-LANGGRAPH-SCAFFOLD v1](../specs/0034-SPEC-langgraph-scaffold.spec.md)
**Plan slice:** T10 of the owner-approved eleven-ticket breakdown.
**What to build:** Run the generated agent image through the same microruntime Job lifecycle, preserving source and resource ownership.
**Blocked by:** CLI-RUNTIME-07 (T7), CLI-RUNTIME-09 (T9)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Unit references generated source and a consumer-built image without source copies.
- [x] Runtime/run correlation is injected and finite Job completion/failure is inspected.
- [x] Execution evidence, logs, and cleanup use normal lifecycle paths.
- [x] No runtime/Job execution is performed for verification; operational results remain unverified.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
