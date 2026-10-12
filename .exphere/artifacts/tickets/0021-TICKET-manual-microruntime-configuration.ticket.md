# MRC-01: Configure and validate a manual v2 microruntime

**Document number:** `TICKET-0021`

**Spec:** [SPEC-MICRORUNTIME-CONFIGURATION v1](../specs/0009-SPEC-microruntime-configuration.spec.md).

**What to build:** A developer can initialize, discover, and validate a manually configured v2 microruntime referencing existing components and consumer-maintained native configuration. The CLI explains invalid or ambiguous input and the legacy transition without changing existing runtimes or invoking infrastructure.

**Blocked by:** None.

**Status:** in-review

**Execution authorization:** The owner's later October 11, 2026 request, `implement && commit separate branch && PR`, authorizes this implementation and its proposed disposable public-CLI verification seam, commits, and PR delivery. This supersedes the earlier phase restrictions in the approval/history below. Implementation choices are recorded in the parent specification. Real infrastructure, application probes, and production deployment were not exercised by these fixtures.

**Approval:** Approved for the presented ticket scope, granularity, and blocking edges by the project owner's message "Approved" on October 11, 2026, responding to the seven-ticket breakdown. Implementation and proposed verification execution are not authorized by this approval. Accepted revision before recording approval: SHA-256 `aa6d84c7c6aca287fbfb1976853d6f1a65cb062c98d701e835a4e5e1f352817d`.

**Requirements:** `REQ-MR-002`, `REQ-MR-003`, `REQ-MR-004`, and configuration portions of `REQ-MR-005`, `REQ-MR-012`, `REQ-MR-013`, and `REQ-MR-014`.

## Acceptance criteria

- [ ] New manual initialization uses the v2 location and accepted manual-input contract. Discovery and validation distinguish a complete usable configuration from missing required inputs; existing output is not overwritten.
- [ ] The formal descriptor contract and validator agree on identity, local environment, owner, explicit context/namespace, nonempty selected units, preparation configuration, and optional declared `.sh` hooks. Unknown fields, wrong types, blank values, and unsupported versions produce actionable diagnostics.
- [ ] Unit names match existing component directory names. Component references resolve from the consumer project and native configuration references from the runtime, independently of the working directory. Missing targets, name conflicts, boundary escapes, and unsafe symbolic-link resolution fail clearly.
- [ ] Multiple selected components and references to nested native configuration are represented without copying application source. Workload and quota settings retain their native authority; validation preserves consumer edits and does not claim measured consumption or enforced limits.
- [ ] Discovery distinguishes legacy and new locations. The agreed compatibility policy preserves legacy files and explicit supported low-level behavior, rejects same-ID ambiguity, and reports unsupported location/version combinations without automatic conversion or fallback.
- [ ] Initialization, discovery, and validation execute no infrastructure commands or hooks. Public help and diagnostics describe actual supported behavior and the explicit handoff to lifecycle operations.
- [ ] The agreed public-CLI verification demonstrates valid/invalid manual inputs, native edits, reference boundaries, multiple components, legacy/new/ambiguous discovery, and unchanged existing source/runtime content; implementation receives both Standards and Spec review on the same snapshot.

**Original verification plan:** Proposed seam `VER-MRC-01`: disposable consumer projects and public CLI invocations, observing file changes, diagnostics, and exit status. No live cluster or application probe is needed. Expanded fixtures require confirmation and authorization before execution; none ran during ticket drafting.

**Original planning prerequisites:** Approve the relevant parent scope and seam, then resolve `DEC-MRC-01` through `DEC-MRC-03` as applicable: manual initialization inputs, formal schema packaging, native configuration references, and the legacy policy. These are pending decisions, not completed dependency tickets. No standalone prefactoring is required by current evidence; any small internal adjustment stays within this verifiable slice.

**Evidence:** `sh packages/cli/scripts/test-configuration.sh` and the legacy CLI suite passed on October 11, 2026. Public commands exercised manual initialization, multi-unit references, native-edit preservation, invalid paths, duplicate keys, ambiguous IDs, and v1 compatibility. Both review axes cleared the configuration snapshot after correcting documentation claims.

## Draft breakdown review — October 11, 2026

Two independent reviewers assessed the seven ticket additions against base `89e4bd796d3ec8ff76bed414c39f19be2d365b7e`, using PRD-0002, SPEC-0009, SPEC-0010, and the owner's `to-tickets` request as sources. Parent artifacts and unrelated changes were excluded from the changed scope. The hashes below identify the reviewed ticket bodies before this review record was appended; the other six files remained unchanged.

| Ticket | Reviewed SHA-256 |
| --- | --- |
| MRC-01 / TICKET-0021 | `adba351ccd5226a93daa76fb1ed2aca8d4224c82c725ef1b9f59e556d6c8731d` |
| MRC-02 / TICKET-0022 | `d1c2d6fb9cd2cdb6ddafbf6a321f9d2012d2a77d1e2da924e0aebc7537a6eb07` |
| MRL-01 / TICKET-0023 | `32539d1a1072e9c866a915a7ed1bd700839eff7d2045f1dee7e8c908ce7063f5` |
| MRL-02 / TICKET-0024 | `54a7b5e4281b903d7402489343448a594313ad06e7d8f529c700282928082371` |
| MRL-03 / TICKET-0025 | `28a2f3bad35e54db9f631e66f95f44ef74f089a7abd609851b39272f8eca3dcf` |
| MRL-04 / TICKET-0026 | `e6470dd30c550c3c34aa7087c04cbcb5187506c8fbd399a09d13cecf922cdba0` |
| MRL-05 / TICKET-0027 | `987cd0cab6e8aa637a2d08ab2447255461ee9b34b5bea532c7c580965e67dff1` |

- Standards: **0 findings**. One parent per ticket, canonical draft fields, en-US, vertical behavior, minimal blocking edges, and authorization boundaries conform to local rules.
- Spec: **0 findings**. The breakdown covers the two specifications, all 14 PRD requirements, and four metrics. Evidence and safe cleanup accompany the first mutation; guided setup does not block manually configured execution.
- Static inspection: unique stable IDs, required fields, parent/dependency links, dependency ordering without cycles, and whitespace checked. No implementation, application tests, or infrastructure operations were performed.
- Readiness at review time: all seven tickets were `draft`; granularity, dependency edges, and merge/split preferences had not yet been confirmed. This historical review is not implementation approval or operational evidence.

## Breakdown approval — October 11, 2026

The project owner subsequently replied "Approved" to the seven-ticket proposal and its questions about granularity, blocking edges, and merging/splitting. This records acceptance of the presented scopes and dependency graph for MRC-01, MRC-02, and MRL-01 through MRL-05, with no requested changes. Each ticket's approval field identifies its accepted revision before this metadata update.

The tracker does not define an `approved` ticket execution state. Status therefore remains `draft` with approval recorded separately; `ready-for-agent` still requires approved implementation inputs, satisfied dependencies, and authorization to execute. The approval does not resolve the explicitly open parent technical decisions or authorize tests, infrastructure operations, commits, or publication. Those boundaries do not require reconfirming this approved breakdown.

**Delivery numbering:** Fresh `main` already contained TICKET-0019 and TICKET-0020. These uncommitted microruntime documents were renumbered to TICKET-0021 through TICKET-0027 before publication; stable MRC/MRL IDs, approved scope, and dependencies are unchanged.
