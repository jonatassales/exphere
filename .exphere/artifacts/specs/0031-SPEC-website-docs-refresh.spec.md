# Website, documentation, and README refresh

- ID: `SPEC-WEBSITE-DOCS-REFRESH`
- Version: 1
- State: `approved`
- PRD: Existing website and Exphere product requirements; this owner-directed maintenance cycle has no new PRD.
- Technical owners: Exphere website and repository maintainers.
- Base: `6f22e1403bde1e09cb4624dcf379497898af19f7` (main after PR #24).

## Contract and composition

Use Next.js 16.4.0, Nextra/Docs Theme 4.6.1, React 19.3.0, Tailwind 4.3.3 and the existing design/web packages. Add only a website-owned Pagefind build dependency for local static search. Keep the existing TypeScript and Zod compatibility pins. No SDK, CLI, public package API, external service, secret or production policy change.

| ID | Requirement and acceptance |
| --- | --- |
| REFRESH-01 | Website App Router lives directly in `app/`, with no `src/` wrapper. MDX mapping lives in `app/components/mdx-components.tsx`; configuration is typed `next.config.ts`. Repair aliases, framework assets and current guidance. |
| REFRESH-02 | Home has three balanced grid rows and a viewport-centered hero, fits 100vh (100dvh on dynamic mobile browsers), and has no page scroll at the verification sizes. Compact spacing/type and hide supporting description on short screens; keep title, links, copy and footer visible. Preserve borderless hero, animation, copy behavior, 360px/12px clipboard and 44px controls. |
| REFRESH-03 | LinkedIn points to `https://www.linkedin.com/in/jonatassales/` with an accurate accessible name. Preserve the owner's existing footer attribution. |
| REFRESH-04 | Docs stay dark/purple with a solid reading background, searchable header, sidebar, breadcrumbs, readable articles, desktop TOC, pagination and mobile navigation. Shader runs on Home only. |
| REFRESH-05 | Author Getting Started (`/docs`), Concepts, Architecture, CLI and Development from existing project material. Clearly distinguish current capabilities and proposals; preserve commands, source links and image provenance. |
| REFRESH-06 | Production build creates and serves a Pagefind index of the five docs pages. Cached builds restore the index. Search supports keyboard entry, real result navigation and empty results. |
| REFRESH-07 | Root README begins with the existing banner; exact requested tagline and quick links are centered. Present benefits, main ideas and the existing current diagram. Move technical detail and the older historical diagram to docs. Preserve Quick start, Architecture and Developer checks anchors. |
| REFRESH-08 | Remove the obsolete website design/identity documents and active references. Retain necessary asset provenance in existing artifacts, preserving historical snapshot facts and hashes. |

## Responsibilities

Consumer: website composition, content, accessibility and search index ownership. Platform: existing package boundaries, native build tools and repository hooks. Owner: Jonatas Sales, who selected scope and publication destination. Source material: repository, supplied Nextra/README role documents and LangDrift docs as a layout reference, not copied content or authority over this request.

## Operation and limits

Search is a static build artifact, not a backend. Index only authored public documentation; no secrets or private working context. Native Next/Pagefind commands own compilation and indexing; no wrapper scripts. Rebuild when content changes. Indexing failure fails the build. Generated files are ignored and included in the website's Turbo cache outputs. Local server and browser verification are temporary and stopped after verification. Existing noindex, unset metadataBase and inactive social-image policy remain unchanged. No claim of production readiness, measured savings, working runtime automation or organizational adoption.

## Verification and decisions

### Owner decisions and authorization

On October 13, 2026 the owner requested this refresh and chose (1) five pages organized from existing material, (2) compact secondary homepage content on short screens, (3) dark Exphere docs, and (4) local browser checks without application test infrastructure. The owner then explicitly requested specs/tickets and a PR and said “execute it” and “go” after execution mode became available. This authorizes artifacts, implementation, dependencies, verification, ticketed commits, normal push and a PR to `jonatassales/exphere:main`. Merge and production promotion are separate actions. Original checkout edits must remain intact.

This request supersedes SPEC-WEBSITE-HOME-LAYOUT's natural-scroll and src/config preservation requirements for this cycle. It also supersedes the website-specific src convention and the earlier one-heading/no-search docs scope. Prior review evidence remains attached to its original revision.

### VER-REFRESH-01

Run scoped formatting, website type checking, production compilation, generated-output inspection and reference checks. Browser-check the production build at 320×568, 390×844, 844×390, 1280×720 and 1440×900: no Home overflow, centered hero, visible controls and copy feedback; normal Docs scrolling, responsive navigation, keyboard search, real result navigation and no-results state. Check index delivery after a cache restore. No permanent application test infrastructure. Required native hook checks remain authorized. Run independent Standards and Spec reviewers against the same hashed source snapshot before commits/push; record findings and re-review material fixes.

### Guardrails

SDD v1: ticket-linked commits, one parent spec, same-snapshot independent reviews and normal feature-branch delivery. 12F-01/02/05/10/11: isolated source, explicit build dependency, generated index shipped with build, local production verification and native diagnostics; other factors unchanged/not applicable. FIN-01/02/04/05/08: existing website owner and delivery environment, five static pages, no new paid service or provisioning; incremental build/storage cost is unmeasured, not assumed zero. Browser/server resources are local and temporary. Existing PR CI is within authorized delivery; no new CI service or budget is introduced. No financial outcome claim.

### Evidence

Implementation and local verification completed on October 13, 2026; independent reviews passed and PR delivery is in progress. Artifact approval records conversation authorization, not an authenticated policy engine.

- `pnpm exec biome check apps/website`: 19 files passed. `git diff --check` passed.
- `pnpm --filter website typecheck`: passed, including generated route types.
- `pnpm build --filter=website...`: passed using Next.js 16.4.0 Turbopack and typed config; all five Docs routes are statically generated. Pagefind 1.5.2 indexed exactly five pages in en-US (615 distinct indexed words). Actual HTML location is `.next/server/app`; no adapter path is assumed.
- Cache restoration: moved this task's generated index aside, reran the same build, observed website cache hit `1862fd0cf52c444c`, and verified the restored index was served and searched successfully.
- Chromium production-browser checks: all five specified Home sizes had exact viewport document dimensions, hero midpoint within 1px of viewport center, non-overlapping header/hero/footer, 44px copy targets and 12px command text. Keyboard entry, personal LinkedIn URL, clipboard success and clipboard-denial feedback passed.
- Docs: all five routes returned 200 with one h1, retained noindex and no shader canvas. Authored internal route/fragment links resolve; both existing architecture illustrations load. Desktop and mobile screenshots inspected.
- Search: keyboard shortcut focused search; `budget` returned four matches and opened `/docs/architecture#context-to-execution`; a nonexistent term produced the empty state. Mobile `scaffold` search and menu navigation to Concepts passed. Restored `/_pagefind/pagefind.js` returned 200. No browser page errors were observed.
- Full repository Biome check also passed: 117 files.
- Reference checks: no newly broken relative Markdown file links; removed-document references are gone. Active icons, manifest and robots files match baseline bytes after their move. Historical literal source paths remain attached to their recorded revisions.
- Temporary browser evidence: `.audits/evidence/runs/website-refresh/verification.json` and Home/Docs/search PNGs (ignored, local). Temporary verification scripts remain outside the repository; no application test infrastructure was added.
- Initial independent review snapshot: 72 paths, manifest SHA-256 `467ab6521ccc1e03ac19d137740b800e235f4a0e7ac7886eaa377e1bb703684e`. Spec: zero source findings. Standards: one P2 historical-source wording issue in retired-document reference replacements; corrected by distinguishing original inputs from current successor links. Refreshed Standards and Spec reviews both passed with zero remaining findings against the final 72-path manifest SHA-256 `1bd79e53144763767e95e4d946500bac2d74e999740c33a328a662d262152269`. Only this closure record and corresponding ticket evidence were appended afterward; application source is unchanged.
- Limitations: Chromium checks cover the recorded viewport sizes, not every browser/device or arbitrary zoom/extreme viewport. Webpack remains outside the supported build path because of the preexisting Nextra metadata-loader incompatibility; its provider alias is configured but this cycle verifies Turbopack. GitHub Markdown API rendering preserves the banner-first order, both centered HTML blocks and the retained headings; it does not emit heading IDs or prove visual rendering in GitHub. Hosted CI and production acceptance remain unverified at this stage.


## Retained asset provenance

Source archive SHA-256: `c1a0bd65799cbcd77dbf63371984f39ea5e551d423a1d86e9b9e6d414ded61ad`. The owner supplied the original black Exphere assets on October 13, 2026. This refresh moves active route assets without changing their bytes.

## Active browser and application assets

| Destination | Size | Treatment and provenance |
| --- | --- | --- |
| `app/icon.svg` | 128×128 vector | Existing black mark on white rounded canvas, unchanged. |
| `app/icon1.png` | 96×96 | Existing black mark on white rounded canvas, unchanged. |
| `app/apple-icon.png` | 180×180 | Exact one-bit black/white bytes recovered from `706d6dae3eb7a95f68738448ae28e36fefd291a3`. |
| `public/icons/app-192.png` | 192×192 | Existing black mark on white canvas, unchanged. |
| `public/icons/app-512.png` | 512×512 | Exact black/white bytes recovered from the same revision. |
| `public/icons/maskable-512.png` | 512×512 | Exact black/white safe-zone composition recovered from the same revision. |

The recovery revision has the identical horizontal SVG checksum as the current
tree, and its icon SVG differs only by an identity transform. Restoring those
existing binary exports preserves the black geometry without redrawing it.
The manifest paths and browser-display semantics remain unchanged. No service
worker, offline behavior or installability guarantee is introduced.

There is no active `favicon.ico` convention file. The original is truncated;
the historical replacement has one-bit embedded PNG frames that Next.js 16.4's
Turbopack ICO decoder rejects. The valid SVG and 96px PNG provide explicit
favicon links instead. Legacy clients requiring only `/favicon.ico` remain a
compatibility limitation until a separately verified ICO export is supplied.

## Preserved corrupt source assets

The PR completion build found six malformed binary assets already present in
the `d6b3c8abff240c54011f81f7088f445e3fbabef4` baseline. They were not usable
rendering evidence. The original bytes are preserved under existing
`public/brand/`, without being advertised by metadata or the manifest:

| Preserved path | Observed defect |
| --- | --- |
| `public/brand/apple-icon.png` | IDAT checksum mismatch. |
| `public/brand/favicon.ico` | Truncated image data. |
| `public/brand/opengraph-image.png` | Declared IDAT length exceeds remaining file bytes. |
| `public/brand/twitter-image.png` | Declared IDAT length exceeds remaining file bytes. |
| `public/brand/app-512.png` | Truncated PNG chunk. |
| `public/brand/maskable-512.png` | Truncated PNG chunk. |

The social alt sidecars moved alongside the originals. These files preserve
historical source material; they are not valid replacement assets. Their
recorded intended composition was black Exphere artwork and technical linework
on white, but the corrupt payloads do not demonstrate a renderable composition.
The earlier validation/checksum claims are superseded by this byte inspection.

No active `opengraph-image.*` or `twitter-image.*` convention file remains.
Pages and the root retain empty image lists, and the production origin
remains undecided. Valid social exports must be supplied and verified before a
future sharing/indexing launch. No canonical, sitemap or entity claim was added.

## Current checksums

SHA-256 identifies the actual bytes in this recovery:

| Active asset | SHA-256 |
| --- | --- |
| `public/brand/exphere-logo.svg` | `0b8f4664b99023004bb89fab930e7688c6e28e3d173264c71db8b65effaafb95` |
| `app/icon.svg` | `f3c3f60bb731efbfa5c95c921c11c89816bb2024ce274d6f299dc7584e2e2260` |
| `app/icon1.png` | `6d66ee8808a24ac86b1bce93af1fd42ad55caf9230269c736e08b9b1f53ae45c` |
| `app/apple-icon.png` | `cd469a3911c0393b9208a50009f0dceb9145ac6ec65f5da54be546a3c0a699fa` |
| `public/icons/app-192.png` | `4c6d36a1fee333fc2f2b95837f93f521e5da0858abfd52afe0f1441be806506b` |
| `public/icons/app-512.png` | `5365a04515ddc66675d7e81ea60cd60c2154a658b659e4c2eb6eba8858305211` |
| `public/icons/maskable-512.png` | `b9a205533fa51bae213e36c98e90af106556833a9c7d991b1808f356fd34637a` |

| Preserved original | SHA-256 |
| --- | --- |
| `public/brand/apple-icon.png` | `2ce7dc593a536409b91ddc52a264cb76263053a7f5c1500f01f80ea5beae3e6f` |
| `public/brand/favicon.ico` | `e68dda39486f91d4c09609021519e8dae81e00cd65d4c665f91e410c0a17c3df` |
| `public/brand/opengraph-image.png` | `f220f3613f92acc4a8156083b6fd2471683fedd693cd2d78e8eece9e1bcd6689` |
| `public/brand/twitter-image.png` | `353e1e860783d1a71a809b8f14fdadd476400e49dd51311a7d8880b7a9840059` |
| `public/brand/app-512.png` | `69c155ce40edb2b60786f93e2d132609fdb351335e1e109c03af0dd31c14013f` |
| `public/brand/maskable-512.png` | `69c155ce40edb2b60786f93e2d132609fdb351335e1e109c03af0dd31c14013f` |

## Historical asset verification boundary

The completion cycle inspected PNG structure, compared recovered bytes with
Git history, compiled the production application and inspected generated
metadata. These checks do not establish browser rendering, deployment,
indexing, Core Web Vitals, or production acceptance. The site remains noindex.


## Deployment correction: REFRESH-09

The owner reported failed production deployment `dpl_4mAxSSndNr5WURnwUTm7hLxzzZQt` after merging PR #25. Vercel built `b8400e2eeac2c89abb6919b0d9dfced51edaee6f` and removed 315 files through the root deployment ignore rules, including both diagram imports. Compilation then failed resolving `@diagrams/backstage-context-team-budget.png` and `@diagrams/runtimes-factory.png`. The successful local/CI builds did not apply that packaging filter.

REFRESH-09 (ticket REFRESH-03): retain exactly those two existing diagram assets in the Vercel build input, leaving other agent guidance, artifacts, environment files and generated output excluded. Do not move or duplicate the images, change application behavior, alter deployment protection, or change production settings. The failure report authorizes this delivery correction, normal branch publication and a follow-up PR; PR #25 is already merged. Build the filtered candidate in a disposable local fixture and recheck the source snapshot through independent Standards and Spec reviews. Actual production recovery remains unverified until a corrected revision is deployed.

Verification of this correction:

- Git ignore-pattern evaluation over tracked source: 288 files excluded by the baseline rules and 286 by the correction. The only newly included files are the two named PNGs; no other `.agents/` files are included. Vercel's observed 315 removed files includes its deployment inventory, so that count is not equated with the local tracked-source inventory.
- A disposable source fixture applied the original deployment exclusions, installed pinned cached dependencies, and forced `turbo run build --filter=website`. It failed with the same two missing-module errors observed in Vercel.
- Restoring only the two allowed PNGs and forcing the same fixture build passed (three tasks, zero cache hits); Next compiled all Docs routes and Pagefind indexed five pages. Both emitted diagram assets match their source bytes exactly.
- This is a local deployment-input reproduction, not a Vercel redeployment. No project setting, protection, deployment target, or production alias changed. No application source or new test infrastructure changed.
- Baseline/corrected build logs and filter inventory are retained locally under `.audits/evidence/runs/deployment-assets/` (ignored). Disposable source fixtures and verification helpers remain outside the repository.
- Independent Standards and Spec reviews both passed with zero remaining findings against manifest `caab755d49c6eba4d5bd7cc685802be7498fcf7c63e56a7cf3d9bb244aa6ca84`, based on `b8400e2eeac2c89abb6919b0d9dfced51edaee6f`. The initial Standards evidence-retention finding is resolved. Only these review-closure records were updated afterward; deployment configuration is unchanged.


## Search deployment correction: REFRESH-10

The owner reported another deployment error after PR #26 merged. Deployment `dpl_GUakJB8mBzfVRM3LqJWp2X6G4fLc`, built from `df49a26c33e2d3da40040f25391f1ecd786b9d3c`, retained the diagram assets and compiled successfully. It failed afterward because Pagefind scanned `.next/server/app`, while Next.js 16.4.0 with Vercel's adapter emitted HTML into its route cache. The earlier local evidence did not cover this platform adapter. Its output-path conclusion is superseded for adapter builds.

REFRESH-10 (ticket REFRESH-03): index prerendered Docs through Next.js build-complete output records and their public URLs before platform packaging. Retain Nextra body markers, the five-page corpus, `public/_pagefind`, ordinary local builds, and the platform's configuration and packaging hooks. Fail on an empty corpus or Pagefind error. Keep the existing pinned dependencies; add no application test infrastructure or command wrappers. A website-owned Next.js adapter is framework configuration, not a repository task wrapper. Account for platform adapter selection/configuration in Turbo caching.

The owner's continuing failure report authorizes implementation, verification, ticket-linked commit, normal publication and a corrective PR under the existing spec. It does not request changes to Vercel settings, protection, production aliases, or a direct production deployment.

### REV-REFRESH-10

- State: local verification and independent reviews passed; PR delivery pending.
- Target: website build integration on base `df49a26c33e2d3da40040f25391f1ecd786b9d3c`.
- Baseline: locally installing the exact `@vercel/next` 21.0.0 adapter used by Vercel CLI 62.7.0 and supplying it to the unchanged build reproduced the zero-HTML Pagefind failure. The adapter package is confined to a disposable directory and is not a project dependency.
- Verification scope: forced ordinary build, forced build with the actual Vercel adapter, generated search URL/content inspection, packaged search-file inspection, cache restoration, type checking and native publication gates. No new browser probes or permanent application tests.
- Independent Standards and Spec reviews: both passed with zero remaining findings against manifest `942fc466d6e80871502b6961bc18211b66a7e929e271eab9c9f2d97ee5d354f2`.
- Evidence: `.audits/evidence/runs/search-deployment/` (ignored local logs and reports).
- Production recovery remains unverified until a corrected revision is deployed.

| Policy/version and ID | Target | Assessment and evidence | State |
| --- | --- | --- | --- |
| Twelve-Factor v1 / 12F-01, 12F-02 | Website build | Same codebase and pinned Next.js/Pagefind dependencies; no added runtime service. | Compliant within this scope |
| Twelve-Factor v1 / 12F-03, 12F-05, 12F-10 | Platform build contract | Preserve injected adapter configuration, generate search before packaging, and compare ordinary versus platform builds. Local output is not a released deployment. | Local checks passed; production not verified |

Delivery authorization is the owner's repeated request to fix the failed deployment and prior explicit PR request. Review records do not imply human acceptance or production approval.

Verification results for REFRESH-10:

- Forced ordinary production build: passed; five documentation pages indexed.
- Forced build with `@vercel/next` 21.0.0: passed; all five public Docs URLs appear in decoded Pagefind fragments, with the expected titles. Vercel Build Output API v3 package contains all 19 search files, byte-identical to `public/_pagefind`.
- Cache restoration after moving generated `.next` and search output aside: all three tasks hit cache; restored public and packaged search files match the verified originals.
- Website type checking, scoped Biome checks and `git diff --check`: passed. Native commit/push gates and hosted CI will be reported with PR delivery.
- No project settings or deployment changed. This covers the provider adapter locally, not a hosted production deployment; production recovery remains unverified.

Initial review of manifest `fb6cb06ef89074db4f2de4929fb0c24676ae280bb56dae5d7a5677136cba2db1`: Spec passed; Standards requested the public Next.js type export, contextual runtime error boundaries, and explicit async/control-flow conventions. All three findings were addressed in the framework adapter; refreshed review is pending.

Refreshed Standards and Spec reviews both passed against `942fc466d6e80871502b6961bc18211b66a7e929e271eab9c9f2d97ee5d354f2` with zero remaining findings. Forced local build/type checks and provider-adapter build passed again after the review fixes; refreshed output inspection confirms the same five URLs and 19 byte-identical packaged assets. Final logs and report are retained alongside the baseline evidence. Only review-closure text changed after this snapshot.


## Header orb appearances: REFRESH-11

The owner explicitly approved the Home star orb / Docs black-hole orb plan and requested implementation, a ticket, and PR delivery on October 13, 2026. During implementation, the owner also requested that Home's Docs label become 20% smaller. This section records those decisions under ticket ORB-01; acceptance of these requirements does not claim implementation verification or production delivery.

- Add the private shared orb prop `appearance?: "star" | "black-hole"`, defaulting to `black-hole`. Home selects `star`; Docs explicitly selects `black-hole`.
- Home's exact palette is primary `#F8FAFF`, secondary `#BDEBFF`, accent `#D8C4FF`, highlight `#FFFFFF`, background `#0a0a0a`. Apply the approved `0 0 20px rgba(210,235,255,0.5)` drop shadow on this appearance only.
- Docs keeps primary `#111111`, secondary `#242424`, accent `#333333`, highlight `#666666`, background `#0a0a0a`, without the extra shadow.
- Shift the shared orb wrapper down exactly 2px using Tailwind. Remove the existing Docs parent offset so its total translation remains 2px. Preserve supported sizes, listening animation, system reduced motion, and decorative accessibility. No shader or public package API changes.
- Reduce only Home's Docs label from `text-xl` (20px) to `text-base` (16px), preserving its 44px minimum target and existing navigation behavior.
- Preserve the original checkout's unrelated CLI edits. Deliver from isolated branch `codex/website-orb-appearance`, based on main `535f8f5`. No dependencies or production settings change.

### Verification and review: VER-ORB-01

Run scoped formatting, website types, production compilation and native publication gates. Inspect Home and Docs at desktop and mobile sizes for the selected palettes, exact 2px transform, unclipped visible glow, existing header spacing, and the 16px Docs label. Also inspect reduced-motion presentation. Use disposable browser inspection only; add no permanent test infrastructure. Retain screenshots/logs under `.audits/evidence/runs/orb-appearance/`. Run independent Standards and Spec reviews against the same identified snapshot before commit and push.

Implementation verification and independent Standards/Spec reviews passed; PR delivery is pending. Both reviews examined manifest `be60a3be9da55cbcaa6b36293e8f25bc44d929af29e7fdb0959cd6dc74672888` based on `535f8f543a49cbc73c49286dea83c50b503a4391`, with zero findings on either axis. Only review-closure text changed afterward.

- Scoped Biome, website production build and type checking passed. The build still indexes all five Docs pages.
- Chromium inspection at 1440x900, 390x844 and 320x568 confirmed the exact palettes, Home-only glow, 24px default wrappers, shared `translate: 0px 2px`, no duplicate Docs parent transform, decorative accessibility, listening state and system reduced motion.
- Home's Docs link computes to 16px with a 44px target. Navigation to Docs switches to the dark appearance. No horizontal overflow or browser page errors were observed; Home has no vertical scroll, while Docs scrolls normally.
- Screenshots visually confirm the bright Home orb, dark Docs orb, readable header spacing and no obvious visible halo clipping. Reduced-motion presentation is captured; retained 2rem sizing is inspected separately.
- Orbo's React types prohibit `className` on the custom element. Styling therefore belongs on the existing wrapper, with static Tailwind data variants; no unsupported host props or dependencies were introduced.
- React checklist: one shared client component, constant palettes outside render, no new effect/state/listener, unchanged lazy browser registration, no public package interface changes.
- Native publication gates and hosted CI results will be reported in PR delivery. Local visual evidence does not claim production deployment.
