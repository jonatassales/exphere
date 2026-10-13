# RUNTIME-ENDPOINTS-01: Reconcile controller-generated Service endpoints

**Spec:** [SPEC-MICRORUNTIME-LIFECYCLE v2](../specs/0033-SPEC-local-microruntime-lifecycle.spec.md#follow-up--disposable-dependency-execution)
**Status:** in-progress
**Origin:** Failure observed during the owner-authorized disposable local dependency pilot on October 13, 2026.

## Problem

Cleanup refuses the endpoint controller's legacy `Endpoints` object because it lacks an owner-reference chain. The Service is recorded and owned, and the endpoint has matching ownership labels and Pod references, but the inventory treats it as foreign. This blocks normal and interrupted runtime cleanup.

## Acceptance

- [ ] Recognize controller-generated Endpoints only through the recorded live Service identity and bounded ownership evidence.
- [ ] Preserve refusal for unrelated endpoints, mismatched identities/labels, and unverified address targets; never rely on names alone.
- [ ] Require derived resources to disappear after deleting the recorded workloads before removing the namespace.
- [ ] Record existing Go checks, independent Standards/Spec review, and the actual recovery observation separately.

## Scope and observations

Only lifecycle inventory classification is changed. No new supported manifest kind, storage API, billing behavior, or broad deletion mechanism is added. No new automated tests or suites are introduced.

The pilot was interrupted after a Neo4j startup configuration collision. Before cleanup, it was scaled to zero with a Deployment UID precondition to stop repeated crashes. Its namespace, resources, configuration, and evidence remain available for explicit recovery. The workload configuration will be corrected only after cleanup succeeds.

FIN-01/04/05: the pilot has explicit local ownership and resource limits; this fix restores bounded cleanup. FIN-02/03/07: no paid service action or financial result is introduced. 12F-09/12: disposal and administrative recovery are the affected contracts. Review does not establish production readiness.

## Verification

Pending. Compare against `a2b78dcf8ba60724654760018c589fd2aef008e7`; exclude the independently reviewed scaffold-publication fix from this ticket's source scope.
