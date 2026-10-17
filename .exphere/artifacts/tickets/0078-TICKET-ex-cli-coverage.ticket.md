# EX-COVERAGE-04: Cover the Go CLI command contracts

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-progress

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

Pending.
