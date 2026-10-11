# Audit, delivery, and observation

**Input:** implemented artifacts, the applicable spec and ticket criteria, the reviewed snapshot, and available verification evidence. Follow the [cycle contract](CYCLE.md).

## Reconcile evidence

1. Relate each applicable criterion to an actual change and observation. Use the [verification](../../../.agents/templates/verification-plan.md) and [review](../../../.agents/templates/review.md) formats within the existing typed artifact instead of creating a parallel report tree.
2. Confirm that the review covers the delivered snapshot. Record changes since review and reassess their impact; document presence alone is not evidence of behavior.
3. Apply relevant [guardrails](../../../.agents/guardrails/README.md) and distinguish their policy assessments from verification results: `passed`, `failed`, or `inconclusive`. Justify non-applicable criteria. An unauthorized or unavailable mandatory check is not a pass.
4. Record what was inspected, the examined revision or hashes, actual outcomes, unresolved limitations, and the responsible role. Keep authorization records separate from observations. Do not invent human acceptance, metrics, or production outcomes.
5. Use the [evidence contract](../../../.audits/evidence/README.md) for authorized execution records. Its `runs/<run-id>/` directory is the specific location excluded by the root ignore configuration; do not claim that all audit files are ignored or that an ignore rule proves Git history.

For documentation-only work, link inspection, document reading, and JSON syntax checks can support documentary criteria. They do not demonstrate application, skill, or workflow execution. Do not create or run tests, smoke checks, HTTP probes, or examples as part of this audit while the prohibition remains active.

## Delivery handoff

Local completion requires the ticket's actual deliverable, satisfied applicable criteria, and a recorded review. A production deployment is not a prerequisite for a documentation ticket that excludes deployment.

Before a commit, push, pull request, remote issue, deployment, provisioned resource, or paid action, verify authorization for that effect and destination. Reuse an existing authorization that covers them. If it is absent, report the ready local result and the pending action; do not perform it because the review passed.

Mark a ticket `done` only when its own acceptance criteria are met. Keep unresolved delivery work pending when delivery is part of its scope. This record does not grant an organization-wide approval.

## Observation

Record observations appropriate to the delivered change. A document may be inspected for navigation and consistency; a service outcome requires operational evidence from its actual environment. State when observation is unavailable rather than fabricating a baseline or improvement.

**Output:** an evidence-backed disposition of the scoped work, delivery conditions, and observed or unknown outcomes.

**Completion:** each applicable criterion has an honest result and any dependent pending action is visible. Enter [refinement](04-refinement.md) only when that activity is authorized.

**Return condition:** a failed criterion returns to execution; changed criteria return to planning. Missing required evidence keeps the dependent action blocked or inconclusive, with a resume condition.
