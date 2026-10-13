# Exphere — Agentic Software Factory

## Current scope

Exphere is an experimental project for developer experience and agent-assisted software delivery. The current tree contains a pnpm/Turborepo workspace and the private TypeScript SDK in `packages/sdk/` and Go CLI in `packages/cli/`. The SDK TypeScript API remains empty. The Go implementation provides project setup, descriptor v2 generation/validation, a bounded local kind/Terraform/Kubernetes lifecycle, and editable finite LangGraph Job scaffolding. Operational cluster and agent execution remain unverified. The former shell microruntime adapters remain historical references, not the current executable implementation. Husky and GitHub workflows own their native checks. There is no workflow engine, comprehensive quality-contract enforcement, or demonstrated production integration. Documents and adapters do not prove execution or outcomes.

The workspace also contains public-intent `@repo/design` and `@repo/web` packages and a minimal Next.js application in `apps/website/`. The earlier API and protobuf workspaces remain absent. Do not restore removed components or advertise unavailable commands as working. The root [README](README.md) describes the current tree and its limitations.

## Project principles

- Use **microruntimes**, singular **microruntime**. The broader capability remains a proposal.
- Consumers choose their stack, components, and composition. The platform defines contracts for security, observability, resources, quality, and evidence.
- Strategy receives leadership objectives and team evidence. DevEx facilitates decisions and conflicts; an LLM does not make delivery commitments.
- Leadership through influence combines listening, evidence, and accountability. Learn from people who understand the business and operate systems, regardless of seniority, including junior developers. Surface conflicts and assess consequences with the responsible people.
- Gherkin documents intent; it does not require BDD or prove execution.
- Goals belong to the service context. Do not invent organizational requirements, approvals, measurements, or adoption.
- Preserve user changes. Commits, pushes, remote issues or pull requests, provisioning, and production access require corresponding authorization. Existing explicit authorization for the same scope remains valid.

## Language and artifacts

All project content must use **en-US**, including documentation, templates, comments, and user-facing messages. Conversation language may differ. Preserve commands, identifiers, technical meaning, and required public third-party attribution. Keep project content focused on Exphere without unrelated recruiting narratives, private project names, or project-origin comparisons.

The [artifact tracker](.exphere/artifacts/design/0006-DD-artifact-tracker.dd.md) defines the directories, numbering, states, and filename rules for every file under `.exphere/artifacts/`. Use four-digit sequences per type and lowercase English slugs:

- `0001-PRD-<slug>.prd.md` in `prd/`.
- `0001-SPEC-<slug>.spec.md` in `specs/`.
- `0001-TICKET-<slug>.ticket.md` in `tickets/`.
- `0001-RSC-<slug>.rsc.md` in `research/`.
- `0001-DD-<slug>.dd.md` in `design/`, including agent configuration designs.

Use lowercase names for every project directory and match their exact spelling in references. Existing filename conventions, including `AGENTS.md`, `README.md`, and typed artifact markers, remain unchanged.

Create only artifacts required for the authorized phase. Preserve stable IDs when moving documents. New drafts do not imply acceptance or readiness.

## Local guardrails

FinOps and Twelve-Factor are local working and review policies adopted October 10, 2026. For changes to resources, costs, or AI consumption, load [FinOps rules](.exphere/harness/rules/0002-finops.rule.md). For services, configuration, dependencies, delivery, or lifecycle, load [Twelve-Factor rules](.exphere/harness/rules/0003-twelve-factor.rule.md). Criteria and evidence requirements are in the [FinOps guardrail](.exphere/harness/guardrails/0001-finops.gr.md) and [Twelve-Factor guardrail](.exphere/harness/guardrails/0003-twelve-factor.gr.md). The former shared guardrail index is unavailable; consult each surviving policy directly. Load the [SDD rule](.exphere/harness/rules/0001-sdd.rule.md) and [SDD guardrail](.exphere/harness/guardrails/0002-sdd.gr.md) for commits, reviews, and PR delivery. The SDD rule requires two-axis code review before completion, commit, or push, feature-branch delivery from main, and no force pushes. SDD identity findings warn for now; missing evidence is not compliance and this exception does not weaken other policies or quality failures. Local hook behavior is documented in the root README; no CLI/CI policy engine is implemented. Preserve scoped test authorization and unrelated restrictions.

## Workflow proposal

SDD (Spec Driven Development) is the common lifecycle: capture, discovery, prioritization, specification, preparation, execution, verification, delivery, and learning. The open/closed analogy is a design principle; it does not make the core immutable.

The current [workflow entry](.exphere/workflow/README.md) and [declarative definition](.exphere/workflow/definition.json) describe that lifecycle. Design, operations, SRE, FinOps, and Dev specialize checkpoints, skills, artifacts, and tool connections. They remain documentary drafts without executors or integrations. Code-oriented skills are not universal obligations for every domain.

