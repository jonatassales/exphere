# PRD — Exphere documentation-first website

- ID: `PRD-EXPHERE-DOCS-WEBSITE`
- Document number: `PRD-0006`
- State: `draft`
- Owner: Exphere project owner
- Authorization: October 13, 2026 request to transform the hero into the first Nextra documentation entry, preserve the black/purple motion direction, integrate orbo-voice, and update navigation/footer/copy.
- Baseline: `d6b3c8abff240c54011f81f7088f445e3fbabef4` (`main`).

## User problem and outcome

The website currently presents an experimental marketing hero with a CLI mockup and an external README Docs link. The owner now wants one simpler, centralized, documentation-first product entry with Orbo visual presence, a copyable future installation command, and the beginning of Nextra docs.

A visitor sees one wider centered introductory panel, a dark copy box containing `npx exphere init`, clear navigation to the starter documentation, and a footer with social links and owner-directed attribution.

## Scope

Included:
- Header: replace the experimental label with `Documentation`; render the published `orbo-voice` component at the left of the typographic Exphere mark, monochrome black/gray, `listening` as **visual demo only** (no implied microphone).
- Main: remove right CLI/example card, widen and center the hero; replace eyebrow/title/body exactly with owner-supplied copy; remove early-stage footnote and repository-hosting label.
- Action: a dark `npx exphere init` copy-to-clipboard control with accessible feedback and failure handling. This is a proposed future invocation, **not an assertion that an npm CLI is published or that init works**.
- Documentation: install/configure Nextra documentation framework; preserve the home intro as the entry experience and add just a `/docs` Getting Started page, with no fabricated service/API details.
- Footer: replace text with a small orb and `exphere by Grupo XLO © 2026` and compact accessible icon links. The wording is supplied by the owner, not independently validated as an organizational endorsement.
- Preserve ExphereShader dark purple motion, SSR App Router ownership, original black identity assets, and the noindex/unknown-origin SEO launch gate.

Not included: voice session/provider, microphone permission, publish/release of exphere npm package, functional init, new docs sections, authentication, deployment or indexing.

## Requirements

| Requirement | Observable criterion | Evidence |
| --- | --- | --- |
| WEB-DOC-01 | Header text `Documentation`; Orbo in `listening` visual-only state left of mark with monochrome palette and aligned size. | Source and generated-output review; browser behavior not verified in this cycle. |
| WEB-DOC-02 | Exact requested hero copy; no old CLI right card or early-stage/repository labels. | Rendered and source inspection. |
| WEB-DOC-03 | Single accessible copy control for `npx exphere init`, success/error feedback, keyboard accessibility. | Source contract review; actual clipboard interaction not verified in this cycle. |
| WEB-DOC-04 | Home intro links to first Nextra docs page; `/docs` only shows Getting Started with no invented runtime readiness. | Nextra build and generated-route/link inspection. |
| WEB-DOC-05 | Footer attribution and valid icon-link destinations, no placeholder social URLs. | Accessible-link review. |
| WEB-DOC-06 | Shader, black-logo assets and prelaunch SEO remain intact. | Diff/metadata inspection. |

## Metrics and decision

- Success within this cycle: source and built website satisfy the authorized static/build checks. Keyboard/clipboard execution and visual motion contrast retain a separate browser-verification gap.
- Not claimed: functional `npx exphere init`, production docs URL, SEO indexing, organizational brand approval, browser audits before execution.
- See [SPEC-WEB-DOCS](../specs/0024-SPEC-website-nextra-getting-started.spec.md), [ADR-0004](../design/0012-DD-documentation-architecture.dd.md).
