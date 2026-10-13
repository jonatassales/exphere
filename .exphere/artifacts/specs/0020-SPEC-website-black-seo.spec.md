# Monochrome website SEO branding implementation

- ID: `SPEC-WEBSITE-BLACK-SEO`
- Document number: `SPEC-0020`
- Version: `1`
- State: `approved for scoped implementation; review pending`
- PRD: [PRD-WEBSITE-DESIGN-BRANDING v1](../prd/0003-PRD-website-design-branding.prd.md)
- Supporting design contract: [SPEC-WEBSITE-DESIGN-SYSTEM v1](0019-SPEC-website-design-system.spec.md)
- Architecture decision: [ADR-0002](../design/0010-DD-website-design-system-branding.dd.md)
- Technical owners: project owner for brand/design decisions; implementing agent for bounded assets, evidence, review, and PR publication.
- Authorization: the October 13, 2026 request authorizes PRD/ADR/spec/ticket creation, implementation, review, a feature branch, and PR creation for this scope. It does not authorize merge, deployment, production access, indexing launch, or unrelated website redesign.
- Baseline: main `49ba260e45250172e0e4ea090627b724569d420d`.
- Tickets: [WEB-BRAND-PLAN](../tickets/0041-TICKET-website-branding-plan.ticket.md), [WEB-BRAND-01](../tickets/0042-TICKET-black-seo-branding.ticket.md).

## Contract and composition

The change consumes the owner-supplied identity geometry and rebuilds the website-consumed identity in black. It adds the website-local design contract and regenerates only assets already owned by the website identity surface. The current home logo remains commented out. Existing root/page metadata and the noindex/origin gating remain unchanged.

### Acceptance

| ID | Required behavior | Acceptance criterion |
| --- | --- | --- |
| REQ-BSEO-01 | Website design source | `apps/website/DESIGN.md` maps the selected reference to Exphere with pure-black brand primary and explicit source/adaptation boundaries. |
| REQ-BSEO-02 | Horizontal brand asset | `public/brand/exphere-logo.svg` preserves supplied geometry and uses black for both mark and wordmark; no purple/graphite/yellow fill remains. |
| REQ-BSEO-03 | Browser/app identity | `icon.svg`, `icon1.png`, `apple-icon.png`, `favicon.ico`, and 192/512/maskable public icons are black-mark-on-white and keep expected dimensions/manifest paths. |
| REQ-BSEO-04 | Social SEO identity | Open Graph and Twitter PNGs are black-and-white, flat, technical compositions derived from supplied vector artwork; alt text matches visible content. |
| REQ-BSEO-05 | Bounded semantic scope | `layout.tsx`, `page.tsx`, manifest semantics, robots policy, metadata copy, indexing/origin decisions, dependencies, shared design tokens, shader, and deployment config are unchanged. |
| REQ-BSEO-06 | Provenance and validation | `IDENTITY.md` records source ZIP hash, design reference/adaptation, asset hashes, dimensions, and chroma/geometry checks. |
| REQ-BSEO-07 | SDD delivery | Planning commit precedes implementation; each commit declares one ticket; final PR body contains `Spec: SPEC-WEBSITE-BLACK-SEO`; review/CI limitations are explicit. |

### Allowed change manifest

Planning artifacts: PRD-0003, DD-0010, SPEC-0019, this spec, and TICKET-0041/0042.

Website implementation:

- `apps/website/DESIGN.md`, `README.md`, `IDENTITY.md`.
- `apps/website/public/brand/exphere-logo.svg`.
- `apps/website/public/icons/app-192.png`, `app-512.png`, `maskable-512.png`.
- `apps/website/src/app/icon.svg`, `icon1.png`, `apple-icon.png`, `favicon.ico`.
- `apps/website/src/app/opengraph-image.png`, `opengraph-image.alt.txt`, `twitter-image.png`, `twitter-image.alt.txt`.

No other path is authorized by this spec.

## Responsibilities

- Consumer: supplies/approves identity direction and future origin/indexing decisions.
- Platform: preserves the existing website/framework/package boundaries and static-file conventions.
- Service owners: no production service or resource is changed.

## Operation and limits

- No dependency, script, service, secret, environment variable, runtime request behavior, or package interface is added.
- Assets are pre-generated repository files. No runtime image generator or font dependency is introduced.
- White backgrounds remain presentation surfaces; the Exphere identity itself is black. Raster antialiasing may contain neutral grayscale pixels but no chromatic brand pixels.
- Existing metadata intentionally keeps social image URLs inactive until a production origin is accepted; rebuilding the files does not activate them.

## Verification and decisions

- Affected guardrails: SDD v1 and frontend ownership. FinOps/Twelve-Factor are not materially affected by static source assets and documentation; no compliance claim is inferred.
- Verification plan: validate SVG colors/elements, raster decode/dimensions/chroma, ICO frames, maskable essential-mark bounds, manifest path continuity, source hashes, bounded diff, and two-axis Standards/Spec review. Inspect CI after PR publication when available.
- Build/typecheck: no executable TS/JS or dependency file changes are planned. Existing CI remains authoritative for repository integration; a source-only asset validation does not claim a Next.js production build passed.
- Open issues: production origin/indexing launch, restoring the visible home logo, shared-token restyling, font loading, browser appearance, deployment, and SEO outcomes remain outside scope.
- Technical review: required before completion and recorded in TICKET-0042/PR; unavailable independent sub-agent review must be named rather than fabricated.
