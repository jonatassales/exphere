# Documentation and workflows

- ID: `SPEC-DOCS-WORKFLOWS`
- Document number: `SPEC-0001`
- Version: `2`
- Status: `implemented; advisory technical review recorded`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md), draft; no product approval recorded.
- Design: [DD-0001](../design/0001-DD-exphere.dd.md).
- Technical owners: the project owner accepts scope; the agent prepares artifacts. Other owners are unassigned.
- Authorization: on October 10, 2026, after the artifact and language reorganization, the project owner explicitly invoked `implement` for this current spec and its four tickets in the same conversation. This authorizes the bounded documentary implementation of version 2; it does not approve the broader draft PRD, organizational adoption, tests, commits, or publication.

## Contract and composition

- Requirements covered: `REQ-DOC-01` through `REQ-DOC-07`.
- Consumer-selected components: existing documentation, four workflow domains, installed Pocock skills, and the local artifact tracker.
- Environment and executor: local documents, with manual or agent-assisted work. No workflow engine or application execution is included.
- Extension points and lifecycle: common SDD lifecycle with domain specializations. Dev describes planning, execution, review, audit, and refinement without replacing the common lifecycle.
- Configuration, secret references, and data ownership: no application settings, credentials, or business data changes; the project owns its local artifacts.

### Problem and intended result

Deleted files left documentation out of sync with the current tree. Some descriptions still implied that absent applications and scripts were available. The workflow documents also need their own location and an explicit Dev entry.

The intended result is accurate, navigable project documentation and a separate workflow location that preserves the four existing domains while adding Dev. The authorized documentation prerequisite has already established typed artifact directories and en-US content. Implementation must inspect the current files instead of assuming that every earlier reference defect is still present.

### User stories and requirements

| ID | Story and observable behavior |
| --- | --- |
| REQ-DOC-01 | As a maintainer, I can follow operational references to existing sources without depending on removed files. |
| REQ-DOC-02 | As a reader, I can distinguish present components, proposals, examples, and unavailable commands. |
| REQ-DOC-03 | As the project owner, I receive en-US content focused on Exphere, without unrelated employers, recruiting narratives, private project names, or project-origin comparisons. |
| REQ-DOC-04 | As a workflow consumer, I can find workflows outside the agent directory, with a common index and the four existing domains preserved. |
| REQ-DOC-05 | As a developer, I can follow a Dev workflow using the installed Pocock skills, with clear inputs, outputs, authorization boundaries, and return paths. |
| REQ-DOC-06 | As a reviewer, I can trace consistent names, states, ownership, references, and evidence across workflows and typed artifacts. |
| REQ-DOC-07 | As a maintainer, I can distinguish examples and known limitations from operational dependencies without recreating removed material or presenting plans as results. |

### Implementation decisions

1. Use the current tree for claims about presence and availability. Without Git metadata, do not invent a historical diff or infer who deleted a file.
2. Resolve broken operational references with existing equivalent material, or remove the active dependency and state its limitation. Do not create empty substitutes or restore removed applications, glossaries, prompts, or directories automatically.
3. Preserve relevant DevEx, leadership, consumer autonomy, quality, and cost principles without unrelated organizational associations. Discovery interviews in skills are a technical method, not recruiting content.
4. Keep skills, templates, rules, guardrails, SDK, and consumer configuration in their current locations. Relocate only workflow documents and their consumers.
5. Preserve SDD, the four domains, lifecycle identifiers, transitions, and the non-executable model. Dev is an additional specialization, not a competing lifecycle.
6. Document Dev through seven coordinated documents. Use the installed skill versions, local tracker states, typed filenames, and available references.
7. Accept a directly authorized phase and reuse valid authorization. Documenting a phase never invokes it automatically. Grilling is appropriate only when unresolved decisions warrant it.
8. Review and audit distinguish missing evidence, failure, and approval. Reuse valid review of the same snapshot; re-review material changes. File snapshots are acceptable when Git is unavailable.
9. The current prohibition on creating or running tests takes precedence over TDD recommendations. Dev must not run tests, smoke checks, HTTP probes, services, or paid actions implicitly.
10. Preserve attribution and license information for public third-party skills. A missing local license file must not be represented as present or hidden by removing attribution.

## Responsibilities

- Consumer: choose scope, review the proposed decomposition, and authorize implementation and external effects.
- Platform: document the common lifecycle, contracts, and references. This initiative does not implement enforcement.
- Service owners: no service change is included; organization-specific goals and approvals must not be invented.

## Operation and limits

