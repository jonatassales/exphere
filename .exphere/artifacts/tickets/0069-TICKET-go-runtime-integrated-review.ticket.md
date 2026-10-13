# CLI-RUNTIME-11: Integrated documentation and existing checks

**Spec:** [SPEC-GO-CLI-FOUNDATION v1](../specs/0032-SPEC-go-cli-foundation.spec.md)
**Plan slice:** T11 of the owner-approved eleven-ticket breakdown.
**What to build:** Deliver coherent documentation and recorded existing-check plus Standards/Spec review results for the integrated CLI.
**Blocked by:** CLI-RUNTIME-04 (T4), CLI-RUNTIME-08 (T8), CLI-RUNTIME-10 (T10)
**Status:** done
**Approval:** Owner's October 13, 2026 explicit request to implement the complete Go CLI foundation/local runtime lifecycle plan, including this scope and dependency breakdown. Local implementation is authorized; publication, new test scenarios, and live infrastructure verification are excluded.

## Acceptance

- [x] CLI README and current-scope guidance describe implemented commands and explicit operational limits.
- [x] Run only existing authorized checks, formatting verification, compilation, and go vet; record exact outcomes.
- [x] Standards and Spec reviewers inspect the same identified complete snapshot; resolve actionable findings.
- [x] Keep unexecuted lifecycle/agent integration unverified; do not publish, add scenarios, or claim savings.

## Verification record

Implementation is complete under the authorized source and existing-check scope. Acceptance checkboxes describe implementation and review, not live infrastructure verification. See the final record in [CLI-RUNTIME-11](0069-TICKET-go-runtime-integrated-review.ticket.md). Cluster and agent execution remain operationally unverified.

## Initial verification — October 13, 2026

These results precede final review corrections. They are not a claim that the final corrected snapshot has already passed. The parent implementation agent reported the following existing checks:

| Check | Observed result | Boundary |
| --- | --- | --- |
| `pnpm check` | Passed; 117 files checked. | Existing static repository checks. |
| `pnpm typecheck` | Passed; 7 tasks. | Existing workspace type checks. |
| `pnpm build` | Passed; 5 tasks. | Existing production/package builds; no deployment. |
| Current Go tests and `go vet` | Passed. | Adapted existing Go cases only. |
| Existing web, design, and hook tests | Passed, including 10 existing Playwright web cases. | Existing authorized suites; no new cases. |
| Aggregate `pnpm test` | Failed in the existing consumer contract assertion requiring absence of package `bin`. | That old assertion conflicted with the approved direct-`ex` packaging; the same-case adaptation and passing rerun are recorded below. |
| Generated-agent TypeScript compilation | Passed. | Static compilation only; graph/image/Job not executed. |
| Package shell syntax and scoped whitespace checks | Passed. | Static inspection only; no personal profile changed. |
| Runtime/cluster/agent operational scenarios | Not executed. | Intentionally excluded; operationally unverified. |

## Initial same-snapshot review

- Base: `b8400e2eeac2c89abb6919b0d9dfced51edaee6f`.
- Reviewed source snapshot SHA-256: `8bc6405cae14597ff3171ba8996f6f531805fad64e42d0db3cff15d909f03c46`.
- Standards and Spec independently reviewed that snapshot. Both returned actionable findings; a passing overall review is not recorded.

| Axis | Finding | Current disposition |
| --- | --- | --- |
| Standards | Missing explicit Terraform provider can allow an ambient provider target. | Resolved in the final reviewed source. |
| Standards | Cluster deletion inventory covers insufficient scopes. | Resolved in the final reviewed source. |
| Standards | Unsupported volume sources can escape the intended stateless workload scope. | Resolved in the final reviewed source. |
| Spec | Cluster deletion inventory must cover foreign resources beyond the default namespace. | Resolved by the same reviewed cluster-inventory correction. |
| Spec | Runtime event filtering loses owned ReplicaSet events. | Resolved in the final reviewed source. |
| Spec | Failed execution records omit configured image references. | Resolved in the final reviewed source. |

## Existing consumer-contract rerun

After adapting the obsolete package-bin assertion to the owner's approved direct-`ex` packaging, the existing consumer-harness rerun passed all 76 checks with no added scenario. Its current built CLI/SDK bridge help/version checks also passed. The setup helper was exercised only with `--help`; no profile was written. The earlier aggregate failure remains recorded above; the other existing aggregate suites had already passed. Final review-fix validation is recorded below.

## Final review and verification

- Final reviewed source snapshot: `bbe97b881962e18a5f053b8e81832967979d20a78d2711c313a6b581f43b364c`, 63 task-owned paths, compared with base `b8400e2eeac2c89abb6919b0d9dfced51edaee6f` on `codex/go-runtime-lifecycle`.
- Standards: **0 remaining actionable findings**. Spec: **0 remaining actionable findings**. Both independent reviewers verified the same file-hash manifest. The six original findings are resolved; unchanged reviewed scope was retained.
- Final privacy correction: runtime `up`/`down` serialize the same sanitized outcome as inspection/evidence rather than private ownership state. Both reviewers refreshed that exact two-file delta.
- After the lifecycle fixes: existing `go test ./...`, `go vet ./...`, macOS compilation, Linux amd64 cross-compilation, and Go formatting verification passed. After the final outcome-projection change, existing Go tests, vet, and macOS compilation passed again. No platform-specific behavior changed in that final projection.
- Existing workspace checks/builds and existing suites passed as individually recorded above. The aggregate test command was not rerun wholesale after the single obsolete assertion was adapted; its previously failing consumer suite passed all 76 existing cases on rerun. No suite or scenario was added.
- Direct package-bin and SDK-bridge help/version passed. One-time shell setup was inspected and syntax-checked; only its help was executed. No personal profile was modified.
- The generated agent TypeScript source compiled in isolation. The graph, container image, cluster, Terraform preparation, workloads, cleanup, and failure/recovery scenarios were **not executed**. Their operational reliability is **not verified**.
- Review manifests are retained as local evidence at `.audits/evidence/runs/2026-10-13-go-cli-foundation/source-manifest.json`; ignored local evidence is not a published attachment. Post-review changes are limited to completion statuses, acceptance bookkeeping, and this verification record; implementation source is unchanged from the reviewed snapshot.
- No commit, push, pull request, package publication, cloud provisioning, paid model call, or savings claim was performed. Completion is the authorized implementation/documentation/static-and-existing-check delivery, not a release or operational certification.

## Draft PR delivery follow-up

The owner subsequently requested the missing PR on October 13, 2026. This authorizes a scoped commit, normal push, and draft PR for the reviewed implementation; it does not authorize package publication, merging, or infrastructure execution. The preceding no-publication statements describe the earlier implementation phase.

The delivery branch starts from main at `5f6ba77758755249d7024bebaa73a69f99e7d236`. Its intervening changes affect website documentation and deployment, without changing the reviewed CLI source. The new local ticket filenames move from 0058–0068 to 0059–0069 because main allocated 0058; all stable CLI-RUNTIME identities and links are preserved. The PRD verification summary is corrected to reflect the completed reviews. These are administrative integration changes.
