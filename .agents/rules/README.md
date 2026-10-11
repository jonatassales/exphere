# Agent rules

- Respect the authorized scope and explicit user instructions; preserve unrelated files and changes.
- Load only skills relevant to the phase, reading `.agents/skills/<name>/SKILL.md` when no invocation tool is available. Preserve upstream invocation boundaries; documenting a phase does not authorize the next one.
- Recognize authorization already given for the same scope. Commits, pushes, remote publication, provisioning, and production actions require the corresponding authorization.
- Consult [context](../CONTEXT.md), the [local tracker](../../.artifacts/agents/0006-DD-artifact-tracker.dd.md), and [domain configuration](../../.artifacts/agents/0007-DD-domain-model.dd.md) when relevant; create only the artifacts needed for the request.
- Distinguish proposals, authorized decisions, implementation, and observed results. Do not invent approvals, measurements, identities, or organizational targets.
- Apply the [guardrails](../guardrails/README.md) when designing contracts. Selected developer checks have local hooks; broader policy enforcement is not implemented.

These rules guide agents; they do not replace permissions, policies, or executable checks. The root [AGENTS.md](../../AGENTS.md) remains the project entry point.

## Policies by context

| Load when working on | Agent rules | Criteria and evidence |
| --- | --- | --- |
| Resources, paid consumption, infrastructure, AI costs, or savings claims | [FinOps](finops.md) | [FIN-01 through FIN-08](../guardrails/finops.md) |
| Commits, ticket/spec scope, PR review, or delivery | [SDD](../../.exphere/rules/sdd.md) | [SDD-01 through SDD-03](../../.exphere/guardrails/sdd.md), advisory |
| Services, configuration, dependencies, build/release, data, logs, or lifecycle | [Twelve-Factor](twelve-factor.md) | [12F-01 through 12F-12](../guardrails/twelve-factor.md) |

FinOps and Twelve-Factor were adopted locally on October 10, 2026; advisory SDD was authorized on October 11, 2026. Use the states and application boundaries in the [guardrails index](../guardrails/README.md); third-party skills do not redefine these policies.

## Current user restrictions

YAGNI. Automation scripts must be `.sh` files invoked by manifests. The design token compiler has the narrow TypeScript-behind-shell exception recorded in root AGENTS. Authorized hook, CLI, design-token, and website verification boundaries are recorded in root AGENTS, including the build/test push gate. Unrelated tests still require authorization. These restrictions take precedence over skill suggestions to test or expand the scope.
