# EX-COVERAGE-01: Cover the Go CLI domain rules

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-review

## Delivery criteria

- Table-driven tests for `domain/project`, `domain/cluster`, and
  `domain/microruntime`, one test file per source file, black-box where the
  exported API reaches the behavior.
- Cluster deletion authorization covers unchanged and recreated bootstrap
  objects, controller chains, foreign or replaced objects and namespaces,
  vanished APIs, and records without versioned inventory proof.
- The manifest policy covers each stateless pilot rule with an otherwise valid
  object, and generated native objects satisfy that policy.
- Execution tests cover every ledger transition and its refusals, ownership
  confirmation, readiness, removal, and container observation.
- Cleanup authorization covers owned descendants, namespace defaults, the
  runtime quota, and each condition for controller-generated Endpoints.

## Verification record

Recorded October 17, 2026 against `e3faf4f57fdd1e96a45b64d2af9e806cd2987ee6` (Go source SHA-256 `fb8b2e5d6ffa58757d92ca99c309b075df89838fae2f0df11d3fef71081fbbf3`). Each commit passed gofmt, `go vet ./...`, and `go test -count=1 ./...`; the full suite (902 results) passed and `go test -race ./...` was clean. Domain packages: project 100%, cluster 100%, microruntime 99.8%. Not run: `pnpm check` and the Husky hook contract tests (npm registry unreachable). Independent Standards and Spec reviews were stopped unfinished at the owner's request; none is claimed, and both remain required against the PR head. See the spec's verification record.
