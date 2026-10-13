# SKILLS-OWN-01: Install Go skills and relocate AIHero workflow skills

**Spec:** [SPEC-SKILL-OWNERSHIP-MIGRATION v1](../specs/0027-SPEC-skills-relocation.spec.md)
**Status:** ready-for-agent
**Approval:** Owner's October 13, 2026 exact skill list, deletion and ownership change.
**Blocked by:** None; this work is independent from CLI and website changes.

**What to build:** Vendor all 20 distinct requested Go skills under `.agents/skills`, move 11 existing AIHero workflow skills under `.exphere/workflow/skills`, remove the obsolete writing-for-agents/ADR placeholders and repair navigation.

- [ ] Exactly 20 unique Go `SKILL.md` entrypoints and required references/assets are present.
- [ ] Source revision and MIT license attributed; duplicate Go CLI skill avoided.
- [ ] Eleven AIHero workflow skills retain their full source/support files and canonical new paths.
- [ ] No duplicate old workflow copies, writing-for-agents or `.agents/adr` remain.
- [ ] Active references are repaired; other FinOps/AWS vendor skill ownership preserved.
- [ ] No outside-CLI scripts directory introduced.
