# Backstage context and team budget proposal

- ID: `SPEC-BACKSTAGE-TEAM-BUDGET-DOCS`
- Version: 4.
- State: `draft`; technical review and product implementation acceptance are separate.
- Date: October 13, 2026.
- PRD: [PRD-0001](../prd/0001-PRD-exphere.prd.md) provides product context; [PRD-0002](../prd/0002-PRD-local-microruntimes.prd.md) defers financial enforcement. No approved PRD version for the proposed RAG/funding implementation is asserted.
- Technical owners: project owner for this documentation; consumer portal, platform, and budget owners remain to be designated for an executable integration.
- Authorization: the owner's October 13 request explicitly authorizes a new diagram highlighting Backstage with its logo, updates under `.agents/features/`, an image in its existing `assets/` directory, one SPEC, one ticket, and a PR. This authorization covers documentation delivery, not integration implementation, deployment, or merge.
- Scope refinement: before PR publication, the owner additionally requested a polished root README linking the feature images and supplied the Platform README Expert role. Version 2 included that documentation work using existing assets. The subsequent explicit banner request below authorizes one new visual.
- Current-base reconciliation: v3 targets `e969af6892a7d355f806d9b458eb134b7925d912`, which migrated the CLI to Go and retired the shell commands. Onboarding must show only current help/version and local website development; no runtime generation or PATH setup is available. Filename sequences were allocated after the concurrent migration, preserving this SPEC's stable ID and the single ticket's stable ID.

- Visual follow-up (v4): after PR #21 was merged, the owner requested that the other existing diagram appear inline, a new banner use the Exphere logo and the supplied headline reference with a purple gradient, and the main README title be centered. This follow-up starts from `b9ba11ddf25fa0d84fc724504a20793e5caa5d58`, preserves both diagrams, and changes only presentation plus its traceability records.

## Contract and composition

The previous diagram left Backstage inside a generic context label. The feature register also allowed independently authorized cycle budgets, which conflicts with the owner's clarified team funding model. Deliver a visible, source-attributed Backstage context boundary and a consistent team budget proposal, keeping the existing thirteen feature IDs.

### Requirements and acceptance

| ID | Required documentation outcome | Verification seam |
| --- | --- | --- |
| REQ-BCTX-01 | The white-background diagram prominently identifies Backstage with its logo and a direct context connection to RAG. | Visual inspection of the committed PNG. |
| REQ-BCTX-02 | Backstage ownership, team, component, dependency, and documentation context is distinguished from artifact bodies retrieved from their source. MCP/API access is configured, authorized, and read-only. | Diagram and feature prose agree; primary references are included. |
| REQ-BCTX-03 | The authorized budget belongs to the team and funding period. Features/tickets/cycles have adjustable allocations or attribution, with no individual-developer budgets or ticket funding grants. | Inspect shared contracts, F-03, F-06, F-09, and dependency order for contradictions. |
| REQ-BCTX-04 | RAG, cost allocation, LangGraph routing, and deterministic reservation remain separate concerns; every covered paid call, including planning/retrieval, uses the team account. | Inspect flow, control connection, feature prose, and folder tree. |
| REQ-BCTX-05 | An adjacent proposed agents tree identifies the Backstage connector and the retrieval, rationale, orchestration, and budget-client responsibilities. | Image and Markdown tree match; no executable scaffolding is added. |
| REQ-BCTX-06 | Execution results feed episodic memory with sources, costs, failures, outcomes, and uncertainty; justified estimates are distinguished from actual charges and proven return. | Static content review of the proposed learning and accounting boundaries. |
| REQ-BCTX-07 | Existing thirteen feature IDs, the prior illustration, consumer stack choices, portal ownership, and current runtime schema remain intact. | Review the scoped diff and verify all thirteen unique feature headings remain. |
| REQ-BCTX-08 | Documentation and images are en-US, discoverable under the requested features directory, and source-attributed. SPEC/ticket/PR traceability and actual review evidence are recorded. | Local links, asset inspection, two-axis review, ticket trailer, and actual PR body. |
| REQ-BCTX-09 | The root README presents the product, current Go scaffold and empty SDK, honest quick start, architecture, feature-image links, workspace navigation, and native contributor checks. Retired shell commands are not advertised as available. Existing assets are reused, with superseded budget wording in the earlier illustration explicitly qualified. | Inspect source/CLI contracts, Markdown links and image descriptions, rendered HTML where available, and preservation of the developer-checks anchor. No browser or theme validation is inferred from source inspection. |
| REQ-BCTX-10 | Center the main README title, embed both existing diagrams, and add a banner with the existing Exphere identity above the reference headline "Full blast / agentic FinOps runtimes" and a purple gradient. Preserve current capability statements and the historical budget qualification. | Inspect the banner against both supplied references, the centered heading markup, both inline image references, full-size links, and rendered output. |

Components remain consumer choices. LangGraph is the proposed orchestration framework in this design, not an installed dependency. Vector, relationship, and episodic storage providers, deployment topology, model catalog, and price coverage remain open. A relationship graph in retrieval is distinct from the LangGraph execution graph.

Backstage supplies organizational context. A trusted mapping resolves the retrieved team reference to the authorized budget account. Neither catalog metadata nor model output can grant funding, mutate permissions, or redirect charges. Missing/ambiguous ownership, inaccessible required context, unavailable balance, or unbounded cost produces an explicit unresolved state before paid execution. Catalog context can be consumed without replacing the portal.

