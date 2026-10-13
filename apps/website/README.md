# Website

The initial Exphere website has one en-US page at `/`. The home logo and its
heading are temporarily commented out at the owner's request, leaving only the
shared `ExphereShader` motion background and the main container with spacing from
`@repo/design`. It has no navigation, marketing sections, authentication, API,
external integrations, or persistent state. This application is private and has
no deployed release.

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
preferences. Shared token ownership remains in `@repo/design`; Exphere-specific
website visual direction lives in [DESIGN.md](DESIGN.md). Read that document before
adding website UI values. Do not push Exphere branding into the public design
package without a separately approved package-level change.

Generated Next.js types, build output, and TypeScript cache files are ignored by
the repository. Framework diagnostics go to stdout/stderr. There is no separate
application test framework, telemetry integration, or production capacity claim.

Production compilation uses Next.js's supported Webpack option. The local Turbopack CSS worker failed to bind its worker port in the execution environment; this keeps the build command usable without requiring that worker port. Development retains the framework default bundler.

## Identity and SEO status

[Identity provenance](IDENTITY.md) records the owner-supplied geometry and the
October 13 monochrome refresh. Website branding is now black on white across the
horizontal logo, favicon/application icons, and prepared social SEO artwork. The
ClickHouse design-system analysis is a structural reference only: Exphere does not
adopt its yellow accent or marks.

The page remains a Server Component. The logo's complete heading block and its
`next/image` import are retained as comments in `src/app/page.tsx`; uncomment both
together to restore the original aspect ratio, accessible name, and placement.
No empty heading or replacement content is rendered while the logo is disabled.
See [SPEC-WEBSITE-HOME-LOGO-VISIBILITY](../../.exphere/artifacts/specs/0018-SPEC-website-home-logo-visibility.spec.md).

The root layout owns application identity, the light viewport, and `noindex`.
The page owns its title, experimental-project description, and en-US social copy.
Icons, the manifest, robots, and social assets use static files directly under
`src/app/`; manifest resources and the home logo use `public/`. The manifest's
browser display adds no offline or installability contract.

No production origin or indexing launch has been accepted. `metadataBase` is
null, canonical and `og:url` are omitted, and both the root and page explicitly
set empty Open Graph and Twitter image lists. This intentionally gates the
framework's automatic image URLs rather than emitting localhost or preview
origins. The black-and-white PNGs and their alt sidecars are prepared, not active
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

The original identity/SEO delivery remains historically documented in
[SPEC-WEBSITE-IDENTITY-SEO](../../.exphere/artifacts/specs/0017-SPEC-website-identity-seo.spec.md).
The monochrome redesign is governed by
[SPEC-WEBSITE-BLACK-SEO](../../.exphere/artifacts/specs/0020-SPEC-website-black-seo.spec.md).
Static asset inspection is not a passing application build, browser audit,
indexing result, or Core Web Vitals measurement.
