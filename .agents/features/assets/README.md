# Feature illustration provenance

## Backstage context and shared team budget

- Diagram: [backstage-context-team-budget.png](backstage-context-team-budget.png).
- Status: architecture proposal; integrations and the generated agents tree are not implemented.
- Created: October 13, 2026, using the built-in image-generation tool, followed by visual inspection.
- Official reference artwork: [backstage-logo.png](backstage-logo.png), downloaded unchanged from the [CNCF Backstage black horizontal artwork](https://raw.githubusercontent.com/cncf/artwork/main/projects/backstage/horizontal/black/backstage-horizontal-black.png).
- [Backstage logos documentation](https://backstage.io/docs/overview/logos/) points to the official artwork and [identity guidance](https://backstage.io/logo_assets/Backstage_Identity_Assets_Overview.pdf).
- Backstage artwork identifies the proposed third-party connection. It does not imply sponsorship, endorsement, an installed connection, or transfer of trademark rights. The diagram is an AI-generated composition using the official reference, not an official Backstage architecture.

### Generation brief

Create a sparse white-background Excalidraw-style diagram, with English labels and the official Backstage logo prominently placed as a context source. Separate Backstage from PRD/SPEC/ticket/PR artifact bodies. Connect both sources to RAG, then allocation, LangGraph orchestration, and microruntime execution. Feed outcomes back to memory. A shared team budget governs every covered paid call through deterministic reservations. Show the proposed `.exphere/agents/` tree alongside the flow, including `rag/connectors/backstage.ts`. Mark the entire drawing as a proposal; keep shared memory and the ledger outside Git.

### Final refinement prompt

Make a targeted correction to the arrows of this diagram. Preserve ALL labels, title, official Backstage logo, folder tree, node contents, style, white background and layout. The TEAM BUDGET green card must visibly connect DIRECTLY to the Deterministic control green card. Route this new green arrow from the RIGHT EDGE of TEAM BUDGET down along the outside right edge of the PRDs/Specs/Tickets/PRs card and then left into the RIGHT EDGE of Deterministic control, staying inside the left diagram panel. Delete the incorrect black downward arrow from the PRDs/Specs/Tickets/PRs card to Deterministic control. The purple PRDs/Specs/Tickets/PRs card should have ONLY one outgoing arrow: its existing arrow to RAG. Remove the small orphan black arrowhead below the MCP label near the middle of RAG's top edge: retain only the real connected Backstage-to-RAG arrow and the real artifacts-to-RAG arrow. Connect the LEFT EDGE of Deterministic control to the existing green dashed vertical bracket, so that it explicitly governs RAG, allocation, orchestration, and execution. All paid calls share TEAM BUDGET. No other changes.

## Earlier illustration

[runtimes-factory.png](runtimes-factory.png) is the pre-existing broad factory illustration. This change preserves it without claiming new provenance for its contents. The updated team-budget proposal is documented in the [feature register](../README.md).
