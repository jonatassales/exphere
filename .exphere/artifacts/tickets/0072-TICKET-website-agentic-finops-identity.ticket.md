# BRAND-01: Update website identity, links and disabled clipboard

**Spec:** [SPEC-WEBSITE-AGENTIC-FINOPS-IDENTITY v1](../specs/0035-SPEC-website-agentic-finops-identity.spec.md)
**What to build:** Apply the owner-requested Home/Docs identity copy, disabled clipboard styling and behavior, shared Neongate black-hole footer, and social destinations.
**Blocked by:** None.
**Status:** in-review
**Approval:** Owner requested Spec → ticket → implementation → PR on October 13, 2026. Commits and PR publication are authorized; merge/deployment are not.

- [x] IDENTITY-01: Replace the hero eyebrow.
- [x] IDENTITY-02: Make command-copy interaction truly disabled and visibly muted.
- [x] IDENTITY-03: Reuse the black-hole orb with `Neongate © 2026` in the shared footer.
- [x] IDENTITY-04: Correct Home LinkedIn/GitHub links, accessible text and Docs project link.
- [x] IDENTITY-05: Update website README to match behavior.
- [x] VER-IDENTITY-01: Inspect scoped source diff and record available static evidence and missing runtime/reviewer checks.
- [ ] Open ticket-linked PR without merging.

## Evidence

Baseline: `a2b78dcf8ba60724654760018c589fd2aef008e7` on `main`. Implementation source: `8496a8db62f29f0e7e8a836d09d7f40c27ca3a0f`. The five requirements were checked by scoped source inspection against the pinned baseline; a two-axis manual code review found no apparent defects. Independent sub-agent review, Biome, TypeScript, production build, browser checks and CI were not performed in the GitHub-connector-only session. See the parent spec for detailed evidence and limitations. PR publication remains pending.
