# Website hero and documentation entry point

- ID: `SPEC-WEBSITE-HERO-DOCS`
- Document number: `SPEC-0021`
- Version: `1`
- State: `approved for scoped implementation; verification pending`
- PRD: [PRD-0001](../prd/0001-PRD-exphere.prd.md) — broader product direction; organizational acceptance remains unproven.
- Visual contract: [ADR-0002](../design/0010-DD-website-design-system-branding.dd.md) and [website DESIGN.md](../../../apps/website/DESIGN.md).
- Technical owner: website implementer; project owner retains production, docs-hosting, and launch decisions.
- Ticket: [WEB-HERO-01](../tickets/0043-TICKET-website-hero-documentation.ticket.md).
- Baseline: `6133b4cfb8b83adf5929f5c055d6e46631e50778` (`main`, after PR #14 merged).
- Authorization: the owner's October 13, 2026 follow-up requests a ClickHouse-design-based hero page with a documentation link. The current scoped implementation and prior same-repository feature-branch/PR delivery instruction authorize this bounded change and a PR; merge and deployment are not authorized.

## Problem and outcome

The home route currently renders an empty container with the earlier shader behind it. Visitors cannot learn what Exphere is or reach the existing documentation from that page.

Create one concise, accessible hero that introduces the experimental Exphere project and leads directly to available documentation. Apply the **existing Exphere adaptation** of the ClickHouse design language: white canvas, black branding, bold sans headings, restrained spacing/radii, technical monospace detail, subtle hairlines, and flat surfaces. Do not copy ClickHouse yellow or its product-specific copy.

## User story

As someone visiting the Exphere website, I want a clear description of the experimental project and a working documentation link so I can learn about the current CLI and microruntime approach.

## Contract and composition

- The existing Next.js App Router `/` page remains a Server Component.
- A single hero contains a small text-based Exphere masthead, accessible `h1`, factual supporting text, a visible **Read documentation** link, and an optional code-style CLI example grounded in commands already documented in the repository.
- The documentation destination is the current [repository README](https://github.com/jonatassales/exphere#readme). This repository is private; the link is not a claim that public docs hosting exists. Do not create an unimplemented `/docs` route or invent a separate docs domain.
- The previous home SVG logo remains disabled; a plain typographic project name in the masthead is not its restoration.
- The site-wide shader currently introduces a purple gradient and animation, contrary to the accepted white/black flat visual direction. Stop mounting `ExphereShader` in the website root layout; keep the shared component/package unchanged.
- Use Tailwind classes and a minimal app-local semantic token bridge for website colors. Keep `@repo/design` generic.
- Leave metadata, noindex, robots, manifest, favicon/social assets, dependencies, scripts, and deployment configuration unchanged.

## Acceptance

| ID | Behavior | Verification |
| --- | --- | --- |
| REQ-HERO-01 | Home presents an informative hero. | Exactly one visible `h1`, brief factual experimental-product description, and masthead; no claimed production features. |
| REQ-HERO-02 | Docs CTA is usable. | Real anchor labeled "Read documentation" leads to the repository README, has a visible focus state and adequate contrast; no invented `/docs`. |
| REQ-HERO-03 | Visual contract is respected. | White background, black branding, bold hierarchy, hairline panel, small radii, technical monospace content; no new yellow, purple, gradients, shadows, or remote assets. |
| REQ-HERO-04 | Hero adapts to devices. | Single-column on narrow screens and 2-column editorial/CLI layout on desktop, with readable text and no forced horizontal page scrolling. |
| REQ-HERO-05 | CLI preview is truthful. | Only `pnpm ex runtime list` and `pnpm ex runtime billing init`, matching the root README; no fabricated output. |
| REQ-HERO-06 | No unnecessary runtime effects. | Remove the root shader mount without changing `@repo/web` source; page remains server-authored and adds no dependency or client component. |
| REQ-HERO-07 | Existing SEO/identity contract holds. | Root and page metadata, `noindex`, manifest, robots, favicon/social images, and hidden SVG logo are not activated or rewritten. |
| REQ-HERO-08 | Traceable delivery. | One parent spec and ticket, review against fixed `main` baseline, evidence for available checks, one Ticket trailer per commit and an actual PR `Spec:` declaration. |

## Allowed change manifest

- `.exphere/artifacts/specs/0021-SPEC-website-hero-documentation.spec.md`
- `.exphere/artifacts/tickets/0043-TICKET-website-hero-documentation.ticket.md`
- `apps/website/src/app/page.tsx`
- `apps/website/src/app/layout.tsx`
- `apps/website/src/app/globals.css`
- `apps/website/README.md`

## Ownership and operation

The website owns its presentation and docs link. Shared `@repo/design` and `@repo/web` contracts are unchanged. There are no secrets, servers, API requests, backing services, paid models, analytics, or launch/indexing changes. Link follows an external destination and does not create runtime state.

## Decisions and trade-offs

- **DOCS-01 — Existing documentation:** select GitHub README as the only verified documentation landing. It requires repository access while the repository is private; future public docs hosting is an independent decision.
- **VIS-01 — Shader:** stop mounting the site shader rather than obscuring an actively rendered purple canvas under an opaque page. The component remains available in its shared package.
- **CONTENT-01 — Truthful copy:** distinguish the experimental project from a completed workflow engine. The code card shows commands, not invented runtime output.
- **STYLE-01 — Tokens:** expose site-only neutral/black roles through the existing Tailwind bootstrap rather than changing generic package tokens or adding CSS selectors.
- **SCOPE-01 — SEO:** visual navigation does not approve indexability or a production origin.

## Verification plan

1. Review source against the accepted design and this spec; inspect semantic heading, CTA URL, readable/focus classes, and CLI commands.
2. Run existing `pnpm --filter website typecheck`, `pnpm build --filter=website...`, and `pnpm check` with the installed repository toolchain when available. Inspect built HTML for a single hero heading and docs anchor if a build environment is available; do not add a test framework just for this slice.
3. Review `main...branch` on independent Standards and Spec axes following the local SDD rule; report honestly if the independent agents are unavailable.
4. Confirm unchanged SEO asset/metadata scope and published PR traceability. Missing evidence is not a passing check.

### Evidence

Awaiting the implementation snapshot and review. Do not mark the ticket done without verification.
