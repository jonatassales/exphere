# Agent rules

- Respect the authorized scope and explicit user instructions; preserve unrelated files and changes.
- Load only skills relevant to the phase, reading `.agents/skills/<name>/SKILL.md` when no invocation tool is available. Preserve upstream invocation boundaries; documenting a phase does not authorize the next one.
- Recognize authorization already given for the same scope. Commits, pushes, remote publication, provisioning, and production actions require the corresponding authorization.
- Consult [context](../CONTEXT.md), the [local tracker](../../.artifacts/agents/0006-DD-artifact-tracker.dd.md), and [domain configuration](../../.artifacts/agents/0007-DD-domain-model.dd.md) when relevant; create only the artifacts needed for the request.
- Distinguish proposals, authorized decisions, implementation, and observed results. Do not invent approvals, measurements, identities, or organizational targets.
- Apply the [guardrails](../guardrails/README.md) when designing contracts. Selected developer checks have local hooks; broader policy enforcement is not implemented.

These rules guide agents; they do not replace permissions, policies, or executable checks. The root [AGENTS.md](../../AGENTS.md) remains the project entry point.

## Engineering rules by change

Before changing implementation, load the general engineering rule and each rule whose applicability matches the change. Use the test-ownership rule when classifying verification or handling evidence, including changes with no new tests. Framework and state rules apply only to the selected technology; they do not choose a stack for other consumers.

| Load when working on | Rule |
| --- | --- |
| Any implementation or automation | [Engineering authority](0000-engineering-core.rule.md) |
| Frontend and shared UI styling | [Styling](0010-styling.rule.md) |
| JavaScript/TypeScript environment values or external runtime inputs | [Environment and external input](0020-environment-runtime.rule.md) |
| TypeScript or JavaScript control flow | [Control flow](0030-control-flow.rule.md) |
| Next.js App Router applications | [Next.js structure](0040-nextjs-structure.rule.md) |
| React async UI and Next.js rendering boundaries | [Async UI](0050-react-async-ui.rule.md) |
| Package scripts and workspace orchestration | [Package scripts](0060-package-scripts.rule.md) |
| Website indexing or social metadata | [SEO and metadata](0070-seo-metadata.rule.md) |
| Translation catalogs or localized application behavior | [Localization](0080-localization.rule.md) |
| Verification scope, test ownership, or evidence | [Test ownership](0090-test-ownership.rule.md) |
| React components, hooks, imports, shared UI, or application configuration | [Frontend](0100-frontend.rule.md) |
| An application that has selected Jotai | [Jotai](0110-jotai.rule.md) |

New rule names use `NNNN-<lowercase-english-name>.rule.md`. Existing policy filenames stay stable. The four-digit rule sequence is independent of artifact numbering and preserves the imported source order.

The [import specification](../../.artifacts/specs/0007-SPEC-agent-rule-import.spec.md#source-snapshot-and-destination-inventory) maps every source rule, the source README, and all four reference guardrails to this corpus. Source commit: `e518dace741d8b9b44dd0a9d851fa3f42506320a`. Each rule retains its pinned provenance; the specification records substantive adaptations. Required third-party names and attribution remain intact.

This Markdown index replaces editor-specific attachment metadata with explicit reading conditions. A linked rule does not prove that an agent loaded it, that Cursor attached it, or that a CLI/CI gate enforces it. Existing local policies below retain their authority.

## Policies by context

| Load when working on | Agent rules | Criteria and evidence |
| --- | --- | --- |
| Resources, paid consumption, infrastructure, AI costs, or savings claims | [FinOps](finops.md) | [FIN-01 through FIN-08](../guardrails/finops.md) |
| Commits, ticket/spec scope, PR review, or delivery | [SDD](../../.exphere/rules/sdd.md) | [SDD-01 through SDD-03](../../.exphere/guardrails/sdd.md), advisory |
| Services, configuration, dependencies, build/release, data, logs, or lifecycle | [Twelve-Factor](twelve-factor.md) | [12F-01 through 12F-12](../guardrails/twelve-factor.md) |

FinOps and Twelve-Factor were adopted locally on October 10, 2026; advisory SDD was authorized on October 11, 2026. Use the states and application boundaries in the [guardrails index](../guardrails/README.md); third-party skills do not redefine these policies.

## Current user restrictions

YAGNI. Automation scripts must be `.sh` files invoked by manifests. The hook initiative authorizes scoped fixture tests and the build/test push gate as recorded in root AGENTS. Unrelated tests still require authorization. These restrictions take precedence over skill suggestions to test or expand the scope.
