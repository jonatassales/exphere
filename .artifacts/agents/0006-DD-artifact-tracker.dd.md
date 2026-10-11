# Local artifact tracker

- ID: `DD-0006`
- Status: `active configuration`
- Authority: artifact directories, naming, language, and removals explicitly requested by the project owner on October 10, 2026.

The tracker uses local files. Reading this configuration does not authorize creating, editing, or closing remote issues, pull requests, or projects.

## Paths and naming

Every file under `.artifacts/` uses one of these patterns. Slugs use lowercase English words separated by hyphens; the type marker is uppercase and the suffix is lowercase.

| Type | Directory | Filename pattern |
| --- | --- | --- |
| Product requirements | `.artifacts/prd/` | `0001-PRD-<slug>.prd.md` |
| Technical specification | `.artifacts/specs/` | `0001-SPEC-<slug>.spec.md` |
| Work ticket | `.artifacts/tickets/` | `0001-TICKET-<slug>.ticket.md` |
| Research | `.artifacts/research/` | `0001-RSC-<slug>.rsc.md` |
| Design document | `.artifacts/design/` | `0001-DD-<slug>.dd.md` |
| Agent configuration design | `.artifacts/agents/` | Same DD pattern and sequence |

Allocate the next available four-digit number per type across `.artifacts/`, including DDs in both design and agent configuration directories. Do not restart a type's sequence for each initiative. Preserve existing IDs when relocating or renaming an artifact; a filename number does not approve its content. Never overwrite an existing numbered file.

PRDs, specs, and tickets have their own directories. Design files use the DD pattern. Architectural decision records are design documents with explicit decision status; preserve any existing decision ID inside the document. Intake, discovery, verification, review, and decisions can be sections of the relevant typed artifact rather than creating untyped files or a fixed initiative tree.

All project content is written in en-US. Conversation language does not change artifact language. Use the existing templates in `.agents/templates/` and the user's requested scope. Create only artifacts required for the authorized phase.

## States and authorization

New work artifacts start as `draft`. A decision record identifies the responsible person, explicit decision, scope, and exact artifact revision. `approved` means documented approval for that scope. `ready-for-agent` requires approved input and authorization to execute; generation alone does not grant readiness.

Ticket states are `draft`, `ready-for-agent`, `in-progress`, `in-review`, `done`, and `blocked`. A blocked ticket names the blocking condition and the state to return to. Material scope changes require reconsidering readiness. Workflow lifecycle states are separately described in the [workflow definition](../../.exphere/workflows/definition.json); they are not ticket states.

Existing explicit authorization remains valid for the same scope. Do not invent identities, dates, approvals, or commitments. Prioritization is a human decision recorded with the relevant PRD, spec, ticket, or design document.

Git can provide history when available and commits are authorized. The current directory has no Git metadata. Local Markdown does not authenticate signatures, control access, or enforce transitions.