- Resources, isolation, permissions, and capacity: documentation and the declarative workflow definition only; no infrastructure or runtime changes.
- Failure, cancellation, and cleanup: record unavailable dependencies accurately; do not execute commands merely because documents mention them. Preserve unrelated user changes.
- Installation, updates, and removal: relocate workflows together with their references, then retire the old location. Do not keep two active canonical locations or install/update skills.
- Observability and execution correlation: record the documents and revisions inspected, not fictitious application or workflow runs.
- Out of scope: repairing runtime scripts, dependency manifests, deployment settings, or absent applications; creating an engine, CI, certification, SDK distribution, new domains, or a new product cycle; commits, pushes, or remote publication.

## Verification and decisions

- Guardrails: local FIN v1 and 12F v1 policies, adopted October 10, 2026; see [guardrails](../../.agents/guardrails/README.md). Preserve their authority and references.
- Applicability and evidence: inspect the affected documents. No service conformity assessment is claimed because services, resource allocation, and application consumption are unchanged.
- Cost impact: no resource creation or AI, CI, or cloud configuration change is proposed. Assistance consumption was not measured; no savings or zero-cost claim is made.
- Pending decisions and exceptions: implementation of this scope is authorized; human acceptance of the completed result is separate from technical review. No exception to tests or external-effect authorization has been granted.
- Verification plan: `VER-DOCS-WORKFLOWS`, below; completed as documentary inspection.
- Trade-offs: use lowercase directory names throughout, following the project owner's October 11, 2026 naming correction. Move documents and update their references together.
- Technical review: the examined snapshot, reviewer roles, findings, and limitations are recorded in the implementation record below. Human acceptance is not inferred.

### VER-DOCS-WORKFLOWS

The verification surface is document navigation: project entry → workflows → skills, templates, and artifacts. Inspect links, anchors, operational paths, identifiers, and assertions about the current tree. Classify examples and optional conventions separately from active dependencies.

Inspect all final Markdown, including hidden directories and third-party material. Confirm en-US content and typed artifact filenames. Recalculate relative links after relocation. Confirm that the workflow JSON remains syntactically valid and retains its identifiers and transitions. Read Dev end to end for authorization, lifecycle, review, and evidence consistency.

No application modules will be tested. Unit, integration, end-to-end, smoke, and HTTP probes remain prohibited. Document and JSON inspection does not demonstrate workflow execution. Record future findings as passed, failed, or inconclusive rather than inferring success from missing evidence.

### Current dependencies and limitations

- Root application commands still refer to unavailable helper scripts; this initiative must not advertise them as working or restore them implicitly.
- There is no standalone glossary or consolidated FinOps prompt. Existing domain configuration, rules, and guardrails are the available references; they must not claim to reproduce removed material.
- The local third-party license location recorded in skill metadata is absent. Keep public attribution and the limitation explicit; do not fabricate a successful license audit.
- Paths generated on demand, fenced examples, and optional conventions in skills are not missing implementations merely because they are absent locally.

## Workflow structure and tickets

The authorized documentary implementation uses the following layout:

```text
.exphere/
  workflows/
    README.md
    definition.json
    design/README.md
    finops/README.md
    operations/README.md
    sre/README.md
    dev/
      README.md
      CYCLE.md
      00-planning.md
      01-execution.md
      02-review.md
      03-audit.md
      04-refinement.md
```

Use exactly `.exphere`, `workflows`, and `dev`. Do not introduce an intermediate SDD directory. The SDK location remains unchanged. The October 11, 2026 directory convention supersedes the earlier capitalization requirement; [DOC-05](../tickets/0005-TICKET-lowercase-directory-references.ticket.md) records the authorized reference correction. [DOC-06](../tickets/0006-TICKET-exphere-workspace-context.ticket.md) supersedes the root directory name and records the Exphere bootstrap context; the lowercase convention remains active.

| Ticket | Deliverable | Blocked by |
| --- | --- | --- |
| [DOC-01](../tickets/0001-TICKET-documentation-references.ticket.md) | Reconciled references and current-tree descriptions | None |
| [DOC-02](../tickets/0002-TICKET-project-context.ticket.md) | Reviewed project context and language boundaries | None; coordinate shared documents with DOC-01 |
| [DOC-03](../tickets/0003-TICKET-workflow-relocation.ticket.md) | Common lifecycle and four domains in the separate workflow location | DOC-01 |
| [DOC-04](../tickets/0004-TICKET-development-workflow.ticket.md) | Dev documents integrated with the lifecycle and installed skills | DOC-03 |

