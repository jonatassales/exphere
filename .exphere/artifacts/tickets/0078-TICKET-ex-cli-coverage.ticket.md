# EX-COVERAGE-04: Cover the Go CLI command contracts

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-review

## Delivery criteria

- Every command maps its arguments and flags to the expected request, renders
  indented or compact JSON, and classifies invalid usage with exit code 2.
- Operational failures exit 1, interruption exits 130, structured diagnostics
  follow `--json`, and `--timeout` bounds only finite operations.
- Guided runtime initialization reads its answers from standard input, writes
  questions to diagnostics, and its generated configuration passes
  `ex runtime validate` with the real local file adapters.
- Update the CLI README and root agent instructions to describe the verified
  scope and its remaining limits.

## Verification record

Recorded October 17, 2026 against `e3faf4f57fdd1e96a45b64d2af9e806cd2987ee6` (Go source SHA-256 `fb8b2e5d6ffa58757d92ca99c309b075df89838fae2f0df11d3fef71081fbbf3`). Each commit passed gofmt, `go vet ./...`, and `go test -count=1 ./...`; the full suite (902 results) passed and `go test -race ./...` was clean. Presentation: cli 98.7%, catalog 93.0%, support 93.3%, cmd/ex 42.9% (only `main` itself is untested). Module coverage rose from 9.0% to 93.3%. README and AGENTS.md updated. Not run: `pnpm check` and the Husky hook contract tests (npm registry unreachable). Independent Standards and Spec reviews were stopped unfinished at the owner's request; none is claimed, and both remain required against the PR head. See the spec's verification record.
