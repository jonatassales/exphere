# Control flow

## Description

Use guard clauses, early exits, and named predicates to keep JavaScript and TypeScript control flow readable.

## Applies when

Creating or changing JavaScript or TypeScript code, including JSX and TSX.

## Branches and early exits

Leave a function, loop, or branch as soon as the result is known. Use guards to reject invalid or irrelevant cases before the main operation.

After a branch ends with `return`, `throw`, `continue`, or `break`, let the following applicable work continue directly; do not put it inside an `else`.

When a condition combines several business or runtime rules, name the predicate so its intent can be read at the decision point.

New control flow stays within two conditional levels. Beyond that, use a guard, a named function, a `switch`, or an explicit state. Preserve readability: replacing branches with a harder-to-read boolean expression does not satisfy the rule.

## Provenance and adaptations

Imported from [the control flow source rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/30-control-flow.mdc) at revision `e518dace741d8b9b44dd0a9d851fa3f42506320a`.

The [adaptation register](../../.artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register) converts editor-specific metadata into readable applicability. The source control-flow requirements are retained; this file does not configure a linter or prove enforcement.
