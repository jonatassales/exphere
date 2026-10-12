# Website identity and non-indexable SEO foundation

- ID: `SPEC-WEBSITE-IDENTITY-SEO`
- Document number: `SPEC-0013`
- Version: `1`
- State: `authorized scope; implementation and verification pending`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md); broad product approval remains unrecorded. This bounded change follows the owner's direct request.
- Technical owners: the project owner owns brand and launch decisions; the implementing agent owns this scoped proposal, implementation, and evidence. No independent human reviewer is asserted.
- Authorization: the October 12, 2026 conversation request supplies the identity ZIP, visual reference, and Staff SEO Engineer role; explicitly requests `to-spec`, new `to-tickets` work without changing existing tickets, implementation through a final PR, and scoped auto-approval without human interruption. This covers local verification, feature-branch commits, and PR creation. It does not authorize deployment, provisioning, paid execution, production access, merging, or fabricated origin/entity facts.
- Baseline: `main` at `d315a4249323f62c61c1c6d47e4878ba93269c53`, tree `ff606e759a22004a32311ba8f1f23ccdd0842dea`.
- Tickets: [WEB-ID-01](../tickets/0028-TICKET-website-brand-identity.ticket.md), [WEB-SEO-01](../tickets/0029-TICKET-website-seo-foundation.ticket.md).

## Contract and composition

- Requirements addressed: `REQ-IDSEO-01` through `REQ-IDSEO-08` below.
- Components selected by the consumer: the existing Next.js 16.4.0 / React 19.3.0 website, its unchanged `ExphereShader`, Tailwind utilities, and the supplied Exphere SVG artwork. No dependency is added or updated.
- Environment and executor selected by the consumer: existing pnpm 12.4.2 / Turborepo commands and Node >=22.22.1. This executor can read/write GitHub through the connector and inspect local files, but has Node 22.16.0, no pnpm or Next installation, and no DNS access to GitHub. No clean checkout or fresh application build is claimed.
- Extension points and execution lifecycle: retain the single en-US `/` page and framework-owned static metadata routes. Use only the real page and root-layout consumers; no metadata helper framework, locale catalogs, or new application routes.
- Configuration, secret references, and data ownership: no new environment input, secret, service, or request-host-derived value. The production origin is unknown and must remain unset. Origin-dependent metadata activation is a later launch decision, not an inferred approval.

### Intended result

The home page shows only the supplied horizontal Exphere logo at the upper left, replacing the existing visible text heading. Its accessible heading remains Exphere. The existing decorative shader remains unchanged. Browser identity and a non-indexable metadata foundation are installed without adding navigation, a hero, descriptive copy, a footer, a gallery, or runtime demonstrations.

### Requirements and acceptance

| ID | Requirement | Acceptance criterion |
| --- | --- | --- |
| REQ-IDSEO-01 | Keep the visible surface minimal. | `/` contains one left-aligned logo, with a single accessible Exphere heading. No extra visible content or new client boundary; shader and design packages are unchanged. |
| REQ-IDSEO-02 | Use the owner's artwork. | The light horizontal SVG is copied from the supplied pack without changing its geometry or colors. Raster derivatives retain the supplied mark; provenance and checksums identify source and transformations. No font files are included. |
| REQ-IDSEO-03 | Supply browser and application identity. | Static favicon ICO, SVG/raster icons, opaque 180px Apple icon, manifest, and its 192/512px and maskable resources exist. Every manifest icon resolves to a packaged asset. The manifest uses browser display and promises no offline application. |
| REQ-IDSEO-04 | Establish document and page metadata. | Root owns application name, null/unset production metadata base, light viewport, and a noindex default. Home owns its title, description, and en-US social copy. Metadata uses supported product facts and microruntime terminology. |
| REQ-IDSEO-05 | Prepare truthful social assets without a fake origin. | Static PNG social images and alt sidecars live directly under `src/app`. The card uses only the approved identity, not unverified capability claims. Empty image lists explicitly defer image URL emission until an origin is accepted; no hand-written dimensions, MIME type, alt descriptor, or absolute image URL duplicates framework ownership. |
| REQ-IDSEO-06 | Keep launch decisions open and safe. | Home remains noindex and crawlable. Static robots has no invented host or sitemap directive. No canonical, sitemap, JSON-LD entity, social account, hreflang, AI-crawler-specific policy, or llms file is fabricated. |
| REQ-IDSEO-07 | Preserve repository boundaries. | No existing ticket, package, lockfile, workflow, deployment config, shader, or token source changes. No generic icon library or pack generator is imported. Changes are limited to the manifest below. |
| REQ-IDSEO-08 | Deliver reviewable evidence. | New spec/ticket history precedes implementation; every commit has one Ticket trailer and the PR has the Spec declaration. Available asset/source checks and both review axes identify their snapshot. Missing typecheck/build/Biome/generated-HTML evidence prevents done/merge-ready claims. |

