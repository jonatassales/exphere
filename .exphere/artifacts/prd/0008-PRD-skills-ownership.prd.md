# PRD — Installed Go and workflow skill ownership

- ID: `PRD-SKILL-OWNERSHIP`
- Document number: `PRD-0008`
- State: `draft`
- Owner: Exphere project owner
- Baseline: `d6b3c8abff240c54011f81f7088f445e3fbabef4`.
- Sources: owner's October 13, 2026 explicit list of 21 Go skill URLs (20 distinct: `golang-cli` repeated), [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang), and [AI Hero skills](https://www.aihero.dev/skills).

## Desired result

Go engineering guidance belongs in `.agents/skills/` and the complete requested AIHero catalog (except the explicitly deleted writing-for-agents) belongs under `.exphere/workflow/skills/`; eliminate the obsolete `writing-for-agents` skill and the unused `.agents/adr/` placeholder. Preserve attribution, licensed source text, and necessary supporting references when relocating bundled third-party skills.

## Requirements

| ID | Criterion |
| --- | --- |
| SKL-01 | Install each **unique** requested Samber Go skill in its own `.agents/skills/<name>/SKILL.md`, including upstream support material needed for execution, with source and license recorded. |
| SKL-02 | Cover the public AIHero catalog at `.exphere/workflow/skills/`: preserve the 11 existing adaptations and add 15 missing catalog skills; exclude writing-for-agents as explicitly requested. Preserve support material except optional shell helpers forbidden outside the CLI, recording those omissions. No duplicate authoritative copies remain in `.exphere/harness/skills/`. |
| SKL-03 | Keep unrelated FinOps/AWS third-party skills in their currently owned namespace, except explicit script-path retirement. |
| SKL-04 | Delete `.agents/skills/writing-for-agents/` and `.agents/adr/`; repair active navigation and invocation paths. |
| SKL-05 | Keep reproducible provenance (upstream repo, version/commit and MIT licensing) without inventing third-party authorship or claiming an unrun installer. |

## Decision

Treat `.agents/skills/` as local Go agent-skill ownership and `.exphere/workflow/skills/` as reusable workflow skill ownership. Source tree content is vendored, not dynamically fetched at runtime. See [SPEC-SKILL-OWNERSHIP-MIGRATION](../specs/0027-SPEC-skills-relocation.spec.md) and [DD-0013](../design/0013-DD-skill-ownership.dd.md).
