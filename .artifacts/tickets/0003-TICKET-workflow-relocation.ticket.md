# DOC-03: Relocate workflows and preserve the four domains

- Document number: `TICKET-0003`
- Status: `done`
- Spec: [SPEC-DOCS-WORKFLOWS v2](../specs/0001-SPEC-documentation-workflows.spec.md).
- Dependency: DOC-01, completed; no active blocker.
- Authorization: the project owner explicitly invoked `implement` for SPEC-DOCS-WORKFLOWS v2 and these four tickets in this conversation on October 10, 2026. Implementation is authorized; advisory technical review found no implementation defects. No tests, commit, or publication are authorized.

## Deliverable

Consumers reach the common SDD lifecycle and the four current domain workflows through the separate location specified in the spec.

## Acceptance criteria

- [x] The common index, declarative definition, and four domain READMEs occupy the specified locations and preserve the required capitalization.
- [x] Project entry points, tracker, context, design documents, and workflow consumers describe the new boundary and link to the canonical location.
- [x] Relative links resolve and no operational dependency on the old workflow location remains.
- [x] Common SDD identifiers, states, transitions, authorized delivery, observation, and the non-executable model remain intact.
- [x] Skills, templates, rules, guardrails, SDK, and consumer configuration stay in their current locations; no duplicate active workflow tree or speculative directories are created.
- [x] Final structure and JSON syntax are inspected without claiming workflow execution.

Use `VER-DOCS-WORKFLOWS`. Move documents and update consumers in the same change. No tests are permitted.

## Completion record

The common index, unchanged declarative definition, and four domain READMEs are available under `.exphere/workflows/`. Consumers use that canonical location, and the retired workflow directory is absent.

Completed locally on October 11, 2026. The [implementation and verification record](../specs/0001-SPEC-documentation-workflows.spec.md#implementation-and-verification-record) identifies the reviewed scope, snapshot digest, separate reviewer outcomes, observations, and remaining limitations. All applicable criteria above are satisfied through documentary inspection; no test or operational execution is claimed. Human acceptance and external delivery are separate decisions.
