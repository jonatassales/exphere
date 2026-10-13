# Go skills installation and AIHero workflow-skill relocation

- ID: `SPEC-SKILL-OWNERSHIP-MIGRATION`
- Document number: `SPEC-0027`
- Version: `1`
- State: `approved for implementation; verification pending`
- PRD: [PRD-SKILL-OWNERSHIP](../prd/0008-PRD-skills-ownership.prd.md)
- ADR: [ADR-0005](../design/0013-DD-skill-ownership.dd.md)
- Ticket: [SKILLS-OWN-01](../tickets/0049-TICKET-go-and-workflow-skills.ticket.md)
- Baseline: `d6b3c8abff240c54011f81f7088f445e3fbabef4`.

## Contract

Install 20 **unique** Samber `cc-skills-golang` skills explicitly selected by
the user under `.agents/skills/<name>/`: cli, testing, error-handling,
security, design-patterns, performance, concurrency, context, naming,
database, safety, data-structures, project-layout, modernize,
observability, dependency-management, structs-interfaces,
dependency-injection, benchmark, grpc. The duplicated `golang-cli`
listing is deduplicated. Preserve `SKILL.md`, supporting references/
assets, upstream provenance and MIT licensing.

Relocate AIHero/Pocock-derived workflow skills already vendored in
`.exphere/harness/skills` into `.exphere/workflow/skills`:
`code-review`, `codebase-design`, `domain-modeling`,
`grill-with-docs`, `grilling`, `implement`, `research`,
`retro`, `tdd`, `to-spec`, `to-tickets`. Preserve exact existing
source and agent support files where possible; update active navigation,
workflow references and SKILL.md relative links. Do not move non-AIHero
FinOps/AWS vendor skills into the workflow namespace by name alone.

Delete `.agents/skills/writing-for-agents/` and `.agents/adr/`,
and remove dead active navigation. Do not silently restore other removed
skills or claim new organization-wide governance.

## Acceptance

| ID | Criterion |
| --- | --- |
| SKILLS-01 | Exactly 20 requested Go skill entrypoints installed, with required support files and attribution. |
| SKILLS-02 | Eleven existing AIHero workflow skills available at the new canonical path and removed from the former location. |
| SKILLS-03 | writing-for-agents and `.agents/adr` absent. |
| SKILLS-04 | Active skill links and instructions point to new locations; no accidental broken self-links. |
| SKILLS-05 | FinOps/AWS skills not misattributed; licensing and source commit documented. |
| SKILLS-06 | No scripts-directory introduction outside Go CLI. |

## Verification

Compare Git blobs for migrated skills, inspect vendored Go SKILL.md links
against included support files, check actual tree path inventory, and run
repository-native checks when possible. An installed SKILL.md is not proof of
agent auto-discovery. Record missing source/license material honestly.
