# MRL-02: Complete a local website startup-to-cleanup journey

**Document number:** `TICKET-0024`

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v1](../specs/0010-SPEC-local-microruntime-lifecycle.spec.md).

**What to build:** An operator explicitly starts one prebuilt website unit in the selected local environment, observes preparation/readiness and the local endpoint, inspects its evidence, and ends its owned resources with an explained cleanup inventory. Failure, inspection, and cleanup are included in this first mutating slice.

**Blocked by:** [MRL-01 / TICKET-0023 — Explain local readiness before infrastructure mutation](0023-TICKET-local-microruntime-preflight.ticket.md). Startup reuses its validated inventory, target checks, and evidence boundary.

**Status:** in-review

**Execution authorization:** The owner's later October 11, 2026 request, `implement && commit separate branch && PR`, authorizes this implementation and its proposed disposable public-CLI verification seam, commits, and PR delivery. This supersedes the earlier phase restrictions in the approval/history below. Implementation choices are recorded in the parent specification. Real infrastructure, application probes, and production deployment were not exercised by these fixtures.

**Approval:** Approved for the presented ticket scope, granularity, and blocking edges by the project owner's message "Approved" on October 11, 2026, responding to the seven-ticket breakdown. Implementation and proposed verification execution are not authorized by this approval. Accepted revision before recording approval: SHA-256 `54a7b5e4281b903d7402489343448a594313ad06e7d8f529c700282928082371`.

**Requirements:** `REQ-MR-005` through `REQ-MR-011`, plus operational ownership boundaries in `REQ-MR-013` and `REQ-MR-014`, for one supported website unit.

## Acceptance criteria

- [ ] The agreed startup, inspection, and cleanup interface completes one supported Deployment/Service composition using a prebuilt image and an already prepared local cluster. Until composition support lands, mutation explicitly rejects configurations with multiple units rather than running a subset.
- [ ] After successful preflight and evidence initialization, one isolated Terraform root/state prepares the selected namespace and quotas. Workspace/backend inheritance cannot silently change the target; competing mutations are rejected or serialized. Preparation failure blocks workload application and exposes partial changes.
- [ ] The workload uses authoritative native manifests, a recorded image availability/loading path, and finite declared readiness bounds. Actual image identities, events, logs, configured resources, and available observations are recorded. The agreed local endpoint has explicit process ownership and shutdown.
- [ ] A failed apply, image failure, readiness timeout, quota rejection, cancellation, or missing mandatory observation cannot produce a passed journey. Preserve native result meanings and partial inventory, stop further mutations, and collect bounded diagnostics. Do not automatically retry, roll back, or destroy resources after startup failure.
- [ ] Explicit cleanup removes only proven owned workloads before eligible preparation resources. It refuses destructive namespace fallback when workload deletion failed or foreign, retained, unknown, or unobservable resources make deletion unsafe. Shared cluster/source/configuration/evidence remain intact; already absent resources and lookup failures are distinguished.
- [ ] State and ownership records survive process exit. Basic interruption stops owned child processes where possible and records uncertainty; ambiguous recovery remains safely refused until reconciliation is supported. Runtime-operation bounds and cleanup disposition are visible from this first delivery.
- [ ] Correlated operation records explain configuration/image identity, tools/policies, target, actions/timing, unit outcome, and before/after inventory. Capture `MET-MR-001` through `MET-MR-004` only from observed conditions, without invented productivity thresholds, usage, savings, or production claims.
- [ ] Authorized public-CLI fixtures demonstrate stage ordering, failure and ownership protection. Separately authorized local observations demonstrate actual website readiness/endpoint access, namespace quotas, and cleanup; fixtures alone cannot satisfy live behavior acceptance. Both review axes cover the same implementation snapshot.

**Original verification plan:** `VER-MRL-01`, narrowed to one website unit. Use controlled tool outcomes for deterministic failures and the same CLI boundary for an authorized local pilot. A live quota rejection is observed here if practical, or remains explicitly pending for MRL-03; quota enforcement is never inferred from generated files. No verification runs in this drafting phase.

**Original planning prerequisites:** Resolve the parent operation interface, versions, timeout values, local cluster preparation/removal procedure, image loading, endpoint, state/locking, ownership, evidence, and retention decisions before implementation. Authorize the actual environment, resource envelope, and operational checks separately. `FIN-01`/`FIN-04`/`FIN-05`/`FIN-06` and relevant Twelve-Factor criteria require recorded observations; paid dependencies trigger the conditional FinOps assessment.

**Evidence:** `scripts/tests/lifecycle.sh` and `terraform-runtime.sh` passed with controlled tools: prepare/apply/readiness/inspection/cleanup, repeated cleanup, environment isolation, plan boundaries, provider version, partial preparation, and private native failures. The complete workspace suite passed. Actual website readiness, endpoint, quotas, and removal on a real cluster remain pending; this ticket is not done.

**Delivery numbering:** Fresh `main` already contained TICKET-0019 and TICKET-0020. These uncommitted microruntime documents were renumbered to TICKET-0021 through TICKET-0027 before publication; stable MRC/MRL IDs, approved scope, and dependencies are unchanged.

**Deferred validation debt:** The owner's later instruction defers further tests, including the final full-suite run at the delivered revision. The existing fixtures remain available. Real Docker validation is also deferred. These follow-ups are tracked in the parent specification; this delivery does not claim completed live acceptance.
