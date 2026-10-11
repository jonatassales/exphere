# MRL-01: Explain local readiness before infrastructure mutation

**Document number:** `TICKET-0023`

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v1](../specs/0010-SPEC-local-microruntime-lifecycle.spec.md).

**What to build:** An operator can inspect a manually configured runtime and obtain a recorded explanation of its local execution prerequisites, selected resources, and observable existing state before permitting any infrastructure change. The same preflight contract is available to the later startup operation.

**Blocked by:** [MRC-01 / TICKET-0021 — Configure and validate a manual v2 microruntime](0021-TICKET-manual-microruntime-configuration.ticket.md). Preflight must consume a resolved v2 composition; guided generation is not required.

**Status:** in-review

**Execution authorization:** The owner's later October 11, 2026 request, `implement && commit separate branch && PR`, authorizes this implementation and its proposed disposable public-CLI verification seam, commits, and PR delivery. This supersedes the earlier phase restrictions in the approval/history below. Implementation choices are recorded in the parent specification. Real infrastructure, application probes, and production deployment were not exercised by these fixtures.

**Approval:** Approved for the presented ticket scope, granularity, and blocking edges by the project owner's message "Approved" on October 11, 2026, responding to the seven-ticket breakdown. Implementation and proposed verification execution are not authorized by this approval. Accepted revision before recording approval: SHA-256 `32539d1a1072e9c866a915a7ed1bd700839eff7d2045f1dee7e8c908ce7063f5`.

**Requirements:** `REQ-MR-005`; read-only portions of `REQ-MR-007`, `REQ-MR-008`, `REQ-MR-011`, `REQ-MR-012`, `REQ-MR-013`, and `REQ-MR-014`.

## Acceptance criteria

- [ ] The agreed inspection entry exposes a complete preflight report and read-only existing-resource observations; no new public preparation command or incomplete successful startup is introduced.
- [ ] Preflight revalidates the current configuration and inventories every selected unit and nested native input before mutation. Unsupported resource forms, conflicting identities, mismatched namespaces, and overlap with Terraform-owned resources are explained before application.
- [ ] The operator sees actual tool/provider versions, supported local-target checks, access requirements, image-availability conditions, target/ownership conflicts, and the supported Terraform root scope. A context name, local declaration, host image listing, or tool on PATH alone does not prove readiness.
- [ ] Checks consistently use the explicit target and preserve the global current context. They do not initialize/download Terraform dependencies, load images, execute hooks, reconcile resources, or modify infrastructure; required future effects are reported as such.
- [ ] An operation record begins before any later mutation can be allowed. It identifies runtime/units, input revisions and dirty/untracked configuration, policy/tool versions, actual observed environment, performed checks, unavailable evidence, and the truthful outcome.
- [ ] Inspection distinguishes configured limits from observed usage and unavailable signals. Diagnostics preserve relevant failures and exclude secret values; evidence/retention limits are explicit. An unwritable mandatory evidence destination prevents a mutation-ready result.
- [ ] The public-CLI seam demonstrates invalid references, unsupported/nonlocal/inaccessible targets, missing prerequisites, evidence failures, and read-only inspection without mutating tool calls; both review axes assess the resulting snapshot.

**Original verification plan:** Proposed `VER-MRL-01` public-CLI seam with controlled tool responses in disposable consumer projects. Live read-only inspection needs its own authorized environment; fixtures do not establish actual connectivity, image availability, or enforcement.

**Original planning prerequisites:** Approve relevant `DEC-MRL-01`, `DEC-MRL-02`, and `DEC-MRL-04` decisions: inspection/preflight interface, exact compatibility matrix, local-target proof, supported native inputs, image availability strategy, evidence encoding/bounds, and the verification seam. Resolve these before dependent implementation rather than inventing universal defaults.

**Evidence:** `scripts/tests/preflight.sh` and `observation.sh` passed at the public CLI boundary. The fixtures cover actual-versus-required version reporting, denied access, mismatched cluster CA, nested identities, configured versus observed limits, private sensitive values, and inconclusive mandatory observations. Native infrastructure and actual resource enforcement remain unverified.

**Delivery numbering:** Fresh `main` already contained TICKET-0019 and TICKET-0020. These uncommitted microruntime documents were renumbered to TICKET-0021 through TICKET-0027 before publication; stable MRC/MRL IDs, approved scope, and dependencies are unchanged.