The allocator uses retrieved evidence and available team funds to recommend feature allocations and model/effort per ticket or step. It preserves required quality and records a concise rationale with source revisions, assumptions, alternatives, and uncertainty. Historical similarity supports a forecast; it cannot establish revenue or economic return without business evidence.

The shared ledger would admit and reserve covered requests atomically, reconcile usage, retain uncertain liabilities, and preserve team attribution across retries, runtime changes, and resume. The allocator's own paid calls require the same admission path. A lower-level feature allocation is adjustable; it is not an independent funding authorization. A single-writer local demonstration would not prove distributed enforcement.

### Authorized change manifest

- `README.md`
- `.agents/features/README.md`
- `.agents/features/assets/backstage-context-team-budget.png`
- `.agents/features/assets/backstage-logo.png`
- `.agents/features/assets/README.md`
- `.agents/features/assets/exphere-readme-banner.png` (v4 owner-requested visual addition).
- This SPEC.
- [BCTX-DOCS-01](../tickets/0051-TICKET-backstage-team-budget-proposal.ticket.md).

The folder tree in the image is conceptual. Do not generate the illustrated `.exphere/agents/` files, create a database, alter the runtime descriptor, add dependencies to the product, or implement agents in this slice. Preserve the older factory PNG. Fix relative links in the edited feature register where needed for discoverability.

## Responsibilities

- Consumer: selects components and compatible tools, configures authorized source connections, supplies trusted team-account mappings, and owns access/retention decisions.
- Platform: defines retrieval provenance, controlled routing, future reservation/accounting boundaries, evidence, and quality preservation.
- Service and budget owners: approve applicable targets, permitted actions, team funding periods, and exceptions. Routine allocations can occur within an existing policy; an agent cannot raise the team ceiling.
- Documentation author: publishes the proposal, provenance, and observed verification without implying that the financial controls or Backstage integration already operate.

## Operation and limits

- Resources, isolation, permissions, and capacity: no infrastructure is created. The documentation calls for scoped read access and shared transactional accounting before future multi-operator enforcement claims.
- Failures, timeouts, cancellation, and cleanup: document replan/pause on insufficient funds and preservation of uncertain charges. No cleanup executor is installed by this change.
- Installation, updates, and removal: no runtime, package, schema, SDK, or consumer installation behavior changes.
- Observability and correlation: source/artifact revisions, team account, feature/cycle/attempt identity, selected model/effort, costs, and delivery outcomes are proposed evidence. Live records and secrets stay outside committed source.
- Out of scope: funded agent execution, Backstage configuration changes, database/vendor selection, production access, actual savings claims, new test suites, and changes to other feature implementations.

## Verification and decisions

- Affected guardrails: SDD v1 applies to this PR. FIN v1 informs the proposal; operational FIN-01 through FIN-08 are `not-applicable` to the documentation's application behavior. Future financial controls remain unverified.
- Cost/consumption impact: no application, infrastructure, billing, or provider configuration change. The explicitly requested diagram uses the built-in image-generation tool; this is authoring activity, not measured Exphere workflow spend, and no monetary amount is asserted.
- Verification owner/method: author static inspection plus independent Standards and Spec reviews of the same snapshot. Use existing applicable repository hooks/checks; add no test suite.
- VER-BCTX-01: validate local Markdown targets, thirteen unique feature IDs, and whitespace; inspect PNG labels, logo, arrows, and matching folder tree. Inspect root README command examples against existing CLI/scripts, asset references, Markdown structure, and reader navigation.
- VER-BCTX-02: review against base `e969af6892a7d355f806d9b458eb134b7925d912`, including new documentation and image assets; preserve the primary checkout's unrelated deletion.
- VER-BCTX-03: verify one `Ticket: BCTX-DOCS-01` trailer, configured author/committer identity, and `Spec: SPEC-BACKSTAGE-TEAM-BUDGET-DOCS` in the actual PR.
- Trade-off: update the existing feature register rather than invent a fourteenth capability or an executable architecture. Team funding is the proposed foundation of F-03; F-09 adds allocation/reporting depth.
- Open decisions: executable PRD approval, trusted account-mapping source, retention and freshness, database topology, credentials, coverage/pricing, and reconciliation semantics require a later implementation specification.
- Technical review: independent Standards and Spec reviewers both reported zero actionable findings for staged tree `5335671fe510aeb7aad7f8e5ffd0eb9e38eec462` against the base above. The originating ticket records observed checks and publication-stage limits. Subsequent changes only record this review evidence; implementation acceptance remains separate.

- V4 verification: independent Standards and Spec reviews report zero actionable findings for tree `1d4fd38e902d72572d9d2094d4333c52a303c32a`. Review covers the incremental presentation diff against `b9ba11ddf25fa0d84fc724504a20793e5caa5d58`; the ticket records the new snapshot and independent review. Earlier review evidence applies only to the unchanged proposal. No new test suite is required. The existing native publication gates remain applicable.

### Primary references

- [Backstage Software Catalog](https://backstage.io/docs/features/software-catalog/): ownership and component metadata.
- [Backstage MCP Actions Backend](https://backstage.io/docs/ai/mcp-actions/): plugin configuration and authenticated tool access.
- [Backstage logo assets](https://backstage.io/docs/overview/logos/): official artwork location and usage guidance.
- [LangGraph overview](https://docs.langchain.com/oss/javascript/langgraph/overview): stateful orchestration rather than a supplied financial policy.

Consulted October 13, 2026. These sources support integration mechanisms; the team-budget and allocation design is Exphere's proposal.
