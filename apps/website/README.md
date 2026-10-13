# Website

Exphere's homepage presents the product direction in a viewport-height, three-row layout. It retains the purple shader animation and compact copy control. On short screens, secondary description text is hidden so the title, links, copy control, and footer remain visible. The copied `npx exphere init` command is preview text, not a working installer; copying never executes it.

`/docs` offers Getting Started, Concepts, Architecture, CLI, and Development. Nextra owns navigation, breadcrumbs, the article wrapper, table of contents, pagination, mobile menu, and Pagefind search. Docs use a solid dark reading background; the shader mounts only on Home. Existing diagram assets are imported from their repository owner through the `@diagrams` alias.

## Local development

Run commands from the repository root:

| Command | Purpose |
| --- | --- |
| `pnpm build --filter=website...` | Build shared dependencies, compile the website, and generate search assets. |
| `pnpm dev --filter=website` | Build shared dependencies and start development. |
| `pnpm start --filter=website` | Serve the completed production build locally. |
| `pnpm --filter website typecheck` | Generate Next.js route types and check TypeScript. |

Next.js defaults to port 3000; pass `--hostname 127.0.0.1 --port 3000` to the package's dev/start command to select the local interface. Stop the process when finished. No application secrets, backing service, or additional environment variables are required. Native diagnostics use stdout/stderr.

Production and development use Next.js 16.4's native Turbopack bundler. The App Router and static metadata files live directly in `app/`, with MDX mapping in `app/components/mdx-components.tsx`. Typed configuration maps the MDX provider alias for both bundlers. Webpack remains outside the supported build path because Nextra 4.6.1's loader has a previously observed metadata incompatibility with this Next.js release.

## Vercel installation

The Vercel project root is `apps/website`. Its local `vercel.json` installs the pinned workspace with `EXPHERE_SKIP_CLI_BUILD=1` scoped to that install command, then builds only `website` and its dependencies. The website does not execute the Go CLI, so its deployment does not require a Go toolchain. Other dependency lifecycle scripts remain enabled; normal developer installation still builds the CLI. This configuration does not change the separate root-level Vercel services configuration.

## Search lifecycle

The website owns the pinned Pagefind build dependency. The build runs `next build`. The website-owned `next.adapter.mts` uses Next.js build-complete output records to index prerendered Docs HTML with its public route URL, without assuming an internal output directory. When Vercel supplies `NEXT_ADAPTER_PATH`, the adapter preserves its configuration hook and runs its packaging hook after writing the search assets. Nextra marks article bodies for indexing; Home and framework error pages do not enter the corpus. Verify five docs pages when adding or changing routes.

Generated `public/_pagefind/` files are ignored by Git and included in the website's Turbo build outputs. Diagram assets outside the package are explicit build inputs. A cached build restores search assets alongside Next output. Indexing errors fail the build. The development server needs a previously generated index for search; production verification must check result URLs and served assets, not just the input field.

## Presentation and metadata

The site is dark only. Tailwind utilities consume public design-token CSS and the website's charcoal/purple theme bridge; global CSS contains framework imports and token integration. Home alone mounts the unchanged shared shader. The decorative orb respects reduced motion and has no microphone or audio integration. Copy interaction remains local React state and announces success/failure.

LinkedIn points to the owner's profile. The existing owner-requested footer attribution is preserved. No independent organizational endorsement is inferred.

The root owns `lang="en-US"`, application identity, and `noindex`. Pages own titles and descriptions. `metadataBase` remains null; no canonical or sitemap is introduced. Existing valid icons and the manifest are preserved. Corrupt historical binary assets remain inactive under `public/brand/`; social-image lists remain empty. Asset provenance is retained in [SPEC-WEBSITE-DOCS-REFRESH](../../.exphere/artifacts/specs/0031-SPEC-website-docs-refresh.spec.md#retained-asset-provenance).

An indexing launch, social-card activation, and production promotion require separate decisions. Browser verification covers the recorded local build, not production availability.

## Dependency compatibility

Website TypeScript stays pinned to 6.0.3 because Nextra's Twoslash dependency requires the JavaScript compiler API. Scoped workspace overrides keep Nextra and its theme on Zod 4.1.12; newer Zod previously rejected the theme's omitted children schema field during rendering. Preserve these bounded pins until an upgrade passes production compilation.

## Scope and evidence

[SPEC-WEBSITE-DOCS-REFRESH](../../.exphere/artifacts/specs/0031-SPEC-website-docs-refresh.spec.md) records this cycle's requirements, owner decisions, checks, and independent reviews. The [Development guide](app/docs/development/page.mdx) contains contributor commands and hook semantics.
