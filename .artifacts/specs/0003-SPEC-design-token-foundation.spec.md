# Design token foundation

- ID: `SPEC-DESIGN-TOKENS`
- Document number: `SPEC-0003`
- Version: `1`
- State: `implemented; reviewed local scope`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md), still a draft; no approved PRD version covers this package delivery.
- Technical owners: project owner for visual decisions and consumer composition; package maintainers for implementation and verification, not yet assigned.
- Source: [DD-0009](../design/0009-DD-web-foundation.dd.md) and the owner's package, naming, and neutral-token decisions on October 11, 2026.
- Authorization: on October 11, 2026, the owner followed `to-spec` with `to-tickets && implement and commit and push on a separate branch`. This authorizes bounded implementation, the public consumer seam below, and reviewed feature-branch commit/push. It does not record human approval of this exact document revision or authorize npm publication, deployment, or unrelated work.
- Ticket: [DESIGN-01](../tickets/0016-TICKET-design-token-foundation.ticket.md).

## Contract and composition

- Requirements addressed: `REQ-DESIGN-01` through `REQ-DESIGN-05`; supporting product principles `REQ-PRD-002`, `REQ-PRD-005`, and `REQ-PRD-006`.
- Components selected by the consumer: `@repo/design` version `0.0.0` in `packages/design/`, intended for public distribution and independent of Exphere branding.
- Environment and executor selected by the consumer: the existing pinned pnpm workspace and Turborepo task graph. The token compiler uses TypeScript behind `.sh` entry points under the scoped implementation exception below; tooling versions must be recorded in the manifest and lockfile.
- Extension points and execution lifecycle: token source is authored centrally; validation and generation produce consumer-facing CSS and JSON artifacts. Build is finite; watch is a separately invoked development process. Public entry points are explicit.
- Configuration, secret references, and data ownership: the owner controls token values. Token data contains no credentials or environment-specific service configuration. Consumers control application composition and theme selection.

### Problem and solution

The requested website needs a small, reusable visual foundation while the owner has not yet chosen its visual identity. Scattering provisional colors and spacing across consumers would make that later decision costly and inconsistent.

Provide one neutral token source and generated package outputs. The first values use grayscale colors, system fonts, and restrained dimensions and effects. They are replaceable placeholders, not a permanent palette or a branding decision. The package supplies data and styles without taking ownership of components or application state.

### User stories

1. As the project owner, I want provisional tokens centralized so that I can define the visual identity later without editing each consumer.
2. As a website developer, I want stable CSS and JSON imports so that the application consumes the package through its public interface.
3. As a package maintainer, I want invalid token definitions to fail clearly so that consumers do not receive silently incorrect generated values.

### Requirements

| ID | Contract | Acceptance criterion |
| --- | --- | --- |
| REQ-DESIGN-01 | Provide the requested package identity and public distribution intent. | The manifest identifies `@repo/design`, includes an explicit version, and does not declare the package private; actual registry publication remains separately authorized. |
| REQ-DESIGN-02 | Keep the initial foundation neutral and replaceable. | Colors, typography, dimensions, and effects are centrally authored; changing a source value can update consumer outputs without introducing brand-specific values elsewhere. |
| REQ-DESIGN-03 | Support typed token data and aliases. | The generator contract below defines inherited types, value validation, alias resolution, and invalid-input outcomes. |
| REQ-DESIGN-04 | Expose generated CSS and canonical JSON through explicit exports. | Consumers need neither source-file access nor repository-relative imports; repeated generation from equivalent inputs has stable output ordering and content. |
| REQ-DESIGN-05 | Support build and development regeneration. | A finite build produces validated exports; watch regenerates after source changes and releases its resources when stopped. Execution behavior remains unverified. |

### Implementation decisions

The owner selected package identity, public intent, and the neutral provisional foundation. The implementation request resolves the following bounded technical choices for this cycle; this records execution decisions without inventing a separate human approval of every detail.

- Author four JSON foundation categories: color, typography, dimensions, and effects. Tokens carry `$value`; `$type` may be declared on a token or inherited from its nearest enclosing group. A token's explicit type takes precedence. The initial supported types are `color`, `dimension`, `fontFamily`, `shadow`, and `cubicBezier`, with string values or token aliases. Literal dimensions are nonnegative values expressed in `px`, `rem`, or `em`. This is a limited token schema, not a claim of complete Design Tokens Community Group format compliance.
- Validate token aliases by token identity across the source set. Reject missing targets, alias cycles, duplicate identities, unsupported types, and incompatible values with a diagnostic identifying the affected token. Resolve references for validation without flattening authored aliases in the published JSON.
- Generate deterministic CSS custom properties and canonical combined JSON from the same validated token graph. CSS preserves token references as `var(...)` expressions. JSON preserves authored aliases, `$type`, and `$value`, including inherited group types, with stable ordering; it does not replace them with a flattened map of resolved values. It is a generated consumer contract, not another editable source of truth. No generation timestamps or machine-specific paths enter the artifacts.
- Use neutral CSS names beginning with `--design-` and public imports `@repo/design/tokens.css` and `@repo/design/tokens.json`. No JavaScript runtime API is requested.
- Emit shared foundation variables under `:root` and semantic mode variables under explicit `[data-theme="light"]` and `[data-theme="dark"]` selectors. The website explicitly selects light. There is no automatic system-preference selection, theme switch, or persistence.
- Package consumers declare an actual workspace dependency only when importing its exports. Use initial version `0.0.0` and public-intent metadata; scope ownership, registry access, future version policy, and release authorization remain separate concerns.
- Manifest automation entries remain `.sh` files. The token compiler's TypeScript implementation behind those entries is a scoped exception selected under the owner's execution request. It does not permit non-shell automation elsewhere or embedded-language substitutes for unrelated shell scripts.

