# CI-01: Review pull requests against standards and their specification

**Document number:** `TICKET-0020`

**Spec:** [SPEC-GITHUB-AGENT-REVIEW v2](../specs/0008-SPEC-github-agent-review.spec.md).

**What to build:** Contributors receive separate Standards and Spec assessments of one immutable PR snapshot from the `agent-review` job, with inspectable evidence, bounded opt-in model execution, and explicit unavailable, skipped, stale, or failed outcomes.

**Blocked by:** None.

**Status:** done

**Approval:** On October 11, 2026, after SPEC-0008 and its PR-to-report verification seam were presented, the owner explicitly invoked `to-tickets` and `implement` together and authorized commits on a separate branch, push, and PR creation. This ticket is the complete vertical delivery slice for the same specification; it introduces no additional scope or dependency. Controlled local contract fixtures are authorized. Paid API calls, secret/billing configuration, deployment, and merge remain outside this delivery.

## Acceptance criteria

- [x] `REQ-CI-01` / `REQ-CI-08`: The requested job handles documented PR events and eligibility using trusted workflow/adapter/skill revisions, read permissions, and PR content only as data.
- [x] `REQ-CI-02` / `REQ-CI-03`: Independent parallel Standards and Spec invocations consume the installed skill and the same immutable snapshot, with complete source identities, file-status coverage, exclusions, and version records.
- [x] `REQ-CI-04` / `REQ-CI-05`: Axis reports remain separate and bounded; actual PR and commit artifact relations produce advisory diagnostics, and an unavailable authoritative spec remains explicitly unverified.
- [x] `REQ-CI-06` / `REQ-CI-07`: Summary and artifact distinguish substantive findings, no findings, no change, unavailable evidence, ineligibility, stale results, and technical failures; no failed worker becomes a clean review.
- [x] `REQ-CI-09`: Opt-in configuration, fixed consumption limits, approval expiration, local worker cancellation, report retention, usage reporting, and provider limitations are explicit. No paid execution occurs during delivery.
- [x] `VER-CI-01`: Authorized disposable fixtures and workflow inspection verify the public event-to-report contract, including negative paths, credential isolation, and absence of contributor-code execution.
- [x] Both code-review axes examined the same identified implementation snapshot; all actionable findings are resolved before committing.
- [x] Publish ticket-linked commits on a separate branch and create a PR declaring the parent spec.

## Evidence and limits

The local implementation covers the requested PR-to-report behavior. `sh scripts/tests/agent-review.sh` passed all 18 contract groups without network or paid calls; `actionlint` v1.7.11 and POSIX shell syntax checks passed. The suite is included in the existing `pnpm test` command. Existing root Git hooks remain applicable to publication.

Initial independent review covered all 12 changed files over base `f0a14fe4f15c113e43c8dea0e9f6d96bdcabab55`, manifest SHA-256 `017cfbd7c38e4a1d29e2f9b8ce03124dac72312e1031419d75a990ddffe99b5b`: Standards found one P2 (invalid calendar dates); Spec found three P2 findings (irrelevant-edit cancellation/repeated calls, dates, and absent request counts). Corrections add strict date round trips, a metadata-only concurrency-scope job, and request-attempt counters retained across outcomes. Regression fixtures cover each correction. On the second snapshot (`5fad98d113a5e3107c745c6efaacbd6b7f7ab2d51c27b709b9c908902b0f9fab`), Spec reported zero findings; Standards found a P2 old-event concurrency issue. Scoping now checks current PR metadata and isolates already-stale reruns; regression coverage preserves draft-transition cancellation. Final independent reassessment on October 11, 2026: **Standards: 0 unresolved findings; Spec: 0 findings.** Both assessed the 13-file manifest `857cdb50d10217a68c6f80fb96eb50ab997b85ff03c93687e9f0abd730805aa8` over the same base. Spec also verified the final credential-description correction in the adapter README (SHA-256 `dea66d6b7a925581e722ce334d4f859097e63bdc9b2e1440c27949c837cd8ab8`); all implementation/test/workflow hashes remained unchanged. This paragraph and the spec assessment record only the received review outcomes. The final 18-group suite, POSIX syntax checks, and actionlint v1.7.11 passed after the source corrections. `pnpm build` passed with the SDK build cache hit; `pnpm test` passed five hook groups and 18 agent-review groups, with no package-level test tasks declared.

Delivery: implementation commit `33cfeaf39f824a53a7e1722f3b3192a918ad5a4e` was published on `codex/github-agent-review` with `Ticket: CI-01`; [PR #4](https://github.com/jonatassales/exphere/pull/4) is open against `main`, authored by `jonatassales`, and its actual body declares `Spec: SPEC-GITHUB-AGENT-REVIEW`. Author and committer are the configured Jonatas Sales identity. The first normal push passed the build/test gate; conservative new-ref diagnostics also reported preexisting merge commits and historical specs, separately from this PR's scope.

While publication was in progress, main advanced to `96b4eb453cc5dc6901ef0039a48d3957dd94964e`. The branch incorporates it through a normal merge, preserving current SDK/CLI/design/web/website boundaries and resolving the README command-table conflict. The PR difference remains the same 13 CI-delivery files; no source adapter behavior changed. After reconciliation, `pnpm build` passed all three declared builds from cache, and `pnpm test` passed five hook groups, 18 review groups, and the existing CLI/design contract tasks. Independent reassessment of the reconciled 13-file scope against that main revision completed before the merge commit: **Standards: 0 findings; Spec: 0 findings.** Both reviewers verified manifest SHA-256 `2e56a580a6fd9a5dd96438d0408476adfdc95feb6bfe26acd1ebdf3993181a61`. Subsequent artifact edits only record these received outcomes and delivery states; implementation, workflow, tests, and the README resolution remain unchanged.

SDD v1 SDD-01 and SDD-02 are `compliant` for the published implementation commit and actual PR declaration, with semantic scope review recorded above. SDD-03 is `compliant` for the observed outgoing inspection and its disclosed historical warnings; it is not an assertion that all historical commits have ticket identities. FinOps and Twelve-Factor adaptations and pending operational evidence are recorded in the parent specification. Required configuration references do not authenticate a budget decision or inspect provider-side limits. Live provider behavior, GitHub event delivery, billable consumption, and production readiness are not established by local fixtures.
