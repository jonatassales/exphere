# Website identity and non-indexable SEO foundation

- ID: `SPEC-WEBSITE-IDENTITY-SEO`
- Document number: `SPEC-0017`
- Version: `1`
- State: `source implemented; in review; execution verification blocked`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md); broad product approval remains unrecorded. This change follows the owner's direct request.
- Technical owners: the project owner owns identity and launch decisions; the implementing agent owns scoped implementation and evidence. No independent human review is asserted.
- Authorization: the October 12, 2026 request supplies the identity ZIP, visual reference, and Staff SEO Engineer role, and requests `to-spec`, new `to-tickets`, implementation, and a final PR with scoped auto-approval and no human interruption. It authorizes this bounded work, local verification, commits, and PR creation, not merging, deployment, provisioning, paid execution, production access, or invented origin/entity facts.
- Initial baseline: `d315a4249323f62c61c1c6d47e4878ba93269c53` on main.
- Reconciled main: `2865485fece84a39b49d2d28268f692b538bd283`.
- Tickets: [WEB-ID-01](../tickets/0038-TICKET-website-brand-identity.ticket.md), [WEB-SEO-01](../tickets/0039-TICKET-website-seo-foundation.ticket.md).

## Contract and composition

The existing Next.js 16.4.0 / React 19.3.0 website retains one en-US route at `/`, its Tailwind styling, and the unchanged `ExphereShader` wrapper. Replace only the visible heading with the supplied horizontal Exphere logo at the upper left, retaining its accessible Exphere heading. Add no navigation, hero, descriptive body copy, footer, gallery, runtime demonstration, or other visible content.

Use the existing pnpm 12.4.2 / Turborepo workspace and Node >=22.22.1 contract. Add no dependencies, scripts, services, secrets, environment variables, or request-host-derived URLs. The production origin remains unknown. Framework-convention assets are static files under `src/app`; public logo and manifest resources use `public/`. Root document and page metadata retain their respective ownership. A single page requires no metadata helper framework, locale catalog, or empty directory.

### Requirements and acceptance

| ID | Required behavior | Acceptance criterion |
| --- | --- | --- |
| REQ-IDSEO-01 | Minimal home identity. | One left-aligned logo and accessible Exphere heading, with no additional visible content or authored client module. Shader and design packages remain unchanged. |
| REQ-IDSEO-02 | Owner-supplied artwork. | SVG geometry and colors match the pack; raster provenance and transformations are documented. No font files are included. |
| REQ-IDSEO-03 | Browser/application identity. | Static ICO, SVG/raster icons, opaque 180px Apple icon, manifest, and 192/512px and maskable resources are valid. Every manifest icon resolves to a packaged asset. Browser display promises no offline application. |
| REQ-IDSEO-04 | Document and page metadata. | Root owns application name, null/unset production metadata base, light viewport, and noindex default. Home owns title, description, and en-US social copy grounded in product facts and microruntime terminology. |
| REQ-IDSEO-05 | Truthful social assets without a fake origin. | Static PNGs and alt sidecars live directly under `src/app`. The card contains only the approved identity. Explicit empty image lists defer URL emission until an origin is accepted, without manually duplicating framework-owned image descriptors. |
| REQ-IDSEO-06 | Safe launch deferral. | Home stays noindex and crawlable. No canonical, sitemap, entity graph, social profile, hreflang, AI-specific crawler policy, or llms file is fabricated. Robots has no invented host or sitemap directive. |
| REQ-IDSEO-07 | Bounded diff. | Existing tickets, packages, lockfile, workflow, deployment config, shader, and token sources are unchanged. No generic icon library or pack generator is imported. |
| REQ-IDSEO-08 | Traceable, honest delivery. | Spec/ticket history precedes implementation; each commit has one Ticket trailer and the PR has the Spec declaration. Source/asset checks and both review axes identify their snapshot. Missing execution evidence prevents done or merge-ready claims. |

### Allowed change manifest

This spec and its two new tickets; plus these 18 files under `apps/website`:

- `src/app/page.tsx`, `layout.tsx`, `favicon.ico`, `icon.svg`, `icon1.png`, `apple-icon.png`, `manifest.webmanifest`, `robots.txt`.
- `src/app/opengraph-image.png`, `opengraph-image.alt.txt`, `twitter-image.png`, `twitter-image.alt.txt`.
- `public/brand/exphere-logo.svg`; `public/icons/app-192.png`, `app-512.png`, `maskable-512.png`.
- `README.md` and `IDENTITY.md`.

Missing origin-bearing artifacts are intentionally not written with placeholders. The complete identity pack stays outside the repository. Paths are explicit to satisfy the supplied SEO role's bounded-diff requirement.

