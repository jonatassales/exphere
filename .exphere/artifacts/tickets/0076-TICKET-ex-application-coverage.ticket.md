# EX-COVERAGE-02: Cover the Go CLI use cases

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-review

## Delivery criteria

- Exercise every use case through its `Execute` method with in-memory fakes of
  the ports it declares; no adapter or native tool runs.
- Cluster creation, reuse, inspection, image loading, and deletion: recorded
  intent before effects, failures recorded with their cause, adoption refused,
  and deletion refused while a runtime or foreign object remains.
- Runtime up and down: obligations recorded before creation, every exit path
  settled with evidence, existing namespaces and objects never adopted, and no
  delete request issued when ownership or configuration cannot be proven.
- Inspection, logs, forwarding, and hooks: recorded targets only, sanitized
  evidence, and hook outcomes recorded before and after execution.
- Project, runtime, and agent initialization: identity reuse, guided input
  parsing, and validation before anything is written.

## Verification record

Recorded October 17, 2026 against `e3faf4f57fdd1e96a45b64d2af9e806cd2987ee6` (Go source SHA-256 `fb8b2e5d6ffa58757d92ca99c309b075df89838fae2f0df11d3fef71081fbbf3`). Each commit passed gofmt, `go vet ./...`, and `go test -count=1 ./...`; the full suite (902 results) passed and `go test -race ./...` was clean. Application package: 93.0% of statements; every use case runs against in-memory fakes. Not run: `pnpm check` and the Husky hook contract tests (npm registry unreachable). Independent Standards and Spec reviews were stopped unfinished at the owner's request; none is claimed, and both remain required against the PR head. See the spec's verification record.
