# EX-COVERAGE-01: Cover the Go CLI domain rules

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-progress

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

Pending.
