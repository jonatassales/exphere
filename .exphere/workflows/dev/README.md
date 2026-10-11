# Dev — software delivery within SDD

Dev is the software specialization of the [common SDD workflow](../README.md) and its [declarative definition](../definition.json). It documents how to use the installed Pocock skills; it is not an executor, CI gate, approval service, or proof of organizational adoption.

## Entry points

Start with the phase the user has authorized. Reuse the existing conversation, artifacts, and valid authorization. A direct request for a spec does not require a new interview; an implementation request can cover an existing spec and its tickets. Resolve only gaps that materially prevent the requested work.

The [cycle and authorization contract](CYCLE.md) owns the stage mapping, ticket-state rules, and handoffs. Read it before performing a Dev phase. Each phase below states its required inputs, output, and completion condition.

| Document | Responsibility |
| --- | --- |
| [Planning](00-planning.md) | Clarify the problem when needed, specify scope, and prepare traceable tickets. |
| [Execution](01-execution.md) | Implement the authorized scope while preserving user changes and recording verification limits. |
| [Review](02-review.md) | Assess standards and spec alignment against the same artifact snapshot. |
| [Audit](03-audit.md) | Reconcile requirements, changes, reviews, evidence, and remaining delivery conditions. |
| [Refinement](04-refinement.md) | Learn from observed outcomes and propose bounded changes for a separately authorized cycle. |

## Project contracts

- [AGENTS.md](../../../AGENTS.md) and [working rules](../../../.agents/rules/README.md): scope, authorization, language, and scoped hook-test authorization and restrictions on unrelated tests.
- [Context](../../../.agents/CONTEXT.md) and [domain configuration](../../../.artifacts/agents/0007-DD-domain-model.dd.md): consumer boundaries and available vocabulary.
- [Artifact tracker](../../../.artifacts/agents/0006-DD-artifact-tracker.dd.md): typed filenames, numbering, directories, ticket states, and decision records.
- [Guardrails](../../../.agents/guardrails/README.md): applicable local policies and evidence criteria.
- [Evidence contract](../../../.audits/evidence/README.md): what an authorized execution record must contain.

All project content uses en-US. User conversation may use another language. Preserve microruntime terminology, public third-party attribution, and the distinction between proposals and observed results.

## Installed skills

These links locate the relevant instructions; they do not invoke skills or authorize actions. Read the applicable `SKILL.md` when no Skill tool is available.

| Need | Skill |
| --- | --- |
| Primary-source investigation | [research](../../../.agents/skills/research/SKILL.md) |
| Explicit discovery discussion | [grill-with-docs](../../../.agents/skills/grill-with-docs/SKILL.md), using [grilling](../../../.agents/skills/grilling/SKILL.md) and [domain-modeling](../../../.agents/skills/domain-modeling/SKILL.md) |
| Specification | [to-spec](../../../.agents/skills/to-spec/SKILL.md) |
| Ticket decomposition | [to-tickets](../../../.agents/skills/to-tickets/SKILL.md) |
| Authorized implementation | [implement](../../../.agents/skills/implement/SKILL.md) |
| Module and interface design | [codebase-design](../../../.agents/skills/codebase-design/SKILL.md) |
| Technical review | [code-review](../../../.agents/skills/code-review/SKILL.md) |
| Explicit retrospective | [retro](../../../.agents/skills/retro/SKILL.md) |
| Agent-facing documents | [writing-for-agents](../../../.agents/skills/writing-for-agents/SKILL.md) |
| Test-first development at an authorized seam, including the hook-contract suite | [tdd](../../../.agents/skills/tdd/SKILL.md) |

Skill availability does not authorize a later phase. Current project restrictions override skill defaults, including automatic tests or commits. The installed versions and their limitations remain in the [skill configuration](../../../.artifacts/agents/0008-DD-agent-skills.dd.md).

## Local developer checks

The [command contract](../../../README.md#developer-checks) configures Husky in postinstall while preserving Exphere setup. Pre-commit blocks staged lint failures and reports an informational harness score; commit-msg blocks invalid Conventional Commits and warns about ticket links; pre-push reports SDD findings before blocking build/test checks. Apply the [SDD rule](../../rules/sdd.md) and [guardrail](../../guardrails/sdd.md). Review checks actual ticket/spec scope; audit records unavailable evidence and bypass limitations.
