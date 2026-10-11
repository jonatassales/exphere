# DOC-06: Adopt the Exphere workspace directory and bootstrap context

**Document number:** `TICKET-0006`

**What to build:** contributors find the existing SDD workflows under `.exphere` and understand why this project supplies that directory before automated setup exists. The project context records the owner's direction: Exphere will be developed using its own CLI and SDD, and installing the CLI through npm is intended to generate this project directory in the future.

**Blocked by:** None. DOC-05 is complete. The existing workflow documents are sufficient for this bounded migration; future CLI generation commands do not block it.

**Status:** done

**Approval:** On October 11, 2026, after this ticket was presented, the project owner explicitly invoked `implement` in the same conversation. That instruction approves this ticket's bounded scope and authorizes its local implementation; it does not authorize tests, commits, publication, or implementing CLI generation.

**Source:** the [project context](../../.agents/CONTEXT.md) and the owner's current direction. The supplied context is the document to update during implementation.

## Acceptance criteria

- [x] The existing `.platform` directory is renamed to `.exphere`, retaining the common workflow definition and all five domain workflows without a duplicate active directory.
- [x] Project navigation, local links, inline paths, directory trees, and active naming instructions consistently identify the new directory. Local targets resolve with exact case, and historical references are clearly distinguished from active dependencies.
- [x] The project context explains that the workflow directory is supplied now so development can follow SDD while the corresponding Exphere CLI setup and workflow capabilities are still being built.
- [x] The project context records the intention to develop Exphere using its own CLI and SDD, without claiming that every development activity is already executed or enforced by the CLI.
- [x] The project context records automatic creation of the directory when a consumer installs the CLI through npm as intended future behavior. It distinguishes this from the current user-local command setup and existing microruntime commands, which do not generate the workflow directory.
- [x] Existing workflow stages, authorization boundaries, consumer choices, artifact conventions, and historical evidence remain intact. All directory names remain lowercase and all project content remains en-US.
- [x] Inspection confirms the renamed tree, corrected references, accurate capability descriptions, and an unchanged declarative workflow model. No test or workflow execution is claimed as evidence of this documentation change.

## Scope and verification

This is one complete documentary migration: directory, consumers, and context move together. Its bounded size does not require parallel canonical locations or separate migration batches.

Inspect the current tree before editing, preserve unrelated changes, and capture the affected files and their hashes when Git history is unavailable. Verify links and anchors against exact directory-entry spelling after the rename. Record the actual observations and review in this ticket; prior review hashes remain historical.

Implementing installation hooks, choosing package publication settings, generating consumer files, adding CLI commands, or building a workflow executor belongs to later work. This ticket records the installation outcome the owner wants without selecting an unimplemented mechanism or presenting it as available. No installation, tests, application execution, commits, or remote publication are included.

## Implementation and verification record

- Date: October 11, 2026. Implementation follows the explicit approval recorded above.
- Renamed the workflow directory and preserved all 13 contained files byte for byte, including the declarative model and all five domain workflows. The former directory is absent.
- Updated 13 existing Markdown documents, including this ticket, with current navigation, naming, context, and traceability. No new artifact or application file was created.
- Inspected 79 Markdown files and 289 local references, including 25 anchors, using exact directory-entry spelling. No missing target, casing mismatch, or broken anchor was found; all directory names are lowercase.
- References to the former directory remain only as this ticket's migration source and DOC-05's explicitly historical completion context. There is no active dependency on it.
- Context now explains why the workflow directory is supplied before automated setup, the intended use of Exphere's own CLI and SDD for development, and future project-directory generation on CLI installation through npm. It distinguishes that direction from the capabilities present today.
- Application code, package manifests, executable configuration, and CLI commands are unchanged. JSON inspection confirms the unchanged workflow definition remains valid. Historical review digests remain historical.
- Review snapshot: `DOC06-01`, captured from a task-start content inventory and a shared SHA-256 manifest for both review axes. No Git history is available.
- Advisory standards review: `standards_review` found zero documented-standard violations and zero actionable smells in `DOC06-01`; worst issue: none.
- Advisory spec review: `spec_review` found zero missing, incorrect, or out-of-scope requirements in the same snapshot; worst issue: none.
- Completion: all criteria are satisfied. The implementation agent reassessed this final status and review record against both reports; implementation content remains unchanged from the reviewed snapshot. Local completion does not imply human acceptance, organizational adoption, or permission for external delivery.
- Verification is documentary only. No installation, tests, application or workflow execution, commit, or publication was performed. Automatic directory generation and external URL availability were not verified.
