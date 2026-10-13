# Website

Exphere's en-US documentation entry lives at `/`. A single centered hero uses
the owner's FinOps copy and a dark copy-to-clipboard control for
`npx exphere init`. That command is a preview: no Exphere npm executable or
working `init` is claimed. Copying never executes the command; success and
failure feedback is announced accessibly, and the visible command remains
selectable when clipboard access is unavailable.

**Documentation** links to `/docs`, the only authored Nextra Docs Theme page,
containing just the Getting Started heading. There is no search index, additional
documentation, edit-page action, or fabricated runtime guide. Next.js App Router
and Nextra's official plugin own the routes; `src/mdx-components.tsx` supplies
the theme's MDX components. The root layout retains one `ExphereShader`.

The header and footer render the native `orbo-voice` `<orb-o>` component in
black/gray shades. Its `listening` state is decorative, hidden from assistive
technology, and respects reduced motion. Browser registration happens only
inside the small client boundary. No microphone, voice provider, media session,
or audio playback is configured. The copy control owns local React state;
no application state store or provider is needed for the hero.

The footer uses the owner's literal `exphere by Grupo OLX © 2026` credit and
accessible GitHub and LinkedIn icons. GitHub points to this repository (which
may require access); the organization LinkedIn destination is listed on
[Grupo OLX's official website](https://www.grupoolx.com.br/). This is not a claim
of independently verified organizational endorsement. No npm icon links to a
nonexistent Exphere package. The compact icon arrangement follows the owner's
[Vidro reference](https://vidro.pro/pt-BR/) without copying unrelated profiles.

## Local development

Run these commands from the repository root:

| Command | Purpose |
| --- | --- |
| `pnpm build --filter=website...` | Build shared dependencies and the application. |
| `pnpm dev --filter=website` | Build shared dependencies and start development. |
| `pnpm start --filter=website` | Serve the completed production build locally. |
| `pnpm --filter website typecheck` | Generate Next.js route types and check TypeScript. |

Package aliases invoke Next.js and TypeScript directly. There is no website
`scripts/` directory. Production compilation and development use Next.js 16.4's native Turbopack
bundler. Nextra 4.6.1's legacy Webpack loader misclassifies MDX metadata under
this Next.js version. The supported `turbopack.resolveAlias` configuration maps
Nextra's MDX provider alias directly to this application's `src/mdx-components.tsx`. The framework defaults to port 3000; pass `--hostname 127.0.0.1 --port
3000` to the `dev` or `start` alias to select a local interface explicitly.

No application secrets, backing service, remote origin, or extra environment
variables are required. Diagnostics use stdout/stderr. Next.js output, route
types and TypeScript caches remain ignored. There is no application test runner,
telemetry integration, deployment, or measured capacity claim.

## Design and metadata

The application is dark only, including Nextra. Tailwind utilities consume the
public `@repo/design` token CSS and the website's charcoal/purple theme bridge.
Nextra's required framework stylesheet is the only new global style import.
The root imports application bootstrap CSS before the shared shader stylesheet,
and declares `theme, base, components, utilities` in that order. This prevents
framework resets from taking precedence over Tailwind utilities.
`src/app/_meta.ts` keeps the documentation sidebar limited to Getting Started.
[DESIGN.md](DESIGN.md) records website-only visual decisions; shared token and
shader ownership stay in their packages. The existing shader uses the same
purple-on-black palette, motion algorithm, reduced-motion support and fallback.

Original black brand assets remain intact; [IDENTITY.md](IDENTITY.md) records
their provenance. The earlier SVG logo heading remains commented out in the
home source under SPEC-WEBSITE-HOME-LOGO-VISIBILITY. Each page has one visible
`h1`; the root document owns `lang="en-US"`, `dir="ltr"` and the dark theme.

The root owns application identity and `noindex`. Each page supplies its own
title, description and social metadata. The production origin and indexing
launch remain undecided: `metadataBase` stays null, image URL lists stay empty,
and no canonical, sitemap or structured entity claims are invented. Static icons, manifest and robots retain their framework paths. Six corrupt
baseline binary assets are preserved under `public/brand/`; the active Apple
and 512px manifest icons were recovered from the earlier black-brand revision, and existing valid
SVG/PNG favicons remain active. Corrupt social images are no longer metadata
convention files; their image lists remain empty. See IDENTITY.md for exact
provenance and limitations.
`robots.txt` permits crawling so the HTML noindex directive can be discovered.
Nextra does not authorize an indexing launch or production deployment.

Before indexing, accept an origin/policy, configure root metadataBase and route
canonicals/Open Graph URLs, activate social image metadata, and add a static
sitemap for indexable routes. Reinspect generated HTML and manifests. Local
compilation and source review do not establish browser interaction, visual
acceptance, Core Web Vitals, indexing, or production readiness.

Current scope is defined by
[SPEC-WEB-DOCS](../../.exphere/artifacts/specs/0024-SPEC-website-nextra-getting-started.spec.md)
and [WEB-DOCS-01](../../.exphere/artifacts/tickets/0046-TICKET-website-nextra-entry.ticket.md).
The earlier hero/right-card and repository-only documentation behavior in
SPEC-WEBSITE-HERO-DOCS is superseded by this documentation entry.

## Dependency compatibility

The website compiler is pinned to TypeScript 6.0.3 because Nextra's Twoslash
dependency requires its JavaScript compiler API, which TypeScript 7 no longer
provides. Nextra and its Docs Theme resolve Zod 4.1.12 through scoped workspace
overrides: newer Zod 4.4.3 rejects the theme's omitted `children` schema field
during server rendering. These bounded pins preserve the existing workspace
compiler choices elsewhere. Production compilation must remain part of an
upgrade review; peer-range satisfaction alone did not catch either runtime gap.
