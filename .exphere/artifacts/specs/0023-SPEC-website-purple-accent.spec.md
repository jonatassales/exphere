# Website purple accents and dark motion

- ID: `SPEC-WEBSITE-PURPLE-ACCENT`
- Document number: `SPEC-0023`
- Version: `1`
- State: `source implemented; in review; execution verification pending`
- PRD: [PRD-WEBSITE-PURPLE-ACCENT](../prd/0005-PRD-website-purple-accent.prd.md)
- Design decision: existing [ADR-0002](../design/0010-DD-website-design-system-branding.dd.md) with a new additive accent amendment.
- Earlier requirements: [SPEC-WEBSITE-DARK-THEME](0022-SPEC-website-dark-theme.spec.md) (dark-only, motion intact, Docs link).
- Ticket: [WEB-PURPLE-01](../tickets/0045-TICKET-website-purple-motion.ticket.md)
- Baseline: `a9c78f33ab1f7bfaed26dccfd2ad27477b026734` on `main`.
- Authorization: the project owner's October 13, 2026 request for OLX-inspired purple in place of the ClickHouse yellow-green accent, while retaining a black background and the existing motion. This revises UI accent and motion color only. Feature-branch/PR delivery follows the existing user-authorized workflow; merge/deployment are excluded.

## Contract and composition

The Next.js App Router website stays dark-only and server-rendered. The `/` page keeps its exact factual copy, single `h1`, responsive editorial/CLI split, docs CTA URL, CLI examples and commented SVG logo.

The **app-local** Tailwind semantic token bridge adds:

| Role | Color | Usage |
| --- | --- | --- |
| `site-accent` | `#6d0ad6` | Primary CTA and limited emphasis. |
| `site-accent-hover` | `#8c3bef` | CTA hover; white label contrast preserved. |
| `site-accent-readable` | `#ba86ff` | Small purple labels or highlight text on dark surfaces. |

The source accent `#6d0ad6` comes from Exphere's prior token history and is an **OLX-inspired selection**, not a verified official OLX token. ClickHouse's attached reference actually identifies its bright accent as yellow `#faff69`, which can read lime/green; do not copy it. Keep all existing near-black, white and neutral text/surface roles unchanged. Exphere vector/raster branding remains black; interface purple is a separately scoped contrast/action role.

Update the home hero CTA to purple with a white label and visible focus; emphasize only a short phrase in the existing heading and limited technical labels. Avoid purple body paragraphs, multiple unrelated accents, gradients/new animations, white cards, shadows or new layout components.

The website root continues to mount exactly one `ExphereShader` and uses its **existing** opt-in `palette` property with:
`primary: "#36135a"`, `primaryHover: "#6d0ad6"`, `background: "#0a0a0a"`, `surface: "#121212"`.
The shared shader's source, public API, WebGL program and reduced-motion/visibility/fallback logic are untouched; the existing CSS fallback and WebGL should inherit the same CSS color inputs. The outer document/manifest remains dark.

Do not add a new `motion` dependency or replace WebGL with Motion JS; the supplied senior staff role requests preserving existing frameworks and SSR/client boundaries. Repo-specific Tailwind ownership takes precedence over its general preference for authored native CSS.

## Acceptance

| ID | Contract | Verification |
| --- | --- | --- |
| REQ-PURPLE-01 | Dark-only site retained | Existing `data-theme="dark"`, browser colors and all `site-*` neutral surfaces stay unchanged. |
| REQ-PURPLE-02 | Accent roles | Three site-only purple tokens exist; no shared design token source is altered. |
| REQ-PURPLE-03 | Accessible Docs CTA | Same `href`, accessible name, keyboard focus; base and hover purple surfaces with white text meet >=4.5:1 token-pair contrast. |
| REQ-PURPLE-04 | Restrained content emphasis | One headline phrase and small technical labels use the readable purple token; white primary text and neutral body stay legible. |
| REQ-PURPLE-05 | Motion preserved | Same `ExphereShader` mount, same CSS/WebGL source and fallback contract; only opt-in palette values change to purple on black. |
| REQ-PURPLE-06 | Scope safety | No client/hydration expansion, dependency, shader source change, new marketing content, logo asset edit, metadata/indexability change, or docs destination edit. |
| REQ-PURPLE-07 | SDD delivery | Planning precedes reviewed implementation; commit trails point to one ticket; PR declares `Spec: SPEC-WEBSITE-PURPLE-ACCENT`; missing runnable evidence remains explicit. |

## Allowed change manifest

- `.exphere/artifacts/prd/0005-PRD-website-purple-accent.prd.md`
- `.exphere/artifacts/specs/0023-SPEC-website-purple-accent.spec.md`
- `.exphere/artifacts/tickets/0045-TICKET-website-purple-motion.ticket.md`
- `.exphere/artifacts/design/0010-DD-website-design-system-branding.dd.md`
- `apps/website/DESIGN.md`, `apps/website/README.md`
- `apps/website/src/app/globals.css`, `apps/website/src/app/layout.tsx`, `apps/website/src/app/page.tsx`