### Allowed change manifest

- This spec and the two new linked ticket files.
- `apps/website/src/app/page.tsx` and `layout.tsx`.
- `apps/website/src/app/favicon.ico`, `icon.svg`, `icon1.png`, `apple-icon.png`, `manifest.webmanifest`, `robots.txt`.
- `apps/website/src/app/opengraph-image.png`, `opengraph-image.alt.txt`, `twitter-image.png`, `twitter-image.alt.txt`.
- `apps/website/public/brand/exphere-logo.svg`.
- `apps/website/public/icons/app-192.png`, `app-512.png`, `maskable-512.png`.
- `apps/website/README.md` and `apps/website/IDENTITY.md`.

Paths are explicit because the supplied SEO role requires a bounded diff. This takes precedence over the generic skill suggestion to omit paths. Missing origin-bearing artifacts are intentionally not created with placeholders. The complete identity pack stays outside the repository.

## Responsibilities

- Consumer: supplies the visual identity and owns future origin, indexing intent, public entity facts, and deployment decisions.
- Platform: preserves existing conventions, public package boundaries, static metadata ownership, and SDD traceability. No new executor or automated approval service is introduced.
- Service owners: no production service is touched and no operator, budget, SLA, or launch date is assigned.

## Operation and limits

- Resources, isolation, permissions, and capacity: existing local file inspection and GitHub publication only. No cloud resources or live URL probes. Asset processing introduces no website runtime dependency.
- Failures, timeouts, cancellation, and cleanup: unavailable tooling remains an explicit verification block. Do not disable hooks, weaken checks, change dependency versions, or provision a substitute environment to manufacture a pass.
- Installation, updates, and removal: merge the scoped source and static assets only after required checks; removal reverses these files. No postinstall, environment wrapper, generator, or service worker is added.
- Observability and execution correlation: record base SHA, remote commit/tree SHAs, selected file hashes, commands/results, and review limits in these artifacts and the PR. Do not publish temporary raw-download tokens or private logs.
- Out of scope: any additional visible UI, other routes/apps, localization, JSON-LD enrichment, analytics, Search Console, browser audits, new tests/dependencies, CI changes, deployment/DNS, package publication, unrelated ticket edits, and merge.

## Verification and decisions

- Affected guardrails: local SDD v1 for commit/PR traceability; existing website verification contract for compilation and generated artifacts. Dependency/config/build boundaries remain unchanged; no backing service, paid provider, or infrastructure is introduced. FinOps execution/capacity claims are not applicable to this source-only change; local consumption is unmeasured.
- Applicability, criteria, owners, and planned evidence: the agent records asset/source inspection and a two-axis review. Full website typecheck, production build, root Biome, and the existing pre-push build/test gate require the project's installed toolchain. The existing CI performs agent review, not those application checks.
- Cost/consumption impact: no paid service is created or invoked. Existing GitHub event behavior is not reconfigured. No zero-cost or performance claim is made.
- Open issues and exceptions: origin, indexing launch, entity facts, and external measurement remain owner decisions. Missing verification is not an exception or acceptance. The available executor has no parallel reviewer tool; separate sequential Standards and Spec passes must be labeled as a self-review rather than independent sub-agents.
- Verification plan: `VER-IDSEO-01` below.
- Trade-offs, decisions, and blocking questions: `DEC-IDSEO-01` through `DEC-IDSEO-03` below.
- Technical review: pending implementation; planning reviewed for narrow scope and traceability. Delivery status must reflect actual evidence.

### BASE-IDSEO-01 — Re-baseline

Source facts confirmed at the recorded main commit: one home page; root en-US/light document; unchanged shader wrapper; title-only page metadata; no `public/` or identity/SEO convention assets in the application tree. The website manifest still pins Next 16.4.0 / React 19.3.0 and shell-based commands. The role's older branch now appears in main through the layout-reference merge; shared skills/policies use `.exphere/harness/`.

Fresh prerendered head, static rendering mode, redirect semantics, missing-page metadata, hydration, and shader runtime behavior were not re-executed. The role's cached build observations are historical evidence, not current results. Local network/toolchain failures are recorded above. Existing root deployment configuration is outside scope and cannot establish an accepted website origin.

### DEC-IDSEO-01 — Identity and surface

