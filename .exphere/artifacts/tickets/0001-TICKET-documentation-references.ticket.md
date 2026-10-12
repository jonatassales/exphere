# DOC-01: Reconcile documentation references

- Document number: `TICKET-0001`
- Status: `done`
- Spec: [SPEC-DOCS-WORKFLOWS v2](../specs/0001-SPEC-documentation-workflows.spec.md).
- Blocked by: none.
- Authorization: the project owner explicitly invoked `implement` for SPEC-DOCS-WORKFLOWS v2 and these four tickets in this conversation on October 10, 2026. Implementation is authorized; advisory technical review found no implementation defects. No tests, commit, or publication are authorized.

## Deliverable

Readers can navigate project documentation and distinguish available components from absent scripts, removed workspaces, examples, and proposals. Inspect the current tree: some earlier findings were addressed during the authorized artifact and language normalization.

## Acceptance criteria

- [x] Operational local links and anchors resolve, or unavailable references have been removed as active dependencies with their limitations stated.
- [x] Descriptions of applications, contracts, scripts, domain vocabulary, prompts, and license material match the files present.
- [x] Public third-party attribution and historical validation records remain accurate; past inspection is not presented as proof of current integrity.
- [x] Fenced examples, generated paths, and optional skill conventions are classified without creating unnecessary files.
- [x] No application, helper script, glossary, or removed directory is restored to satisfy an outdated description.
- [x] Findings and remaining limitations are recorded with the examined revision, without running application commands or tests.

Verification uses `VER-DOCS-WORKFLOWS` in the spec. Coordinate shared documents with DOC-02. Executable configuration repairs are outside this ticket.

## Completion record

Reconciled navigation was verified across the current Markdown tree. Root commands and missing local sources are described accurately; examples and generated paths were not recreated as dependencies.

Completed locally on October 11, 2026. The [implementation and verification record](../specs/0001-SPEC-documentation-workflows.spec.md#implementation-and-verification-record) identifies the reviewed scope, snapshot digest, separate reviewer outcomes, observations, and remaining limitations. All applicable criteria above are satisfied through documentary inspection; no test or operational execution is claimed. Human acceptance and external delivery are separate decisions.
