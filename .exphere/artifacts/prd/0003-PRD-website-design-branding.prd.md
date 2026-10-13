# PRD — website design language and monochrome SEO identity

- ID: `PRD-WEBSITE-DESIGN-BRANDING`
- Document number: `PRD-0003`
- State: `approved for scoped implementation`
- Product/journey owner: project owner
- Sources: owner direction on October 13, 2026; [ClickHouse design-system analysis](https://getdesign.md/clickhouse/design-md); supplied `exphere-identity-seo(1).zip` (`c1a0bd65799cbcd77dbf63371984f39ea5e551d423a1d86e9b9e6d414ded61ad`).

## Problem and outcome

- Users and problem supported by evidence: future website changes have a generic token foundation but no durable website-specific design language, while the current SEO identity pack still encodes purple/graphite branding that conflicts with the owner's black-brand direction.
- Related business objective: present Exphere as a precise, technical agentic software runtime factory with a consistent identity across browser, social sharing, and future website work.
- Expected outcome and value hypothesis: one website design source and one monochrome brand treatment reduce visual drift and make SEO/browser assets consistent with the selected technical-documentation design language.
- Baseline and comparison method: main `49ba260e45250172e0e4ea090627b724569d420d`; compare design documentation, SVG color values, raster chroma, dimensions, manifest references, and the bounded Git diff.

## Scope

- Included: a website-local visual contract (now retired); black Exphere logo; black-on-white browser/app icons; black-and-white Open Graph and X/Twitter cards; asset provenance/alt-text documentation; PRD/ADR/spec/ticket traceability.
- Out of scope: restoring the currently commented home logo, redesigning page content, changing shared `@repo/design` tokens, adding fonts or dependencies, changing metadata copy, accepting a production origin, enabling indexing, adding sitemap/entity/social-profile facts, deployment, or merge.
- Dependencies, constraints, and open questions: the ClickHouse reference is an independent design analysis, not an affiliation or license to reuse ClickHouse marks. Structural principles are adapted; ClickHouse yellow is intentionally not adopted. Production origin/indexing remains an independent launch decision.

## Requirements and acceptance

| Requirement | Behavior/outcome | Verifiable criterion | Expected evidence |
| --- | --- | --- | --- |
| REQ-BRAND-001 | Canonical website design language | The former website visual contract recorded the ClickHouse-derived technical rules and the Exphere-specific monochrome override. | Source review against the selected external reference and owner direction. |
| REQ-BRAND-002 | Black brand identity | Exphere mark and wordmark use black only; no purple/yellow/chromatic brand pixels remain in consumed website identity assets. | SVG inspection and raster chroma scan. |
| REQ-BRAND-003 | SEO/browser consistency | Favicon, Apple/app/maskable icons and social cards use the same black-on-white identity and retain required dimensions/references. | Image decode, dimensions, ICO frame, maskable-boundary, manifest-path checks. |
| REQ-BRAND-004 | Technical, flat visual language | SEO cards use white canvas, black identity, technical line work, restrained geometry, and no shadows/gradients. | SVG/raster visual-source inspection. |
| REQ-BRAND-005 | Existing SEO truth boundaries remain intact | No production origin, canonical, sitemap, entity facts, indexability, metadata copy, or route contract changes are introduced. | Git diff and metadata-source comparison. |
| REQ-BRAND-006 | Traceable delivery | Planning precedes asset implementation; commits have one Ticket trailer; the PR declares one implementation spec and records review/CI state. | Git history and PR metadata. |

## Metrics and decision

- Success metrics, owners, and windows: source-level acceptance in this implementation cycle; no production traffic/SEO metric is claimed before launch.
- Targets not yet approved: search ranking, click-through rate, Core Web Vitals, brand-recognition measures, and production-indexing outcomes.
- Scope approval: owner direction on October 13, 2026 authorizes this PRD scope, implementation, review, feature-branch publication, and PR creation; merge/deploy are not authorized.
- Implementation decisions: `ADR-0002`, `SPEC-WEBSITE-DESIGN-SYSTEM`, and `SPEC-WEBSITE-BLACK-SEO`.
