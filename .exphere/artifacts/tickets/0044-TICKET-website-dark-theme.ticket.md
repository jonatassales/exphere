# WEB-DARK-01: Apply the dark theme to the hero and motion background

**Spec:** [SPEC-WEBSITE-DARK-THEME v1](../specs/0022-SPEC-website-dark-theme.spec.md)
**What to build:** Replace the light/white Exphere hero, CLI cards and browser chrome with the ClickHouse-derived dark-only palette and readable white type. Keep the existing animated shader but provide it dark neutral colors, preserving its current default public consumer behavior. Keep the Docs CTA, SEO launch gate, black logo assets and responsive layout.
**Blocked by:** None. The merged [hero spec](../specs/0021-SPEC-website-hero-documentation.spec.md) and existing website DESIGN.md provide the baseline.
**Status:** ready-for-agent
**Approval:** The owner's October 13, 2026 request explicitly authorizes the PRD, spec, ticket, implementation, commit and PR for this exact dark-theme scope; prior motion preservation continues. No merge, deployment or public launch authorized.

- [ ] REQ-DARK-01: dark document/viewport/manifest browser chrome.
- [ ] REQ-DARK-02: dark hero and CLI panels, no white/light cards.
- [ ] REQ-DARK-03: white and neutral accessible text, visible white CTA, responsive/mobile layout.
- [ ] REQ-DARK-04: existing shader still animates, with dark neutral WebGL and fallback colors.
- [ ] REQ-DARK-05: opt-in shader palette keeps old default working; targeted consumer regression coverage.
- [ ] REQ-DARK-06: original black artwork, Docs link, CLI commands and noindex SEO remain unchanged.
- [ ] REQ-DARK-07: full bounded diff review, stated verification, traceable commit and PR.

## Evidence

Awaiting implementation and review. Acceptance remains tied to the actual checked revision, not to a generated spec.
