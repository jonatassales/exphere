# Next.js

Applies to LangDrift Next.js applications, in addition to [frontend.md](frontend.md).

## Application and route ownership

Place the App Router's `app/` directly under the `src/` wrapper.

Apply [frontend composition](frontend.md#components-hooks-and-composition) through route files and layouts: the filesystem owns page identity. A route should compose its page instead of merely passing a page discriminator into a universal view. Navigation/title models can still represent useful data without owning route dispatch.

Give distinct pages appropriate page-specific metadata. Shared layout metadata is a foundation, not a replacement for page identity.

## Navigation and server boundaries

Use Next Link/client navigation for ordinary internal navigation. An anchor remains valid when the semantics require it: external destinations, fragment links, downloads, and deliberate full-document navigation or recovery. Do not ban those because they use an anchor.

Keep configuration used only by server-side operations at the server boundary. Expose configuration to client code only when that client has a real need for it. Whether a value is a URL does not, by itself, establish that it is secret or that it belongs in a client bundle. Do not add a centralized environment wrapper.

## Localization ownership

For localized applications, keep app-specific localization under `src/app/template/i18n/`. That directory owns routing, navigation, request configuration, messages, and locale helpers. Do not add another localization directory.

Consume the shared language control through the [generic UI owner](frontend.md#shared-ui-ownership), keeping app-specific messages and behavior with the app.

Locale choices, persistence identifiers, timezone and control placement follow the application contract; the Dashboard's Settings placement is not a universal Next.js requirement.

## Metadata ownership

Application SEO source and composition live in `src/app/metadata/`:

```text
site.json
pages.json
locales.json
organization.json
page-metadata.ts
```

Do not move that directory to `src/metadata`.

Next.js file-convention metadata stays directly under `src/app/`, where the framework requires it:

```text
favicon.ico
icon.png
apple-icon.png
opengraph-image.png
twitter-image.png
robots.txt
sitemap.xml
manifest.webmanifest
```

`app/metadata/` is LangDrift's metadata source. The convention files beside it are framework-owned endpoints and assets.

## Next.js folder structure

`template/` is shared application presentation infrastructure used by the App Router. Not every file in it is JSX. `template/tailwind/` holds Tailwind directives, theme tokens, custom variants, and approved custom utilities. Component styling belongs in JSX through Tailwind utility classes.

Do not create authored application CSS selectors as a parallel styling system. Do not add `.btn`, `.header-nav`, `.mobile-visible`, or `.mobile-hidden` when a native utility already expresses the behavior, such as `className="block sm:hidden"`. Use `@utility` only for a repeated single-purpose capability Tailwind does not already provide. Do not use `@layer components` as an application styling strategy. Repeated multi-property UI becomes a React component. Conditional classes use the existing `cn()` formatter.

`src/factories/` is the factory directory. `ports/` and `adapters/` are optional. Add a port only when a real interface boundary requires one, and an adapter only when a real external or framework adaptation requires one. Do not create those directories to match this diagram.

```text
src/
├── app/
│   ├── template/                 shared App Router presentation infrastructure
│   │   ├── tailwind/             directives, theme tokens, variants, approved utilities
│   │   ├── formatters/           e.g. cn.fmt.ts, to-currency.compute.ts
│   │   └── i18n/
│   │       └── messages/
│   ├── metadata/                 application SEO/metadata source and composition
│   ├── api/                      Next.js route handlers
│   ├── state/
│   │   ├── domain/               state-domain contracts
│   │   ├── schemas/              state validation schemas
│   │   └── state.data.ts
│   ├── atoms/
│   └── …                         routes, layouts, pages, slots, and route-owned UI
├── infra/                        concrete third-party integrations
│   └── better-stack/
├── services/
├── factories/
├── ports/                        only when a real boundary requires them
└── adapters/                     only when a real adaptation boundary requires them
```
