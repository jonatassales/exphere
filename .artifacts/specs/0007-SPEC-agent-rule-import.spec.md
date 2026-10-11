# Technical specification

- ID: `SPEC-AGENT-RULE-IMPORT`
- Document: `SPEC-0007`
- Version: `1`
- State: `approved`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md); product scope approval remains unrecorded.
- Technical owners: project owner as consumer; implementation and independent Standards/Spec reviewers execute the authorized scope and record their evidence below.
- Approval: on October 11, 2026, after receiving version 1, the owner explicitly requested `to-tickets`, `implement`, and commit/push on a separate branch. This authorizes the documented import, adaptation register, numbering, static verification seam, and delivery as one ticket without widening the scope. It does not authorize a pull request, merge, deployment, or unrelated changes.

## Contract and composition

- Requirements addressed: `REQ-RULE-01` through `REQ-RULE-08`; supports `REQ-PRD-002`, `REQ-PRD-005`, and `REQ-PRD-006`.
- Components selected by the consumer: a local Markdown rule corpus and its navigation index; no new runtime, library, agent plugin, or dependency is selected.
- Environment and executor selected by the consumer: the existing repository and agent harness. Agents read the applicable rules through project navigation; automatic discovery or attachment is not established.
- Extension points and execution lifecycle: this is a specification for importing and adapting documentation. The import does not implement workflow execution, policy enforcement, consumer setup, or SDK distribution.
- Configuration, secret references, and data ownership: rule content belongs to this repository. Record the source revision and adaptation decisions without credentials, temporary download tokens, source-product configuration, or private operational data.

### Problem and intended result

Exphere has local FinOps, Twelve-Factor, and SDD guidance, but lacks the requested engineering and frontend rule corpus. The owner supplied an upstream rule directory and four frontend guardrails. Copying them without reviewing applicability would retain obsolete paths, introduce conflicting script instructions, and apply another application's routing and test decisions to Exphere.

The intended result is a complete, traceable import into `.agents/rules/`, using `NNNN-<lowercase-english-name>.rule.md`. All ten source rules remain represented. The source README informs the existing local index. The four guardrails supply complementary frontend, Next.js, Tailwind, and optional Jotai guidance. Local contracts take precedence, and every substantive adaptation is visible for approval.

### User stories

1. As a contributor, I want every supplied engineering rule available through the local rule index so that I can find the guidance applicable to my change.
2. As a frontend developer, I want consistent component, import, styling, framework, and state guidance so that ownership remains clear without creating unnecessary application structure.
3. As a reviewer, I want a source-to-destination inventory and explicit adaptation decisions so that I can verify completeness without mistaking copied documentation for implemented enforcement.

### Requirements and acceptance

| ID | Required behavior | Reviewable acceptance criterion |
| --- | --- | --- |
| REQ-RULE-01 | Import the complete source rule set. | Every `.mdc` rule in the pinned source directory maps to one destination rule. No topic is silently omitted, including environment handling, control flow, scripts, SEO, localization, and test ownership. The source README's inventory and applicability information are reconciled into the existing index. |
| REQ-RULE-02 | Use the requested destination and format. | New rules live in `.agents/rules/`, use `.md`, and match `^[0-9]{4}-[a-z0-9]+(?:-[a-z0-9]+)*\.rule\.md$`. Names are unique. No `.mdc` copies or new Cursor-specific directory are introduced. Existing policy filenames and `README.md` remain unchanged. |
| REQ-RULE-03 | Incorporate all four guardrail references. | The coverage map below accounts for frontend, Jotai, Next.js, and Tailwind guidance. Complementary guidance has a local canonical owner; cross-references resolve without requiring a checkout of the source repository. |
| REQ-RULE-04 | Preserve rule meaning and applicability. | Each rule records a concise description and when it applies. General engineering and test-ownership guidance remain general; technology-specific guidance remains conditional. Cursor `description`, `globs`, and `alwaysApply` intent is expressed as readable Markdown; stale source globs are not advertised as working attachment configuration. |
| REQ-RULE-05 | Resolve conflicts against Exphere's contracts. | The adaptation register accounts for source-specific paths, script policy, authority, shared UI ownership, localization, SEO, and evidence/test rules. Existing user restrictions and adopted policies remain intact. The document does not establish a new universal consumer stack. |
| REQ-RULE-06 | Integrate navigation without replacing local policy. | The local rule index links every imported or supplemental rule and preserves FinOps, Twelve-Factor, SDD, scope, and authorization guidance. Root or harness links change only if needed to reach the index. No existing rule or unrelated draft is overwritten or renamed. |
| REQ-RULE-07 | Keep content usable and attributable. | Content is en-US, uses Exphere terminology, and retains required public third-party attribution. Source URLs and the pinned revision are provenance; unrelated product names, domains, metrics, locale identifiers, unavailable commands, and origin narratives do not become Exphere policy. |
| REQ-RULE-08 | Record bounded evidence. | Static review identifies the source snapshot, destination snapshot, complete mapping, adaptations, link results, and remaining gaps. Drafting, importing, loading, enforcing, and executing are distinguished. No application behavior, compliance, or publication is inferred from Markdown. |

