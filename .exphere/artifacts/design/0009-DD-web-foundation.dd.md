# Package and website foundation discovery

- ID: `DD-0009`
- Status: `in-progress; bounded implementation authorized; verification pending`
- Scope: the project owner authorized discovery through `grill-with-docs`, specification synthesis through `to-spec`, then `to-tickets && implement and commit and push on a separate branch` on October 11, 2026. This authorizes the bounded work below without inventing human acceptance of an exact document revision.

## Confirmed direction

The owner requested `packages/design`, `packages/web`, and `apps/website`. The web package will contain `src/internal/`, `src/react/`, `src/web-components/`, `src/vendor/`, and `src/utilities/`, and provide the public exports for its shared components and utilities. SmoothUI is the requested component source. The website will use Next.js, Jotai, Immer, jotai-immer, and Tailwind.

On October 11, 2026, the owner selected a minimal first website page. Marketing content, authentication, and integrations belong to later work. The initial component demonstration was narrowed by the subsequent instruction to keep the web package directories as `.gitkeep` placeholders and declare only the selected dependency in its manifest. No shared component implementation is included in this cycle; the minimal page can demonstrate design tokens.

On October 11, 2026, the owner corrected the earlier distribution decision: `design` and `web` are intended to be public packages, independent of Exphere branding. This supersedes the private-workspace-only direction. The owner selected the default Turborepo example prefix, `@repo/`: manifest and import names are `@repo/design` and `@repo/web`, in `packages/design/` and `packages/web/`. Public distribution is an architectural requirement, not an instruction to publish during discovery. The `web-components/` directory contains only `.gitkeep`; no Custom Element or React implementation is requested there yet.

The initial tokens use a provisional neutral foundation: grayscale colors, system fonts, and restrained spacing, radii, and effects. The owner will define the actual visual identity and token values later. Initial values remain centralized and replaceable through the token source; they do not establish a permanent brand palette. This cycle emits shared `:root` foundation variables and explicit light/dark data-theme selectors. The website selects light without a toggle, automatic mode selection, or persistence.

The owner requested only a SmoothUI dependency declaration, without adding component source. Official SmoothUI documentation describes a component registry and CLI rather than a React runtime package. Under the subsequent implementation request, select `smoothui-cli` version `1.1.3` as a development dependency only. The earlier dependency-role question had no separate recorded answer; this is a bounded execution decision, not a claim of exact human revision approval. Do not execute acquisition commands or add component source. Future component/token adaptation remains deferred.

The design package uses `--design-` names and public `@repo/design/tokens.css` and `@repo/design/tokens.json` exports. Its TypeScript token compiler behind `.sh` entry points is a scoped implementation exception; other automation retains the shell rule. Generated JSON preserves authored aliases and type/value metadata. Initial package versions are `0.0.0` for both public `@repo/` packages and both private `@exphere/` packages. The website is a private application rather than a published library.

## SDK and CLI separation

On October 11, 2026, the owner requested splitting the existing `packages/exphere/` package into two private, versioned packages. This is part of the current discovery scope and supersedes the previous requirement to retain the combined package location.

| Directory | Manifest name | Visibility | Responsibility |
| --- | --- | --- | --- |
| `packages/sdk/` | `@exphere/sdk` | Private | The existing TypeScript library surface and its build outputs. |
| `packages/cli/` | `@exphere/cli` | Private | The existing `ex` shell command, setup, microruntime descriptor handling, and adapters. |

Both manifests carry initial version `0.0.0`, preserving the combined package's inspected baseline. The split does not establish a release cadence or require a new version-management tool. Public package scope remains limited to `@repo/design` and `@repo/web` in this initiative. Future SDK/CLI distribution remains a separate MVP decision and release scope.

The migration must preserve the `ex` command and existing behavior while updating root dependencies, command paths, postinstall integration, hook fixtures, and current documentation references. Historical verification records retain the source identity and package names they actually examined. The SDK's TypeScript API is currently empty; splitting packages must not invent SDK APIs or a CLI-to-SDK dependency without actual consumption.

Baseline source inspection found two migration-sensitive behaviors. The CLI reads its version from the manifest above its script directory, so its destination layout must resolve the CLI package's own version. Setup refused existing user-local links whose targets differed from the CLI path. The selected compatibility behavior migrates only links with exact destinations matching this checkout's former CLI paths, including its environment entry, while preserving refusal for unrelated installations or ordinary files. Verification uses isolated installation fixtures; real user-local links remain outside this implementation authorization.

## Remaining decisions and evidence gaps

- Permanent visual identity and replacement token values.
- Future web components, public component exports, and token adaptation.
- Licensing, registry ownership/access, release cadence, and any eventual npm publication.
- Implementation review and measured build/test outcomes tied to examined source revisions; authorization does not establish a pass.
- Browser appearance, hydration, service binding/shutdown, deployment, and production capacity remain unverified. Website browser/service probes and automated application/browser test infrastructure remain outside this cycle.

## Specifications and implementation tickets

The October 11, 2026 `to-spec` request produced four separate scope contracts. The later direct execution request authorizes their bounded implementation and ticket preparation. The specifications record selected implementation details separately from human acceptance, technical review, and observed outcomes.

| Specification | Scope | Dependency |
| --- | --- | --- |
| [SPEC-DESIGN-TOKENS](../specs/0003-SPEC-design-token-foundation.spec.md) | Public `@repo/design`, provisional neutral token sources and generated CSS/JSON. | No dependency on the other new packages. |
| [SPEC-WEB-PACKAGE](../specs/0004-SPEC-web-package-foundation.spec.md) | Public `@repo/web`, five placeholder boundaries, and SmoothUI development tooling only. | No artificial dependency on design or either Exphere package. |
| [SPEC-WEBSITE-FOUNDATION](../specs/0005-SPEC-website-foundation.spec.md) | Minimal Next.js application, selected state/style dependencies, and frontend ownership rules. | Consumes the agreed design export contract; does not consume the empty web package. |
| [SPEC-SDK-CLI-SEPARATION](../specs/0006-SPEC-sdk-cli-separation.spec.md) | Separate private, versioned `@exphere/sdk` and `@exphere/cli`, including installation compatibility. | Independent of the frontend specs; future consumer-context generation remains separate. |

Implementation is tracked by [SPLIT-01](../tickets/0015-TICKET-sdk-cli-separation.ticket.md), [DESIGN-01](../tickets/0016-TICKET-design-token-foundation.ticket.md), [WEB-01](../tickets/0017-TICKET-web-package-foundation.ticket.md), and [SITE-01](../tickets/0018-TICKET-website-foundation.ticket.md). Installation, type checking, build, and focused public consumer tests for design and CLI are authorized. The website uses build/type checking and static review without adding application tests or browser/service probes.

Delivery uses a separate feature branch and reviewed ticket-scoped commits and normal pushes; force pushes remain prohibited. This authorization does not extend to merging, registry publication, deployment, or unrelated work. Source and execution results belong in the corresponding specification/ticket evidence; this discovery record itself proves no build, test, or runtime outcome.
