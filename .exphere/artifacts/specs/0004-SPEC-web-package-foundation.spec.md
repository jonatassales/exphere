# Web package foundation

- ID: `SPEC-WEB-PACKAGE`
- Document number: `SPEC-0004`
- Version: `1`
- State: `implemented; reviewed local scope`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md), also draft; no approved PRD version covers this addition.
- Technical owners: project owner for consumer composition and package direction; platform maintainer for workspace and delivery policy. Named implementation owners remain unassigned.
- Source: owner decisions captured in [DD-0009](../design/0009-DD-web-foundation.dd.md) and the October 11, 2026 specification request.
- Authorization: on October 11, 2026, the owner requested `to-tickets && implement and commit and push on a separate branch`. This authorizes the bounded scaffold, dependency installation, verification, and reviewed feature-branch commit/push. It does not record human approval of this exact document revision or authorize component acquisition, registry publication, or deployment.
- Ticket: [WEB-01](../tickets/0017-TICKET-web-package-foundation.ticket.md).

## Contract and composition

- Requirements addressed: `REQ-WEB-01` through `REQ-WEB-05`; supports `REQ-PRD-002`, `REQ-PRD-005`, and `REQ-PRD-006`.
- Components selected by the consumer: public `@repo/web` version `0.0.0` in `packages/web/`, with `smoothui-cli` version `1.1.3` as a development dependency only.
- Environment and executor selected by the consumer: existing pnpm `12.4.2`, Node `>=22.22.1`, and Turborepo workspace; no new runtime process or task executor.
- Extension points and execution lifecycle: reserve the requested source boundaries as placeholders; introduce explicit public exports only when actual components or utilities exist.
- Configuration, secret references, and data ownership: package metadata and the existing lockfile own dependency declarations; no application state, secrets, external data, or consumer configuration is introduced.

The package establishes a reusable web boundary without implementing UI behavior. It is independent of Exphere branding. Public distribution is the intended package direction; this specification does not authorize a registry release or establish ownership of the requested npm scope.

### Requirements and user stories

| ID | User story | Acceptance criterion |
| --- | --- | --- |
| REQ-WEB-01 | As a consumer, I want a distinct web package so that future shared components have an explicit home. | The workspace discovers one package named `@repo/web` at the requested directory, with metadata expressing public distribution intent. |
| REQ-WEB-02 | As a maintainer, I want reserved source boundaries so that later additions preserve the chosen structure. | `src/internal/`, `src/react/`, `src/web-components/`, `src/vendor/`, and `src/utilities/` each contain only `.gitkeep`; no implementation is added. |
| REQ-WEB-03 | As a maintainer, I want a supported SmoothUI dependency so that future component adoption uses its documented tooling. | The manifest and lockfile declare `smoothui-cli` version `1.1.3` as a development dependency under the execution decision in `DEC-WEB-01`; no component-generation command runs. |
| REQ-WEB-04 | As a package consumer, I want honest public metadata so that an empty foundation does not advertise unavailable imports. | No `main`, `module`, `types`, `bin`, or `exports` entry points at nonexistent implementation; internal and vendor paths are not declared public. |
| REQ-WEB-05 | As a maintainer, I want dependencies to reflect actual consumption so that the foundation stays small. | No speculative React runtime, animation library, design package, SDK, or CLI dependency is added; any dependency change is limited to the resolved SmoothUI tooling decision. |

### Decisions and open choices

