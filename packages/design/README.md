# Design tokens

`@repo/design` is a versioned package intended for public distribution. Its light theme supplies Exphere's basic palette from one editable JSON source. Shared grayscale foundations and the existing dark theme retain their original values. No registry release is performed by installation or build.

## Consumer interface

The explicit exports are `@repo/design/tokens.css` and `@repo/design/tokens.json`. Import the CSS once from the application stylesheet. The package has no JavaScript runtime API and does not depend on the SDK, CLI, or web package.

Foundation variables belong to `:root`. Semantic colors belong to `[data-theme="light"]` or `[data-theme="dark"]`; consumers set the attribute explicitly. The package implements no theme detection, toggle, or persistence. The initial website uses light mode.

The seven basic palette roles are available in light mode. `foreground` remains a compatibility alias of light `text`. The dark theme retains its four existing roles; no dark primary, primary-hover, text, or text-secondary values are defined.

| Variable | Value or meaning |
| --- | --- |
| `--design-color-primary` | Light: `#6D0AD6`. |
| `--design-color-primary-hover` | Light: `#5408A5`. |
| `--design-color-background` | Light: `#FFFFFF`; dark: gray 950. |
| `--design-color-surface` | Light: `#F9F9F9`; dark: gray 900. |
| `--design-color-text` | Light: `#27262A`. |
| `--design-color-text-secondary` | Light: `#535257`. |
| `--design-color-border` | Light: `#DDDDDD`; dark: gray 800. |
| `--design-color-foreground` | Light: alias of `text` (`#27262A`); dark: gray 50. |
| `--design-typography-font-body` | `system-ui, sans-serif` |
| `--design-typography-size-body` | `1rem` |
| `--design-typography-size-heading` | `2rem` |
| `--design-dimensions-space-4` | `1rem` |
| `--design-dimensions-radius-md` | `0.5rem` |
| `--design-dimensions-content-max` | `64rem` |
| `--design-effects-shadow-sm` | `0px 1px 2px #00000014` |

## Source contract

Four source categories live in `tokens/`: color, typography, dimensions, and effects. Nested objects define token identities. `$type` is inherited from the nearest enclosing group; an explicit token type overrides it. Every leaf contains a string `$value`, optionally `$type` and a string `$description`. A group may carry `$type` and `$description`. Other metadata, arrays, mixed token/group leaves, and duplicate JSON keys or root groups are rejected.

This is a limited schema, not full Design Tokens Community Group format compliance:

- `color`: hexadecimal colors with 3, 4, 6, or 8 digits, `transparent`, or `currentColor`.
- `dimension`: finite nonnegative decimal values with `px`, `rem`, or `em` units; a unit is required even for zero.
- `fontFamily`: comma-separated unquoted family names using letters, digits, spaces, and hyphens, beginning with a letter.
- `shadow`: `none`, or two to four dimension values followed by a hexadecimal color. Offsets and spread may be negative; blur may not. Multiple shadows and other CSS functions are unsupported.
- `cubicBezier`: a `cubic-bezier(...)` string containing four finite decimal numbers. Its first and third numbers must be between zero and one.

A whole value such as `{color.gray.50}` is an alias. Its target must exist and have the same effective type. Cycles fail. Foundation aliases cannot target a theme; theme aliases may target foundations or the same theme. Token keys contain letters, digits, hyphens, and underscores, beginning with a letter or digit. Dot separators, underscores, and camel-case boundaries normalize to hyphens in lowercase CSS variables prefixed with `--design-`. Normalized name collisions fail, including collisions between a theme and a foundation token.

The reserved `themes.light` and `themes.dark` groups map to the corresponding selectors. Their tokens omit the theme prefix from CSS names. Generated CSS preserves aliases as `var(...)`; generated JSON combines the sources while preserving authored aliases and `$type`/`$value` metadata. It is not a flattened resolved-value map. Generated output ordering is deterministic and includes no timestamps or machine paths.

## Development and verification

Use the workspace's pinned pnpm with Node.js 22.22.1 or later. `pnpm --filter @repo/design build`, `dev`, `typecheck`, and `test` invoke the corresponding shell entry points. The TypeScript compiler runs through Node's native type stripping; the package declares TypeScript and Node type definitions for static checking.

Build validates the complete token graph before preparing both outputs. A temporary output directory replaces the previous output only after generation succeeds; an installation failure attempts to restore the previous directory. Failed validation leaves previous outputs unchanged and reports them as stale. Run one generator per package directory. The two directory renames are not a cross-process transactional filesystem interface; consumers should rely on completed build results.

Development watch polls only the four source files every 200ms, debounces changes, and regenerates after valid edits. Invalid edits report diagnostics while retaining the last valid outputs. SIGINT or SIGTERM clears pending work and removes watchers. Polling avoids platform-specific native watcher limits and follows files replaced by editors.

The shell contract suite builds an isolated package and resolves both public exports from a disposable consumer. It checks the seven supplied light-palette values, the foreground compatibility alias, preserved dark roles, deterministic rebuilds, rejected invalid graphs and unsafe values, unchanged outputs after failures, light-token regeneration in both exports, and clean watcher shutdown. It does not claim browser rendering, registry availability, or production readiness.
