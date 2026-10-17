# EX-COVERAGE-03: Cover the Go CLI adapters

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-review

## Delivery criteria

- Files and storage: symlink refusal, bounded reads, private atomic writes,
  cross-process locks, project discovery, and record round trips, including
  the original and standalone record formats and refused legacy obligations.
- Configuration and scaffolding: strict descriptor decoding, snapshots and
  their compatible fingerprints, the Terraform root policy, generated runtime
  configuration that validates, and exclusive scaffold publication.
- Process runner: exit codes, bounded capture, streaming, cancellation of the
  whole process group, and cancellable input, using local `sh` processes only.
- kubectl, kind, Terraform, toolchain, and hook adapters: exact native
  arguments, explicit targets, neutralized ambient configuration, plan
  validation, and error reporting, through recorded command fakes.

## Verification record

Recorded October 17, 2026 against `e3faf4f57fdd1e96a45b64d2af9e806cd2987ee6` (Go source SHA-256 `fb8b2e5d6ffa58757d92ca99c309b075df89838fae2f0df11d3fef71081fbbf3`). Each commit passed gofmt, `go vet ./...`, and `go test -count=1 ./...`; the full suite (902 results) passed and `go test -race ./...` was clean. Adapters: files 85.0%, storage 92.0%, configuration 89.5%, scaffold 79.4%, process 95.0%, kubectl 94.9%, kind 95.0%, terraform 95.9%, toolchain 100%, hooks 100%. 20 production safety checks were removed one at a time and a test failed for each; the process-group cancellation test fails when only the direct child is killed. Not run: `pnpm check` and the Husky hook contract tests (npm registry unreachable). Independent Standards and Spec reviews were stopped unfinished at the owner's request; none is claimed, and both remain required against the PR head. See the spec's verification record.
