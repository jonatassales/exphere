# Website hero and documentation entry point

Reference maintenance: successor links below point to the later website refresh, not to the source reviewed in this historical cycle. Original revisions and review hashes remain authoritative.

- ID: `SPEC-WEBSITE-HERO-DOCS`
- Document number: `SPEC-0021`
- Version: `2`
- State: `source implemented; in review; runtime verification pending`
- PRD: [PRD-0001](../prd/0001-PRD-exphere.prd.md) — broader product direction; organizational acceptance remains unproven.
- Visual contract: [ADR-0002](../design/0010-DD-website-design-system-branding.dd.md) and [current successor and retained provenance](0031-SPEC-website-docs-refresh.spec.md#retained-asset-provenance).
- Technical owner: website implementer; project owner retains production, docs-hosting, and launch decisions.
- Ticket: [WEB-HERO-01](../tickets/0043-TICKET-website-hero-documentation.ticket.md).
- Baseline: `6133b4cfb8b83adf5929f5c055d6e46631e50778` (`main`, after PR #14 merged).
- Authorization: the owner's October 13, 2026 follow-up requests a ClickHouse-design-based hero page with a documentation link, then explicitly corrects the scope to retain the existing motion background. This version supersedes the unimplemented motion-removal decision in v1. The current scoped implementation and prior same-repository feature-branch/PR delivery instruction authorize this bounded change and a PR; merge and deployment are not authorized.

## Problem and outcome

The home route currently renders an empty container with the earlier shader behind it. Visitors cannot learn what Exphere is or reach the existing documentation from that page.

Create one concise, accessible hero that introduces the experimental Exphere project and leads directly to available documentation. Apply the **existing Exphere adaptation** of the ClickHouse design language: black branding, bold sans headings, restrained spacing/radii, technical monospace detail, subtle hairlines, and flat, lightly translucent neutral content surfaces that leave the existing shader visibly animated behind the page. Do not copy ClickHouse yellow or its product-specific copy.

## User story

As someone visiting the Exphere website, I want a clear description of the experimental project and a working documentation link so I can learn about the current CLI and microruntime approach.

## Contract and composition

- The existing Next.js App Router `/` page remains a Server Component.
- A single hero contains a small text-based Exphere masthead, accessible `h1`, factual supporting text, a visible **Read documentation** link, and an optional code-style CLI example grounded in commands already documented in the repository.
- The documentation destination is the current [repository README](https://github.com/jonatassales/exphere#readme). This repository is private; the link is not a claim that public docs hosting exists. Do not create an unimplemented `/docs` route or invent a separate docs domain.
- The previous home SVG logo remains disabled; a plain typographic project name in the masthead is not its restoration.
- **Retain the existing `ExphereShader` mount and motion background** in the website root layout, unchanged, as explicitly required by the owner. Its inherited shader colors and animation are a narrowly scoped, pre-existing exception to the flat/no-new-gradient UI guidance; black is still the only authored Exphere brand color. Do not recolor, remove, disable, or cover the motion with an opaque full-viewport surface.
- Use existing Tailwind utilities and the website's approved neutral/black palette. Keep `@repo/design` generic. No new style sheet or shared token migration is needed for this single hero.
- Leave metadata, noindex, robots, manifest, favicon/social assets, dependencies, scripts, and deployment configuration unchanged.

## Acceptance

| ID | Behavior | Verification |
| --- | --- | --- |
| REQ-HERO-01 | Home presents an informative hero. | Exactly one visible `h1`, brief factual experimental-product description, and masthead; no claimed production features. |
| REQ-HERO-02 | Docs CTA is usable. | Real anchor labeled "Read documentation" leads to the repository README, has a visible focus state and adequate contrast; no invented `/docs`. |
| REQ-HERO-03 | Visual contract is respected. | Black-only authored branding, bold hierarchy, translucent white/neutral contrast surfaces, hairline panel, small radii, and technical monospace content; no new chromatic accents, gradients, shadows, or remote assets. The unchanged existing animated shader is a documented exception. |
| REQ-HERO-04 | Hero adapts to devices. | Single-column on narrow screens and 2-column editorial/CLI layout on desktop, with readable text and no forced horizontal page scrolling. |
| REQ-HERO-05 | CLI preview is truthful. | Only `pnpm ex runtime list` and `pnpm ex runtime billing init`, matching the root README; no fabricated output. |
| REQ-HERO-06 | Motion remains intact. | The existing root layout continues mounting `ExphereShader` unchanged, the animation remains visible behind hero content, and no new client module/dependency is introduced. |
| REQ-HERO-07 | Existing SEO/identity contract holds. | Root and page metadata, `noindex`, manifest, robots, favicon/social images, and hidden SVG logo are not activated or rewritten. |
| REQ-HERO-08 | Traceable delivery. | One parent spec and ticket, review against fixed `main` baseline, evidence for available checks, one Ticket trailer per commit and an actual PR `Spec:` declaration. |

## Allowed change manifest

- `.exphere/artifacts/specs/0021-SPEC-website-hero-documentation.spec.md`
- `.exphere/artifacts/tickets/0043-TICKET-website-hero-documentation.ticket.md`
- `apps/website/src/app/page.tsx`
- the retired website visual contract
- `apps/website/README.md`

## Ownership and operation

The website owns its presentation and docs link. Shared `@repo/design` and `@repo/web` contracts are unchanged. There are no secrets, servers, API requests, backing services, paid models, analytics, or launch/indexing changes. Link follows an external destination and does not create runtime state.

## Decisions and trade-offs

- **DOCS-01 — Existing documentation:** select GitHub README as the only verified documentation landing. It requires repository access while the repository is private; future public docs hosting is an independent decision.
- **VIS-01 — Shader:** retain the pre-existing animated `ExphereShader` root mount. The owner's explicit preservation requirement overrides the general no-gradient rule for this existing motion layer only. Keep the hero surface transparent overall; only individual content areas may use static, translucent white for readability. No shader modification or new animation is authorized.
- **CONTENT-01 — Truthful copy:** distinguish the experimental project from a completed workflow engine. The code card shows commands, not invented runtime output.
- **STYLE-01 — Tokens:** use static Tailwind utilities and existing neutral/black roles locally without editing generic token sources, framework bootstrap CSS, or introducing additional style files.
- **SCOPE-01 — SEO:** visual navigation does not approve indexability or a production origin.

## Verification plan

1. Review source against the accepted design and this spec; inspect semantic heading, CTA URL, readable/focus classes, and CLI commands. Verify the root shader mount is unchanged and remains visible through the page's transparent layout.
2. Run existing `pnpm --filter website typecheck`, `pnpm build --filter=website...`, and `pnpm check` with the installed repository toolchain when available. Inspect built HTML for a single hero heading and docs anchor if a build environment is available; do not add a test framework just for this slice.
3. Review `main...branch` on independent Standards and Spec axes following the local SDD rule; report honestly if the independent agents are unavailable.
4. Confirm unchanged SEO asset/metadata scope and published PR traceability. Missing evidence is not a passing check.

### Evidence

Source review snapshot: implementation commit `eab6e044ccbba6ecd4ba0004fe6ec8de7b02d0dd`,
against fixed `main` baseline `6133b4cfb8b83adf5929f5c055d6e46631e50778`.

The GitHub compare reports three commits ahead, zero behind and exactly five scoped
files changed: this spec, WEB-HERO-01 ticket, website page, website README, and
retired website visual contract. No root-layout, shader, package, lockfile, Tailwind bootstrap,
metadata, robot policy, social image, manifest, or deployment change exists.

Implementation source identities:

- `apps/website/src/app/page.tsx` Git blob: `07b9b6d9a88046c383814e52aa8b4a1c2babcbf0`.
- the retired website visual contract Git blob: `44221edd04a2bf667f6705a8b5813b0a8de3fe10`.
- `apps/website/README.md` Git blob: `3ef0f406fbfc2b20e410bfb62cf46542d189e4ff`.
- `apps/website/src/app/layout.tsx` remains baseline blob
  `2f3afff8c66e37da29c0d9e2e4b6a3a07ffb18e3` with
  `<ExphereShader>{children}</ExphereShader>` intact.

Static source inspection verifies the single rendered `h1`, an external
documentation anchor with focus-visible affordances and safe new-tab attributes,
two documented CLI commands, responsive grid and scrollable code examples,
static translucent white content surfaces, black CTA, and the still-commented
home SVG logo. No CLI output is fabricated.

### Standards axis

Sequential source-level review against `AGENTS.md`, the website design
contract, local styling/Next.js/frontend rules and SDD v1 found no actionable
violation. The route remains a Server Component, component styling uses Tailwind,
semantic App Router metadata is untouched, no authored selector CSS or new
dependency was added, and the site-specific exception accurately preserves the
owner-approved animated shader. The two small static command rows intentionally
share presentation markup without adding an unnecessary component abstraction.

### Spec axis

Sequential source-level review confirms REQ-HERO-01 through REQ-HERO-07
at the inspected source revision. REQ-HERO-08 is only partially verified:
three commits use one `Ticket: WEB-HERO-01` trailer; final PR publication and
independent review still require inspection. The changed layout does **not**
remove, recolor, or obscure the existing shader with an opaque full-screen layer.
No unapproved docs route, claimed production capability, or launch/indexing
metadata has been introduced.

### Unverified execution and review

The connector execution has no checked-out workspace or installed project
toolchain. Next.js production build, TypeScript checks, Biome, real browser
rendering, animation visibility during actual playback, and focus contrast under
live motion were **not run**. Source-level preservation is not a browser test.

The local code-review skill calls for parallel independent sub-agents; this
execution only performed sequential manual Standards/Spec inspection. Prior
repository CI runs used a disabled provider configuration and cannot be assumed
to supply independent approval for this change. The PR must record actual CI
results separately. No work is marked done or merge-ready from these checks.

