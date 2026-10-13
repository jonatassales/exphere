# PRD — OLX-inspired purple accents and dark motion

- ID: `PRD-WEBSITE-PURPLE-ACCENT`
- Document number: `PRD-0005`
- State: `approved for this scoped implementation`
- Owner: Exphere project owner
- Request: October 13, 2026 — replace the ClickHouse-like bright accent with OLX-inspired purple while retaining the black website and Exphere motion background.
- Sources: supplied `DESIGN-clickhouse.md` and `SENIOR-STAFF-REACT-TS-JS-MOTION-SURFACES.role(1).md`; existing the original website visual contract (now retired); [dark-only website PRD](0004-PRD-website-dark-theme.prd.md).
- Current successor: [website refresh and retained provenance](../specs/0031-SPEC-website-docs-refresh.spec.md#retained-asset-provenance); this was not an input to the historical approval below.
- Baseline: `a9c78f33ab1f7bfaed26dccfd2ad27477b026734` (`main`, dark-theme PR #17 merged).

## Problem and expected outcome

The existing website correctly uses the ClickHouse-derived near-black canvas, charcoal panels, white type and preserved ExphereShader, but its only primary action remains neutral white and the animated surface is grayscale. The owner wants the striking single-accent visual language of the reference, substituting an OLX-inspired purple for the reference's yellow-green accent.

Visitors should see a coherent **black + purple** Exphere interface with a clear documentation CTA, a restrained purple highlight in the hero and technical labels, and purple-toned motion underneath the dark panels. The background must remain dark and animated. No new UI flow, product claim or production launch is requested.

## Scope

- Included:
  - Keep `#0a0a0a` canvas and established neutral dark surfaces.
  - Introduce one purple accent family owned by the website: source/accent `#6d0ad6`, hover `#8c3bef`, readable small text `#ba86ff`.
  - Apply purple to the documentation CTA, selected hero/terminal emphasis, and restrained motion palette.
  - Preserve the existing WebGL renderer, animation timing, fallbacks, reduced-motion support, and dark document/manifest.
  - Amend website design guidance and record this new direction without overwriting historical decisions.
  - Verify contrast of relevant static color pairs and bounded-source consistency.

- Excluded:
  - Recoloring black Exphere logo SVGs, favicon, app icons, or brand-only SEO image exports; OLX wordmarks, shapes, official brand assets or affiliation.
  - Literal copying of ClickHouse's yellow/green CTA; new accents other than purple; new light cards; theme toggle.
  - New Motion JS/React dependencies or replacing the existing shader implementation.
  - New marketing content, navigation, docs site, search indexing, analytics, API integrations, deployment or merge.

The selected `#6d0ad6` is the project's previously authored purple color and is **OLX-inspired**, not a claim of independently verified official OLX brand-token equivalence. Bright `#ba86ff` is a contrast adaptation for text over charcoal rather than another brand hue.

## Requirements and acceptance

| ID | User-facing outcome | Evidence |
| --- | --- | --- |
| REQ-PURPLE-01 | Dark theme remains intact. | Dark document/manifest, charcoal panels, white headings; no white cards or light page regions introduced. |
| REQ-PURPLE-02 | Purple is the sole accent. | New semantic purple roles; CTA and restrained hero/CLI highlight; no yellow/green new UI accents. |
| REQ-PURPLE-03 | The docs CTA remains accessible. | Same URL/label and keyboard focus; white text on purple background meets WCAG AA at rest and hover. |
| REQ-PURPLE-04 | Motion stays active and dark. | Existing root `ExphereShader` mount with opt-in dark-purple inputs and near-black background; no animation code change. |
| REQ-PURPLE-05 | Product/SEO/identity stays truthful. | Original experimental copy, CLI commands, disabled logo and noindex/origin-neutral SEO metadata untouched. |
| REQ-PURPLE-06 | Delivery is traceable. | PRD, spec, ticket, reviewed feature-branch diff, one Ticket trailer per commit and PR spec declaration. |

## Measures, approval and decisions

- Visual acceptance is subject to actual browser review; token contrast arithmetic alone cannot certify legibility over moving translucent surfaces.
- Existing shader behavior and general public package contracts are preserved. No new recurring cost or service is introduced.
- Authorization: project owner's October 13, 2026 change instruction, in the ongoing Exphere website implementation/feature-PR workflow.
- Implementation: [SPEC-WEBSITE-PURPLE-ACCENT](../specs/0023-SPEC-website-purple-accent.spec.md), tracked by [WEB-PURPLE-01](../tickets/0045-TICKET-website-purple-motion.ticket.md).
