# Change and evidence review

Use this format within the relevant typed artifact, following the [artifact tracker](../../.artifacts/agents/0006-DD-artifact-tracker.dd.md).

- Section ID: `REV-<id>`
- State: `draft`
- Reviewers and roles: `<authorized owners>`
- Change, PRD, spec, and versions reviewed: `<references>`
- Verification executions: `<IDs; record absence>`

## Traceability

| Requirement | Change | Test/metric | Evidence | State |
| --- | --- | --- | --- | --- |
| REQ-001 | `<reference>` | `<TEST/MET IDs>` | `<artifact>` | `<absent/compliant/non-compliant>` |

## Assessment

- Alignment with approved intent and scope: `<findings and limitations>`
- Security, permissions, quality, and observability: `<evidence>`
- Achieved load, resources, and applicable targets: `<evidence>`
- Recovery, cleanup, and operational impact: `<evidence>`
- Differences and remaining open questions: `<fill in>`

## Affected guardrails

Record only criteria applicable to the change, using the [policy states](../guardrails/README.md).

| Policy/version and FIN/12F ID | Target/revision | Method and evidence | State | Owner and open issue/exception |
| --- | --- | --- | --- | --- |
| `<fill in>` | `<fill in>` | `<reference or absence>` | `<compliant / non-compliant / not-verified / not-applicable / authorized-exception>` | `<person/team; decision section ID when relevant>` |

## Review decision

- Automated assessment: `<advisory, with source and version>`
- Human decision: `pending`
- Authorized owner, date, version, and record: `not recorded`
- Exceptions: `<valid decision section ID if the policy permits; none implied>`
- Delivery approval: `<specific authorization; not inferred from the assessment>`

Missing mandatory evidence prevents approval. Changes after review require reassessment of the affected scope.
