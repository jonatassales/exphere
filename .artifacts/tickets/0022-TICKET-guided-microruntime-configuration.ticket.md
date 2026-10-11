# MRC-02: Generate equivalent configuration through guided setup

**Document number:** `TICKET-0022`

**Spec:** [SPEC-MICRORUNTIME-CONFIGURATION v1](../specs/0009-SPEC-microruntime-configuration.spec.md).

**What to build:** A developer answers guided questions and receives a valid, inspectable runtime configuration with units referencing existing components and editable native Kubernetes/Terraform files. Equivalent manual inputs retain the same meaning and validation.

**Blocked by:** [MRC-01 / TICKET-0021 — Configure and validate a manual v2 microruntime](0021-TICKET-manual-microruntime-configuration.ticket.md). Guided generation consumes its descriptor, reference resolution, and validation contract.

**Status:** in-review

**Execution authorization:** The owner's later October 11, 2026 request, `implement && commit separate branch && PR`, authorizes this implementation and its proposed disposable public-CLI verification seam, commits, and PR delivery. This supersedes the earlier phase restrictions in the approval/history below. Implementation choices are recorded in the parent specification. Real infrastructure, application probes, and production deployment were not exercised by these fixtures.

**Approval:** Approved for the presented ticket scope, granularity, and blocking edges by the project owner's message "Approved" on October 11, 2026, responding to the seven-ticket breakdown. Implementation and proposed verification execution are not authorized by this approval. Accepted revision before recording approval: SHA-256 `d1c2d6fb9cd2cdb6ddafbf6a321f9d2012d2a77d1e2da924e0aebc7537a6eb07`.

**Requirements:** `REQ-MR-001`, `REQ-MR-002`, `REQ-MR-004`, and configuration portions of `REQ-MR-005`, `REQ-MR-012`, `REQ-MR-013`, and `REQ-MR-014`.

## Acceptance criteria

- [ ] Explicit guided entry collects the selected components, owner, local target, prebuilt images, ports, resource/replica/probe settings, and quotas required by the agreed supported composition. It neither builds images nor invents consumer values.
- [ ] Initial native workload and preparation files contain their authoritative settings; the descriptor contains identity, target selection, and references without duplicate editable image, resource, readiness, or quota settings.
- [ ] Generated units preserve component directory names and reference source without copying it. Only selected capabilities create content; optional hooks never produce unused placeholder scripts or directories.
- [ ] Equivalent manual and guided inputs pass the same validator and produce semantically equivalent effective configuration. Later consumer edits remain authoritative and are never silently reset by validation.
- [ ] Existing output and conflicting component names stop generation before publication. Cancellation, interruption, and write failure preserve preexisting content and identify any newly created partial output that could not be removed.
- [ ] Generated guidance explains selected components, native ownership, prerequisites, and explicit lifecycle operations without claiming that configuration generation executed a runtime. No cluster operation, hook invocation, or surrounding project/portal migration occurs.
- [ ] Public-CLI checks compare manual/guided semantics, generated content, source preservation, conflicts, cancellation, and partial-write outcomes; both review axes assess the implementation snapshot.

**Original verification plan:** Proposed `VER-MRC-01` seam, using disposable consumer projects and observable generated artifacts. This includes configuration support for `MET-MR-004`; it does not establish readiness, quota enforcement, or cleanup. No new fixture execution is authorized by this draft.

**Original planning prerequisites:** Confirm the proposed verification seam and authorize execution; settle guided/manual inputs and supported native forms/tool-provider versions under `DEC-MRC-02` with the lifecycle decisions. Agreement on those contracts is required, but completion of the lifecycle implementation is not a dependency. The ticket scope and blocking edge are already approved.

**Evidence:** `sh packages/cli/scripts/test-guided-configuration.sh` passed on October 11, 2026. Cases include manual/guided native equivalence, multiple units, optional hooks without execution, collisions, cancellation, failed publication, and unsafe quota interpolation. Both review axes cleared the configuration snapshot.

**Delivery numbering:** Fresh `main` already contained TICKET-0019 and TICKET-0020. These uncommitted microruntime documents were renumbered to TICKET-0021 through TICKET-0027 before publication; stable MRC/MRL IDs, approved scope, and dependencies are unchanged.