- Section ID: `DEC-IDSEO-01`; type: scope; state: selected under delegated task authority.
- Requester and authorized human owner: the project owner through the October 12 request; artifacts assessed: this spec v1 and the supplied identity ZIP.
- Context: adopt the supplied identity without turning the minimal page into a showcase.
- Options: import the whole pack (unneeded UI and generator surface), or select only consumed identity assets (bounded maintenance).
- Proposal and consequences: select consumed assets only; preserve the SVG master, allow documented optimized raster exports, and use a brand-only social card. The homepage remains one logo.
- Actual decision: the owner's request establishes identity use, left placement, no additional visible content, new tickets, and autonomous execution through PR. The agent selects the minimal integration within that scope; no independent brand/trademark approval is asserted.

### DEC-IDSEO-02 — Unknown origin and indexability

- Section ID: `DEC-IDSEO-02`; type: scope; state: launch decisions open; safe implementation selected.
- Requester and authorized human owner: project owner; artifacts assessed: this spec v1 and the supplied SEO role.
- Context: no accepted production origin or indexable launch is recorded. An owner-configured repository homepage is not a deployment or canonical contract.
- Options: infer a domain (unsupported public claim); block all independent work; or install non-indexable, origin-neutral identity/metadata and defer URL activation.
- Proposal and consequences: choose the last option. Null metadata base and explicit empty social image lists prevent a deliberate localhost/preview URL fallback; no canonical, sitemap, entity graph, or social profile is authored. Static social files remain ready for later framework activation. No caller-controlled origin is read.
- Actual decision: no production origin, launch, or entity facts are approved by this document. Deferral implements the supplied role without inventing facts. Before an indexable release, the owner must accept the origin and policy; update root base, self canonical, static sitemap/robots, social image activation, and verification together.

### DEC-IDSEO-03 — Verification and PR readiness

- Section ID: `DEC-IDSEO-03`; type: scope; state: implementation authorized; verification conditions retained.
- Requester and authorized human owner: project owner; artifacts assessed: this spec v1 and existing website/SDD contracts.
- Context: authorized commands cannot run with the local executor's missing toolchain and network; independent reviewer execution is unavailable.
- Options: falsely claim a build, weaken gates, or publish explicitly incomplete review work with the blockers intact.
- Proposal and consequences: continue independently checkable implementation, then create a draft PR if mandatory execution evidence remains unavailable. No ticket is done and no merge-readiness is claimed without its evidence.
- Actual decision: the owner authorized commits and a PR; this is not a waiver of unavailable checks. Any draft status records a technical block, not a request for repeated approval of the scoped implementation.

### VER-IDSEO-01 — Existing application boundary

1. Inspect the supplied ZIP safely; verify checksums, SVG safety, raster decodability/dimensions, Apple opacity, ICO frames, and the maskable safe zone. Record any raster adaptation rather than claiming unchanged bytes.
2. Compare application source against the pinned baseline; verify one logo, one accessible heading, no new client code, and an unchanged shader/layout shell.
3. Check static metadata formats, manifest targets, truthful copy, noindex/crawlability pairing, and absence of invented origins or entities.
4. With the existing installed toolchain, run `pnpm --filter website typecheck`, `pnpm build --filter=website...`, `pnpm check`, and the existing authorized build/test gate. Inspect `.next/server/app/index.html` and build manifests for actual metadata, routes, static behavior, and unchanged missing-page semantics. Do not equate source inspection with these results.
5. Review the same file manifest/hashes on Standards and Spec axes. Record the lack of independent sub-agents if using sequential self-review. Reassess after material changes.
6. Verify the remote diff, ticket trailers, actual PR Spec line, branch ancestry, and unmodified existing tickets. Leave required evidence gaps visible and the PR non-merge-ready.

### References and adaptation

- The user supplied `exphere-identity-seo.zip` (SHA-256 `c1a0bd65799cbcd77dbf63371984f39ea5e551d423a1d86e9b9e6d414ded61ad`) and `Staff SEO Engineer — Exphere Website (Role Prompt).md`.
- The referenced website's metadata composition at revision `ba9966c0d0f4daaee68a3b71181639cb0c3a2158` informed coverage only. Exphere's static-file rule and current single-route contract override its generators, locales, domain, and entity data; no third-party implementation is copied.
- Next.js 16.4.0 metadata resolution source: `packages/next/src/lib/metadata/metadata-resolution-primitives.ts`, especially `mergeStaticMetadata`. It skips file-derived social images when that segment explicitly owns an `images` field. This is source inspection, not a local runtime test.
