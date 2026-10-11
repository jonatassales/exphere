# Exphere — Agentic Software Factory

## Current scope

Exphere is an experimental project for developer experience and agent-assisted software delivery. The current tree contains a pnpm/Turborepo workspace and the private, versioned SDK in `packages/sdk/` and CLI in `packages/cli/`. The SDK TypeScript API remains empty. The CLI owns `ex`, microruntime descriptors, Terraform/Kubernetes adapters, and explicit consumer `.sh` hooks. Local hooks implement selected developer checks and advisory SDD traceability. There is no workflow engine, comprehensive quality-contract enforcement, or demonstrated production integration. Documents and adapters do not prove execution or outcomes.

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

The [artifact tracker](.artifacts/agents/0006-DD-artifact-tracker.dd.md) defines the directories, numbering, states, and filename rules for every file under `.artifacts/`. Use four-digit sequences per type and lowercase English slugs:

- `0001-PRD-<slug>.prd.md` in `prd/`.
- `0001-SPEC-<slug>.spec.md` in `specs/`.
- `0001-TICKET-<slug>.ticket.md` in `tickets/`.
- `0001-RSC-<slug>.rsc.md` in `research/`.
- `0001-DD-<slug>.dd.md` in `design/`, or `agents/` for existing agent configuration designs.

Use lowercase names for every project directory and match their exact spelling in references. Existing filename conventions, including `AGENTS.md`, `README.md`, and typed artifact markers, remain unchanged.

Create only artifacts required for the authorized phase. Preserve stable IDs when moving documents. New drafts do not imply acceptance or readiness.

## Local guardrails

FinOps and Twelve-Factor are local working and review policies adopted October 10, 2026. For changes to resources, costs, or AI consumption, load [FinOps rules](.agents/rules/finops.md). For services, configuration, dependencies, delivery, or lifecycle, load [Twelve-Factor rules](.agents/rules/twelve-factor.md). Criteria and evidence requirements are in [guardrails](.agents/guardrails/README.md). Load the [SDD rule](.exphere/rules/sdd.md) and [SDD guardrail](.exphere/guardrails/sdd.md) for commits, reviews, and PR delivery. The SDD rule requires two-axis code review before completion, commit, or push, feature-branch delivery from main, and no force pushes. SDD identity findings warn for now; missing evidence is not compliance and this exception does not weaken other policies or quality failures. Local hook behavior is documented in the root README; no CLI/CI policy engine is implemented. Preserve scoped test authorization and unrelated restrictions.

## Workflow proposal

SDD (Spec Driven Development) is the common lifecycle: capture, discovery, prioritization, specification, preparation, execution, verification, delivery, and learning. The open/closed analogy is a design principle; it does not make the core immutable.

The current [workflow entry](.exphere/workflows/README.md) and [declarative definition](.exphere/workflows/definition.json) describe that lifecycle. Design, operations, SRE, FinOps, and Dev specialize checkpoints, skills, artifacts, and tool connections. They remain documentary drafts without executors or integrations. Code-oriented skills are not universal obligations for every domain.

Workflows live in `.exphere/workflows/`. The [Dev workflow](.exphere/workflows/dev/README.md) documents planning, execution, review, audit, and refinement with the installed Pocock skills. The [documentation spec](.artifacts/specs/0001-SPEC-documentation-workflows.spec.md) records this implementation; organizational adoption and automated execution remain unproven.

Artifacts share identification, version, origin, ownership, and traceability while preserving domain-specific content and criteria. Checkpoints may occur before, during, or after execution without introducing another lifecycle. Grow domain adaptations with the responsible specialists and observed needs.

Organizational adoption is unvalidated. Begin with pilots, listen to teams, and measure effort and benefit. A general prohibition on local workflows remains open. Certification, exceptions, and governance require further design; a document does not establish an approved organizational policy. See the [institutional proposal](.artifacts/design/0003-DD-institutional-workflow.dd.md).

The [workflow profiles](.artifacts/design/0004-DD-workflow-profiles.dd.md) are a separate hypothesis from domain adaptations. They do not justify arbitrary methodology or obligation choices. Start with one pilot before expanding.

## Navigation and harness boundary

- [Harness entry](.agents/README.md), [context](.agents/CONTEXT.md), and [working rules](.agents/rules/README.md).
- [Product requirements](.artifacts/prd/0001-PRD-exphere.prd.md) and [design overview](.artifacts/design/0001-DD-exphere.dd.md).
- [Domain configuration](.artifacts/agents/0007-DD-domain-model.dd.md) and [microruntime requirements](.artifacts/design/0002-DD-microruntimes.dd.md).
- [Proposed architecture](.artifacts/design/0005-DD-microruntime-architecture.dd.md), retaining decision ID `ADR-0001`.
- [Templates](.agents/templates/) and [evidence contract](.audits/evidence/README.md).

