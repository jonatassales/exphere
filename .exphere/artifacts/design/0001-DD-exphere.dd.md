# Exphere — design overview

- ID: `DD-0001`
- Version: `1`
- Status: `draft`
- Product context: [PRD-0001](../prd/0001-PRD-exphere.prd.md).
- Scope: document existing boundaries and the proposed design; no new runtime or workflow implementation is authorized by this document.

## Responsibilities

The consumer chooses the stack, components, composition, configuration, and domain criteria. The platform defines contracts for security, observability, resources, quality, and evidence. Authorized people decide priorities, acceptable risk, and commitments. Agents investigate, synthesize, propose, and perform bounded work within the authorization they receive.

Microruntimes are the proposed unit for composing and executing consumer-owned use cases. The guiding principle is to provide a platform while leaving consumer decisions with the people who use it. Platform policies and consumer composition remain separate responsibilities.

## Current structure

| Surface | Present responsibility | Limitation |
| --- | --- | --- |
| `packages/sdk/` | Private, versioned TypeScript SDK | API remains empty. |
| `packages/cli/` | Go-only scaffold with help/version and explicit unsupported init; retained schemas are source references | Former shell runtime/adapters are retired; infrastructure execution is not demonstrated. |
| `packages/design/` | Neutral tokens and generated CSS/JSON | Public intent; no registry release. |
| `packages/web/` | Source placeholders and SmoothUI development tooling | No usable runtime exports yet. |
| `apps/website/` | Minimal Next.js consumer of the design package | Build evidence does not establish browser or production behavior. |
| `.agents/` | Repository context, working rules, frontend guardrails, writing guidance, and templates | Instructions guide behavior; they do not authenticate approvals or enforce transitions. |
| `.exphere/harness/` | Shared SDD, FinOps, and Twelve-Factor rules and guardrails, plus workflow skills | Guidance and skills have no implemented policy or workflow executor. |
| `.exphere/workflow/` | Common SDD model and four documented domain adaptations: Dev, FinOps, Operations, and SRE | Documentary guidance without an executor or organizational adoption evidence; the Design adaptation document is absent. |
| `.exphere/artifacts/` | Typed PRDs, specs, tickets, research, and design documents, including agent configuration designs | Local records do not provide access control or an execution engine. |
| `.exphere/agents/` | Empty placeholder | No agent runtime or integration is implemented here. |
| `.micro-runtime/<id>/` | Consumer configuration created on demand | It is not a predefined stack, application workspace, or deployed environment. |

The current tree does not contain the previously described API or protobuf workspace. Native workspace tools, Husky hooks and package-owned checks provide builds, local checks and authorized contract tests. Removed API and protobuf components are not restored.

## Workflow design

SDD is the shared lifecycle: capture, discovery, prioritization, specification, preparation, execution, verification and review, authorized delivery, observation, and learning. Design, operations, SRE, FinOps, and Dev specialize checkpoints, skills, artifacts, and evidence while preserving that lifecycle.

Workflows are documented in `.exphere/workflow/`, with a common index and definition and Dev, FinOps, Operations, and SRE adaptations. The [workflow entry](../../workflow/README.md) is canonical. Design remains a proposed specialization without a current adaptation document. The [documentation spec](../specs/0001-SPEC-documentation-workflows.spec.md) records the earlier implementation and its verification limits.

Dev documents planning, execution, review, audit, and refinement using the installed Pocock skills. It preserves direct user authorization, local tracker states, shared SDD transitions, and the verification scope recorded in root AGENTS. It does not introduce an engine or an alternate source of authority.

## Artifact contract

All project content uses en-US. The [artifact tracker](0006-DD-artifact-tracker.dd.md) owns filename patterns, directories, numbering, and states. Stable requirement and ticket IDs survive relocation. Design documents may carry proposed architectural decisions; research retains its original observation date and uncertainty.

References must point to existing project material or clearly identified public technical sources. A removed file must not be silently recreated to satisfy a stale link. Third-party attribution remains intact; absent local license material must be disclosed accurately.

## Detailed design and open decisions

- [Microruntime requirements](0002-DD-microruntimes.dd.md).
- [Institutional workflow proposal](0003-DD-institutional-workflow.dd.md).
- [Workflow profiles](0004-DD-workflow-profiles.dd.md).
- [Proposed microruntime architecture](0005-DD-microruntime-architecture.dd.md).

The pilot, organization-specific targets, enforcement mechanisms, external distribution, and production integration remain open. The first evaluation should establish whether the documented workflow reduces effort for one use case without weakening quality or accountability.
