# Shared workflow profiles — design hypothesis

Status: **draft for discussion**. Names, selection criteria, and specific obligations still require organizational validation. This document does not establish accepted policies or implement a selection mechanism.

Rigor profiles are separate from domain adaptations. Design, operations, SRE, FinOps, and Dev follow the SDD cycle defined in [the workflow documentation](../../.exphere/workflows/README.md); they are neither rigor profiles nor alternative methodologies.

## Shared structure, proportionate depth

The hypothesis is to offer three profiles of one workflow. They would preserve artifact formats, identification, versioning, ownership, states, and traceability. Investigation depth and required checks would vary according to risk, impact, and reversibility without multiplying independent workflows.

| Candidate profile | When to investigate its use | Candidate depth and checks |
| --- | --- | --- |
| Exploration | Investigate a hypothesis within a limited scope and an appropriate environment. | Problem, hypothesis, components involved, experiment boundaries, observation criteria, and evidence; checks appropriate to actual access, data, and impact. |
| Delivery | Evolve a known capability with understood impact and operation. | Sufficient discovery, a PRD or spec proportionate to the change, relevant decisions, verification of behavior and applicable quality contracts, review, and delivery policy. |
| Enhanced rigor | Changes whose risk or uncertainty justifies additional investigation and validation. | Dependency and failure-mode analysis, additional capacity, security, recovery, and operational validation, with more detailed responsibilities and evidence. |

These profiles do not classify languages, frameworks, or stacks as more or less suitable. A POC can carry high risk because it accesses sensitive data or real systems; a project's name does not automatically authorize the exploration profile.

## Fundamental controls

Under the proposed hypothesis, selecting a profile would not disable identification and context, ownership, applicable permissions and security, traceability of decisions and changes, evidence integrity, or authorization for external effects. The concrete application of these controls depends on context; their absence cannot be presented as compliance.

Observability, tests, and metrics would have explicit criteria proportionate to the case. When a mandatory criterion cannot be verified, the result remains unapproved. An exception would require its own authorized process, rationale, and scope; switching profiles is not an exception.

## Selection still to be defined

Organizational criteria are unknown. Data handled, reach of the change, operational impact, dependencies, reversibility, and service requirements are candidates for guiding selection, not an adopted classification.

The consumer would supply context and propose a profile. The final selection would need to respect the policy and authority defined by the organization; it would not be a free choice to reduce obligations. Changes in context or scope could require reclassification, recorded against the assessed version.

## Possible future setup experience

A setup process or SDK could ask:

- Is the target a single repository or a monorepo? Which units and boundaries are involved?
- Which components does the consumer want to include, and who owns them?
- Which use case, environment, data, permissions, and expected effects are involved?
- Which profile is proposed, and what information supports its selection?

The answers could prepare artifacts and identify gaps under the adopted rules. Component and stack choices would remain with their technical owners. This scaffold has no implemented SDK, selection schema, executor, or automated validation for workflow profiles.

## Risk of premature complexity

Creating three complete profiles before observing use can produce duplicated documentation, confusing options, and rules without evidence. The proposed pilot is to try **one profile, one journey, and one team**, using [the institutional structure](0003-DD-institutional-workflow.dd.md). The others remain hypotheses until needs arise that justify implementing them.

The pilot should evaluate whether distinguishing profiles reduces effort and preserves quality, using actual results and feedback. No benefit, numeric target, or adoption at scale has been demonstrated.

Navigation reference: [the workflow documentation](../../.exphere/workflows/README.md).