`.agents/` contains agent guidance, rules, guardrails, skills, and templates. Workflow documents live separately in `.exphere/workflows/`. The harness also includes project artifacts, evidence, the SDK and CLI, and consumer configuration created on demand. `.agents/` is not the entire harness. The [project context](.agents/CONTEXT.md) records the intended CLI installation and development workflow; project-directory generation is not implemented.

The SDK and CLI are separate `@exphere/sdk` and `@exphere/cli` packages. `ex runtime <id> init` creates `.micro-runtime/<id>/schema.json` on demand, with no predefined infrastructure or components. Create no speculative directory trees.

## Agent skills

Installed skills and local adaptations are described in the [skill configuration](.artifacts/agents/0008-DD-agent-skills.dd.md) and [lock](.agents/skills.lock.json). Keep public third-party attribution and accurately report any missing local license material.

Load only skills relevant to the authorized phase. If the executor has no Skill tool, read the relevant `.agents/skills/<name>/SKILL.md`. Automatic discovery in that directory has not been verified. Preserve invocation boundaries; a documented phase does not authorize the next one. Reference installation commands do not authorize running them.

Project rules and explicit user instructions take precedence over skill defaults. A user can authorize the current phase without adopting the entire institutional proposal. Do not request an already unambiguous authorization again.

## State, evidence, and scaffold rules

Distinguish drafts, authorized decisions, implementations, and observed outcomes. Skills guide behavior; authenticated approvals, enforced transitions, CI gates, and production policies are not implemented. Review the actual changed scope, including uncommitted files. Missing required evidence is not approval. Acceptance identifies the reviewed revision; material changes require reassessment.

- YAGNI: add only what the request requires, without speculative abstractions, endpoints, or integrations.
- Automation scripts must be `.sh` files; package manifest scripts invoke those files. Application code and framework configuration are not helper scripts. SPEC-DESIGN-TOKENS has a scoped exception for its TypeScript token compiler behind shell build/watch entry points, recorded under the owner's October 11, 2026 implementation request.
- SPEC-GIT-HOOKS-SDD authorizes build/test in pre-push and scoped hook-contract tests in disposable local Git repositories, including a local bare remote. The owner authorized implementation on October 11, 2026 after that seam was presented. Unrelated application tests, service probes, project commits, and remote publication still require corresponding authorization.
- Use pnpm pinned in the manifest and Turborepo for workspace tasks. Workspaces own their dependencies; actual internal dependencies use `workspace:*`.
- SPEC-SDK-CLI-SEPARATION authorizes isolated package-consumer and CLI setup fixtures under the owner's October 11, 2026 implementation request. Use disposable installation directories; real user shell/profile changes and infrastructure execution remain outside verification.
- Preserve the existing SDK and consumer boundaries. Do not recreate removed applications or contracts without a separate request.

<!-- BEGIN:turborepo-agent-rules -->

# This is NOT the Turborepo you know

Turborepo configuration, task behavior, and CLI commands can vary between installed versions and may differ from your training data. Resolve the `turbo` package from this file's directory or relevant workspace; in monorepos, it may not be visible from the repository root. For example, run `node -p "require.resolve('turbo/package.json')"` from a workspace that depends on `turbo`.

Read `docs/README.md` inside that installed package first, then read the relevant pages from its `docs/` directory before changing Turborepo configuration or commands. Heed deprecation notices. These bundled docs match the installed package version and are available without network access.

This block is written and re-added by `turbo` before repository-scoped commands when an AI agent is detected. In the Turborepo source repository, its template is defined in `crates/turborepo-cli/src/cli/agent_guidance.rs`. Removing the managed block while updates are enabled means a later qualifying invocation will add it again. Set `"agentGuidance": false` in the root `turbo.json` or `turbo.jsonc` to opt out; this does not remove an existing block. Keep the block committed with your work to avoid an uncommitted change on the next agent invocation.
<!-- END:turborepo-agent-rules -->

- SPEC-DESIGN-TOKENS authorizes isolated public-export and watch contract fixtures. SPEC-WEBSITE-FOUNDATION authorizes dependency installation, type checking, production compilation, and inspection of generated page/CSS artifacts; browser probes and application test infrastructure remain outside this cycle. These scopes follow the October 11, 2026 combined ticket/implementation request.
