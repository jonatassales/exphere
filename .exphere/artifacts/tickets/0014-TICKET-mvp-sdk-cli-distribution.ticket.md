# CTX-03: Release the SDK and CLI with the context extension contract

**Document number:** `TICKET-0014`

**Source:** the former `ADR-0002`, whose document is absent from the current tree. No implementation spec or release approval is recorded yet.

**What to build:** an MVP consumer can obtain the released SDK and CLI through the documented npm installation flow, initialize Exphere alongside an existing harness, and update that integration without losing project context.

**Blocked by:** CTX-01 — Initialize and update Exphere alongside a consumer harness. Actual publication also requires explicit release authorization and registry access; ticket creation supplies neither.

**Status:** draft

**Approval:** The owner requested the two-slice breakdown by merging setup and updates on October 11, 2026. Package publication, the implementation spec, and execution are not authorized.

- [ ] The release spec identifies the separate SDK and CLI packages, supported runtime/toolchain, CLI entry, versions, included generated-context resources, and the boundary between package installation and project setup.
- [ ] Packed release candidates contain each package's required files, including the CLI's required context resources; a clean consumer can install the documented package set and exercise initial setup and upgrade through the public CLI boundary. Do not assume that the CLI depends on the SDK unless it actually consumes its API.
- [ ] Consumer evidence shows the Exphere directory, a resolving root context reference, preservation of the existing harness, and honest handling of absent instructions or conflicting managed entries.
- [ ] After explicit release authorization, the documented npm packages are available and a fresh consumer can reproduce the published install/setup flow using the identified versions.
- [ ] Release notes distinguish observed SDK/CLI availability and context generation from unsupported workflow automation or broader product-readiness claims.

The owner's October 11, 2026 package-boundary decision specifies `@exphere/sdk` and `@exphere/cli`, both private and versioned during the current foundation work. See [package and website discovery](../design/0009-DD-web-foundation.dd.md#sdk-and-cli-separation). This future release ticket does not change their current intended visibility or authorize publication.
