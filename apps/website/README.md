# Website

The Exphere website has one en-US page at `/`: a responsive, server-authored
hero introducing the experimental project, a short preview of documented local
CLI commands, and a **Read documentation** link to the repository README. The
linked repository is private and requires access; no separate docs site is
claimed. The earlier home SVG logo remains commented out at the owner's request.

The existing `ExphereShader` motion background remains mounted in the root
layout and visible behind the hero. Static, translucent white content surfaces
preserve readability without covering the animation. The hero follows the
black-branded website [design contract](DESIGN.md); this does not alter the
generic `@repo/design` or `@repo/web` packages. The application has no
authentication, API, external service integration, or persistent state. It is
private and has no deployed release.

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

The page remains a Server Component. Its visible text `h1` is a hero heading,
not a restoration of the earlier Exphere logo asset. The original SVG logo's
complete heading block and `next/image` import remain as comments in
`src/app/page.tsx`; uncommenting them later requires a separate accessibility
review to avoid duplicate headings. No new image/font dependency was introduced.
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

## Hero and motion

The hero follows [SPEC-WEBSITE-HERO-DOCS](../../.exphere/artifacts/specs/0021-SPEC-website-hero-documentation.spec.md)
and [WEB-HERO-01](../../.exphere/artifacts/tickets/0043-TICKET-website-hero-documentation.ticket.md).
Its documentation CTA opens the existing GitHub README, which is not a public
documentation product while repository access is restricted. The CLI panel
contains commands already documented by the project; it displays no invented
output or runtime status.

The owner's October 13, 2026 correction explicitly retains the existing
animated `ExphereShader` wrapper. Its source, mount, animation, and colors are
unchanged, and the translucent hero surfaces leave it visible. No new gradient,
animation, shadow, or colored Exphere branding is introduced. This local
exception to the general flat-surface guidance is also recorded in
[DESIGN.md](DESIGN.md#10-existing-motion-background-exception).
