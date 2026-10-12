# Website

The initial Exphere website has one en-US page at `/`. It displays only the
supplied horizontal Exphere logo at the upper left, with an accessible Exphere
heading, spacing supplied by `@repo/design`, and the shared `ExphereShader` motion
background around root-layout children. It has no navigation, marketing sections,
authentication, API, external integrations, or persistent state. This application
is private and has no deployed release.

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

## Identity and SEO status

[Identity provenance](IDENTITY.md) lists the supplied artwork and raster exports.
The page remains a Server Component and uses the framework's `Image` component
with an explicit aspect ratio and accessible name; no application client module
is added. The logo is not a navigation bar or link to an unimplemented route.

The root layout owns application identity, the light viewport, and `noindex`.
The page owns its title, experimental-project description, and en-US social copy.
Icons, the manifest, robots, and social assets use static files directly under
`src/app/`; manifest resources and the home logo use `public/`. The manifest's
browser display adds no offline or installability contract.

No production origin or indexing launch has been accepted. `metadataBase` is
null, canonical and `og:url` are omitted, and both the root and page explicitly
set empty Open Graph and Twitter image lists. This intentionally gates the
framework's automatic image URLs rather than emitting localhost or preview
origins. The brand-only PNGs and their alt sidecars are prepared, not active
large-image sharing metadata. Do not interpret their presence as deployment
verification.

`robots.txt` allows crawling so the HTML noindex directive remains discoverable.
No sitemap, structured entity data, social profile, locale alternatives,
AI-specific crawler policy, analytics, or Search Console integration is invented.
A single page does not need a metadata helper framework or empty catalogs.

Before an indexable launch, accept the production origin and policy, set the root
metadata base, add the page's self canonical and Open Graph URL, remove both
image-list gates, and choose `summary_large_image`. Add a static sitemap listing
only indexable canonical URLs and its robots directive in the same change.
Reinspect generated HTML and route manifests after the website typecheck,
production build, and repository Biome check. Non-production deployments must
retain noindex. Deployment configuration and production access remain separately
owned and are not changed by this integration.

The source-only identity/SEO delivery has an explicit verification block in
[SPEC-WEBSITE-IDENTITY-SEO](../../.exphere/artifacts/specs/0017-SPEC-website-identity-seo.spec.md).
Asset inspection is not a passing application build, independent review, browser
audit, indexing result, or Core Web Vitals measurement.