The documentation prerequisite addressed parts of DOC-01 and DOC-02. This implementation verifies the current tree and completes workflow relocation and Dev documentation under the explicit `implement` request. Ticket completion records identify the observations and technical review; no workflow execution is claimed.

## Implementation and verification record

This section records the original implementation review. Its counts and hashes are historical evidence, not the identity of files after subsequent corrections; DOC-05 records the subsequent casing correction, and DOC-06 records the current directory migration and context update.

- Record: `REV-DOCS-WORKFLOWS-01`; documentary implementation completed on October 11, 2026, under the October 10 authorization above.
- Scope: SPEC-DOCS-WORKFLOWS v2 and DOC-01 through DOC-04. The artifact and language prerequisite was inspected in its current state; it was not treated as an uncompleted migration.
- Comparison: task-start file contents and SHA-256 inventory, followed by the shared review snapshot `DWF-01`: 14 changed files, 13 additions, and six retired workflow files. No Git history or commit revision exists. Unrelated changes were excluded and preserved.
- Historical snapshot identity: the 13 workflow files reviewed at that time had aggregate SHA-256 `8dade820a14b589c840c61058fa458d9d44e5f269f46941d5dbaf8d850a23222`. The digest hashes sorted records of repository-relative path, colon, file SHA-256, and newline. The local review manifest also captures each changed document's hash; completion bookkeeping is reassessed separately from the unchanged workflow bundle.
- Verification surface: all 77 Markdown files, including hidden directories and third-party material, plus 10 JSON files and all 16 typed artifacts. The final inspection covered 282 local links and reference definitions, including 25 anchors, with no broken target; this includes the completion records.
- Executor: the implementation agent performed static navigation, filename, JSON, content, and snapshot inspection. The standards and spec reviewers assessed the same frozen scope independently.

| Requirement | Observed change and evidence | Result |
| --- | --- | --- |
| REQ-DOC-01 | Project entries, typed artifacts, and workflow references resolve. Known unavailable dependencies remain explicit in the current-dependencies section above. | `passed` |
| REQ-DOC-02 | Root documentation distinguishes the available SDK and CLI from absent application workspaces and helper scripts. Generated paths and examples remain documentary conventions. | `passed` |
| REQ-DOC-03 | Repository-wide text search and contextual reading found en-US project content with the requested identity boundaries; relevant technical principles and public attribution remain. | `passed` |
| REQ-DOC-04 | The [common index](../../.exphere/workflows/README.md) and four existing domain READMEs occupy the canonical workflow location. The retired tree is absent. | `passed` |
| REQ-DOC-05 | The [Dev entry](../../.exphere/workflows/dev/README.md), cycle, and five phases describe inputs, outputs, authorization, installed skills, completion criteria, and return paths. | `passed` |
| REQ-DOC-06 | Tracker states and typed filenames remain consistent. The [common definition](../../.exphere/workflows/definition.json) is byte-identical to its task-start contents, including identifiers, transitions, and its non-executable status. | `passed` |
| REQ-DOC-07 | No removed application, helper script, glossary, or prompt was restored. Missing local license material remains disclosed with public attribution. Plans and document presence are not reported as runtime results. | `passed` |

### Advisory review

- Standards reviewer: `standards_review`, agent role; zero documented-standard violations and zero actionable baseline smells in the implementation snapshot. Worst issue: none.
- Spec reviewer: `spec_review`, agent role; zero missing, incorrect, or out-of-scope implementation findings against version 2. Worst issue: none.
- Both reviewers verified snapshot hashes. The final shared snapshot `DWF-02` includes completion statuses and this evidence record for reassessment. They do not modify the authorized requirements or workflow content.
- Human acceptance: not recorded. The implementation instruction authorizes the local work; advisory assessment does not approve organizational adoption or external delivery.

### Applicability and remaining limits

FIN v1 and 12F v1 remain active local policies. Service, resource, load, capacity, cost, isolation, and operational recovery criteria are `not-applicable` to this documentary change because no corresponding implementation or configuration changed. Existing policy links and authority were preserved. No exception was requested or inferred.

All applicable documentary criteria passed. Operational execution, service conformity, production outcomes, third-party license-file integrity, and external URL availability were not verified by this inspection. These are explicit limits, not failed documentary criteria or implicit approvals. Assistance consumption was not measured.

No tests, smoke checks, HTTP probes, application commands, installation, commits, pushes, remote publication, provisioning, or deployment were performed. Local completion of these four tickets does not start a new product cycle.
