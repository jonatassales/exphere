# SKILLS-OWN-01: Install Go skills and relocate AIHero workflow skills

**Spec:** [SPEC-PR19-COMPLETION v1](../specs/0028-SPEC-pr19-completion.spec.md)
**Focused contract:** [SPEC-SKILL-OWNERSHIP-MIGRATION v1](../specs/0027-SPEC-skills-relocation.spec.md)
**Status:** in-review
**Approval:** Owner's October 13, 2026 exact skill list, deletion and ownership change.
**Blocked by:** None; this work is independent from CLI and website changes.

**What to build:** Vendor all 20 distinct requested Go skills under `.agents/skills`, preserve the 11 existing adaptations and install the other 15 requested AIHero catalog skills under `.exphere/workflow/skills`, remove the obsolete writing-for-agents/ADR placeholders and repair navigation.

- [x] Exactly 20 unique Go `SKILL.md` entrypoints and required references/assets are present.
- [x] Source revision and MIT license attributed; duplicate Go CLI skill avoided.
- [x] All 26 AIHero catalog skills except the explicitly deleted writing-for-agents are present; 11 existing adaptations retained, 15 missing skills installed with pinned license/provenance. Optional upstream shell templates are omitted under the owner script boundary and documented.
- [x] No duplicate old workflow copies, writing-for-agents or `.agents/adr` remain.
- [x] Active references are repaired; other FinOps/AWS vendor skill ownership preserved.
- [x] No outside-CLI scripts directory introduced.

## Completion audit evidence — October 13, 2026

- Compared all 126 non-evaluation files for the 20 requested Go skills to pinned upstream commit `8e899e20ff0cd4dc524af3993e4c62d8ee8c5717`. Restored the one missing file, `golang-benchmark/references/benchstat.md`; all retained files and the MIT license match upstream bytes.
- Inspected the public AIHero catalog: 27 entries, including the explicitly excluded writing-for-agents. The local catalog now contains 26 skills: 11 preserved adaptations and 15 newly installed entries at commit `49dd158d1076134a641b33efb035946536778336`. The [catalog](../../workflow/skills/README.md) records the complete mapping, restored MIT license and optional shell-template omissions.
- Removed the two FinOps shell helpers and replaced their dead invocation instructions with scoped native read-only gh commands. No billing queries or cloud actions were performed.
- Inspected relative links in changed Markdown: the only apparent missing path is the literal `[Topic](link)` example inside the upstream wayfinder template, not an active document reference.
- The bundled Python skill validator could not start because PyYAML is unavailable. A separate check with the already installed YAML 2.9.1 parser subsequently parsed all 46 Go/workflow entrypoints and verified nonempty descriptions and names matching their directories. This is frontmatter validation, not the unexecuted Python validator, automatic client discovery, or a behavioral evaluation of skills.

Implementation and two-axis review are complete; owner acceptance remains pending in PR #19. The integration ticket records the reviewed source and verification boundaries.