Workflows live in `.exphere/workflow/`. The [Dev workflow](.exphere/workflow/dev/README.md) documents planning, execution, review, audit, and refinement with the installed Pocock skills. The [documentation spec](.exphere/artifacts/specs/0001-SPEC-documentation-workflows.spec.md) records this implementation; organizational adoption and automated execution remain unproven.

Artifacts share identification, version, origin, ownership, and traceability while preserving domain-specific content and criteria. Checkpoints may occur before, during, or after execution without introducing another lifecycle. Grow domain adaptations with the responsible specialists and observed needs.

Organizational adoption is unvalidated. Begin with pilots, listen to teams, and measure effort and benefit. A general prohibition on local workflows remains open. Certification, exceptions, and governance require further design; a document does not establish an approved organizational policy. See the [institutional proposal](.exphere/artifacts/design/0003-DD-institutional-workflow.dd.md).

The [workflow profiles](.exphere/artifacts/design/0004-DD-workflow-profiles.dd.md) are a separate hypothesis from domain adaptations. They do not justify arbitrary methodology or obligation choices. Start with one pilot before expanding.

## Navigation and harness boundary

- [Local guidance](.agents/README.md), [context](.agents/CONTEXT.md), and [working rules](.agents/rules/README.md).
- [Product requirements](.exphere/artifacts/prd/0001-PRD-exphere.prd.md) and [design overview](.exphere/artifacts/design/0001-DD-exphere.dd.md).
- [Domain configuration](.exphere/artifacts/design/0007-DD-domain-model.dd.md) and [microruntime requirements](.exphere/artifacts/design/0002-DD-microruntimes.dd.md).
- [Proposed architecture](.exphere/artifacts/design/0005-DD-microruntime-architecture.dd.md), retaining decision ID `ADR-0001`.
- [Templates](.agents/templates/) and [evidence ownership guidance](.agents/rules/0090-test-ownership.rule.md#evidence-ownership). The former evidence README is unavailable; these formats do not replace that contract.

`.agents/` contains local guidance, engineering rules, frontend guardrails, templates, and locally installed Go skills. AIHero workflow skills live in `.exphere/workflow/skills/`; shared numbered SDD, FinOps, and Twelve-Factor policies remain in `.exphere/harness/`. Local Go skills live in `.agents/skills/`. Workflow documents live in `.exphere/workflow/`; typed artifacts, including agent configuration DDs in `design/`, live in `.exphere/artifacts/`. The harness also includes project artifacts, evidence, the SDK and CLI, and consumer configuration created on demand. `.agents/` is not the entire harness. The [project context](.agents/CONTEXT.md) records the intended CLI installation and development workflow; project initialization creates identity/private-state metadata; it does not install dependencies or a complete harness automatically.

The SDK remains the separate TypeScript `@exphere/sdk` package; its npm bin bridges delegate to its explicit `@exphere/cli` dependency. The CLI is Go-only in `packages/cli/`, with Cobra, explicit composition, and `src/cmd/ex` plus `src/internal`. Current commands use verbs before runtime IDs. Previous shell CLI adapters/setup and legacy v1 generation/execution are historical and unavailable; the current Go v2 implementation is documented separately. For current behavior see [Go CLI README](packages/cli/README.md). The website's `npx exphere init` copy command is product-facing preview text and does not prove npm publication.

## Current Go delivery authorization

The owner's October 13, 2026 explicit implementation request authorizes [PRD-GO-LOCAL-RUNTIME-DELIVERY](.exphere/artifacts/prd/0009-PRD-go-cli-local-runtime-delivery.prd.md), its four specifications, and eleven local tickets. Adapt existing tests and surviving contract checks only; add no new suites/scenarios, and do not execute Docker/kind/Terraform/application scenarios during this delivery. Preserve operationally unverified status until separately authorized observations exist. Historical fixture permissions below do not expand this delivery's verification scope.

The CLI detects tools rather than installing them; loads consumer-built images rather than building them; and uses private project-owned kind context/state. Native Kubernetes and Terraform configuration remain authoritative within the documented supported subset. Source stays outside units, and runtime cleanup preserves configuration/evidence and the shared cluster. Go doc comments should explain contracts, resource ownership, cancellation, and non-obvious effects. Goroutines remain owned by their use case; do not add a generic routines package or speculative shared structs.

### Direct project-local command — subsequent owner decision

The owner subsequently selected one-time shell setup so ordinary usage is `ex --help`, without a `pnpm` prefix. The package CLI exposes `ex` and explicit `ex-shell-setup` bins; SDK bridges forward to the CLI dependency. Source installation currently builds the Go executable with an already installed toolchain. Postinstall never changes profiles or PATH. Only the explicitly invoked setup bin writes a marked project-aware function to the selected Bash/Zsh profile; it resolves the nearest local executable and refuses system-editor fallback. Do not execute personal profile changes during verification. The small `.sh` package bridges and CLI setup/build helpers are authorized by this decision; the CLI implementation remains Go.

## Agent skills

Installed skills and local adaptations are described in the [skill configuration](.exphere/artifacts/design/0008-DD-agent-skills.dd.md), [workflow catalog](.exphere/workflow/skills/README.md), and [Go catalog](.agents/skills/README.md); the former skill lock is unavailable. Keep public third-party attribution and accurately report any missing local license material.

Load only skills relevant to the authorized phase. If the executor has no Skill tool, read the relevant `.exphere/workflow/skills/<name>/SKILL.md` for workflow guidance or `.agents/skills/<golang-name>/SKILL.md` for Go guidance; third-party FinOps/AWS skills remain under `.exphere/harness/skills/`. Automatic discovery in that directory has not been verified. Preserve invocation boundaries; a documented phase does not authorize the next one. Reference installation commands do not authorize running them.

The AIHero catalog contains 26 installed skills after excluding `writing-for-agents` as requested. Generic upstream tracker setup must reuse the existing typed artifact and domain configurations; it does not authorize a second tracker or restore `.agents/adr`. Project rules and explicit user instructions take precedence over skill defaults. A user can authorize the current phase without adopting the entire institutional proposal. Do not request an already unambiguous authorization again.

## State, evidence, and scaffold rules

Distinguish drafts, authorized decisions, implementations, and observed outcomes. Skills guide behavior; authenticated approvals, enforced transitions, CI gates, and production policies are not implemented. Review the actual changed scope, including uncommitted files. Missing required evidence is not approval. Acceptance identifies the reviewed revision; material changes require reassessment.

- YAGNI: add only what the request requires, without speculative abstractions, endpoints, or integrations.
- Repository task aliases invoke the tools' own native commands through pnpm/Turbo/Next/Go/Husky; wrapper `scripts/` directories are retired outside the CLI. Application code, framework configuration, the existing TypeScript token compiler and substantive native test files keep their language and framework owners. Husky owns its lifecycle hooks; allowed CLI verification helpers remain under `packages/cli/`. Do not disguise retired wrappers under a different directory name.
- SPEC-GIT-HOOKS-SDD authorizes build/test in pre-push and scoped hook-contract tests in disposable local Git repositories, including a local bare remote. The owner authorized implementation on October 11, 2026 after that seam was presented. Unrelated application tests, service probes, project commits, and remote publication still require corresponding authorization.
- Use pnpm pinned in the manifest and Turborepo for workspace tasks. Workspaces own their dependencies; actual internal dependencies use `workspace:*`.
- SPEC-SDK-CLI-SEPARATION authorizes isolated package-consumer and CLI setup fixtures under the owner's October 11, 2026 implementation request. Use disposable installation directories; real user shell/profile changes and infrastructure execution remain outside verification.
- Preserve the existing SDK and consumer boundaries. Do not recreate removed applications or contracts without a separate request.
- SPEC-MICRORUNTIME-CONFIGURATION authorizes disposable public-CLI configuration fixtures under the owner's October 11, 2026 `implement` request. Consumer files and real shell profiles remain outside those fixtures.

<!-- BEGIN:turborepo-agent-rules -->

# This is NOT the Turborepo you know

Turborepo configuration, task behavior, and CLI commands can vary between installed versions and may differ from your training data. Resolve the `turbo` package from this file's directory or relevant workspace; in monorepos, it may not be visible from the repository root. For example, run `node -p "require.resolve('turbo/package.json')"` from a workspace that depends on `turbo`.

Read `docs/README.md` inside that installed package first, then read the relevant pages from its `docs/` directory before changing Turborepo configuration or commands. Heed deprecation notices. These bundled docs match the installed package version and are available without network access.

This block is written and re-added by `turbo` before repository-scoped commands when an AI agent is detected. In the Turborepo source repository, its template is defined in `crates/turborepo-cli/src/cli/agent_guidance.rs`. Removing the managed block while updates are enabled means a later qualifying invocation will add it again. Set `"agentGuidance": false` in the root `turbo.json` or `turbo.jsonc` to opt out; this does not remove an existing block. Keep the block committed with your work to avoid an uncommitted change on the next agent invocation.
<!-- END:turborepo-agent-rules -->

- SPEC-DESIGN-TOKENS authorizes isolated public-export and watch contract fixtures. SPEC-WEBSITE-FOUNDATION authorizes dependency installation, type checking, production compilation, and inspection of generated page/CSS artifacts; browser probes and application test infrastructure remain outside this cycle. These scopes follow the October 11, 2026 combined ticket/implementation request.
