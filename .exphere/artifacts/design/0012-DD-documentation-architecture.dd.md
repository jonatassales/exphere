# Nextra documentation entry architecture

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

Run pnpm frozen install/build, TypeScript, Nextra MDX routing, accessibility and browser checks before merge. Pin package versions and reconcile pnpm-lock; if registry access blocks lock generation, **report and keep the PR draft** rather than claiming a reproducible install. No deployment is authorized.
