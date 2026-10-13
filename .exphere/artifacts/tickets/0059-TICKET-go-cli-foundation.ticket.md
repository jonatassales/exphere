# CLI-RUNTIME-01: Cobra foundation and documented Go contracts

**Spec:** [SPEC-GO-CLI-FOUNDATION v1](../specs/0032-SPEC-go-cli-foundation.spec.md)
**Plan slice:** T1 of the owner-approved eleven-ticket breakdown.
**What to build:** Go CLI entry point, explicit composition, documented package boundaries, and existing command behavior under Cobra.
**Blocked by:** None.
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] Help/version require no project, tools, or network; invalid usage and output failures retain explicit exit behavior.
- [x] Move source to the agreed layout and update build/task references; keep Go doc comments on public contracts.
- [x] Use bounded native process execution and cancellation; no global registration or shell fallback.
- [x] Adapt existing Go checks only and record their results without adding scenarios.

## Subsequent approved scope: direct local executable

The owner additionally requested direct `ex --help` after dependency installation and chose one-time project-aware shell setup. This same foundation ticket owns the small package-bin bridges, source-install native build, explicit shell setup, and truthful documentation; no additional runtime behavior is introduced.

- [x] CLI package exposes its compiled Go executable through npm bins; SDK forwards through its real CLI dependency.
- [x] Source installation requires an existing Go toolchain, forbids automatic toolchain installation, and gives an explicit remedy when dependency scripts were disabled.
- [x] Explicit Bash/Zsh setup preserves unrelated profile content and selects the nearest project-local executable without changing PATH or using the system editor.
- [x] Public commands use `ex` after setup; no profile edit happens automatically or during verification; no npm release/prebuilt distribution is claimed.

## Verification record

Implementation and independent Standards/Spec review are complete within the authorized verification scope. The [integrated delivery record](0069-TICKET-go-runtime-integrated-review.ticket.md) records the final source snapshot, passing existing checks, resolved findings, and limitations. Checked acceptance items describe implemented source contracts; lifecycle, cluster, and LangGraph operational behavior remains unverified without separately authorized execution.
