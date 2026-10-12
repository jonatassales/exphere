# Jotai

Jotai is an application-level choice, not a LangDrift-wide dependency requirement.

Apply this document only when the application has chosen Jotai. General module, component and type boundaries remain in [frontend.md](frontend.md).

## State lifetime and ownership

Keep ephemeral interaction state in local React state when it does not need to escape the component or local composition boundary. Use atoms for state that must be shared, independently consumed, coordinated or observed outside that boundary.

Organize shared state by cohesive domain/feature ownership. Keep a concern's primitive state, derived state and write behavior together rather than distributing unrelated domains across global technical buckets. Let the actual domain boundaries determine the decomposition.

Keep state units fine-grained and independently consumable. Coordinated writes can remain with the values and concern they coordinate. This does not mandate the Dashboard's global `atoms/`/`domain/` layout, alias names, or a universal one-atom-per-file filename scheme.

## Atom definitions and updates

Atom definitions should not declare unnecessary React client boundaries. Put required framework client boundaries at the consuming UI boundary instead of marking every atom module with `'use client'`.

Use ordinary atoms for primitive values. Use Immer only when complex object/array state benefits from draft-style updates; complex state is not automatically required to use Immer.

## Inspectability

Keep useful development/debugging inspectability in mind for shared state. Choose a diagnostic mechanism that fits the application; neither a central atom registry nor the old StateLogger is required. Console logging every transition is not a standard and must not be restored as an automatic compliance measure.
