# Next.js structure

**Description:** App Router conventions keep routes, framework boundaries, and application concerns with their owners.

**Applies when:** Changing a Next.js application's source, configuration, or manifest. It does not require creating a Next.js application.

## Application and route ownership

Use the App Router directly under `src/app/`. Do not add a Pages Router tree. Framework files retain their framework meaning: `layout.tsx`, `page.tsx`, `template.tsx`, `loading.tsx`, `error.tsx`, `not-found.tsx`, `route.ts`, and, when needed by the installed version, `proxy.ts`. Use those conventions instead of custom wrappers that duplicate their jobs.

The filesystem owns page identity. Apply [frontend composition](0100-frontend.rule.md#components-hooks-and-composition) through route files and layouts: each route composes its page instead of passing a discriminator into a universal view. Navigation and title models may represent useful data without owning route dispatch. Give distinct pages page-specific metadata; a shared layout's metadata is a foundation, not a replacement for page identity.

Keep route UI, localization, data, and application state under their App Router owner. `src/infra/` owns concrete framework or third-party integrations; `src/services/` owns actual application services, including cookie or crypto services when needed; `src/factories/` owns factories. Introduce `ports/` only for a real interface boundary and `adapters/` only for a real external or framework adaptation. Do not add generic `utils/`, `helpers/`, `common/`, or `misc/` buckets.

`src/app/template/` is shared application presentation infrastructure, including non-JSX modules. Its `tailwind/` area owns the integration surfaces described in [styling](0010-styling.rule.md); its `formatters/` area may own presentation formatters. State organization follows actual domains and the [optional Jotai rule](0110-jotai.rule.md), not a mandatory global `state/` or `atoms/` scaffold. Create each boundary only when real behavior needs it.

## Navigation and server boundaries

Use Next Link or client navigation for ordinary internal navigation. Anchors remain appropriate for external destinations, fragment links, downloads, and deliberate full-document navigation or recovery.

Keep configuration used only by server operations at the server boundary. Expose a value to the client only when the client needs it. Being a URL alone establishes neither secrecy nor a need to enter the client bundle. Follow [environment and external input](0020-environment-runtime.rule.md); do not introduce a centralized environment wrapper.

When an application needs a proxy, verify the installed Next.js version's file convention and place the framework entry accordingly. With the `src/app/` convention and framework support for a sibling proxy, that entry is `src/proxy.ts`; any required locale implementation may live in `src/proxy/`. A diagram or imported rule does not authorize adding a proxy. The minimal website draft requires none.

## Localization ownership

For an application that actually supports localization, `src/app/template/i18n/` owns its routing, navigation, request configuration, messages, and locale helpers. Keep one localization owner rather than adding another localization directory. Apply [localization](0080-localization.rule.md) to catalogs and behavior.

Consume a shared language control through the [generic UI owner](0100-frontend.rule.md#shared-ui-ownership) when that owner exports one, while retaining application-specific messages and behavior with the application. Locale choices, persistence identifiers, timezone, and control placement follow the application contract.

## Metadata ownership

Application SEO source and composition belong in `src/app/metadata/`, not a parallel `src/metadata/`. Where needed, `site.json`, `pages.json`, `locales.json`, and `organization.json` own their respective data, and `page-metadata.ts` owns page metadata composition. Those responsibilities do not require empty catalogs or helper files.

Framework-convention assets and endpoints stay directly under `src/app/`: icons, social images, `robots.txt`, `sitemap.xml`, and `manifest.webmanifest`. Follow [SEO metadata](0070-seo-metadata.rule.md) for static-file ownership and indexing behavior. Add only files the application's actual contract requires.

## Provenance and adaptations

Sources at `e518dace741d8b9b44dd0a9d851fa3f42506320a`: [Next.js structure rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/40-nextjs-structure.mdc) and [Next.js guardrail](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/nextjs.md).

Adaptation: obsolete source paths and contradictory proxy placement are replaced by conditional ownership and version verification. Source examples do not create application directories, mandatory state buckets, a proxy, or shared component exports. See [DEC-RULE-01](../../.artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register).