## Responsibilities

- Consumer: import generated styles through the public contract, compose the website, and explicitly select its light theme. Do not duplicate editable token values in consumer modules.
- Platform: provide the existing workspace/task conventions, applicable quality rules, and artifact traceability. This package adds no policy engine or enforcement of consumer design choices.
- Service owners: the project owner accepts the provisional foundation and future visual identity; maintainers record package compatibility and release limits. No organizational adoption or performance target is established.

## Operation and limits

- Resources, isolation, permissions, and capacity: local generation reads its package inputs and writes its owned generated outputs. It needs no network service, credentials, infrastructure, AI consumption, or production access. No measured time or memory target is available.
- Failures, timeouts, cancellation, and cleanup: validation failure returns a nonzero build result and actionable diagnostics. Validate the whole graph before replacing outputs so an invalid watch iteration cannot present a partially updated set as successful. Previously generated outputs, if retained, must be reported as stale. Watch shutdown releases watchers; no arbitrary timeout is selected.
- Installation, updates, and removal: dependency installation does not publish the package or mutate consumer branding. Builds regenerate owned outputs. Removing the package requires consumers to remove its imports; no consumer source rewriting is requested.
- Observability and execution correlation: generation reports success or failure through normal process output. Authorized verification later records package version, source revision, command outcome, and output identity. A draft, manifest, or generated file alone does not prove consumer compatibility.

### Out of scope

Brand identity, final token values, implemented React or Custom Element components, SmoothUI adaptation, a theme toggle, persisted theme state, and a new application testing framework are excluded. The website and web-package scaffolds belong to their own specifications. Registry publication, release automation, external infrastructure, SDK/CLI changes, and automated quality certification are also excluded.

## Verification and decisions

- Affected guardrails: [Twelve-Factor local policy v1](../../.agents/guardrails/twelve-factor.md), especially `12F-01`, `12F-02`, and `12F-05` for package identity, declared tooling, and generated artifacts. `12F-11` applies narrowly to generator diagnostics. [SDD local policy v1](../../.exphere/guardrails/sdd.md) applies when implementation is reviewed or delivered.
- Applicability, criteria, owners, and planned evidence: this is a build-time library, not a deployed service. Service ports, backing services, credentials, scaling, and production readiness are not applicable to this scope. Package maintainers must record the actual dependency graph, build result, consumer-import outcome, and accepted technical decisions; no evidence is claimed now.
- Cost/consumption impact: local developer/build compute only; no provisioned resources, new AI consumption, budget commitment, or measured savings are proposed.
- Open issues and exceptions: `DEC-DESIGN-01` records the limited TypeScript compiler exception. Final visual identity and release policy remain open; the implementation decisions and consumer seam below are resolved for this cycle.
- Verification plan: `VER-DESIGN-01` below is authorized by the current implementation request. Outcomes remain `not-verified` until evidence is recorded.
- Execution evidence: [DESIGN-01 evidence](../tickets/0016-TICKET-design-token-foundation.ticket.md#evidence) records current command outcomes; the final technical review is recorded below. Technical review does not establish organizational adoption or release acceptance.
- Trade-offs, decisions, and blocking questions: central generated outputs simplify consumer imports but require a validated build; placeholder values accelerate integration without settling visual identity. See the decision register below.
- Technical review: Standards and Spec reviews passed for snapshot `c5f15b459bfc415172764c4aa16d39fb9ac437207a709e11c0ae471751d3f63d` after correction of the missing CLI environment-asset check. See linked ticket evidence for methods, red/green verification, and limits.

### VER-DESIGN-01 — package-consumer seam

Use one external seam: a consumer of the generated package exports, with the minimal website as the eventual real consumer. Verify public behavior rather than parser functions or internal generator structure. For equivalent valid input, repeated generation exposes identical CSS and JSON; JSON retains authored aliases and type/value metadata, while CSS retains valid references as `var(...)`; inherited types and explicit leaf overrides are honored; an edited neutral token reaches the consumer. Invalid alias, cycle, duplicate, type, or dimension input produces a failed build with useful diagnostics and no falsely successful partial output. Verify shared foundation output and both explicit mode selectors without adding browser tests.

The shell-based SDK build and disposable hook fixtures provide prior art for isolated task execution. The current implementation request authorizes installation, build/type checking, and focused tests at this package's public consumer seam. It does not authorize browser infrastructure, service probes, or unrelated application tests. No build or test pass is claimed by this authorization record; evidence remains pending.

### Decision register

| ID | Resolved implementation choice | Boundary |
| --- | --- | --- |
| DEC-DESIGN-01 | TypeScript token compiler behind `.sh` entries. | Scoped exception for this compiler only; other automation retains the shell rule. |
| DEC-DESIGN-02 | Foundation `:root` variables and explicit light/dark data-theme selectors. | Consumers select modes; the website selects light with no toggle or persistence. |
| DEC-DESIGN-03 | `--design-`, public CSS/JSON exports, limited typed schema, and JSON alias preservation. | Values remain provisional; no full external token-standard compliance claim or runtime API. |
| DEC-DESIGN-04 | Focused public consumer tests, installation, type checking, and build. | Authorized for this cycle; results require separate evidence and unrelated tests remain excluded. |

### Delivery verification

The linked ticket records the completed local implementation and its observed evidence on October 11, 2026. The earlier verification sections describe the planned criteria; results are limited to the installed dependency graph, static review, compilation, and expressly authorized fixture or generated-artifact checks. Production and browser/runtime criteria without execution evidence remain not-verified. No blanket policy compliance or release availability is claimed.