## Responsibilities

- Consumer: supplies the identity and owns future origin, indexing intent, entity facts, and launch decisions.
- Platform: preserves existing package, framework, static metadata, and SDD boundaries; introduces no approval service or executor.
- Service owners: no production service is touched and no operator, budget, SLA, or launch date is assigned.

## Operation and limits

Existing local file inspection and GitHub publication are the only execution effects. No backing service, runtime integration, paid provider, or cloud resource is created; local consumption is unmeasured. Diagnostics are command results and file/revision records, not telemetry. Static assets add no export-time tool to the application dependency graph.

Preserve the existing build and run commands. Toolchain failures remain verification blocks; do not weaken gates or change dependency versions to manufacture a pass. Asset removal reverses only the owned files. No postinstall, environment wrapper, image generator, service worker, or new test infrastructure is introduced. Browser audits, production/DNS, analytics, Search Console, localization, other pages/packages, and merge remain outside this cycle.

## Verification and decisions

Local SDD v1 applies to commit/PR traceability. Existing website compilation/generated-artifact verification remains required. Dependency, configuration, build/run, logging, and service boundaries are unchanged; this source change does not establish blanket Twelve-Factor or FinOps compliance, capacity, availability, performance, or zero-cost claims.

### BASE-IDSEO-01 — Re-baseline and concurrent planning

Source inspection at the initial baseline confirmed one home page, en-US/light document, shader wrapper, title-only metadata, and no public directory or identity/SEO convention assets. The role's older layout-reference branch was merged into main. Fresh prerendered HTML, rendering mode, redirects, missing-page behavior, hydration, and shader execution were not reverified; cached role observations remain historical evidence.

Planning was committed first as `273b368f55a770b2c08c251e7735827fbbb8f97c`, followed by identity implementation `433c6e6189048179aeacb1a885bcf742a97e0fb8` and SEO implementation `ea7bc05e1f82e65dc19822639170aa2d94c6b0d8`. Each identifies its stable ticket. The first planning revision used SPEC-0013 and TICKET-0028/0029.

While work proceeded, main advanced to `2865485fece84a39b49d2d28268f692b538bd283`, adding only 14 consumer-harness planning documents. Their numbers occupy SPEC-0013 through 0016 and TICKET-0028 through 0037. This cycle therefore renumbers only its own documents to SPEC-0017 and TICKET-0038/0039, preserving stable IDs, the docs-first history, and every concurrent document. No force push or history rewrite is used. The executable website source and applicable policies did not change in that main advance.

### DEC-IDSEO-01 — Identity and scope

- Type: scope; state: selected under delegated task authority.
- Requester and authorized human owner: project owner in the October 12 request. Artifacts assessed: this spec v1, supplied identity ZIP and SEO role.
- Context/options: importing the whole pack adds unused UI and generators; selecting only consumed assets fulfills the request with less surface area.
- Recommendation and consequences: retain the exact SVG masters, document optimized raster exports, use a brand-only sharing card, and keep the page to one logo.
- Actual decision: the request establishes supplied identity use, left placement, no extra UI, and autonomous scoped delivery. Asset selection is an implementation decision, not independent trademark or brand clearance. The phrase 'no new client boundary' means no authored client module; `next/image` retains its own framework implementation and no zero-JavaScript claim is made.

### DEC-IDSEO-02 — Origin and indexing

- Type: scope; state: launch decisions open, safe implementation selected.
- Owner: project owner; artifacts assessed: this spec v1 and supplied SEO role.
- Context/options: a repository homepage is not an accepted production-origin contract. Guessing a domain makes an unsupported public claim; blocking all identity work is unnecessary; an origin-neutral non-indexable foundation preserves progress.
- Recommendation and consequences: choose the last option. Set no production metadata base, canonical, Open Graph URL, sitemap, entity graph, or social profile. Explicit `images: []` at root and home gates automatic image URL resolution. Static cards remain prepared but inactive as sharing metadata. Robots allows crawling so noindex is discoverable.
- Actual decision: no production origin or launch is approved. Before an indexable release, accept the origin/policy and update root base, page canonical/Open Graph URL, social-image activation, static sitemap/robots, and verification together. Non-production sites must retain noindex. Entity facts and measurement remain future owner decisions.

### DEC-IDSEO-03 — Verification and publication

- Type: scope; state: implementation/publication authorized, verification conditions retained.
- Owner: project owner; artifacts assessed: this spec v1 and existing website/SDD contracts.
- Context/options: the executor has Node 22.16.0, no pnpm/Next installation, and cannot resolve GitHub for a shell clone. It has no independent parallel reviewer tool. Claiming success or weakening gates is not acceptable.
- Recommendation and consequences: complete independently checkable work and publish a draft PR with the blockers explicit. Source inspection does not replace compilation or independent review. Git API publication cannot run checkout hooks and is not evidence those hooks passed.
- Actual decision: scoped commits and a PR are authorized; missing checks are not waived. Tickets remain in review and the PR is not merge-ready. No deployment or merge is performed.

