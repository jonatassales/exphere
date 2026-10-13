# Nextra website entry, Orbo preview and Getting Started

- ID: `SPEC-WEB-DOCS`
- Document number: `SPEC-0024`
- Version: `1`
- State: `approved for owner-requested implementation; verification pending`
- PRD: [PRD-EXPHERE-DOCS-WEBSITE](../prd/0006-PRD-exphere-documentation-site.prd.md)
- ADR: [ADR-0004](../design/0012-DD-documentation-architecture.dd.md)
- Ticket: [WEB-DOCS-01](../tickets/0046-TICKET-website-nextra-entry.ticket.md)
- Technical owner: website implementer
- Baseline: `d6b3c8abff240c54011f81f7088f445e3fbabef4`.

## Contract

The existing Next.js App Router home page remains a server-rendered first entry. The visual design follows the site's dark/purple Exphere DESIGN.md and retains a single existing ExphereShader background. The right CLI card disappears. One **centered, slightly wider** hero includes exactly one `h1`, the owner's exact title and description and one interactive dark copy field for `npx exphere init`. The header label becomes `Documentation`, linking to `/docs`.

Header: an `orbo-voice` native `<orb-o>` element appears **left** of the Exphere text logo, aligned in scale, using `state="listening"`, dark grayscale colors and reduced-motion `system`. This is a **visual demo**, not evidence of recording or an active microphone. Register the web component only in a small client boundary; preserve SSR accessibility.

Hero copy:
- eyebrow `DevEX / FinOps Platform`
- headline `Exphere - Full blast agentic FinOps runtimes`
- description `Exphere explores FinOps principles, agent-assisted software delivery, and consumer-composed microruntimes.`
- delete the early-stage disclaimer, right CLI card, the prior "Hosted in the repository" note and other removed marketing copy.

Footer: inline icon links with accessible names (only verified GitHub, npm and organization LinkedIn destinations), and a small Orb plus literal `exphere by Grupo OLX © 2026`. The supplied footer wording is owner-directed; organizational endorsement is not independently authenticated.

Clipboard: label `npx exphere init`; button copies exactly these bytes, shows success or failure message via `aria-live`, keyboard usable. The command is **not implemented/published** by the Go scaffold yet and must not be presented as an executable supported feature.

Nextra 4 Docs Theme is integrated via its official Next.js plugin, required `mdx-components` file and an App Router `/docs` MDX Getting Started page. The owner requested no other substantive docs. `/` remains the initial hero entry with a working Docs link to `/docs`. Maintain current page/noindex metadata and light/dark state (dark only), including within Docs.

## Requirements

| ID | Requirement |
| --- | --- |
| DOCS-01 | Header Documentation and black/gray listening Orbo left of mark, SSR-safe, motion-only. |
| DOCS-02 | Centered/wider single hero with all exact requested text, no right card/disclaimer/hosted hint. |
| DOCS-03 | Copy-to-clipboard control with reliable status/error states, no hidden execution or unsupported success claim. |
| DOCS-04 | Real Nextra Docs framework and one Getting Started MDX page reachable at `/docs`. |
| DOCS-05 | Footer Orb, owner text, verified accessible SVG social links. |
| DOCS-06 | Preserve ExphereShader background, tokens, black logo sources, and noindex/unknown origin; avoid new frameworks beyond explicit Nextra/Orbo. |
| DOCS-07 | App dependency declarations and lockfile synchronized; build/typecheck/relevant accessibility review required for merge. |

## Allowed changes

`apps/website/src/app/page.tsx`, `src/app/docs/layout.tsx`,
`src/app/docs/page.mdx`, `src/app/template/orbo-preview.tsx`,
`src/app/template/copy-command.tsx`, `src/mdx-components.tsx`,
`next.config.mjs`, `package.json`, `README.md`, optional Nextra
metadata files only where needed and `pnpm-lock.yaml`. Relevant PRD/ADR/spec/ticket
and repository docs may be updated for supported behavior.

No new routes or services beyond `/docs`; no auth, audio recording, or actual
CLI install invocation.

## Test and review

Check Next.js typecheck, app build, MDX render, command clipboard in success/
failure (mock clipboard where necessary), keyboard/focus, narrow/desktop
layout, shader visible and reduced motion. No synthetic no-op test counts.
Any inability to regenerate pinned pnpm lockfile is a **blocking gap** for
frozen CI/merge; declare it explicitly.
