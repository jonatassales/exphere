# Local agent guidance

This directory contains repository-local guidance, engineering rules, frontend guardrails, templates, and `writing-for-agents`. Shared skills and numbered policies live in `.exphere/harness/`. The intended CLI bootstrap is recorded in the [project context](CONTEXT.md); project-directory generation and the broader harness distribution contract remain unimplemented.

| Entry | Responsibility |
| --- | --- |
| [CONTEXT.md](CONTEXT.md) | Context and boundaries of this consumer project |
| [rules/](rules/README.md) | Local engineering rules and policy-reading conditions |
| [guardrails/](guardrails/) | Retained frontend, Next.js, Tailwind, and Jotai guidance; the former shared guardrail index is unavailable |
| [writing-for-agents](skills/writing-for-agents/SKILL.md) | Local agent-facing writing guidance and skill mechanics |
| [Shared skills](../.exphere/harness/skills/) | Workflow and FinOps skills, with retained [provenance and limitations](../.exphere/artifacts/design/0008-DD-agent-skills.dd.md) |
| [Shared policies](rules/README.md#policies-by-context) | Numbered SDD, FinOps, and Twelve-Factor rules and guardrails under `.exphere/harness/` |
| [templates/](templates/) | Reusable artifact formats, not replacement policy or evidence contracts |
| [Workflows](../.exphere/workflow/README.md) | Common SDD architecture and four surviving domain documents: Dev, operations, SRE, and FinOps |

The harness also relies on typed artifacts in `.exphere/artifacts/`, the CLI in `packages/cli/cli/`, and consumer runtime configuration created on demand in `.exphere/runtimes/` (or legacy `.micro-runtime/`). `.agents/` is not the entire harness. The boundary between distributable content and consumer configuration still needs to be defined.

The skill lock, evidence README, shared guardrail index, CLI-context ADR, and Design workflow document remain removed. The earlier FinOps synthesis and local Pocock license file are also absent. Retained skill attribution does not establish current lock-based integrity or local license completeness. The [verification plan](templates/verification-plan.md), [review format](templates/review.md), and [evidence ownership guidance](rules/0090-test-ownership.rule.md#evidence-ownership) are applicable surviving material, not a replacement for the removed contracts. Existing generated output stays under the ignored `.audits/evidence/runs/` destination.

The [SDD rule](../.exphere/harness/rules/0001-sdd.rule.md) and [SDD guardrail](../.exphere/harness/guardrails/0002-sdd.gr.md) provide advisory commit/ticket and PR/spec traceability. Local checks and their limits are in the [developer commands](../README.md#developer-checks).

The root [AGENTS.md](../AGENTS.md) is the agent entry point. These documents do not execute phases automatically. Artifact naming and states follow the [local tracker](../.exphere/artifacts/design/0006-DD-artifact-tracker.dd.md).
