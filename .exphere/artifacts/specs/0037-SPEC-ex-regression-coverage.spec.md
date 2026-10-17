# Go CLI regression coverage

- ID: `SPEC-EX-REGRESSION-COVERAGE`
- Version: `1`
- State: `draft`
- Owner: project owner for scope; implementation and review agents for local delivery.
- Authorization: on October 17, 2026, the owner requested a review of this
  repository and then a pull request addressing its findings, on a separate
  branch and traced through a spec and tickets. The review identified missing
  regression coverage of the Go CLI as the largest gap. This revision authorizes
  new Go unit and component tests beside the packages they exercise,
  corrections for defects those tests expose, and the related package and agent
  documentation.

## Scope and baseline

The comparison baseline is Exphere `main` at
`1e1a1f94e44f842ddb5d34b8de7b9b3314848e14`, `packages/ex`. It contains one Go
test file, `src/cmd/ex/main_test.go`, whose command cases cover help, version,
and project initialization. Module statement coverage measured with
`go test -coverpkg=./... ./...` is 9.0%; every domain, application, and
infrastructure package reports no tests.

## Required behavior

1. Domain: cover project identity; cluster ownership, readiness, and deletion
   authorization; microruntime identifiers, paths, quantities, descriptors,
   blueprints, and workloads; the manifest policy and execution claims;
   generated native objects; execution ledger transitions; readiness and
   removal; container observation; and cleanup authorization, including
   controller-generated Endpoints.
2. Application: cover each use case through its declared ports with in-memory
   fakes. Assert recorded state, evidence, refusals, and the absence of
   destructive calls when ownership cannot be proven.
3. Infrastructure: cover file, storage, configuration, and scaffold adapters in
   disposable temporary directories; the process runner with local `sh`
   processes only; and the kubectl, kind, Terraform, toolchain, and hook
   adapters through recorded command fakes. No native infrastructure tool runs.
4. Presentation: cover command contracts, flags, exit codes, structured
   diagnostics, and guided runtime generation followed by validation with the
   real local file adapters.
5. A defect exposed by these tests is corrected in its own commit with a
   regression test and its own ticket under this spec.
6. Tests use only the standard library and the module's existing
   dependencies, compile with the module's Go 1.23 directive, run in parallel
   where independent, and avoid wall-clock waits. Temporary directories are
   canonicalized first, because the file adapters refuse symlinked ancestors,
   such as macOS's `/var` link.
7. Update the CLI README and the root agent instructions so they describe the
   new verification scope accurately.

## Verification and limits

Run formatting, `go vet` (including its standard-library version check against
the module directive), `go test -count=1 ./...`, the race detector, coverage
before and after, and the existing consumer-harness and hook contract checks.
Review Standards and Spec against the same identified snapshot, resolve
actionable findings, and refresh affected reviews after material changes.

No Docker, kind, Terraform, kubectl, Kubernetes, or agent application runs;
personal shell profile changes; dependency changes; new test runners; or CI
workflow changes are included. Tests and reviews do not establish live
cluster startup, readiness, cleanup, or production behavior, which remain
unverified until separately authorized observations exist.

FIN-02/03: no paid resource or AI consumption is created; the added Go tests
run inside the existing CI job and local hooks. FIN-05 and 12F-09 apply to
cleanup authorization, whose rules the tests constrain. 12F-02: dependency
declarations stay unchanged. 12F-12: command contracts are covered without
executing administrative operations against a cluster.

## Delivery

Tracked by:

- [EX-COVERAGE-01](../tickets/0075-TICKET-ex-domain-coverage.ticket.md): domain rules.
- [EX-COVERAGE-02](../tickets/0076-TICKET-ex-application-coverage.ticket.md): use cases.
- [EX-COVERAGE-03](../tickets/0077-TICKET-ex-infrastructure-coverage.ticket.md): adapters.
- [EX-COVERAGE-04](../tickets/0078-TICKET-ex-cli-coverage.ticket.md): command contracts.

Publish on a feature branch from `main` using normal pushes, one ticket trailer
per commit, and this spec ID in the PR body.
