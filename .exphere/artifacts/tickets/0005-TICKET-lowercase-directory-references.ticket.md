# DOC-05: Correct references to lowercase directories

- Document number: `TICKET-0005`
- Status: `done`
- Related spec: [SPEC-DOCS-WORKFLOWS v2](../specs/0001-SPEC-documentation-workflows.spec.md), with the directory naming correction recorded there.
- Blocked by: none.
- Authorization: on October 11, 2026, the project owner reported completed directory renames, required lowercase directory names, and explicitly requested one additional ticket and implementation of the reference review and corrections.

## Deliverable

At completion of DOC-05, documentation and local references matched the lowercase directory names, including `.platform/workflows/dev/`. [DOC-06](0006-TICKET-exphere-workspace-context.ticket.md) records the later directory migration; this completion record remains historical. Preserve the user's renames, existing filename conventions, workflow behavior, and historical evidence. This ticket supersedes the earlier workflow directory capitalization requirement without changing the workflow scope.

## Acceptance criteria

- [x] All project directory names are lowercase; existing filenames remain unchanged.
- [x] Links, inline paths, directory trees, and active instructions use the current spelling of renamed directories.
- [x] Local Markdown targets and anchors resolve with exact case for every path component, independently of filesystem case sensitivity.
- [x] Historical review hashes remain identifiable as historical rather than evidence for the renamed current tree.
- [x] Only this one ticket is added; application code, executable configuration, and the declarative workflow model remain unchanged.

## Verification and limits

Use repository-wide text inspection and a case-sensitive comparison against directory entries, including hidden directories. Inspect Markdown links and anchors, distinguish paths from ordinary domain names and external references, and compare the changed files with the task-start inventory. No Git metadata is available, so record scoped file hashes for review without creating a repository.

No tests, application execution, commits, publication, or further workflow cycle are included. The observed results and advisory review are recorded below.

## Implementation and verification record

- Date: October 11, 2026.
- Corrected 12 existing Markdown documents and added only this ticket. Updated links, inline paths, the directory tree, and the current naming instruction; preserved existing filenames and the user's directory renames.
- Inspected 78 Markdown files and 284 local references, including 25 anchors. Every local target matches the exact case of its directory entries; no missing target or anchor was found.
- Found no uppercase project directory names or remaining references using the previous workflow directory spelling. Domain display names and external references remain unchanged.
- Application files, executable configuration, and the workflow JSON are byte-identical to the task-start inventory. No files were removed.
- The original spec review digest remains unchanged and is explicitly marked as historical. The corrected directory convention is recorded as the owner's authorized follow-up.
- Review snapshot: `DOC05-01`, with a task-start file inventory and a shared SHA-256 manifest for the 12 changed files and this ticket. No Git history is available.
- Advisory standards review: `standards_review` found zero documented-standard violations and zero actionable smells in `DOC05-01`; worst issue: none.
- Advisory spec review: `spec_review` found zero missing, incorrect, or out-of-scope requirements in the same snapshot; worst issue: none.
- Completion: all criteria are satisfied. The implementation agent reassessed the final status and review-record update against both reports; implementation content is unchanged from the reviewed snapshot. This local completion does not imply human acceptance or external delivery approval.
- No tests, application commands, commits, or publication were performed. External URL availability was not checked.
