# Frontend

**Description:** React modules preserve meaningful ownership, explicit public boundaries, and direct UI composition.

**Applies when:** Changing React surfaces and their frontend modules. Load [Next.js](0040-nextjs-structure.rule.md), [styling](0010-styling.rule.md), or [Jotai](0110-jotai.rule.md) when the application's selected technologies require them.

## Ownership and public boundaries

Use `./` only within the same local ownership boundary, including obvious siblings and descendants. Use a meaningful absolute import or public package export when leaving that boundary. Parent-directory traversal in module imports is prohibited, including traversal embedded in a longer path.

Alias names and abstractions are developer-owned: make navigation and ownership meaningful without a universal vocabulary. Meaningful absolute subpaths are allowed. Public barrels are intentional and optional; when providing one, export its intended symbols explicitly by name instead of wildcard exports.

Keep reusable business and domain types with their domain owner and consume those contracts with `import type`. Component props and types derived solely from props and used only in that file remain local. Package-owned types retain their package ownership; a view barrel does not become their domain owner. No universal domain directory, filename suffix, or enum preference follows.

## Components, hooks and composition

Define one React component per component file and one custom hook per `.hook.ts` file. Colocate related files by concern. These are component and hook boundaries, not a one-function-per-file rule or a numerical limit on comments.

For a component with props, declare a named props interface, receive a `props` argument, and destructure it at the beginning of the function body. Keep the props declaration with the component unless it has an actual shared owner. Anonymous object annotations, props type aliases, and destructured parameter lists do not express this contract.

Compose independently meaningful UI responsibilities at their owning page, layout, or feature. Avoid a central component that selects whole pages through a mode or section dispatcher. Ordinary configurable components, render props, and dependency injection remain valid.

## Shared UI ownership

Generic primitives belong to the selected shared web UI owner once that boundary exists and exposes real components. Use its available SmoothUI or shadcn-based foundations instead of rebuilding application-local base primitives. Application-specific business composition stays with the application.

When choosing a shared icon family, keep its dependency and public access with that shared UI owner so consuming React applications use one icon identity. Do not duplicate the shared icon dependency in every application.

The related web and design drafts describe future package ownership. This rule does not implement their packages, exports, primitives, icons, or tokens, approve their open decisions, or authorize speculative dependencies.

## Readable control flow

Use descriptive bindings rather than one-letter variables. Follow [control flow](0030-control-flow.rule.md) for guards and early exits.

When awaiting a response that will be consumed, receive it in a named binding. If it can be missing or invalid, handle that condition explicitly before using dependent values. Do not combine optional chaining into the same statement as `await`. Continue, use the specified fallback, or throw according to the application contract; optional chaining elsewhere remains valid, and absence does not always require throwing.

Separate await statements from adjacent statements with a blank line. Place a blank line before a return when another statement precedes it in the block. Separate initial props destructuring from the following statement. Block boundaries need no artificial empty lines. Do not treat a formatting-tool pass as evidence that this statement spacing was checked.

## Application configuration and documentation

Keep application TypeScript aliases exclusively in `tsconfig.paths.json`, extended by the application configuration. Do not use `baseUrl` or duplicate `paths` in the extending configuration.

An application-local Turbo configuration contains meaningful application overrides rather than copies of root behavior. Omit versions from private application manifests unless publication becomes an explicit requirement. Publishable package versioning and existing SDK/CLI contracts remain separate.

Automation follows [package scripts](0060-package-scripts.rule.md): manifests invoke `.sh` automation files under Exphere's local policy. Keep necessary container-specific orchestration at the container boundary.

An application README explains the surface's product role and behavior. Stack details support that explanation.

## Provenance and adaptations

Source at `e518dace741d8b9b44dd0a9d851fa3f42506320a`: [frontend guardrail](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/frontend.md).

Adaptation: fixed source package paths and available shared UI become conditional ownership. Exphere's `.sh` automation policy replaces the conflicting direct-manifest-command guidance. Framework choices remain application-specific, and no draft web foundation is implemented or accepted by this rule. See [DEC-RULE-01](../../.artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register).
