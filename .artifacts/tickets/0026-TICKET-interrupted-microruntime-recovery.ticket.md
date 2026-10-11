# MRL-04: Reconcile interrupted runs before safe cleanup

**Document number:** `TICKET-0026`

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v1](../specs/0010-SPEC-local-microruntime-lifecycle.spec.md).

**What to build:** After interruption or a configuration change, an operator can inspect recorded versus actual owned resources and explicitly clean up the recoverable scope, with clear retention or refusal when identity and ownership cannot be established.

**Blocked by:** [MRL-02 / TICKET-0024 — Complete a local website startup-to-cleanup journey](0024-TICKET-single-unit-local-lifecycle.ticket.md). Reconciliation needs its durable runtime state, operation records, and already safe cleanup behavior; multiple-unit support is not required.

**Status:** in-review

**Execution authorization:** The owner's later October 11, 2026 request, `implement && commit separate branch && PR`, authorizes this implementation and its proposed disposable public-CLI verification seam, commits, and PR delivery. This supersedes the earlier phase restrictions in the approval/history below. Implementation choices are recorded in the parent specification. Real infrastructure, application probes, and production deployment were not exercised by these fixtures.

**Approval:** Approved for the presented ticket scope, granularity, and blocking edges by the project owner's message "Approved" on October 11, 2026, responding to the seven-ticket breakdown. Implementation and proposed verification execution are not authorized by this approval. Accepted revision before recording approval: SHA-256 `e6470dd30c550c3c34aa7087c04cbcb5187506c8fbd399a09d13cecf922cdba0`.

**Requirements:** `REQ-MR-006`, `REQ-MR-008`, `REQ-MR-010`, `REQ-MR-011`, and `REQ-MR-014`.

## Acceptance criteria

- [ ] A later invocation reconciles state, prior operation records, the current configuration, and actual resources rather than assuming an interrupted subprocess made no changes or completed its recorded action.
- [ ] Inspection identifies stale/incomplete operations and resources from earlier configurations, including declarations removed or renamed after a partial run. Resource names alone never establish deletion authority.
- [ ] Explicit cleanup handles a provably owned recoverable partial run and repeated cleanup, preserving original evidence and linking new observations. Missing/corrupt state, inaccessible inventory, uncertain process ownership, or ambiguous resource identity causes an explained safe refusal or retention.
- [ ] Foreign or deliberately retained namespace contents still prevent preparation destruction. A failed workload deletion never becomes an excuse to remove the namespace; every remaining owned or unobservable resource receives a disposition.
- [ ] Concurrency and interruption handling cannot silently release a still-active mutation boundary or retry/apply/destroy resources automatically. Existing finite operation bounds and secret-handling rules remain effective during recovery.
- [ ] The public-CLI seam covers interrupted preparation/application/cleanup, changed configuration, unavailable state or evidence, repeated cleanup, and competing operations; observed cleanup completeness and traceability support `MET-MR-003` and `MET-MR-004`. Both review axes assess the implementation snapshot.

**Original verification plan:** Proposed recovery cases within `VER-MRL-01`, using disposable state and controlled tool outcomes first. Live failure/recovery experiments require separate authorization and an identified disposable environment. They do not prove universal recovery or rollback.

**Original planning prerequisites:** Resolve `DEC-MRL-03` recovery/locking semantics and the operator's permitted cleanup/retention scope; confirm the relevant verification seam. This ticket extends successful reconciliation, not baseline safety: safe refusal, partial inventory, and cleanup protection are already required by MRL-02.

**Evidence:** `scripts/tests/recovery.sh` covers interrupted preparation/application, retained native UID reconciliation, prior declarations after rename, active-lock refusal, expired-lock recovery, absent namespaces, invalid state, and repeated cleanup. `concurrency.sh` verifies exclusive recovery acquisition; `process-boundary.sh` verifies stopping a TERM-resistant descendant with observable process state. Unknown process ownership retains its lock. The owner deferred live Docker validation beyond this delivery.

**Delivery numbering:** Fresh `main` already contained TICKET-0019 and TICKET-0020. These uncommitted microruntime documents were renumbered to TICKET-0021 through TICKET-0027 before publication; stable MRC/MRL IDs, approved scope, and dependencies are unchanged.
