# Exphere — product requirements

- ID: `PRD-0001`
- Version: `1`
- Status: `draft`
- Product owner: project owner; organizational stakeholders have not been assigned.
- Source: the project vision and the owner's documentation requirements, consolidated on October 10, 2026.
- Approval: creation of this document is authorized. Product scope, organizational adoption, targets, and implementation commitments remain unapproved.

## Problem and intended outcome

Engineering teams need to connect business goals, technical decisions, agent-assisted work, and verifiable evidence without giving up control of their stack and service composition. Exphere explores a shared way to organize that work while keeping decisions with the people accountable for their consequences.

The intended outcome is greater team autonomy, better decision traceability, and less operational effort while preserving quality. These are hypotheses, not measured improvements. No organizational baseline or pilot outcome has been established.

The platform receives business objectives, constraints, priorities, and investment criteria from leadership. Technical leads and teams contribute friction, evidence, dependencies, capacity, and domain-specific needs. Operations and platform teams contribute incidents, cost, reliability, permissions, and shared limits. Authorized people resolve conflicts and make commitments; an LLM can synthesize evidence and suggest options, but cannot make those commitments.

## Scope

Included in the product direction:

- Trace an observed problem through affected users, a hypothesis, intended outcomes, costs, dependencies, success criteria, a pilot, and review of the decision.
- Organize work around a shared Spec Driven Development (SDD) lifecycle, with domain-specific artifacts and verification.
- Let consumers choose their stack, components, composition, and service-specific targets.
- Define platform contracts for security, observability, resources, quality, and evidence with the people responsible for those policies.
- Explore microruntimes as a reusable capability for use cases, proofs of concept, and verification.
- Begin with one use case and one partner team; expand only when evidence and support capacity justify it.

Out of scope for the current delivery: an automated workflow engine, organization-wide adoption, production integrations, universal stack choices, automated certification, new infrastructure, and claims of measured productivity or cost savings.

Current implementation is limited to the SDK and its shell CLI. The workflow and institutional contracts remain documentary proposals. See the [design overview](../design/0001-DD-exphere.dd.md) for the observed boundaries.

## Requirements and acceptance

| Requirement | Behavior or outcome | Reviewable criterion | Expected evidence |
| --- | --- | --- | --- |
| REQ-PRD-001 | Preserve the origin of a request and the people responsible for decisions. | Artifacts distinguish leadership objectives, team needs, operational evidence, proposals, and authorized decisions. | Artifact review; no invented actors or approvals. |
| REQ-PRD-002 | Preserve consumer autonomy. | Stack, components, composition, and service targets belong to the consumer; platform contracts state their limits. | Design and specification review. |
| REQ-PRD-003 | Use a coherent lifecycle. | Capture, discovery, prioritization, specification, preparation, execution, verification, delivery, and learning remain traceable across domains. | Workflow and artifact inspection. |
| REQ-PRD-004 | Evaluate value before expansion. | A pilot identifies its baseline, affected users, outcomes, costs, comparison conditions, and decision owner. | Pilot plan, followed by observed evidence when execution is authorized. |
| REQ-PRD-005 | Separate intent from results. | Drafts, authorized decisions, implementations, and observed outcomes are labeled accurately. Missing evidence cannot imply approval. | Review records tied to the examined revision. |
| REQ-PRD-006 | Maintain a usable project record. | Project content uses en-US; artifacts follow the typed naming convention; active references resolve; content describes the present tree. | Static document and reference inspection. |

## Metrics and decisions

Candidate measures include time to a valid verification, completion without assistance, perceived effort, quality, rework, and cost. Owners, baselines, targets, and observation windows remain to be defined for a pilot. Code volume, token usage, and document counts are not standalone evidence of productivity.

Adding teams or integrations requires evidence of benefit and capacity to sustain them. The workflow proposal does not decide in advance which existing organizational process must be replaced. Microruntimes are a capability hypothesis, not an approved business priority merely because they are documented here.

- Scope approval: pending; identify the authorized owner and the exact accepted revision.
- Initial design: [DD-0001](../design/0001-DD-exphere.dd.md).
- Current documentation initiative: [SPEC-DOCS-WORKFLOWS](../specs/0001-SPEC-documentation-workflows.spec.md), still a draft.
- Artifact rules: [local tracker](../design/0006-DD-artifact-tracker.dd.md).
