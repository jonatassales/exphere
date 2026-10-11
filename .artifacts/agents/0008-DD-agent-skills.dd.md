# Agent skills

- ID: `DD-0008`
- Status: `configuration with recorded limitations`

The project includes 12 Matt Pocock skills and four FinOps skills selected on October 10, 2026. They support research, discussion, specifications, tickets, implementation, review, and retrospectives. Their presence does not establish organizational adoption or an automated executor.

Start with the [local rules](../../.agents/rules/README.md) and [guardrails](../../.agents/guardrails/README.md). The previous consolidated FinOps prompt is unavailable; these references do not claim to include its full analysis or corrections to third-party examples.

## Installed FinOps skills

| Directory | Skill name | Scope |
| --- | --- | --- |
| `finops-workflows` | `finops-workflows` | GitHub Actions run analysis and two shell scripts. |
| `finops-cost-optimization` | `finops-cost-optimization` | OCI cost analysis and CLI reference. |
| `aws-cost-finops` | `aws-cost-optimization` | AWS guidance, governance references, and a report template. |
| `finops-expert` | `finops-expert` | Cost concepts and illustrative code. |

Public sources, pinned revisions, hashes, and license details are recorded under `external_skills` in the [skill lock](../../.agents/skills.lock.json). Installation did not run cloud examples, billing queries, or scripts. Client-specific metadata does not demonstrate equivalent permissions or model behavior in another client. Related skills that are not installed remain unavailable; references to them do not authorize installation.

The [candidate research](../research/0002-RSC-finops-twelve-factor-skills.rsc.md) records a separate historical selection. Those candidates were not installed by that research. Automatic discovery and behavioral compatibility remain unverified.

## Public attribution and versioning

- Pocock source: [mattpocock/skills](https://github.com/mattpocock/skills).
- Pinned revision: [`49dd158d1076134a641b33efb035946536778336`](https://github.com/mattpocock/skills/tree/49dd158d1076134a641b33efb035946536778336).
- Public [MIT license at that revision](https://github.com/mattpocock/skills/blob/49dd158d1076134a641b33efb035946536778336/LICENSE).
- The license location recorded in the lock is absent from the current tree. Do not claim local license completeness; retain attribution and record the limitation without recreating removed directories automatically.
- Local skills live under `.agents/skills/`. The lock records source and local hashes, invocation policies, dependencies, and adaptations.

There are no automatic updates or global installations. A future update must inspect the selected public revision, preserve necessary local behavior, and update version and license records as applicable. A hash establishes content identity, not functional quality or approval.

## Skills and invocation

| Skill | Input | Skill dependencies |
| --- | --- | --- |
| `research` | Question and primary sources | Delegates research and records an RSC artifact. |
| `grill-with-docs` | Explicitly requested discovery | `grilling`, `domain-modeling`. |
| `grilling` | Open decisions and prerequisites | None. |
| `domain-modeling` | Domain terms and consequential decisions | Includes glossary and decision guidance. |
| `to-spec` | Conversation or discovery to synthesize | None. |
| `to-tickets` | Spec or plan to decompose | None. |
| `implement` | Authorized implementation scope | `tdd` only when permitted; `code-review` for the result. |
| `tdd` | Agreed behavior and verification seam | `codebase-design` as needed; currently subject to the test prohibition. |
| `codebase-design` | Module or interface design question | None. |
| `code-review` | Scoped changes and comparison | Separate standards and spec review. |
| `retro` | Session to evaluate | `writing-for-agents`. |
| `writing-for-agents` | Agent-facing documentation | Includes skill mechanics. |

`grill-with-docs`, `to-spec`, `to-tickets`, `implement`, and `retro` retain explicit invocation. Preserve `disable-model-invocation` and the corresponding metadata. Invoking one phase does not invoke the next. Without a Skill tool, read the relevant local `SKILL.md`; that fallback does not prove automatic discovery in every client.

The [artifact tracker](0006-DD-artifact-tracker.dd.md) and [domain configuration](0007-DD-domain-model.dd.md) are authoritative. No remote tracker is implied. All project artifacts use en-US and the configured typed filenames.

## Local adaptations and evidence

The skill instructions define procedural boundaries: tracker-aware drafting, explicit authorization for commits, review of uncommitted work, and snapshots for directories without Git. Artifact paths, typed filenames, research placement, and design-decision guidance follow the current configuration. Changes to skill content require corresponding local hashes and adaptation notes in the lock; public source hashes remain historical evidence of the pinned revision. Local prose uses American English while public names, source references, and identifiers remain unchanged.

Earlier structural inspection recorded 12 Pocock skills and 31 files, metadata syntax, invocation policies, references, and hashes. Those records describe that inspection, not a current runtime result or a guarantee after later changes. The prior validator could not start because its Python YAML dependency was unavailable; no global package was installed to bypass that limitation.

No skill discovery test, behavioral evaluation, workflow execution, or governance engine validation has been performed by this documentation change. Governance remains procedural and documentary.
