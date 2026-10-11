# Minimal website foundation

- ID: `SPEC-WEBSITE-FOUNDATION`
- Document number: `SPEC-0005`
- Version: `1`
- State: `in-progress`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md); product scope approval remains unrecorded.
- Technical owners: project owner as consumer; implementation and platform reviewers remain to be assigned.
- Authorization: on October 11, 2026, the owner followed specification synthesis with `to-tickets && implement and commit and push on a separate branch`. This authorizes bounded application implementation, dependency installation, type checking, build, and reviewed feature-branch commit/push. It does not record human acceptance of this exact revision or authorize application tests, browser/service probes, deployment, or npm publication.
- Ticket: [SITE-01](../tickets/0018-TICKET-website-foundation.ticket.md).
- Discovery: [DD-0009](../design/0009-DD-web-foundation.dd.md), including the later instruction to leave shared web component directories as placeholders.

## Contract and composition

- Requirements addressed: `REQ-WEBSITE-01` through `REQ-WEBSITE-08`; supports `REQ-PRD-002`, `REQ-PRD-005`, and `REQ-PRD-006`.
- Components selected by the consumer: a minimal Next.js App Router application with React, Jotai, Immer, jotai-immer, and Tailwind; the public design package supplies provisional neutral tokens.
- Environment and executor selected by the consumer: the existing pnpm/Turborepo workspace and root Node engine contract. Select and record mutually compatible exact dependency versions and required peer dependencies in the application manifest and lockfile under the implementation authorization.
- Extension points and execution lifecycle: the application consumes the public `@repo/design` contract using an actual `workspace:*` dependency. Build generated token outputs before the application through the workspace task graph. No application dependency on `@repo/web` exists until it exports something the application consumes.
- Configuration, secret references, and data ownership: no secrets, remote endpoints, backing services, or persistent user data are needed. Local framework host/port settings belong to the execution environment. The application owns its presentation and any later application state; shared packages do not acquire application state ownership.

### Problem and intended result

Exphere needs a minimal web consumer that establishes its frontend conventions and shows that the design package can supply an application. A single en-US page demonstrates the provisional neutral tokens. The shared web package remains a dependency-only scaffold, so this scope includes no shared component demonstration or artificial package dependency.

### User stories

1. As a contributor, I want a minimal application consuming centralized design tokens so that later visual changes have one source of truth.
2. As a frontend developer, I want clear route, component, import, and state ownership so that additional features can follow consistent boundaries.
3. As a reviewer, I want application build and dependency evidence separated from runtime claims so that a scaffold is not presented as a released website.

### Requirements and acceptance

| ID | Required behavior | Reviewable acceptance criterion |
| --- | --- | --- |
| REQ-WEBSITE-01 | Add the website application. | `apps/website` is a private application workspace with Next.js App Router and exactly one minimal public page at `/`; its content is en-US. It is not a public library or a published deployment. |
| REQ-WEBSITE-02 | Own framework and state dependencies locally. | The application declares Next.js, React/React DOM, Jotai, Immer, jotai-immer, Tailwind, and necessary tooling/peers. Resolved versions meet the repository runtime and package-manager constraints; unused demonstration state is absent. |
| REQ-WEBSITE-03 | Consume generated design tokens. | The page visibly uses the provisional grayscale, system-font, spacing, or radius foundation through supported `@repo/design` exports; it neither duplicates token values nor imports package internals. No `@repo/web` dependency or component is required. |
| REQ-WEBSITE-04 | Preserve ownership and route conventions. | Routes live under `src/app`; framework files keep their framework responsibilities. Only folders with actual content required by this scope are created. |
| REQ-WEBSITE-05 | Make imports explicit. | Application aliases are defined only in `tsconfig.paths.json`, extended by `tsconfig.json`, without `baseUrl` or duplicate `paths`. Imports never traverse parent directories; public package exports form cross-package boundaries. |
| REQ-WEBSITE-06 | Use the agreed styling and state boundaries. | UI styling uses Tailwind and centralized tokens. Client boundaries remain narrow; local React state and domain-owned atoms are introduced only for actual behavior. Installing Immer/jotai-immer does not require inventing complex state. |
| REQ-WEBSITE-07 | Integrate application lifecycle commands. | Package scripts invoke `.sh` adapters for framework development, build, start, and type checking as needed. Root Turborepo orchestration reaches the application and its actual design dependency without duplicating root task configuration. |
| REQ-WEBSITE-08 | Record honest delivery evidence. | Application documentation identifies its minimal purpose, available commands, dependencies, and limitations. Build, review, and any later authorized runtime evidence identify the examined revision; no test, deployment, availability, or compliance claim is inferred from authorization alone. |

