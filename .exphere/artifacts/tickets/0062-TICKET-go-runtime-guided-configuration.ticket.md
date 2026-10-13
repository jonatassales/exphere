# CLI-RUNTIME-04: Guided runtime configuration

**Spec:** [SPEC-MICRORUNTIME-CONFIGURATION v2](../specs/0009-SPEC-microruntime-configuration.spec.md)
**Plan slice:** T4 of the owner-approved eleven-ticket breakdown.
**What to build:** Collect consumer inputs and generate native configuration that converges with manual configuration under the same validator.
**Blocked by:** CLI-RUNTIME-03 (T3)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Guided input selects owner, target, components, image, resource/readiness and quota values.
- [x] Write selected values to descriptor/native authority without shadow copies or source duplication.
- [x] Refuse existing output; handled failures preserve preexisting files and report any owned partial output.
- [x] Generation does not execute hooks, install tools, build images, or alter infrastructure.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
