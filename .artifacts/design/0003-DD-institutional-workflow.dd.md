# Institutional workflow — proposal, not an adopted policy

## Intent expressed by the user

The workflow is the factory: it organizes how artifacts are produced, validated, audited, and tested. The user proposes a simple institutional approach centered on skills, designed for extension and gradual adoption by team and project.

Clarification dated October 10, 2026: SDD is this project's shared workflow architecture. Design, operations, SRE, FinOps, and Dev are execution adaptations within the same cycle, currently documented directly in `.exphere/workflows/`. Their checks, checkpoints, integrations, skills, and artifacts vary. That directory's README establishes SDD as their shared approach; there is no intermediate `sdd/` directory or menu of methodologies selected by preference. Rigor profiles are a separate discussion. Organizational adoption requires validation with the responsible people and against actual needs.

## Core and extensions

Use the open/closed principle as design guidance: preserve the SDD cycle and shared contracts while adding capabilities and integrations. Candidate core elements include phases and transitions, artifact identification, context and versions, responsibilities, states, and quality evidence. Candidate extensions include checks and their checkpoints, skills, artifact types, components, executors, integrations, and instrumentation specific to each domain.

Sharing a cycle, metadata, and traceability across adaptations does not require a prototype, a PR, and an operational diagnosis to share content or acceptance criteria. Contracts per artifact type would preserve those differences. Checkpoints can occur at different points in the shared cycle. Reuse skills and integrations when they are sufficient; a new adaptation must address a concrete need and does not create another phase sequence. FinOps can provide checks across domains and have a dedicated adaptation for cost analysis and optimization, always following SDD. The domain entries remain documentation drafts, without implemented executors or integrations.

The core can also evolve through versioning and migration. A different local implementation does not automatically mean noncompliance; the question is whether it meets the applicable profile's obligations. No extension catalog or certification mechanism has been implemented.

## Boundary still open for discussion

The user asked whether technical leads should be prohibited from maintaining their own workflows. This remains a hypothesis for discussion. Do not record a blanket prohibition as an accepted decision. Understand the organization's complexity, practices, incidents, and actual needs before defining which variations are permitted.

## Proposed incremental adoption

1. Observe the current flow with one team and establish a baseline.
2. Select a limited journey; agree on the contract and feedback mechanism.
3. Use the necessary skills and templates without requiring documentation that serves no purpose.
4. Measure effort, autonomy, failures, and cost; check whether the workflow reduced complexity.
5. Adjust, expand, or abandon parts based on evidence.

The [three candidate profiles](0004-DD-workflow-profiles.dd.md) are exploration, delivery, and enhanced rigor. They would share formats, versioning, and traceability, with depth and checks proportionate to risk. Their selection depends on organizational criteria yet to be defined; fundamental controls could not be disabled by switching profiles.

The proposed pilot starts with one profile and one journey. The others remain hypotheses, avoiding options and rules before a real need has been observed. A future setup process could gather repository or monorepo structure, components, owners, and context to propose a profile; no SDK or selection mechanism has been implemented for that purpose.

## What this scaffold allows us to evaluate

Clarity of responsibilities, continuity across documents, usefulness of skills, and remaining open decisions. It does not establish that the workflow improves productivity at scale; that requires use and measurement.

References: [CNCF Platforms](https://tag-app-delivery.cncf.io/whitepapers/platforms/) and [Pocock's skills](https://github.com/mattpocock/skills).
