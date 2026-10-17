# EX-INVENTORY-01: Exclude list-only API views from runtime cleanup inventory

**Spec:** [SPEC-EX-REGRESSION-COVERAGE v1](../specs/0037-SPEC-ex-regression-coverage.spec.md)
**State:** in-progress
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

- [ ] Namespace inventory discovery requests resources supporting both `list`
  and `delete`, matching the cluster inventory.
- [ ] Events stay excluded, and a resource that cannot be listed still makes
  the inventory incomplete rather than shorter.
- [ ] Cleanup authorization itself is unchanged: unidentified objects that are
  inventoried still block cleanup.

## Verification record

Pending. The fix is verified against recorded kubectl invocations; behavior
with a live metrics-server remains unobserved until separately authorized.
