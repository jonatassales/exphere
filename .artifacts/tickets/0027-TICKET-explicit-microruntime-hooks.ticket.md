# MRL-05: Run explicit consumer hooks with accountable outcomes

**Document number:** `TICKET-0027`

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v1](../specs/0010-SPEC-local-microruntime-lifecycle.spec.md).

**What to build:** An operator explicitly selects a declared v2 consumer `.sh` hook and receives a bounded, attributable result whose declared effects can be inspected and cleaned up through the supported runtime ownership contract.

**Blocked by:** [MRL-02 / TICKET-0024 — Complete a local website startup-to-cleanup journey](0024-TICKET-single-unit-local-lifecycle.ticket.md). Supported hook effects need its operational ownership, inspection, evidence, cancellation, and cleanup boundaries; guided generation and multi-unit execution are unnecessary prerequisites.

**Status:** in-review

**Execution authorization:** The owner's later October 11, 2026 request, `implement && commit separate branch && PR`, authorizes this implementation and its proposed disposable public-CLI verification seam, commits, and PR delivery. This supersedes the earlier phase restrictions in the approval/history below. Implementation choices are recorded in the parent specification. Real infrastructure, application probes, and production deployment were not exercised by these fixtures.

**Approval:** Approved for the presented ticket scope, granularity, and blocking edges by the project owner's message "Approved" on October 11, 2026, responding to the seven-ticket breakdown. Implementation and proposed verification execution are not authorized by this approval. Accepted revision before recording approval: SHA-256 `987cd0cab6e8aa637a2d08ab2447255461ee9b34b5bea532c7c580965e67dff1`.

**Requirements:** `REQ-MR-005`, `REQ-MR-008`, `REQ-MR-010`, `REQ-MR-011`, `REQ-MR-012`, and `REQ-MR-014` for supported explicit extensions.

## Acceptance criteria

- [ ] Hook declaration alone causes no execution during initialization, validation, preflight, or startup. Only an explicitly selected declared `.sh` hook runs; missing/invalid/undeclared hooks fail actionably.
- [ ] The accepted hook contract supplies the runtime/project context, explicit arguments/environment, finite duration, result propagation, and interruption behavior without interpreting descriptor values as shell code or exposing secrets in records.
- [ ] Preflight reports unsupported extension effects or unavailable prerequisites before invocation. Supported declared effects have identifiable ownership and inspection/cleanup disposition; an arbitrary script is not presumed discoverable, reversible, or sandboxed.
- [ ] Success, nonzero exit, timeout, cancellation, and unavailable mandatory evidence receive attributable outcomes linked to the runtime. A hook result cannot bypass required readiness or evidence or convert a failed operation into a passed journey.
- [ ] Supported owned effects can be inspected and explicitly removed under the same protection of shared/foreign/retained resources. Incomplete observation remains visible; there is no automatic rollback or blanket cleanup guarantee for trusted consumer code.
- [ ] Existing legacy explicit-hook behavior remains consistent with the accepted compatibility policy. No automatic lifecycle binding, new general workflow engine, or universal consumer script obligation is introduced.
- [ ] Authorized public-CLI fixtures exercise explicit invocation, arguments/context, unsupported effects, failure/timeout/cancellation, evidence, and scoped cleanup using harmless disposable hooks; both review axes assess the same implementation snapshot.

**Original verification plan:** Proposed explicit-extension cases within `VER-MRL-01`, reusing the public CLI boundary and isolated consumer hook conventions. Existing hook fixtures do not authorize this expanded scope or live infrastructure effects. No hook ran during drafting.

**Original planning prerequisites:** Resolve `DEC-MRL-05` explicit invocation and supported effect-accounting contracts together with the relevant failure/evidence decisions. Confirm the seam and operational permissions before execution. Automatic stage bindings remain outside this ticket unless separately accepted in the parent specification.

**Evidence:** `scripts/tests/access.sh` passed explicit context/arguments, unsupported effects, native failure, timeout/cancellation, bounded private output, explicit logs/localhost forwarding, supported workload effects plus cleanup, missing evidence, and foreign-effect retention. Trusted scripts remain unsandboxed. Real hook/provider operation remains unverified.

**Delivery numbering:** Fresh `main` already contained TICKET-0019 and TICKET-0020. These uncommitted microruntime documents were renumbered to TICKET-0021 through TICKET-0027 before publication; stable MRC/MRL IDs, approved scope, and dependencies are unchanged.
