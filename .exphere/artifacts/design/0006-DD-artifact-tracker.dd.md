# Local artifact tracker

- ID: `DD-0006`
- Status: `active configuration`
- Authority: artifact naming and language requested by the project owner on October 10, 2026; directories follow the owner's current project composition.

The tracker uses local files. Reading this configuration does not authorize creating, editing, or closing remote issues, pull requests, or projects.

## Paths and naming

Every file under `.exphere/artifacts/` uses one of these patterns. Slugs use lowercase English words separated by hyphens; the type marker is uppercase and the suffix is lowercase.

| Type | Directory | Filename pattern |
| --- | --- | --- |
| Product requirements | `.exphere/artifacts/prd/` | `0001-PRD-<slug>.prd.md` |
| Technical specification | `.exphere/artifacts/specs/` | `0001-SPEC-<slug>.spec.md` |
| Work ticket | `.exphere/artifacts/tickets/` | `0001-TICKET-<slug>.ticket.md` |
| Research | `.exphere/artifacts/research/` | `0001-RSC-<slug>.rsc.md` |
| Design document, including agent configuration | `.exphere/artifacts/design/` | `0001-DD-<slug>.dd.md` |

Allocate the next available four-digit number per type across `.exphere/artifacts/`. Agent configuration designs share the DD sequence and the design directory. Do not restart a type's sequence for each initiative. Preserve existing IDs when relocating or renaming an artifact; a filename number does not approve its content. Never overwrite an existing numbered file.

PRDs, specs, and tickets have their own directories. Design files use the DD pattern. Architectural decision records are design documents with explicit decision status; preserve any existing decision ID inside the document. Intake, discovery, verification, review, and decisions can be sections of the relevant typed artifact rather than creating untyped files or a fixed initiative tree.

All project content is written in en-US. Conversation language does not change artifact language. Use the existing templates in `.agents/templates/` and the user's requested scope. Create only artifacts required for the authorized phase.

## States and authorization

New work artifacts start as `draft`. A decision record identifies the responsible person, explicit decision, scope, and exact artifact revision. `approved` means documented approval for that scope. `ready-for-agent` requires approved input and authorization to execute; generation alone does not grant readiness.

Ticket states are `draft`, `ready-for-agent`, `in-progress`, `in-review`, `done`, and `blocked`. A blocked ticket names the blocking condition and the state to return to. Material scope changes require reconsidering readiness. Workflow lifecycle states are separately described in the [workflow definition](../../workflow/definition.json); they are not ticket states.

Existing explicit authorization remains valid for the same scope. Do not invent identities, dates, approvals, or commitments. Prioritization is a human decision recorded with the relevant PRD, spec, ticket, or design document.

Git can provide history when available and commits are authorized. The owner authorized initializing this repository on October 11, 2026; commits and remote publication still require their corresponding authorization. Local Markdown does not authenticate signatures, control access, or enforce transitions.

## Repository composition and historical resolution

| Location | Current responsibility |
| --- | --- |
| [`.exphere/artifacts/`](../) | Authored PRDs, specs, tickets, research, and DDs; agent configuration DDs are consolidated in `design/` |
| [`.exphere/harness/`](../../harness/) | FinOps/AWS skills and numbered SDD, FinOps, and Twelve-Factor rules and guardrails |
| [`.exphere/workflow/`](../../workflow/README.md) | Common lifecycle, AIHero skills, and the surviving Dev, operations, SRE, and FinOps documents |
| [`.agents/`](../../../.agents/README.md) | Local guidance, engineering rules, frontend guardrails, templates, and Go skills |

The former skill lock, evidence README, shared guardrail index, CLI-context ADR, and Design workflow document remain unavailable. Surviving guidance and formats do not establish replacement contracts. Generated browser output remains under `.audits/evidence/runs/`; deleting its README does not relocate those outputs. Runtime configuration remains separate in `.exphere/runtimes/` and is not covered by blanket artifact or harness exclusions.

Historical `.artifacts/` paths are not a second authoring location. SDD checks inspect the Git index or each commit's tree, reading both `.exphere/artifacts/` and `.artifacts/` for compatibility. They count artifacts by path, not unique blob hash, so repeated identities across roots remain ambiguous. A working-tree edit cannot repair staged or historical evidence. Keep historical hashes and review records attached to the snapshot they describe.
