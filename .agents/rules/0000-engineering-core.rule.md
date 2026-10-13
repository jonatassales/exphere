# Engineering core

## Description

Engineering authority, implementation boundaries, and native tool ownership for Exphere.

## Applies when

Always. Before changing implementation, load the rules that match the affected responsibility and technology through the [rule index](README.md).

## Authority and implementation

Follow the latest explicit owner instructions, [root project instructions](../../AGENTS.md), and adopted local policies. Apply accepted specifications and decisions to their approved scope. These imported rules do not supersede FinOps, Twelve-Factor, SDD, applicable accepted contracts, or execution permissions. A draft does not override an approved contract.

Use current framework and runtime constraints and inspect the current tree to understand the implementation. Existing code does not legalize a prohibited pattern; a passing check does not make an invalid implementation acceptable. Rules and accepted contracts describe the intended implementation. Guardrails, audits, tests, and harnesses provide criteria and evidence; their outputs do not independently define the architecture or establish approval. Report conflicts against the applicable authority rather than silently weakening it.

Implement the approved target. A tree undergoing a refactor may contain transitional violations. New work follows the applicable contract; record old violations for remediation instead of copying them.

Prefer the direct dependency, framework API, [operation-boundary environment access](0020-environment-runtime.rule.md), [guard clauses](0030-control-flow.rule.md), and framework file conventions. Add a wrapper, helper, compatibility layer, generated file, fallback, or unusual placement only when the implementation needs that boundary. Consumer stack and composition choices remain with the consumer. Use microruntimes terminology without assuming that proposed runtime capabilities exist.

## Automation scripts

Use native tool entrypoints under the [package scripts rule](0060-package-scripts.rule.md). The owner reserves helper scripts for `packages/ex/`; allowed CLI helpers use `.sh`. Existing Husky lifecycle hooks and substantive native test files retain their framework owners. Do not relocate obsolete wrapper automation merely to disguise a deleted `scripts/` directory.

Application code, framework configuration and the existing design-token compiler retain their appropriate language and file conventions. The Go-only CLI scaffold does not dispatch to a shell runtime. These October 13, 2026 owner instructions supersede the earlier mandatory shell wrapper boundary.

## Provenance and adaptations

Imported from [the engineering core source rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/00-engineering-core.mdc) at revision `e518dace741d8b9b44dd0a9d851fa3f42506320a`.

The [adaptation register](../../.exphere/artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register) preserves Exphere's owner instructions, adopted policies, and accepted contracts instead of elevating imported rules above them. Editor attachment metadata becomes this document's description and applicability; reading a file is distinct from automatic attachment or enforcement.
