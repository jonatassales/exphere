# EX-INVENTORY-01: Exclude list-only API views from runtime cleanup inventory

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-review
**Origin:** found while covering the kubectl adapter for EX-COVERAGE-03.

## Problem

`Client.NamespaceInventory` discovered namespaced resources with
`kubectl api-resources --verbs=list`. Aggregated views that can be listed but
not deleted were therefore inventoried as namespace contents. The metrics
API's `pods.metrics.k8s.io` is one: metrics-server reports one PodMetrics view
per pod, copying the pod's labels but carrying no UID or owner reference.
`Execution.AuthorizeCleanup` correctly refuses objects it cannot identify, so
`ex runtime down` would stop with `remaining or foreign PodMetrics/<pod>`
whenever metrics-server runs in the project cluster, although
`ex runtime inspect` explicitly supports that optional API.

`Client.ClusterInventory` already discovers with `--verbs=list,delete` for the
same reason: views that cannot be deleted hold no state and disappear with the
objects they describe.

## Acceptance

- [x] Namespace inventory discovery requests resources supporting both `list`
  and `delete`, matching the cluster inventory.
- [x] Events stay excluded, and a resource that cannot be listed still makes
  the inventory incomplete rather than shorter.
- [x] Cleanup authorization itself is unchanged: unidentified objects that are
  inventoried still block cleanup.

## Verification record

Recorded October 17, 2026 against `e3faf4f57fdd1e96a45b64d2af9e806cd2987ee6` (Go source SHA-256 `fb8b2e5d6ffa58757d92ca99c309b075df89838fae2f0df11d3fef71081fbbf3`). Each commit passed gofmt, `go vet ./...`, and `go test -count=1 ./...`; the full suite (902 results) passed and `go test -race ./...` was clean. The discovery-arguments assertion fails without the fix and passes with it. Events stay excluded and a resource that cannot be listed still yields an incomplete-inventory error (tested). Verified against recorded kubectl invocations only; behavior with a live metrics-server remains unobserved. Not run: `pnpm check` and the Husky hook contract tests (npm registry unreachable). Independent Standards and Spec reviews were stopped unfinished at the owner's request; none is claimed, and both remain required against the PR head. See the spec's verification record.