### Implementation decisions

- The required application tree contains an App Router root layout, the minimal page, and a framework CSS bootstrap, plus manifests, framework/tool configuration, and necessary `.sh` adapters. The root layout owns the document; the page owns its route composition. These structural conventions are intentional contracts, not a demand for empty folders.
- Keep route UI and presentation with the application. Add a metadata boundary only when metadata needs a separate source owner, and a presentation-template boundary only for actual shared presentation infrastructure. Do not precreate services, factories, infrastructure adapters, localization, atom registries, or technical buckets.
- Server Components are the default. Use `'use client'` only for actual browser APIs, interactivity, or required client libraries. Do not introduce loading, error, proxy, template, or route-handler files without corresponding behavior.
- Use `./` imports only within the same local ownership boundary, including local descendants. Crossing ownership uses a meaningful absolute alias or public package export. Public barrels explicitly name their supported exports; reusable domain contracts retain their owner and use type-only imports where appropriate.
- Keep one React component per component file and one custom hook per `.hook.ts` file. Components with props declare a named props interface, accept a `props` argument, and destructure inside the function. Compose independently meaningful UI at its owning route or feature.
- Application styling uses Tailwind utilities and semantic token references. CSS is limited to required framework/Tailwind bootstrap, generated token imports, and the necessary token-to-Tailwind bridge. Do not add authored component/page selectors, layout rules, or a parallel styling system.
- Ephemeral interaction state belongs in local React state. Shared or coordinated state belongs to cohesive application domains through fine-grained atoms. Ordinary atoms handle primitives; Immer or jotai-immer is used only when real complex updates benefit. No synthetic counter, store, provider, or diagnostic registry is required merely to exercise dependencies.
- Treat token values as provisional and replaceable. Consume `@repo/design/tokens.css` and the `--design-` namespace; explicitly select `data-theme="light"` on the root document. Add no theme switch, automatic mode selection, or persistent preference. Permanent visual identity remains undecided.
- Preserve `.sh` script ownership. Reuse suitable existing orchestration, read the installed Turborepo documentation before changing its configuration, and avoid a redundant application Turbo configuration.
- Use the supported `next build --webpack` production command: the default bundler's CSS worker could not bind in the local execution environment and reported `EPERM`, including the escalated attempt. This is a scoped build choice confirmed against the installed CLI help; retain the default development bundler and add no bundler dependency or configuration layer. The build result is still pending evidence in this record.
- The dependency is [SPEC-DESIGN-TOKENS](0003-SPEC-design-token-foundation.spec.md). [SPEC-WEB-PACKAGE](0004-SPEC-web-package-foundation.spec.md) is related scope, not a runtime dependency or prerequisite for rendering this page.

## Responsibilities

- Consumer: the project owner selects this application stack and minimal page scope, owns future visual identity, and defines the implementation and verification boundaries recorded here.
- Platform: maintain workspace task integration, dependency declarations, shell automation conventions, and the applicable quality/evidence policies. Existing hooks do not constitute application acceptance or a production policy engine.
- Service owners: the project owner remains responsible for approving application targets and deployment limits if those become relevant. No production operator, SLA, budget, or organizational acceptance is assigned by this specification.

## Operation and limits

- Resources, isolation, permissions, and capacity: authorized local installation/build execution uses the existing checkout and workspace toolchain. No server execution, cloud resources, production access, traffic assumptions, replicas, memory limits, or capacity measurements are established.
- Failures, timeouts, cancellation, and cleanup: framework/configuration/dependency failures must return a failing command status. Local development processes must stop when their owner ends them. Startup, signal handling, and browser behavior remain unverified; no new background process or polling mechanism is requested.
- Installation, updates, and removal: add the application and actual design dependency to the workspace, preserve the pinned pnpm version, and update the lockfile. Dependency updates must retain compatibility. Generated framework/build outputs remain disposable; removal affects only application-owned files and references.
- Observability and execution correlation: use ordinary framework stdout/stderr and command results associated with the source revision. No telemetry provider, remote logging, analytics, or paid observability integration is added. Planned evidence follows the [evidence contract](../../.audits/evidence/README.md).

### Out of scope

Marketing sections, authentication, APIs, integrations, data persistence, locale routing or translation frameworks, additional pages, proxy logic, SEO campaigns, production domains, deployment, npm publication, shared web component implementations, application test infrastructure, browser probes, and changes to the SDK/CLI responsibilities are excluded. The public identities of `@repo/design` and `@repo/web` do not make the website application a publishable library.

## Verification and decisions