### VER-IDSEO-01 — Existing application boundary

1. Inspect the ZIP safely. Verify SVG structure, image decoding/dimensions, Apple opacity, ICO frames, maskable safe zone, manifest references, and provenance.
2. Compare source against the pinned baseline: one logo/heading, no extra UI or authored client module, unchanged shader/document shell, truthful copy, noindex/crawlability pairing, no invented origin/entity data.
3. With the existing installed toolchain, run `pnpm --filter website typecheck`, `pnpm build --filter=website...`, `pnpm check`, and the existing pre-push build/test gate. Inspect generated HTML and route manifests for actual metadata/rendering behavior and missing-page semantics. Do not add a new test runner.
4. Review the same manifest and revisions on Standards and Spec axes. Record any lack of independent sub-agents; refresh affected review after material changes.
5. Verify the published diff, parent ancestry, stable Ticket trailers, and actual PR Spec declaration. Retain all required evidence gaps.

### EVID-IDSEO-01 — Observed results

The inspected application source is `ea7bc05e1f82e65dc19822639170aa2d94c6b0d8`; final reconciliation changes only its README spec link, not executable source or assets. The final 18-file website manifest has SHA-256 `1380879bf8303fc10f50d13ce8ef2af2b4e195852b419bc8f0a2c2d1f869ea4b`. Reconstruct it by sorting paths and serializing an array of objects with sorted keys `git_blob`, `path`, `sha256`, compact JSON and no final newline. Asset hashes are also published in `apps/website/IDENTITY.md`.

| Check | Actual result |
| --- | --- |
| Safe ZIP and SVG inspection | Passed: no path traversal; supplied SVGs contain allowed vector nodes, no executable handlers, external references, or font files. |
| Raster and manifest inspection | Passed: PNGs decode; ICO has 16/32px frames; Apple is 180px and opaque; manifest points to actual 192/512px resources. |
| Maskable and social assets | Passed: maximum foreground radius 160.538px is inside the 204.8px safe radius; social cards are identical 1200x630 PNGs. |
| Source and hash review | Passed within inspected source: minimal logo composition, root/page metadata ownership, noindex, no fabricated origins, unchanged shader/packages and preserved source SVGs. Remote logo/page/layout blob hashes match local inspected copies. |
| Typecheck, website build, Biome | Each command was attempted and stopped with `pnpm: command not found` before the application check ran. Not verified; this is not a successful or completed application build. |
| Existing build/test and generated HTML | Not run: no installed project toolchain/full checkout. Rendering, metadata resolution, redirects, and missing-page behavior remain not verified. |
| Browser, production, indexing, vitals | Not run or measured; outside the exercised scope. |

#### Standards

Sequential self-review of the identified source/asset snapshot found no remaining actionable source defect against the loaded Exphere rules in this scope. Static-file ownership, Tailwind composition, one component per file, server-authored page, safe assets, explicit provenance, and no speculative dependencies were inspected. Missing toolchain evidence and independent reviewer execution remain open. This is not the skill's independent parallel-subagent review and not blanket standards compliance.

#### Spec

Separate sequential self-review of the same snapshot confirms REQ-IDSEO-01 through 07 in source/assets, with actual rendered behavior still unverified. REQ-IDSEO-08 is incomplete until the required execution/review evidence exists; final PR traceability is checked at publication. Origin-dependent metadata is deliberately deferred by DEC-IDSEO-02, not silently replaced with guessed values. No extra page content, dependency, or production work was introduced.

Summary: no remaining actionable source defects observed in either manual axis; execution and independent-review evidence are incomplete. This status blocks done and merge readiness, not publication of clearly marked draft work.

## References and adaptation

- Supplied `exphere-identity-seo.zip`, SHA-256 `c1a0bd65799cbcd77dbf63371984f39ea5e551d423a1d86e9b9e6d414ded61ad`, and Staff SEO Engineer role. Identity provenance and raster changes are recorded with the application.
- Vidro website reference at `ba9966c0d0f4daaee68a3b71181639cb0c3a2158` informed coverage only. Exphere's static-file and single-route contracts override its generators, locales, origin, and entity data; no third-party implementation was copied.
- Next.js v16.4.0 `packages/next/src/lib/metadata/metadata-resolution-primitives.ts`: `mergeStaticMetadata` skips file-derived social images when the segment explicitly owns `images`. This is version-matched source inspection, not a local runtime test.
