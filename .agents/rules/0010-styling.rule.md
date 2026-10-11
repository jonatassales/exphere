# Styling

**Description:** Tailwind utilities, semantic tokens, and owned UI source define frontend styling.

**Applies when:** Changing application or shared React UI styling where Tailwind is the selected styling system. This rule does not select a stack for every Exphere consumer.

## Application styling

Use Tailwind utilities for component, feature, layout, interaction, and responsive styling. Prefer semantic project tokens over hard-coded values. Use existing shared UI primitives and owned shadcn/ui source when they are available; their mention does not authorize installing dependencies or creating a component library.

Authored vanilla CSS is prohibited. Do not introduce component or page classes, element or descendant selectors, hover or focus rules, media queries, or layout rules as a parallel styling system. An awkward Tailwind expression is not a reason to move application styling into CSS. Repeated multi-property UI belongs in a React component.

Owned shadcn components are source: change their utility classes directly instead of wrapping them in a CSS abstraction. Follow [shared UI ownership](0100-frontend.rule.md#shared-ui-ownership).

## Framework bootstrap and token integration

Keep framework CSS limited to required Tailwind imports for the installed version, imports of generated design-token CSS, required framework global setup, and the minimal token bridge needed to expose an accepted design-token contract through Tailwind. Bootstrap files such as `globals.css` contain no authored application selectors. Do not add CSS files for component styling.

Where an application needs shared App Router styling infrastructure, its Tailwind area owns directives, theme tokens, custom variants, and approved custom utilities. Use `@utility` only for a repeated, single-purpose capability Tailwind does not already provide. Do not use `@layer components` as an application styling strategy. These integration mechanisms do not authorize speculative files or acceptance of provisional design tokens.

## Class composition and theme roles

Use `cn` built with `clsx` and `tailwind-merge` when conditional classes or defaults and consumer overrides need conflict-aware composition. A static class string needs no wrapper solely for consistency. The helper's directory and filename suffix follow its actual owner.

Express shared color and font roles through semantic Tailwind utilities backed by theme tokens. Components consume those roles instead of repeating unrelated palette literals. This rule does not fix palettes, token names, CSS decomposition, or prohibit all arbitrary-value utilities.

## Existing styling

Treat existing authored CSS as debt. When touching a component, move its affected styling to Tailwind if the change is local and safe. Otherwise preserve the existing rule, record it for remediation, and do not expand it.

## Provenance and adaptations

Sources at `e518dace741d8b9b44dd0a9d851fa3f42506320a`: [styling rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/10-styling.mdc), [Tailwind guardrail](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/tailwind.md), and [Next.js styling guidance](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/nextjs.md).

Adaptation: source globs become technology-based applicability; shared primitives and design-token packages are conditional, not implemented facts. Necessary bootstrap, generated-token imports, and the web draft's minimal token bridge are the bounded CSS exceptions. See [DEC-RULE-01](../../.artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register).
