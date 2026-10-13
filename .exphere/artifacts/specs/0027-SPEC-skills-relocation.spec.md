# Go skills installation and complete AIHero catalog ownership

- ID: `SPEC-SKILL-OWNERSHIP-MIGRATION`
- Document number: `SPEC-0027`
- Version: `1`
- State: `draft`
- Implementation authorization: owner's October 13, 2026 original request and PR #19 completion request; verification/review acceptance recorded separately.
- Integrated delivery: [SPEC-PR19-COMPLETION](0028-SPEC-pr19-completion.spec.md); this remains the focused contract, with the original stable ID preserved.
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
workflow references and SKILL.md relative links. Also install the 15 missing public catalog skills from pinned source revision `49dd158d1076134a641b33efb035946536778336`, as listed in the [inventory](../../workflow/skills/README.md). The live October 13 catalog has 27 entries; explicitly exclude writing-for-agents, yielding 26 installed workflow skills. Preserve the upstream MIT license and record local adaptations. Optional diagnosing-bugs/wizard shell templates are omitted under the owner CLI-only script rule; affected skills must describe their unavailability. Do not move non-AIHero FinOps/AWS vendor skills into the workflow namespace by name alone.

Delete `.agents/skills/writing-for-agents/` and `.agents/adr/`,
and remove dead active navigation. Do not silently restore other removed
skills or claim new organization-wide governance.

## Acceptance

| ID | Criterion |
| --- | --- |
| SKILLS-01 | Exactly 20 requested Go skill entrypoints installed, with required support files and attribution. |
| SKILLS-02 | All 26 requested AIHero skills are at the new canonical path: 11 preserved adaptations plus 15 added catalog skills, with no duplicate former copies. |
| SKILLS-03 | writing-for-agents and `.agents/adr` absent. |
| SKILLS-04 | Active skill links and instructions point to new locations; no accidental broken self-links. |
| SKILLS-05 | FinOps/AWS skills not misattributed; licensing and source commit documented. |
| SKILLS-06 | No scripts-directory introduction outside Go CLI. |

## Verification

Compare Git blobs for migrated skills, inspect vendored Go SKILL.md links
against included support files, check actual tree path inventory, and run
repository-native checks when possible. An installed SKILL.md is not proof of
agent auto-discovery. Record missing source/license material honestly.
