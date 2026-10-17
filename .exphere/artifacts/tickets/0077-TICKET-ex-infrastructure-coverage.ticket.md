# EX-COVERAGE-03: Cover the Go CLI adapters

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-progress

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

Pending.
