# Localization

**Description:** Translation catalogs remain JSON data; locale selection, loading, formatting, and validation remain application behavior.

**Applies when:** Changing an application's translation catalogs, locale behavior, localized documentation, or catalog adapters. Exphere project content remains en-US; this rule does not introduce another locale or require a localization framework for a single-language surface.

## Catalog and adapter ownership

Store translation catalogs as UTF-8 `.json` files. Keep translated message values, UI copy maps, language-name maps, and navigation labels out of TypeScript and JavaScript. This applies to every supported catalog locale, including English, and to dependencies maintained within this repository's authorized work.

TypeScript may import JSON, define message types, select locales, and format ICU messages. Keep those loaders free of translated values. A framework-required adapter, such as Nextra's `_meta.ts`, may import and export its adjacent JSON catalog with types as needed; it is not a second source of translation text.

When localized documentation uses MDX, articles remain MDX. Preserve executable examples, technical identifiers, English slugs, and stable heading anchors. UI and navigation text around the articles remains in JSON catalogs.

## Behavior and validation

Preserve key and placeholder parity, rich-text tags, valid ICU, and numeric inputs to formatters. Where counts are localized, review representative counts `0`, `1`, `2`, `3`, and `12` against the actual production catalogs. Preserve the identity of each supported language and script variant; one is not a silent substitute for another.

Keep locale choices, routing, persistence, and delivery behavior with the application's own contract. For Next.js ownership, follow [localization ownership](0040-nextjs-structure.rule.md#localization-ownership).

For catalog or loader changes, use the existing relevant catalog checks and affected application checks only within their current execution authorization. Static catalog-location checks cannot alone prove behavior or detect every visible copy value outside those locations. Review those surfaces as part of the change. Do not advertise an unavailable localization command or introduce tests through this rule.

## Provenance and adaptations

Source at `e518dace741d8b9b44dd0a9d851fa3f42506320a`: [localization rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/80-localization.mdc).

Adaptation: unrelated metric names, preview and signup behavior, product calculations, fixed locale choices, the source-only localization document, and the unavailable `check:i18n` command are not transferred. Catalog and formatting principles remain conditional; no locale catalog, loader, translation framework, or test execution is introduced. See [DEC-RULE-01](../../.exphere/artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register).