No other application, shared package, asset, manifest, workflow, script, or runtime file is in scope.

## Operation, ownership and trade-offs

- Website owns its palette; `@repo/design` remains generic and `@repo/web` keeps the existing shader implementation.
- The black brand-artwork decision is retained while purple UI emphasis is newly authorized. A future purple logo would require a separate request.
- Keep metadata origin unapproved, noindex and crawlable robots unchanged.
- There are no network integrations or added recurring resources.

## Verification

1. Static inspect changed files for exact palette/CTA/docs behavior, unique rendered `h1`, no white card or new chromatic accent, and shader preservation.
2. Compute WCAG contrast for CTA and purple small labels on their respective opaque reference colors. This cannot certify contrast against live animated translucent panels.
3. Use the existing website typecheck/build and repo Biome checks when an installed checkout is available; inspect generated HTML/bundle when possible.
4. Run the existing WebGL consumer browser suite when possible to confirm animation, CSS fallback and reduced motion remain intact. Do not represent unrun tests as passed.
5. Apply two-axis Standards/Spec review to the same fixed diff; record any lack of independent reviewer tools.
6. Publish one PR for this feature branch and verify the actual file manifest and CI status; no merge or deploy.

### Evidence

### Reviewed source snapshot

- Fixed baseline: `a9c78f33ab1f7bfaed26dccfd2ad27477b026734` on `main` (after dark PR #17).
- Planning commit: `226ea9875410b2764a9881c597f9b9f1767ee6cc`.
- Implementation commit: `425f58ac0fcb82a4426b68c7b2d8b354ee557088`.
- GitHub comparison: **2 commits ahead, 0 behind, 9 authorized paths changed**; no other paths, package source, lockfile, build configuration, or deployment modifications.
- Key implementation Git blobs:
  - Home page: `651017993861b7778c58c940087b4e131eb6dd70`.
  - Root layout: `65022481203a43b02ec7365e1c7aac9892f2e50b`.
  - Site token bridge: `f08cbde5b606677bdb1e43a9109edf568b7009bd`.
  - Website design direction: `681d3559dc86f593b687b3502e33dd2a707126aa`.

### Source and accessibility inspection

- `#6d0ad6`, `#8c3bef` and `#ba86ff` are defined only as app-local semantic Tailwind roles. The Docs CTA uses the accent and hover, white text and an existing white focus-visible outline.
- A short phrase of the existing `h1`, one hero label, the CLI title and terminal prompts use the brighter readable role. The remainder of the original copy, two documented CLI commands, the GitHub README URL and the disabled original SVG logo are retained.
- Only the four website `shaderPalette` literals changed: purple shades `#36135a` and `#6d0ad6`, dark base `#0a0a0a`, soft surface `#121212`. The single root shader mount, shared shader code and default behavior for other consumers were not changed.
- Dark HTML/viewport/manifest, charcoal cards, black logo assets, social metadata, and `noindex` were not changed. No new white card, bright ClickHouse accent, client component or dependency was introduced.
- CSS `@theme inline` retains the existing minimal framework/token bridge rather than adding application selectors.

Static sRGB WCAG contrast calculations for **opaque token pairs** (not live composited screenshots):

| Pair | Calculated ratio |
| --- | ---: |
| White `#fff` text on primary purple `#6d0ad6` | 7.88:1 |
| White `#fff` text on hover purple `#8c3bef` | 5.27:1 |
| Readable purple `#ba86ff` on `#121212` | 7.08:1 |
| Readable purple `#ba86ff` on `#1a1a1a` | 6.58:1 |
| Readable purple `#ba86ff` on `#242424` | 5.87:1 |

### Standards review — sequential self-review

Inspected the proposed and committed source against `AGENTS.md`,
SDD traceability v1, website `DESIGN.md`, the Tailwind styling/frontend
rules, App Router metadata ownership, and the supplied Senior Staff motion
role's lifecycle and accessibility considerations. No actionable source-level
finding was observed. The homepage stays server-rendered, semantic roles
remain website-owned, and no speculative dependency, second renderer,
CSS styling system, or new client boundary was introduced.

### Spec review — sequential self-review

REQ-PURPLE-01 through REQ-PURPLE-06 are satisfied at the **source** level
in the identified tree. Only the purple accent theme and shader palette were
changed; there are no extra pages, marketing claims, logo colorways, or
off-scope edits. REQ-PURPLE-07 remains incomplete until published PR/CI
metadata and any required runtime evidence are inspected.

### Remaining verification gaps

The connector execution did not provide a full installed Git checkout.
Project typecheck/build/Biome, existing shader browser/Playwright tests,
WebGL motion and fallback screenshots, keyboard focus in a real browser,
and contrast measured over moving translucent regions **were not run**.
Recorded numeric token ratios are not proof of rendered accessibility.

The repository's code-review skill requests **parallel independent agents**.
Only separate sequential Standards and Spec self-review was available, not
independent reviewer approval. GitHub PR CI must be inspected on its actual
run: a successful wrapper with disabled review-provider configuration does
not demonstrate model review. Do not mark the ticket done or this PR
merge-ready based solely on these checks.
