# DOC-04: Document the Dev workflow

- Document number: `TICKET-0004`
- Status: `done`
- Spec: [SPEC-DOCS-WORKFLOWS v2](../specs/0001-SPEC-documentation-workflows.spec.md).
- Dependency: DOC-03, completed; no active blocker.
- Authorization: the project owner explicitly invoked `implement` for SPEC-DOCS-WORKFLOWS v2 and these four tickets in this conversation on October 10, 2026. Implementation is authorized; advisory technical review found no implementation defects. No tests, commit, or publication are authorized.

## Deliverable

Developers can follow seven coordinated Dev documents that use the installed Pocock skills and the project's lifecycle, artifact rules, and authorization boundaries.

## Acceptance criteria

- [x] The Dev entry, cycle, and five phase documents specified in the spec exist and are linked from the common index.
- [x] Planning, execution, review, audit, and refinement map to existing SDD stages, including authorized delivery and observation.
- [x] References use installed skills, local tracker states, available templates, en-US content, and the typed artifact convention.
- [x] Users can directly authorize a phase; valid authorization is reused. Discovery interviews, later phases, commits, and external effects are not automatic.
- [x] The prohibition on creating and running tests is explicit and takes precedence over TDD references; smoke checks and HTTP probes are not substitutes.
- [x] Standards and spec review use the same snapshot and support directories without Git; audit follows the actual evidence and storage contract.
- [x] References and anchors resolve. Documents do not claim an engine, authenticated approval, or observed results merely because they exist.

Use `VER-DOCS-WORKFLOWS` to inspect navigation and read the full lifecycle without executing workflows or examples.

## Completion record

Seven linked Dev documents now cover the common lifecycle, installed skills, explicit authorization, review, evidence, delivery boundaries, and refinement. The current test prohibition remains explicit.

Completed locally on October 11, 2026. The [implementation and verification record](../specs/0001-SPEC-documentation-workflows.spec.md#implementation-and-verification-record) identifies the reviewed scope, snapshot digest, separate reviewer outcomes, observations, and remaining limitations. All applicable criteria above are satisfied through documentary inspection; no test or operational execution is claimed. Human acceptance and external delivery are separate decisions.
