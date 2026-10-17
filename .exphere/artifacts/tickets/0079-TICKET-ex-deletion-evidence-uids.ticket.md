# EX-DELETION-01: Refuse cluster deletion evidence without UIDs

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-review
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

- [x] An observed namespace without a UID blocks deletion, whether or not the
  baseline names it.
- [x] A baseline namespace recorded without a UID blocks deletion.
- [x] An observed object without a UID, or one whose only controller reference
  has no UID, blocks deletion even when the bootstrap recorded the same empty
  identity.
- [x] Deletion of a cluster whose evidence is complete is unchanged.

## Verification record

Recorded October 17, 2026 against `e3faf4f57fdd1e96a45b64d2af9e806cd2987ee6` (Go source SHA-256 `fb8b2e5d6ffa58757d92ca99c309b075df89838fae2f0df11d3fef71081fbbf3`). Each commit passed gofmt, `go vet ./...`, and `go test -count=1 ./...`; the full suite (902 results) passed and `go test -race ./...` was clean. The three new cases (foreign namespace without a UID, baseline namespace recorded without a UID, objects without UIDs vouching for each other) fail without the fix and pass with it; complete-evidence cases are unchanged. Not run: `pnpm check` and the Husky hook contract tests (npm registry unreachable). Independent Standards and Spec reviews were stopped unfinished at the owner's request; none is claimed, and both remain required against the PR head. See the spec's verification record.
