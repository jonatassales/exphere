# EX-COVERAGE-02: Cover the Go CLI use cases

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-progress

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

Pending.
