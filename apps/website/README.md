# Website

The initial Exphere website has one en-US page at `/`. It displays the project
name using the basic light palette, system font, and spacing supplied by
`@repo/design`, with the shared `ExphereShader` motion background around root-layout children. It has no marketing sections, authentication, API, external integrations,
or persistent state. This application is private and has no deployed release.

Run these commands from the repository root:

| Command | Purpose |
| --- | --- |
| `pnpm build --filter=website...` | Build design tokens, the shared web component, and the application. |
| `pnpm dev --filter=website` | Build shared dependencies and start development. |
| `pnpm start --filter=website` | Serve the completed production build locally. |
| `pnpm --filter website typecheck` | Generate Next.js route types and check TypeScript without emitting application code. |

The framework defaults to port 3000. To choose an explicit local interface and
port, run `pnpm --filter website dev --hostname 127.0.0.1 --port 3000` or pass the
same options to `start`. Stop the foreground process when finished. No application
secrets, remote endpoints, or additional environment variables are required.

The App Router owns route structure under `src/app`. Application aliases live
only in `tsconfig.paths.json`. Components remain server-rendered until real
interactivity requires a client boundary. Jotai, Immer, and jotai-immer are
available for future application-owned state; the initial page needs no store or
provider. The server root layout imports `ExphereShader` from
`@repo/web/react/exphere-shader` and passes children through its client boundary.
The package supplies the viewport decoration, generated styles, reduced-motion
behavior, and static fallback; application content retains its normal rendering.

Tailwind utilities consume generated token CSS through the public package export.
The application selects the light theme without adding a theme switch or storing
preferences. Edit token values in the design package rather than duplicating them
here. Development and production builds use the same token contract; the
framework's hot reload and production optimizations differ.

Generated Next.js types, build output, and TypeScript cache files are ignored by
the repository. Framework diagnostics go to stdout/stderr. There is no separate
application test framework, telemetry integration, or production capacity claim.

Production compilation uses Next.js's supported Webpack option. The local Turbopack CSS worker failed to bind its worker port in the execution environment; this keeps the build command usable without requiring that worker port. Development retains the framework default bundler.
