# Extend the consumer's agent context during Exphere setup

**Decision ID:** `ADR-0002`

**Status:** accepted direction; implementation pending

**Authority:** project owner, October 11, 2026. The owner explicitly requested this ADR under `.agents/`, overriding the usual design-artifact location for this record.

When the MVP makes the SDK and CLI available to consumers, its project setup will generate `.exphere/` and add an Exphere-owned context reference to the root `AGENTS.md`. Exphere will also reference the consumer's current project harness: this is an extension of that project's context, not a replacement of its instructions, harness, or chosen stack.

Repeated setup or a version update may replace the additional reference owned by Exphere. It must preserve consumer-authored content and existing harness references, avoid duplicate managed entries, and report conflicting ownership instead of overwriting unrelated instructions. If the project has no root agent document, setup creates the minimal entry needed for the extension; it must not invent a consumer harness that does not exist.

The exact generated context filename, managed-entry format, project-root selection, and install/setup lifecycle are implementation decisions to specify before execution. The root reference must resolve to generated Exphere context, which in turn identifies the consumer harness when present. Consumer context remains independently maintained.

The current SDK and CLI are separate private, versioned packages (`@exphere/sdk` and `@exphere/cli`). The CLI does not implement this project-context generator. This decision records the future contract; it does not claim npm publication, MVP availability, automatic workflow execution, or authorization to implement or publish the installer.

Draft delivery slices: [CTX-01](../../.artifacts/tickets/0012-TICKET-consumer-context-extension.ticket.md) for initial setup and safe updates, followed by [CTX-03](../../.artifacts/tickets/0014-TICKET-mvp-sdk-cli-distribution.ticket.md). A dedicated implementation spec is still required before implementation delivery; these tickets are derived from this ADR and the owner's request.
