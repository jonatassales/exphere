# Agent skill ownership, provenance and path migration

- ID: `DD-0013`
- Decision ID: `ADR-0005`
- Status: `accepted for bounded skill relocation and local Go installation`
- Owner: Exphere project owner
- Date: October 13, 2026
- PRD: [PRD-SKILL-OWNERSHIP](../prd/0008-PRD-skills-ownership.prd.md)

## Decision

- Local Go skills: `.agents/skills/<golang-*>`. Vendor exact upstream Samber `SKILL.md` and necessary references/assets for the 20 **unique** explicitly requested skills. A duplicated `golang-cli` URL installs once. Include upstream attribution and license, pin the source commit/tree and explain skipped evaluation fixtures if applicable.
- AIHero/Matt Pocock catalog: preserve and relocate the 11 existing local adaptations currently stored in `.exphere/harness/skills` to `.exphere/workflow/skills/<skill>`. Preserve their README/supporting files, Git blobs, attribution, and stable names. Do not silently replace them with newer upstream copies. Install the other 15 catalog skills from the pinned upstream revision; the 27-item catalog minus writing-for-agents yields 26 local skills. The [catalog inventory](../../workflow/skills/README.md) records provenance, preserved adaptations, optional helper omissions and the retained MIT license.
- Unrelated FinOps/AWS vendor skills remain outside AIHero ownership, with any shell helper scripts removed or intentionally migrated without directories named `scripts` outside the CLI.
- Remove `.agents/skills/writing-for-agents/` completely and the unused `.agents/adr/.gitkeep`.
- Update active navigation and skill invocation references to the new owners. Historical artifact evidence may mention former paths, but should be labeled historical; broken active navigation must be fixed.
- Reevaluate workflow skill discovery paths; moving files alone does not prove automatic agent discovery.

## Eleven preserved AIHero/Pocock adaptations

`code-review`, `codebase-design`, `domain-modeling`,
`grill-with-docs`, `grilling`, `implement`, `research`,
`retro`, `tdd`, `to-spec`, `to-tickets`.

## Consequences

The shared-harness `skills/` directory is no longer the canonical owner for
these workflow specialties. The repository's selected `@repo/design`
and front-end code contracts are unaffected. Go skills contain third-party
licensed content; copying does not assert authorship or grant an organizational
engineering approval. Review the moved files against their source hashes before
declaring exact provenance.
