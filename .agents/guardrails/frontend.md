# Frontend

Applies to React surfaces and their frontend modules. Framework, styling and state specializations are selected through [engineering rule index](../rules/README.md#engineering-rules-by-change).

## Ownership and public boundaries

Use `./` only within the same local ownership boundary, including obvious local siblings and descendants. Use an absolute import when leaving that boundary. Parent-directory traversal is prohibited, including traversal embedded in a longer module path.

Alias names and abstractions are developer-owned: make navigation and ownership meaningful rather than imposing a universal vocabulary. Meaningful absolute subpaths are allowed. Public barrels are intentional and optional; when offering one, explicitly export its intended symbols by name rather than exposing everything with wildcard exports.

Keep reusable business/domain types with their domain owner and import those contracts with `import type`. Component props and types derived solely from props and used only in that file remain local. Package-owned types retain their package ownership; a view barrel is not their new domain owner. This does not prescribe a universal domain directory, filename suffix, or enum preference.

## Components, hooks and composition

Define one React component per component file and one custom hook per `.hook.ts` file. Colocate related files by concern. These are component/hook boundaries, not a one-function-per-file rule or a numerical restriction on comments.

For a component with props, declare a named props interface, receive a `props` argument, and destructure it at the beginning of the function body. Keep the props declaration with its component unless it has an actual shared owner. Anonymous object annotations, props type aliases and destructured parameter lists do not express this contract.

Compose independently meaningful UI responsibilities at their owning page, layout or feature. Avoid a central component that selects whole pages through a mode/section dispatcher. Ordinary configurable components, render props and dependency injection are not prohibited by this composition rule.

## Shared UI ownership

Generic UI primitives belong in `packages/react`; use the shared SmoothUI/shadcn-based foundations where appropriate instead of rebuilding app-local base primitives. App-specific business composition stays with its app.

When using the shared icon family, keep its dependency and public access in `packages/react` so consuming React apps use one icon identity. Do not duplicate the icon dependency in each app.

## Readable control flow

Use descriptive bindings instead of one-letter variable names.

When awaiting a response that will be consumed, receive it in a named binding. Where the result can be missing or invalid, handle that condition explicitly before using dependent values. Do not combine optional chaining into the same statement as `await`. Continue, use the specified fallback, or throw according to the application contract; this is not a ban on optional chaining elsewhere or a requirement to throw for every absent value.

Separate await statements from adjacent statements with a blank line, place a blank line before a return when another statement precedes it in the block, and separate initial props destructuring from the following statement. Block boundaries do not require artificial empty lines. Biome does not enforce this statement spacing.

## Application configuration and documentation

Keep app TypeScript aliases exclusively in `tsconfig.paths.json`, extended by the app configuration. Do not use `baseUrl` or duplicate `paths` in the extending config.

An app-local Turbo configuration should contain meaningful app-specific overrides, not copies of root behavior. Omit package versions from private app manifests unless publication becomes an explicit requirement; this does not change the versioning of publishable packages.

Use framework/tool commands directly when a shell wrapper adds no LangDrift behavior. Keep necessary container-specific orchestration at the container boundary; useful project behavior is a valid reason for a script.

An app README should explain the surface's product role and behavior. Stack details support that explanation rather than replace it.
