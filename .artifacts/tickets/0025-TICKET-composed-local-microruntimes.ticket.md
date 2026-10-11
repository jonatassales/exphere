# MRL-03: Operate every selected unit and explain partial composition

**Document number:** `TICKET-0025`

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v1](../specs/0010-SPEC-local-microruntime-lifecycle.spec.md).

**What to build:** An operator starts, inspects, and cleans up a composition of selected units, including nested manifests, with per-unit outcomes that explain partial application, failed readiness, and resource-boundary rejection.

**Blocked by:** [MRL-02 / TICKET-0024 — Complete a local website startup-to-cleanup journey](0024-TICKET-single-unit-local-lifecycle.ticket.md). This extends its complete stage, evidence, ownership, and teardown contract beyond one unit.

**Status:** in-review

**Execution authorization:** The owner's later October 11, 2026 request, `implement && commit separate branch && PR`, authorizes this implementation and its proposed disposable public-CLI verification seam, commits, and PR delivery. This supersedes the earlier phase restrictions in the approval/history below. Implementation choices are recorded in the parent specification. Real infrastructure, application probes, and production deployment were not exercised by these fixtures.

**Approval:** Approved for the presented ticket scope, granularity, and blocking edges by the project owner's message "Approved" on October 11, 2026, responding to the seven-ticket breakdown. Implementation and proposed verification execution are not authorized by this approval. Accepted revision before recording approval: SHA-256 `28a2f3bad35e54db9f631e66f95f44ef74f089a7abd609851b39272f8eca3dcf`.

**Requirements:** `REQ-MR-005`, `REQ-MR-006`, `REQ-MR-007`, `REQ-MR-008`, `REQ-MR-009`, `REQ-MR-010`, `REQ-MR-011`, and `REQ-MR-013`.

## Acceptance criteria

- [ ] Preflight resolves the complete selected resource set, including supported nested manifests, before the first mutation. Duplicate/conflicting identities and unsupported aggregation stop execution instead of silently dropping resources.
- [ ] One runtime preparation root/state serves the composition. Units execute in the agreed deterministic order without an invented component dependency graph, and native settings remain authoritative for every unit.
- [ ] Every selected unit receives an attempted, failed, ready, or not-attempted disposition consistent with the parent stage model. A failed stage stops subsequent mutations; skipped units and already applied resources remain visible in the overall non-passed outcome.
- [ ] Inspection attributes image identities, readiness, events, logs, configured resources, and available usage to the correct runtime and units. Missing observations are explicit and cannot turn a partial composition into success.
- [ ] A separately authorized real quota scenario connects an observed rejection or inability to become ready to cluster quota evidence. Do not infer quota causality from an arbitrary timeout or portray configured quotas as monetary budgets.
- [ ] Explicit cleanup accounts for all owned resources from successful and partial composition, preserves the existing workload-before-preparation order, and reports leftovers without deleting foreign or retained resources.
- [ ] Public-CLI observations cover multiple units, nested inputs, early-unit failure, quota rejection, unavailable evidence, and cleanup. Record the four PRD metric conditions where applicable; both review axes assess the same snapshot.

**Original verification plan:** Proposed `VER-MRL-01` composition scenarios. Deterministic tool fixtures establish enumeration, ordering, and outcome propagation; authorized live observations establish actual readiness, quota enforcement, and removal. No load test or new application test framework is part of this slice.

**Original planning prerequisites:** Confirm supported resource forms, aggregation and ordering under the parent decisions and authorize the corresponding fixture/live checks. Readiness, ownership, and evidence principles remain unchanged; technical proposals are not approved by this ticket.

**Evidence:** `scripts/tests/composition.sh` passed seven public scenarios: two units with nested input, cross-unit selector rejection, deterministic stop after apply failure, quota-related controller evidence, foreign retention, failed deletion inventory, and replaced UID protection. Actual multi-unit quota enforcement remains pending.

**Delivery numbering:** Fresh `main` already contained TICKET-0019 and TICKET-0020. These uncommitted microruntime documents were renumbered to TICKET-0021 through TICKET-0027 before publication; stable MRC/MRL IDs, approved scope, and dependencies are unchanged.
