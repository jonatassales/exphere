# CTX-01: Initialize and update Exphere alongside a consumer harness

**Document number:** `TICKET-0012`

**Source:** [ADR-0002](../../.agents/adr/0002-cli-context-extension.md) and the owner's October 11, 2026 MVP context-extension request. No implementation spec is approved yet.

**What to build:** a consumer using the installed SDK/CLI can initialize or update Exphere project context and discover it through the root agent instructions, while retaining the project's own context and harness.

**Blocked by:** None. The implementation spec must first settle the context entry, ownership markers, root selection, and install/setup lifecycle. That specification and implementation require their own authorization.

**Status:** draft

**Approval:** The owner accepted the architectural direction and requested merging setup and updates on October 11, 2026. This merged planning scope is recorded; its implementation spec and execution are not authorized yet.

- [ ] Project setup generates the Exphere directory and an Exphere-owned context entry, then adds one resolving reference in the root agent document.
- [ ] Generated context identifies the existing project harness when present without replacing, moving, or rewriting its content or instructions.
- [ ] Existing root instructions remain intact; a project without them receives only the minimal extension entry and no invented harness references.
- [ ] A second identical setup is idempotent. Conflicting ownership or unresolved project-root selection produces an actionable result without destructive changes.
- [ ] An authorized consumer-level verification uses the packaged CLI in projects with and without an existing harness; documentation explains exactly what setup owns and modifies.
- [ ] Evidence distinguishes successful generation and navigation from workflow execution or MVP publication.

- [ ] A version update can replace an older Exphere-owned reference or generated entry without duplicating it or replacing the root agent document.
- [ ] Consumer-authored content outside the owned region remains unchanged, including edits made after initial setup. Missing/conflicting ownership markers and user-modified managed content have an explicit, non-destructive conflict policy.
- [ ] An interrupted or failed update does not leave the root reference pointing to missing generated context; authorized verification covers existing installations and changed reference targets.
- [ ] Documentation explains initial setup, repeated setup, upgrades, ownership, recovery, and limitations through the same consumer flow.

The separate, unapproved CTX-02 update draft was merged here at the owner's request. Existing CTX-03/TICKET-0014 identity is retained for distribution; the retired draft number is not reused.