- `DEC-WEB-01` — **Resolved for implementation:** declare exact `smoothui-cli` version `1.1.3` as a development dependency of `@repo/web`. This bounded tooling choice is selected under the subsequent execution request; the earlier dependency-role question had no separate recorded answer. Do not run the CLI or acquire component source.
- Official [installation guidance](https://smoothui.dev/docs/guides/installation) documents component acquisition through a CLI or registry. Discovery found no published runtime package at the `smoothui` registry name; do not invent one or substitute an unrelated package.
- The [published CLI metadata](https://registry.npmjs.org/smoothui-cli/1.1.3), inspected during discovery on October 11, 2026, declares Node `>=22.13.0`, MIT licensing, and `smoothui`/`smoothui-cli` binaries, with no declared package dependencies or installation lifecycle hooks. This does not establish the license for `@repo/web` or future component files.
- `DEC-WEB-02` — **Confirmed:** the five source directories remain placeholders in this cycle. `web-components/` does not yet select a Custom Elements implementation, framework, or React wrapper.
- `DEC-WEB-03` — **Confirmed direction:** future shared components and utilities are exported through this package. Exact entry points, peer dependencies, CSS distribution, bundling, and framework support are deferred until public implementation exists.
- `DEC-WEB-04` — **Initial version resolved; release details open:** use version `0.0.0`. Licensing, registry ownership/access, later version policy, and eventual publication contents remain separate decisions. Public-intent metadata must not imply registry availability or publishing access.
- `DEC-WEB-05` — **Deferred:** token adaptation and the relationship between future SmoothUI source and design tokens are unresolved; no artificial dependency on `@repo/design` is needed for empty directories.

### Out of scope

Component or utility code, barrel files, placeholder APIs, CSS, Custom Elements, registry initialization, SmoothUI `add` commands, component downloads, runtime dependencies without consumers, website implementation, SDK/CLI migration, new application tests, deployment, and npm publication are outside this specification.

## Responsibilities

- Consumer: the project owner selects package identity, future composition, dependency role, and the eventual public surface; application state remains outside this empty package.
- Platform: the maintainer preserves workspace discovery, lockfile consistency, script policy, existing hook behavior, review evidence, and scoped delivery authorization.
- Service owners: no service is created. Future release owners must settle registry access and licensing before distribution; this specification assigns no organizational roles or operational targets.

## Operation and limits

- Resources, isolation, permissions, and capacity: local package metadata and placeholders only; no server, port, worker, persistent storage, or capacity target. A later dependency installation uses existing workspace permissions and does not grant registry publishing access.
- Failures, timeouts, cancellation, and cleanup: an unavailable or incompatible dependency is reported without silently changing packages or versions. A cancelled installation is not success; inspect manifest/lockfile consistency before continuation. No custom timeout or background process is required.
- Installation, updates, and removal: declare the selected tool in the owning workspace and update the root lockfile using pinned pnpm. Do not execute its binaries or add installation hooks. Removal affects this package and obsolete lockfile entries only, preserving unrelated work.
- Observability and execution correlation: record inspected source revision, manifest/lockfile changes, selected dependency metadata, and verification outcomes in this spec and its ticket. The former evidence README is absent from the current tree.
- Build and release boundary: no fabricated build task is needed for empty source directories. Any later automation uses `.sh` entry points under project rules; public manifest intent is not a build, release, or installation result.

## Verification and decisions

- Affected guardrails: [Twelve-Factor v1](../../harness/guardrails/0003-twelve-factor.gr.md) `12F-01`, `12F-02`, and `12F-05`; [FinOps v1](../../harness/guardrails/0001-finops.gr.md); [SDD v1](../../harness/guardrails/0002-sdd.gr.md) `SDD-01` through `SDD-03` when delivery is authorized. See the [policy entry](../../harness/guardrails).
- Applicability, criteria, owners, and planned evidence: `12F-01` requires an identifiable workspace and source revision; `12F-02` requires an explicit compatible tool and consistent lockfile; `12F-05` separates metadata from actual release. The maintainer records evidence and the owner accepts scope. All three are `not-verified` until implementation is inspected.
- `12F-03`, `12F-04`, and `12F-06` through `12F-12` are `not-applicable` to this placeholder package: it creates no service configuration, backing service, runtime process, port, scaling, shutdown, environment parity contract, application logs, or administrative task.
- Cost/consumption impact: no paid resource, CI expansion, telemetry, or AI integration is introduced by this placeholder scope. Local dependency download/build consumption remains unmeasured; no savings or zero-cost claim is made. Reassess relevant FIN criteria before any separately authorized paid execution.
- Open issues and exceptions: release details in `DEC-WEB-04` and future component/token adaptation remain open. Dependency selection and the inspection seam are resolved for this cycle; no policy exception is requested.
- Verification plan: `VER-WEB-01` below, within this artifact.
- Execution evidence: [WEB-01 evidence](../tickets/0017-TICKET-web-package-foundation.ticket.md#evidence) records the current inspection/install outcomes; review of the examined source remains pending. No runtime component behavior is claimed.
- Trade-offs, decisions, and blocking questions: placeholders preserve the selected organization with no usable API; the development CLI provides no runtime components. Release decisions must be resolved before any separately authorized publication.
- Technical review: Standards and Spec reviews passed for snapshot `c5f15b459bfc415172764c4aa16d39fb9ac437207a709e11c0ae471751d3f63d` after correction of the missing CLI environment-asset check. See linked ticket evidence for methods, red/green verification, and limits.

### VER-WEB-01 — Workspace inspection seam

Use one workspace/manifest inspection seam for the future change. Confirm package discovery, the five `.gitkeep` boundaries, absence of invented entry points and implementation, dependency placement/version, Node compatibility, and lockfile consistency. Record the actual inspected revision and limitations rather than asserting runtime behavior from metadata.

The implementation request authorizes this inspection seam and dependency installation; it creates no automated test suite or runtime probe. Existing repository checks remain governed by their scoped authorization. No package tarball or registry publication is required to complete the placeholder foundation. Inspection and installation outcomes remain `not-verified` until recorded evidence is attached.

### Approval record

The owner authorized specification synthesis, then ticket preparation, bounded implementation, and separate-branch commit/push on October 11, 2026. Package identity, public direction, placeholder boundaries, and the absence of component implementation remain unchanged. This execution record is not a human acceptance of this exact revision, completed technical review, or a registry-release approval.

### Delivery verification

The linked ticket records the completed local implementation and its observed evidence on October 11, 2026. The earlier verification sections describe the planned criteria; results are limited to the installed dependency graph, static review, compilation, and expressly authorized fixture or generated-artifact checks. Production and browser/runtime criteria without execution evidence remain not-verified. No blanket policy compliance or release availability is claimed.
