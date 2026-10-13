# SEO metadata

**Description:** Public website metadata has explicit document, route, locale, and static-asset ownership.

**Applies when:** Changing a public Next.js website's metadata, indexing behavior, or social assets. Localization requirements apply only to applications that support localized routes.

## Origin and document ownership

Use the public origin accepted by the application's contract. Do not derive canonical URLs from the incoming request host or copy an upstream product's origin.

The root document layout owns `<html>`, `<body>`, `metadataBase`, and `applicationName`. If the application uses a localized root document, its locale layout owns those responsibilities. Root routing follows the application's contract: a locale-negotiation proxy is appropriate only when that routing is required. The minimal website draft retains its en-US `/` page.

## Indexable routes

An indexable route needs a unique title and description, a self canonical, a server-rendered `lang`, Open Graph and Twitter metadata, and a sitemap entry. For localized routes, localize titles and descriptions and supply hreflang for the application's actual supported alternatives. Child-page metadata belongs to the child page. Transient pages are `noindex`.

## Static assets and metadata data

`opengraph-image.*` and `twitter-image.*` own social image files and framework-derived image metadata. Do not manually duplicate width, height, MIME type, alt, or absolute image descriptors already owned by the framework.

Keep `robots.txt`, `sitemap.xml`, icons, social images, and `manifest.webmanifest` as static convention files under the application's App Router root (`src/app/` by default, `app/` for the Exphere website) when the application requires them. Do not replace these static files with TypeScript generators. Application metadata source and composition follow [Next.js metadata ownership](0040-nextjs-structure.rule.md#metadata-ownership).

For localized applications, routing owns locale IDs, public prefixes, and the default locale, conventionally in `routing.ts`. Metadata JSON owns titles, descriptions, site name, public origin, Open Graph locales, and organization fields. It does not own route paths. Include only fields and locale catalogs required by the application's contract.

## Verification boundary

Localhost social-image URLs during local verification are not a reason to add another root document shell. When deployment and production verification are separately authorized, verify absolute social-image origins against the application's accepted public origin. A local rule import proves no deployed metadata behavior.

## Provenance and adaptations

Sources at `e518dace741d8b9b44dd0a9d851fa3f42506320a`: [SEO metadata rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/70-seo-metadata.mdc) and [Next.js metadata guidance](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/nextjs.md).

Adaptation: source-specific origin, locale negotiation, localized document structure, and production checks become conditional application contracts. No production domain, locale routing, proxy, deployment, or new metadata assets are established by this import. See [DEC-RULE-01](../../.exphere/artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register).