- Affected guardrails: Twelve-Factor v1, `12F-01` through `12F-12`, assessed below; FinOps v1 scope assessment; SDD v1 applies to future review and delivery. See the [policy index](../../.agents/guardrails/README.md).
- Applicability, criteria, owners, and planned evidence: this new application receives a complete Twelve-Factor assessment. The project owner owns the decisions; an implementation reviewer records evidence against the implemented revision. Every applicable behavior is `not-verified` until sufficient evidence exists.

| Criterion | State | Planned contract and evidence |
| --- | --- | --- |
| 12F-01 — Codebase | not-verified | Identify the application workspace, source revision, this specification, and explicit shared-package boundary in the implementation review. |
| 12F-02 — Dependencies | not-verified | Review application manifests, peer/runtime compatibility, lockfile, `.sh` adapters, and the actual design dependency; an authorized build supplies separate behavioral evidence. |
| 12F-03 — Config | not-verified | Document only required local framework host/port inputs and safe defaults; confirm that this page requires no secrets or deployment-specific origin. |
| 12F-04 — Backing services | not-applicable | The minimal page has no database, queue, external API, or other backing service. |
| 12F-05 — Build, release, run | not-verified | Distinguish design generation/application build from development or production-mode start. Record output/source identity and any build-time configuration; release is out of scope. |
| 12F-06 — Processes | not-verified | Confirm no durable application data or sessions; any future local UI state ends with its owning browser lifecycle. Framework build caches are disposable. |
| 12F-07 — Port binding | not-verified | Document the local framework listening interface and overridable host/port without assuming a public deployment. Runtime binding evidence requires authorized execution. |
| 12F-08 — Concurrency | not-verified | Use the framework application process without custom workers or coordination; no scaling or load capacity is claimed. Deployment concurrency limits remain outside this cycle. |
| 12F-09 — Disposability | not-verified | Preserve framework startup and shutdown behavior without custom daemons; signal handling and in-flight behavior require an authorized runtime check before claims. |
| 12F-10 — Dev/prod parity | not-verified | Record development versus production-build/start differences and common resolved dependencies. No production environment exists for a parity claim. |
| 12F-11 — Logs | not-verified | Keep framework diagnostics on stdout/stderr with command and revision evidence; remote collection and retention are absent. |
| 12F-12 — Admin processes | not-applicable | The page introduces no migrations, data administration, or privileged operational jobs. Ordinary build adapters remain versioned `.sh` files. |

- Cost/consumption impact: authorized local installation/build uses compute, storage, and network whose cost is unmeasured; no savings or zero-cost claim is made. This scope creates no paid service or cloud resource. Reassess affected FIN criteria before adding separately authorized paid execution, hosting, or telemetry.
- Open issues and exceptions: dependency resolution requires manifest/lockfile and build evidence. The design consumer contract and installation/typecheck/build seam are selected for this cycle. Browser appearance, hydration, port binding, shutdown, deployment, and capacity remain unverified; missing evidence is not an exception or approval.

### VER-WEBSITE-01 — Consumer-boundary verification

Use one seam: the built application as a consumer of the generated public design package. Installation, type checking, and build are authorized to establish dependency resolution and renderable route construction. Review the minimal page's use of supported token exports without adding tests of internal file layouts. Do not create a separate component showcase, synthetic state scenario, or application test framework.

Existing workspace build orchestration is prior art; the hook-contract suite verifies Git hooks, not this application. Static review and a successful build do not establish browser appearance, accessibility, hydration, port binding, or shutdown behavior. New application tests, browser/service probes, and server execution remain outside the authorized verification scope. Build and runtime behavior remain `not-verified` in this record until corresponding evidence is recorded; no pass is inferred from implementation authorization.

- Verification plan: `VER-WEBSITE-01` in this artifact; source revision, commands, outcomes, and remaining gaps must be recorded during authorized implementation.
- Execution evidence: [SITE-01 evidence](../tickets/0018-TICKET-website-foundation.ticket.md#evidence) records command and generated-output checks; review of the examined source remains pending. These checks do not verify browser behavior, service binding/shutdown, or deployment.
- Trade-offs, decisions, and blocking questions: `DEC-WEBSITE-01` selects compatible exact framework/dependency versions under the execution request, with compatibility still requiring evidence. `DEC-WEBSITE-02` limits this cycle to installation, type checking, build, and static review; tests and browser/service probes remain excluded. `DEC-WEBSITE-03` uses public `@repo/design/tokens.css`, `--design-` token names, and an explicit light theme. Final visual identity and deployment remain later decisions.
- Technical review: `pending; owners and version to be recorded`
