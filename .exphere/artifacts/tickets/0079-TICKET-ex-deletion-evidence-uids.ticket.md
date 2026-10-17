# EX-DELETION-01: Refuse cluster deletion evidence without UIDs

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-progress
**Origin:** found while covering `domain/cluster` for EX-COVERAGE-01.

## Problem

`Record.AuthorizeDeletion` compares observed namespaces with the baseline by
UID. A namespace absent from the baseline and observed with an empty UID
matched the map's zero value, so a foreign namespace was authorized for
deletion. Likewise, an empty UID could become "known" and then vouch for other
objects or controller references without UIDs.

The kubectl adapter already refuses namespaces and objects without UIDs, so no
current command reaches this path. The domain decision guards a destructive
operation and documents that foreign namespaces always block it, so it must
not depend on adapter validation for that guarantee.

## Acceptance

- [ ] An observed namespace without a UID blocks deletion, whether or not the
  baseline names it.
- [ ] A baseline namespace recorded without a UID blocks deletion.
- [ ] An observed object without a UID, or one whose only controller reference
  has no UID, blocks deletion even when the bootstrap recorded the same empty
  identity.
- [ ] Deletion of a cluster whose evidence is complete is unchanged.

## Verification record

Pending.
