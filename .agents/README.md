# Reusable harness — proposal

This directory contains the generic, reusable part of the harness. The intended CLI bootstrap is recorded in the [project context](CONTEXT.md). Project-directory generation is not implemented, and the broader distribution contract for this harness remains undefined.

| Entry | Responsibility |
| --- | --- |
| [CONTEXT.md](CONTEXT.md) | Context and boundaries of this consumer project |
| [rules/](rules/README.md) | Agent behavior, FinOps/Twelve-Factor application, and skill use |
| [guardrails/](guardrails/README.md) | Adopted local FinOps/Twelve-Factor policies and evolving governance contracts |
| [skills/](skills/) | Pocock skills and four FinOps skills, with sources and hashes in the [lock](skills.lock.json) |
| [templates/](templates/) | Reusable artifact formats |
| [Workflows](../.exphere/workflows/README.md) | Common SDD architecture and five domain workflows, maintained outside this directory |

The harness also includes workflow documents in `.exphere/workflows/` and relies on context and contracts in `.artifacts/`, evidence in `.audits/`, the CLI in `packages/cli/cli/`, and consumer configuration in `.micro-runtime/`, created on demand. `.agents/` is not the entire harness. The boundary between distributable content and consumer configuration still needs to be defined.

The previous FinOps synthesis and local Pocock license file are absent. Consult the [skill provenance and limitations](../.artifacts/agents/0008-DD-agent-skills.dd.md); the lock records provenance but does not prove that deleted files remain available. The current FinOps policies are in rules and guardrails. The [SDD rule](../.exphere/rules/sdd.md) and [SDD guardrail](../.exphere/guardrails/sdd.md) live under `.exphere/` and provide advisory commit/ticket and PR/spec traceability. Local checks and their limits are in the [developer commands](../README.md#developer-checks).

The root [AGENTS.md](../AGENTS.md) is the entry point for agents. These documents do not execute any phase automatically. Artifact naming and states follow the [local tracker](../.artifacts/agents/0006-DD-artifact-tracker.dd.md).
