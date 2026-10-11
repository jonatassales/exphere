# Jotai

**Description:** Applications that choose Jotai keep shared state with its domain while retaining local interaction state in React.

**Applies when:** An application has selected Jotai and a change concerns its state or consuming UI. Jotai is not a platform-wide dependency requirement. General module, component, and type boundaries remain in [frontend](0100-frontend.rule.md).

## State lifetime and ownership

Keep ephemeral interaction state in local React state when it need not escape the component or local composition boundary. Use atoms for state that must be shared, independently consumed, coordinated, or observed outside that boundary.

Organize shared state by cohesive domain or feature ownership. Keep a concern's primitive state, derived state, and write behavior together instead of distributing unrelated domains across global technical buckets. Let actual domain boundaries determine the decomposition.

Keep state units fine-grained and independently consumable. Coordinated writes can stay with the values and concern they coordinate. This does not mandate global `atoms/` or `domain/` directories, alias names, or a universal one-atom-per-file scheme. Do not introduce synthetic state to demonstrate a dependency.

## Atom definitions and updates

Atom definitions should not declare unnecessary React client boundaries. Place required framework client boundaries at the consuming UI instead of adding `'use client'` to every atom module.

Use ordinary atoms for primitive values. Use Immer only when complex object or array state benefits from draft-style updates; complex state does not automatically require Immer.

## Inspectability

Keep useful development and debugging inspectability in mind for shared state. Choose a diagnostic mechanism that fits the application. Neither a central atom registry nor a diagnostic logger is required. Logging every transition is not a standard or an automatic compliance measure.

## Provenance and adaptations

Source at `e518dace741d8b9b44dd0a9d851fa3f42506320a`: [Jotai guardrail](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/jotai.md).

Adaptation: source-application examples and legacy logger identity are removed while preserving optional adoption, local state, domain ownership, and inspectability. No universal directory structure, registry, logger, or state demonstration is introduced. See [DEC-RULE-01](../../.artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register).
