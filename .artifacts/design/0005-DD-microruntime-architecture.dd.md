---
status: proposed
---

# Microruntimes: consumer composition and platform contracts

**Legacy decision ID:** `ADR-0001`.

**Status:** proposed; the broader architecture, SDK capability, and institutional adoption have not been approved. Owner of architectural approval: to be defined.

**Initial implementation authorized separately:** the separate private CLI in `packages/cli/` includes `ex`, a version 1 JSON descriptor, Terraform and Kubernetes adapters, and explicit consumer-provided `.sh` hooks. The separate SDK TypeScript API remains empty. This delivery resolves some choices originally left open in this record without approving the institutional proposal or implementing its quality, isolation, and evidence contracts. See [the CLI contract](../../packages/cli/cli/README.md); execution against infrastructure has not been demonstrated.

The proposal is to make microruntimes a reusable capability for composing, executing, and verifying use cases across projects. The principle already defined by the user guides this exploration, translated as: “Build the platform without making the decisions; delegate the decisions to the people using the platform.” The consumer chooses the stack, components, and composition; the platform establishes security, observability, testing, resource, and quality contracts, aligned with the organizational owners of those policies.

## Proposal under evaluation

Explore shared contracts with execution integrations that state their capabilities and limitations. The consumer supplies configuration and domain criteria; product, architecture, and operations owners agree on concrete targets. The platform verifies applicable requirements and records evidence. A consumer's chosen technology may need an integration that does not yet exist; unsupported capabilities must be declared.

The contracts should connect tests relevant to the case—smoke, load, stress, end-to-end, and soak tests where needed—to measurable CPU, memory, storage, latency, and quality criteria. Gherkin scenarios document intent; they do not impose BDD or prove execution. Operational targets require signals from operation and cannot be inferred solely from local tests.

Distribution through an installable and removable SDK, reuse across repositories, and local, CI, and production execution remain hypotheses to validate. The initial CLI defines a descriptor and adapters; external installation, verification runners, isolation, and guarantees across environments remain open. Sharing intent and criteria does not imply parity between environments; local success does not establish production capacity or availability. Finite verification also cannot guarantee the complete absence of memory leaks.

`.agents/` contains skills, templates, and agent support material. Workflow documentation lives separately in `.exphere/workflows/`. The harness also includes instructions, context, artifacts, and evidence outside the agent directory. Future distribution through a DevX SDK is a possibility separate from the decision about the microruntimes SDK; the relationship between these capabilities remains open. This record does not authorize their implementation.

## Alternatives to evaluate

- **Tools maintained separately in each repository:** address local needs with little initial contract, but can duplicate maintenance and make evidence harder to compare.
- **A central runtime with a fixed stack and composition:** simplifies initial support, but restricts decisions that belong to the consumer and can hinder adoption in different contexts.
- **Shared contracts and explicit integrations:** preserve consumer composition and enable shared verification, but require maintaining compatibility, policies, and capabilities per integration. This is the proposed direction; no broader technical choice has been approved.

## Expected consequences

- Consumer autonomy must coexist with verifiable requirements; defaults can help adoption without choosing every project's architecture.
- Portability depends on supported integrations. Differences in isolation, resources, measurement, and lifecycle must appear in configuration and evidence.
- Installing or removing the tool, ending an execution, and deleting persistent data require distinct responsibilities. Versioning, compatibility, and exceptions will have maintenance costs.
- Missing mandatory evidence prevents approval. Passed, failed, and inconclusive results must state the observed conditions; operational actions require their own policy.

## Questions for the next decision

Which pilot use case justifies the capability? Where does the SDK end and consumer configuration begin? Which integrations and execution phases should be supported first? How should installation, removal, ownership, and persistent data be handled? How should contracts, policies, and exceptions be versioned? Which evidence and measures of benefit will support an adoption decision?

Requirements and detail: [the microruntimes record](0002-DD-microruntimes.dd.md). Adoption context: [workflow profiles](0004-DD-workflow-profiles.dd.md). This decision record documents a proposal; it does not establish implementation, execution, or operational readiness.

## Maintaining architecture decisions

Record context, alternatives, consequences, and explicit status when a decision warrants an architecture record. A documented proposal is not an accepted architecture or institutional adoption. Use the [domain-modeling skill's decision format](../../.agents/skills/domain-modeling/ADR-FORMAT.md), within this project's artifact naming and placement rules. PRDs, research, and plans retain their own artifact types; do not create an architecture decision for every detail.
