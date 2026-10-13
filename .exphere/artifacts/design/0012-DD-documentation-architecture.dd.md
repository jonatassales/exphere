# Nextra documentation entry architecture

Reference maintenance: successor links below point to the later website refresh, not to the source reviewed in this historical cycle. Original revisions and review hashes remain authoritative.

- ID: `DD-0012`
- Decision ID: `ADR-0004`
- Status: `selected under owner-requested documentation-only scope`
- Owner: Exphere project owner
- Date: October 13, 2026
- PRD: [PRD-EXPHERE-DOCS-WEBSITE](../prd/0006-PRD-exphere-documentation-site.prd.md)

## Context

The current Next.js 16 App Router website uses Tailwind and the shared animated ExphereShader in a server root layout. The owner requests Nextra docs and a simplified first page. No deployed/public Docs origin exists. The Orbo web component is published as `orbo-voice@1.1.1` and supports `<orb-o state="listening">` and explicit browser registration via `orbo-voice/browser`; HTML custom color attributes provide the grayscale palette. The npm package's published docs do not imply that `state="listening"` starts microphone capture.

## Decision

- Keep `/` as the first documentation-oriented visual entry, not a separate marketing stack.
- Mount Nextra 4 on the existing Next.js App Router with MDX and the Docs Theme; add `/docs` as the **only** authored Nextra documentation page, titled Getting Started. The existing home header/docs CTA points to `/docs`. No additional pages/catalogs or false production-origin URLs.
- Retain the server root layout and existing ExphereShader wrapper. Scope only voice orb registration and clipboard to small React client boundaries; never call browser Web Component registration or Clipboard API while server rendering.
- Show Orbo as a visually controlled preview: no media capture, no provider, no call to `startConversation`. Preserve reduced-motion `system`. Use native `<orb-o>` attributes, no wrapper framework or custom renderer.
- Maintain site dark tokens, near-black surfaces and the current purple motion. Header orb uses `#0a0a0a` through `#666666` neutral colors, not Exphere's purple accent.
- The copy button's command `npx exphere init` is **display-only until the npm executable exists**. Copying must never execute it and must handle navigator.clipboard failure.
- Use inline accessible SVG social icons and real verified URLs, avoiding invented X/Instagram profile links. Render the exact owner-provided `exphere by Grupo OLX © 2026` footer credit; do not infer trademark clearance or organizational legal approval from a repo change.
- Keep `noindex` until a separate accepted production-origin/indexability decision. Nextra theme route does not auto-create public SEO claims.
- Respect the existing project's Tailwind-first styling rule despite the attached generic frontend role's preference for native CSS; preserve framework-local ownership.

## Rejected alternatives

- Rendering the voice orb and clipboard within a client-only whole-page component: violates server boundary and adds unnecessary hydration.
- Fake `/docs` route or a stub Docs URL before Nextra installation: owner requested Nextra explicitly.
- Automatically enabling microphone from `listening` visual state: unsafe and not implied by the published Orbo API.
- Publishing or claiming a working `npx exphere init` before the Go installer exists.
- A second separate Next.js docs app: duplicates existing root and design/theme ownership.

## Verification and risk

Run the authorized pnpm frozen install/build, TypeScript and generated Nextra route inspection; review source accessibility. Browser interactions and visual checks remain outside this cycle and must be recorded as not verified. Pin package versions and reconcile pnpm-lock; if registry access blocks lock generation, **report and keep the PR draft** rather than claiming a reproducible install. No deployment is authorized.

## TypeScript compatibility decision

Nextra 4.6.1 loads twoslash, whose declared compiler support is TypeScript `^5.5.0 || ^6.0.0`. The incoming website compiler at 7.0.2 caused production compilation to fail with `sys.readFile` unavailable. Pin only the website-owned compiler to 6.0.3 and synchronize the lockfile; other workspaces retain their existing 7.0.2 baseline. This is a bounded Nextra build compatibility correction, not a repository-wide compiler downgrade. The integration ticket records the subsequent build result.

## Build and identity recovery amendment

Native Next.js 16.4 Turbopack owns production compilation. Configure its supported `resolveAlias` for `next-mdx-import-source-file` to the application MDX components; this avoids the observed Nextra 4.6.1 legacy Webpack metadata failure without a custom build script. `/docs` is still the only authored MDX page and consumes the root page map.

Pin Zod 4.1.12 only for Nextra 4.6.1 and its Docs Theme through scoped pnpm overrides. The resolved 4.4.3 version rejects the theme's omitted `children` field during server rendering. This and the website-only TypeScript pin are bounded compatibility decisions; other workspace consumers keep their own dependency versions.

Production compilation exposed six corrupt binary assets already present in the base revision. Preserve their original bytes and moved social alt sidecars under existing `public/brand/`; restore active Apple and 512px manifest icons from the verified black-brand revision `706d6dae3eb7a95f68738448ae28e36fefd291a3`. Existing SVG and PNG favicon links remain active. Remove the corrupt ICO/social convention routes while retaining noindex and empty social image metadata. Legacy ICO-only clients and social image publication remain explicit limitations. The [current successor and retained provenance](../specs/0031-SPEC-website-docs-refresh.spec.md#retained-asset-provenance) owns exact byte provenance and checksums; the [focused specification](../specs/0024-SPEC-website-nextra-getting-started.spec.md#native-nextra-build-and-asset-recovery) bounds the affected paths and evidence.

The website implementer reported a successful production build, type check, active-PNG decoding, archived-source byte comparisons and generated HTML/metadata inspection. Final integration review records the checked snapshot separately. No browser verification, indexing, deployment or new brand design is claimed.
