# Nextra website entry, Orbo preview and Getting Started

- ID: `SPEC-WEB-DOCS`
- Document number: `SPEC-0024`
- Version: `1`
- State: `draft`
- Implementation authorization: owner's October 13, 2026 original request and PR #19 completion request; verification/review acceptance recorded separately.
- Integrated delivery: [SPEC-PR19-COMPLETION](0028-SPEC-pr19-completion.spec.md); this remains the focused contract, with the original stable ID preserved.
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

Footer: inline icon links with accessible names (verified GitHub and organization LinkedIn destinations; no nonexistent Exphere npm package link), and a small Orb plus literal `exphere by Grupo OLX © 2026`. The supplied footer wording is owner-directed; organizational endorsement is not independently authenticated.

Clipboard: label `npx exphere init`; button copies exactly these bytes, shows success or failure message via `aria-live`, keyboard usable. The command is **not implemented/published** by the Go scaffold yet and must not be presented as an executable supported feature. Display only the requested command box and copy feedback. Record the unsupported CLI/distribution state in the README; do not add unrequested implementation notes to the hero.

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
`src/app/layout.tsx`, `src/app/globals.css`, `src/app/template/website-footer.tsx`,
`DESIGN.md`, `IDENTITY.md`, removal of retired website script wrappers,
`next.config.mjs`, `package.json`, `README.md`, and optional Nextra metadata files
only where needed. Root `pnpm-workspace.yaml` may carry only the scoped Nextra
compatibility overrides described below; synchronize `pnpm-lock.yaml`.

The bounded asset recovery includes `src/app/apple-icon.png`,
`public/icons/app-512.png`, `public/icons/maskable-512.png`, and preservation of
six malformed baseline binaries under the existing `public/brand/` owner.
Move `src/app/favicon.ico`, `src/app/opengraph-image.png`,
`src/app/opengraph-image.alt.txt`, `src/app/twitter-image.png` and
`src/app/twitter-image.alt.txt` there so corrupt payloads are not active Next.js
metadata convention files. Preserve the replaced Apple and 512px originals
there as well. Relevant PRD/ADR/spec/ticket and repository docs may be updated
for supported behavior.

No new routes or services beyond `/docs`; no auth, audio recording, or actual
CLI install invocation.

## Test and review

Execute the authorized website typecheck, production compilation and generated HTML/CSS inspection. Inspect source for clipboard success/failure feedback, keyboard semantics, responsive layout, SSR-safe registration and reduced-motion configuration. Browser interaction/probe tests remain outside this cycle; record clipboard execution, visual/motion behavior and narrow/desktop appearance as not verified. The existing separate shader browser suite does not establish this website's interactive behavior.

Any inability to regenerate the pinned pnpm lockfile or complete authorized build checks is a blocking reproducibility gap. Static review is not browser evidence.

## TypeScript compatibility decision

Nextra 4.6.1 loads twoslash, whose declared compiler support is TypeScript `^5.5.0 || ^6.0.0`. The incoming website compiler at 7.0.2 caused production compilation to fail with `sys.readFile` unavailable. Pin only the website-owned compiler to 6.0.3 and synchronize the lockfile; other workspaces retain their existing 7.0.2 baseline. This is a bounded Nextra build compatibility correction, not a repository-wide compiler downgrade. The integration ticket records the subsequent build result.

## Native Nextra build and asset recovery

- Use native `next build` with Next.js 16.4 Turbopack. Nextra 4.6.1's legacy Webpack loader misclassifies the MDX metadata. The supported `turbopack.resolveAlias` maps `next-mdx-import-source-file` to `./src/mdx-components.tsx`; the Docs layout uses the root page map for the single authored `/docs` leaf.
- Scope pnpm overrides to `nextra@4.6.1>zod` and `nextra-theme-docs@4.6.1>zod` at 4.1.12. Resolved Zod 4.4.3 rejects the theme's omitted `children` field during server rendering. Do not globally override unrelated Zod consumers. Retain the website-only TypeScript 6.0.3 decision above and include these pins in upgrade review.
- Preserve all six malformed baseline image files byte-for-byte under `public/brand/`; the [identity record](../../../apps/website/IDENTITY.md) contains their paths, defects and SHA-256 checksums. Recover only the active Apple and 512px application/maskable icons from black-brand revision `706d6dae3eb7a95f68738448ae28e36fefd291a3`. This is recovery of existing geometry, not a logo redesign. The valid existing SVG/PNG favicons remain active.
- No active ICO or social-image metadata convention files remain. Legacy clients requiring only `/favicon.ico` and future social sharing retain explicit limitations. The origin/indexing decision and empty social image lists stay unchanged; valid replacement exports require a future verified change.

Website verification reported successful production compilation and type checking, decoding of the five active PNG assets, byte identity of all six archived originals against baseline `d6b3c8a`, and generated HTML containing one heading per page, exact requested copy, the Docs link, noindex directives, and decorative listening orbs. Record the final integrated source snapshot and command evidence in INTEGRATE-01; these observations do not establish browser clipboard, motion, rendering or production behavior.

## Website-only correction — October 13, 2026

The owner rejected the rendered PR #19 website and requested rollback followed by
a correction limited to the website. Skill installation, CLI and repository-wide
tooling are outside this follow-up. Production was rolled back to deployment
`dpl_9yCnQQJH5FAmUHw3XVeiPjnTSMbc` at source `d6b3c8a`.

Browser inspection reproduced the defect: the shared shader stylesheet introduced
the utilities cascade layer before the application bootstrap introduced base.
Base resets therefore overrode utility typography and spacing on both routes.
Import application CSS first and explicitly order Tailwind cascade layers; retain
the shared shader package unchanged. Native Nextra page metadata limits the sidebar
to Getting Started and removes redundant breadcrumbs/table-of-contents chrome.

The current owner request authorizes direct browser inspection of the corrected
website, superseding the earlier static-only scope for this follow-up. Verify the
production build at desktop and mobile widths, clipboard success/failure, internal
navigation, decorative Orbo registration/state and reduced motion. This does not
authorize new application test infrastructure. Record the actual evidence in
WEB-DOCS-01.

The owner subsequently requested a slightly smaller header orb while inspecting
the corrected browser view. Header/docs logo orbs use 1.5rem (24px), centered
with the existing Exphere text, shifted down 2px for the owner's subsequent
optical-alignment request; the footer remains 1.5rem.