### Source snapshot and destination inventory

The supplied `main` references were read through GitHub on October 11, 2026. The branch resolved to commit `e518dace741d8b9b44dd0a9d851fa3f42506320a`. The [directory at that revision](https://github.com/jonatassales/langdrift/tree/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules) contains ten `.mdc` files and one README, with no nested directories. All eleven files and the four guardrails were read at that same revision. This is source inspection evidence, not import evidence.

The authorized allocation zero-pads the existing source numbers, preserving their order and gaps. The rule sequence is separate from the artifact tracker's SPEC sequence. Destination paths in this table define the imported corpus.

| Source entry under `.cursor/rules/` | Destination under `.agents/rules/` | Coverage |
| --- | --- | --- |
| `00-engineering-core.mdc` | `0000-engineering-core.rule.md` | Authority, approved targets, direct boundaries, shell automation |
| `10-styling.mdc` | `0010-styling.rule.md` | Tailwind, token roles, bootstrap CSS, owned UI styling |
| `20-environment-runtime.mdc` | `0020-environment-runtime.rule.md` | External inputs, operation boundaries, errors, configuration |
| `30-control-flow.mdc` | `0030-control-flow.rule.md` | Guard clauses, early exits, named predicates, nesting |
| `40-nextjs-structure.mdc` | `0040-nextjs-structure.rule.md` | App Router, framework conventions, navigation, conditional structure |
| `50-react-async-ui.mdc` | `0050-react-async-ui.rule.md` | Server/client boundaries, transitions, Suspense, route loading/errors |
| `60-package-scripts.mdc` | `0060-package-scripts.rule.md` | Manifest commands and workspace orchestration, adapted to local shell policy |
| `70-seo-metadata.mdc` | `0070-seo-metadata.rule.md` | Metadata ownership and applicable indexing/social metadata |
| `80-localization.mdc` | `0080-localization.rule.md` | JSON catalogs, locale ownership, placeholders and numeric formatting |
| `90-test-ownership.mdc` | `0090-test-ownership.rule.md` | Test classification, ownership, authorization, and evidence |
| `README.md` | Existing `README.md` | Merge the complete rule/applicability index without replacing local policies |

Guardrail coverage supplements the ten-rule import:

| Reference at the same pinned revision | Planned local coverage |
| --- | --- |
| [Frontend](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/frontend.md) | Supplemental `0100-frontend.rule.md`; scripts defer to `0060-package-scripts.rule.md` |
| [Jotai](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/jotai.md) | Supplemental `0110-jotai.rule.md`, applicable only when an application chooses Jotai |
| [Next.js](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/nextjs.md) | `0040-nextjs-structure.rule.md`, with metadata, localization, and styling references to their local owners |
| [Tailwind](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.agents/guardrails/tailwind.md) | `0010-styling.rule.md`, including conditional class composition and semantic theme roles |

The resulting corpus has twelve new numbered rules and an updated existing index. Recheck destination availability before implementation; never overwrite a concurrently added rule or silently renumber an existing identity. Do not mix a later upstream revision into this inventory without updating the specification and reassessing changed content.

### Implementation decisions

- Copy the complete rule corpus with narrow, documented adaptations. Preserve normative intent wherever it is compatible with current owner instructions and local contracts; record changed or inapplicable clauses rather than silently deleting them.
- Convert editor-specific attachment metadata into ordinary description and applicability sections. Use the local rule index as the navigation boundary. This conversion does not implement an editor integration or loader.
- Give each topic one local owner. Integrate styling and framework reference material into their corresponding imported rules; keep general frontend and optional state guidance in supplemental rules. Use links for shared clauses instead of divergent duplicates.
- Preserve frontend ownership: local relative imports stay inside their ownership boundary, parent traversal is prohibited, and cross-boundary imports use meaningful aliases or public exports. Keep reusable types with their domain owner and use type-only imports; public barrels name their exports explicitly.
- Preserve component and hook conventions: one component per component file, one custom hook per hook file, a named props interface, a props parameter, and destructuring inside the function. Compose meaningful UI through its route or feature owner. Keep descriptive bindings, explicit handling of consumed async results, and the reference's statement spacing guidance.
- Keep application aliases in one dedicated alias configuration extended by the application configuration, without duplicate mappings or a base URL. Avoid redundant package task configuration. Private application and publishable package versioning remain distinct; this import does not change SDK or CLI version contracts.
- Keep Tailwind as the selected frontend styling approach with semantic tokens and conflict-aware conditional class composition where needed. Permit only necessary framework bootstrap, generated-token imports, and the token bridge already described by the web drafts. This is not permission to add authored application selectors or a second styling system.
- Apply Jotai only to applications that select it. Local interaction state remains local React state; shared, coordinated, or independently consumed state belongs to cohesive domains. Keep atoms fine-grained; use Immer only when useful for complex updates. Do not require a registry, universal folder layout, diagnostic logger, or synthetic state.
- Keep framework conventions conditional on real behavior. Routes, metadata, async boundaries, and navigation retain their owning responsibilities; examples do not authorize creating unused directories or framework files.

### DEC-RULE-01 — Adaptation register

These resolutions are authorized for this import by the implementation request recorded above. They preserve existing authority and do not amend unrelated specifications.

| Source issue | Exphere resolution and acceptance boundary |
| --- | --- |
| Engineering authority elevates imported rules above other documents. | Root owner instructions and adopted local policies retain authority. The import cannot demote FinOps, Twelve-Factor, SDD, an accepted applicable decision, or execution permissions. A draft rule does not override an approved contract. |
| Several applicability globs and examples use `spaces/`; shared UI assumes `packages/react` and already implemented primitives/icons. | Describe current ownership and technology conditions. The related draft proposes `packages/web` and `packages/design`; neither its components nor its exports become implemented through this import. No dependency installation, app recreation, or UI refactor follows from the references. |
| Package-script rules prohibit shell wrappers; frontend guidance recommends direct framework commands. | Exphere requires automation in `.sh` files invoked by manifests. Preserve atomic operations and root pnpm/Turborepo orchestration within that local rule. Do not import the contradictory wrapper prohibition or rewrite manifests during this documentation scope. |
| Direct environment reads and rejected invented fallbacks can be read as replacing all configuration mechanisms. | Keep the operation-boundary guidance for applicable JavaScript/TypeScript code and protect server-only values. Preserve Twelve-Factor's environment, mounted-file, secret-reference, and explicitly safe local-default contracts. No new central environment wrapper or configuration migration is requested. |
| The Next.js rule description says the website proxy is at package root, while its body places it beside the App Router under `src/`. | Do not copy the contradictory description. State the version-appropriate framework convention when a proxy is actually needed. The minimal website draft needs no proxy; this import adds none. Verify the installed framework's convention during any later implementation that needs it. |
| SEO assumes a specific production origin, locale-negotiated `/`, and a localized root document. | Preserve metadata ownership and indexing principles conditionally. Do not transfer the source domain, localized root routing, or production checks. The minimal website draft retains its en-US `/` page. A public origin, indexable routes, and localization must come from that application's own contract. |
| Localization includes product metric names, existing locale sets, paused signup behavior, and `check:i18n`. | Retain JSON-catalog and placeholder/ICU principles for actual localized surfaces. Remove unrelated product clauses and unavailable command requirements with an explicit adaptation note. Exphere content stays en-US; no locale catalog, loader, translation framework, or catalog test execution is introduced. |
| Test ownership assumes a runtime tree, bans a particular browser runner, and orders `check:boundaries`. | Preserve the distinction between E2E and native service integration and ownership with the responsible context. Do not invent a runtime tree, add a runner, migrate tests, or advertise missing commands. The source's tooling ban is not a new platform-wide consumer restriction; current scoped test permissions remain authoritative. |
| The source treats all `.audits/` content as ignored. | Preserve Exphere's tracked evidence contract and its ignored execution-output boundary. Do not copy a blanket exclusion, delete evidence guidance, or change Git ignore policy. Select publishable evidence deliberately under the local contract. |
| Frontend guardrails and current web drafts overlap. | Reconcile guidance without changing draft states or implementing their contents. Keep token identity provisional and shared web components unimplemented; this import does not establish acceptance of the related drafts. |

## Responsibilities

- Consumer: the project owner approves the imported scope and substantive adaptations, retains application stack and composition choices, and confirms the proposed verification seam before implementation.
- Platform: maintain discoverable local guidance, clear authority and applicability, stable identities, source traceability, and honest evidence states. Markdown does not implement gates or certify consumers.
- Service owners: approve application-specific origins, locales, operational targets, and test execution when those become relevant. This specification creates no new service obligation or organizational approval role.

## Operation and limits

- Resources, isolation, permissions, and capacity: local documentation only; no infrastructure, secret access, package installation, cloud budget, service capacity, or application runtime is introduced.
- Failures, timeouts, cancellation, and cleanup: a missing source file, naming collision, unresolved local link, or unaccounted conflict prevents a complete-import claim. Preserve unrelated files and report partial work. Do not substitute remembered content for unavailable source evidence.
- Installation, updates, and removal: the authorized implementation would add the mapped rules and update navigation. No recurring sync or bootstrap generator is proposed. Later updates identify a new source revision and preserve local decisions; removal must repair affected references without deleting existing policies.
- Observability and execution correlation: record documentary evidence and review outcomes with the source commit and exact destination revision or content hashes in this artifact. There are no service logs, telemetry integration, or automatic enforcement results to claim.

### Out of scope

Application/package implementation, frontend scaffolding, dependency upgrades, SDK/CLI separation, consumer context generation, automated rule discovery, Cursor attachment, new CI/linter/hook enforcement, new tests, application runtime probes, production access, deployment, automatic upstream synchronization, unrelated artifacts, PR creation, and merge are excluded. Renaming existing policies or moving SDD into the agent rule directory is also excluded. Installing the unchanged locked developer tools in the isolated worktree and running existing commit/pre-push gates support the authorized commit and push; they do not add a new application verification scope.

## Verification and decisions

- Affected guardrails: Twelve-Factor v1 policy compatibility, particularly `12F-02`, `12F-03`, `12F-05`, and `12F-12`, because the imported prose discusses dependencies, configuration, commands, and automation. Runtime criteria are `not-applicable` to this document-only change. See the [local policy index](../../.agents/guardrails/README.md).
- Applicability, criteria, owners, and planned evidence: the project owner owns policy choices; Standards and Spec reviewers assessed the actual imported corpus. The implementation record establishes static acceptance and compatibility with existing local policies. No service compliance claim follows.
- Cost/consumption impact: no resource configuration, paid service, or AI consumption policy changes are proposed. FinOps v1 operational criteria are `not-applicable` to the rule import; no cost or savings measurements are claimed.
- Open issues and exceptions: `DEC-RULE-01`, the numbering/supplemental-rule allocation, and `VER-RULE-01` are covered by the recorded implementation authorization. No exception to local policy is requested. New material scope requires reassessment.
- Verification plan: `VER-RULE-01`, below.
- Trade-offs, decisions, and blocking questions: a faithful topic-by-topic import needs narrow adaptation to work in Exphere. The complete mapping makes those changes reviewable. One ticket delivers the complete corpus and index without introducing an artificial dependency chain.
- Technical review: the implementation passed independent Standards and Spec document reviews on October 11, 2026, as recorded below. Commit and pre-push gates have separate delivery evidence.

### VER-RULE-01 — Document-corpus verification

Use one authorized seam: the destination rule corpus as a contributor reaches it through the local index, compared against the pinned upstream inventory and adaptation register. Use static document inspection; no new test harness, application suite, service probe, or maintained verification script is needed.

Good verification checks contributor-visible contracts: all ten source rules and the README are accounted for; all four guardrails have local coverage; names and links resolve; scope remains readable without Cursor metadata; source-specific commands and product facts do not leak into active rules; existing policies and unrelated work are preserved. Review semantic fidelity and explicit adaptations rather than demanding byte-for-byte equality after conversion.

The existing artifact tracker, rule index, guardrail evidence states, and document review practice provide prior art. The hook-contract test suite verifies Git hooks and is not this import's verification seam.

During a later authorized implementation, run the required Standards and Spec reviews against the same identified snapshot, including the uncommitted rule additions. Record their outcomes here, resolve actionable findings, and reassess materially changed content. SDD v1 governs any separately authorized commit or PR delivery, including feature-branch preparation from `main`; advisory identity checks do not replace the required review.

The owner authorized this seam through the implementation request above. No application tests, builds, imports, installation, or runtime checks were performed during drafting. Existing build/test pre-push gates remain applicable to publication under SPEC-GIT-HOOKS-SDD; their execution evidence is separate from the static import review.

### Related local context

- `SPEC-DESIGN-TOKENS`, `SPEC-WEB-PACKAGE`, and `SPEC-WEBSITE-FOUNDATION` supplied separate local planning context during drafting. Those artifacts are outside this branch and are not imported or approved by this change. The rule corpus states its own complete applicability contract and does not depend on those files being present.
- `ADR-0002` supplied separate local context for future consumer-context extension. That artifact is outside this branch. This import preserves consumer-owned harness content and does not distribute these repository rules to every consumer.
- [Domain configuration](../agents/0007-DD-domain-model.dd.md), [artifact tracker](../agents/0006-DD-artifact-tracker.dd.md), and [evidence contract](../../.audits/evidence/README.md) retain their existing roles.

### Draft review record — October 11, 2026

Two independent reviewers inspected only this untracked specification addition against base `d4b6796c9328820686eb1f48fcd6dbef60582773`. Both reviewed candidate SHA-256 `9a927864c267300bead7e8cd92b4a1a730b3624dfbb5551c95c669b888150b73`, before this evidence-only record was appended. All preexisting changes were excluded. The Spec reviewer also compared the complete source snapshot identified above.

#### Standards

No actionable findings. The candidate preserves the local template, naming, en-US language, policy precedence, and draft/verification boundaries.

#### Spec

No actionable findings. The candidate accounts for the ten source rules, README, four guardrail references, requested destination/naming, and explicit adaptations.

Summary: Standards — 0 findings; Spec — 0 findings. Static inspection also found no missing local link targets or whitespace diagnostics. This review concerns the specification only; import implementation, technical acceptance, and test execution remain pending or out of scope as recorded above.

### Implementation review record — October 11, 2026

- Ticket: [RULE-01](../tickets/0019-TICKET-agent-rule-import.ticket.md), one complete slice with no blockers.
- Branch and base: `codex/agent-rule-import`, created from current `origin/main` at `300c25cd77f5acfda5f0e35f1b9f99250b411643` in an isolated managed worktree. Unrelated checkout changes were excluded.
- Scope: twelve new rule documents, the existing rule index, this specification, and RULE-01; fifteen files. No application, dependency declaration, script, existing policy, or evidence-contract change.
- Reviewed snapshot: both reviewers verified every file hash before and after review. The SHA-256 manifest digest was `cbe9befa82ed6d90e8de41c34c03ebc453e25928e904d0a99e229425f149a2e3`, before appending this evidence and changing ticket checkboxes. The rule/index corpus is unchanged by those evidence-only edits.
- Reproducible corpus digest: SHA-256 of the output from `shasum -a 256 .agents/rules/*.rule.md .agents/rules/README.md`, run at repository root, is `ca89a607ebe5809dc40b4dad49a65e304d04131023a882be7bc4b7561189552f`.
- Standards: 0 actionable findings. Project authority, applicability, shell automation, consumer ownership, evidence boundaries, naming, and authorization are preserved. No applicable code-smell findings.
- Spec: 0 actionable findings. All ten rules, the source README, and four reference guardrails satisfy `REQ-RULE-01` through `REQ-RULE-08` within `DEC-RULE-01`.
- Static verification: twelve uniquely named rules have descriptions, applicability, pinned provenance, and index entries. All local link targets and heading anchors resolve. Whitespace checks reported no diagnostics. Existing policies, evidence, scripts, and dependency declarations are unchanged from the base.
- Policy assessment: compatibility with Twelve-Factor v1 `12F-02`, `12F-03`, `12F-05`, and `12F-12` is established for the imported prose only. No runtime compliance or service behavior is claimed. FinOps operational criteria remain not applicable to this document-only scope.
- Tool preparation: installed the unchanged lockfile with pnpm 12.4.2 and lifecycle scripts disabled in the isolated worktree, then activated existing local hooks. The source checkout and personal CLI setup were not changed by this work. The offline cache lacked eight packages; the locked online installation completed without manifest or lockfile changes.
- Delivery preparation: SSH authentication identifies `jonatassales`; configured author and committer identity is `Jonatas Sales <6073626+jonatassales@users.noreply.github.com>`. Commit and push remain subject to their existing hooks. No PR is requested, so SDD-02 is not verified; this is not a publication blocker under advisory SDD v1.

The implementation review covers static rule behavior as read by contributors. It does not establish automatic loading, policy enforcement, runtime correctness, or organizational adoption. Commit/push results are recorded separately after they occur.

### Delivery evidence — October 11, 2026

Implementation commit `6d9a544f429074682db3fdc87aea43ec576f1db0` was pushed to `origin/codex/agent-rule-import` through the existing hooks. Author and committer both match the configured Jonatas Sales identity recorded above, and the commit declares `Ticket: RULE-01`.

- Pre-commit: lint-staged found no configured tasks for Markdown. The advisory harness diagnostic completed at 67/105; its frontmatter recommendation reflects the deliberate plain-Markdown applicability contract. No automatic attachment or score-based compliance is claimed. Other harness recommendations did not expand this scope.
- Commit-msg: Conventional Commit validation passed and SDD resolved RULE-01 to SPEC-AGENT-RULE-IMPORT from the index.
- Pre-push: validated the clean outgoing revision, then passed the workspace build gate (one cached SDK build) and all five shell hook-contract groups. The subsequent Turbo test phase had zero package test tasks, which does not represent application test coverage.
- SDD: RULE-01 resolved in the outgoing commit. For a new branch the hook inspected all reachable history, reporting an existing merge without a ticket trailer and historical associations spanning specs. These warnings remain advisory. Actual PR metadata is unavailable because no PR was requested or created.
- Publication: the remote accepted the new branch and its upstream tracking was configured. This follow-up evidence record leaves the reviewed rule/index corpus unchanged; its own publication uses the same hooks.

RULE-01 is complete for this authorized import and branch publication. No force push, merge, deployment, source-checkout edit, or unrelated artifact publication was performed.
