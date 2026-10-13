# Exphere basic design palette

- ID: `SPEC-DESIGN-PALETTE`
- Document number: `SPEC-0011`
- Version: `1`
- State: `implemented; reviewed local scope`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md), still a draft; no approved PRD version covers this palette update.
- Technical owners: project owner for palette decisions; design-package maintainers for implementation and verification, not yet assigned.
- Related initiative: follow-up to [SPEC-DESIGN-TOKENS v1](0003-SPEC-design-token-foundation.spec.md). Its stable ID and completed foundation record remain unchanged.
- Source: the owner's seven-role “Exphere basic palette” request and explicit `to-spec` invocation on October 11, 2026.
- Authorization: on October 11, 2026, after receiving this draft, the owner requested `to-tickets && implement && commit separate branch and raise a PR`. This authorizes the bounded palette implementation, light-mode and compatibility mapping, established public-consumer verification, feature-branch commit/push, and a PR. It does not imply a separate human signature on the document revision, registry publication, or deployment.
- Ticket: [PALETTE-01](../tickets/0026-TICKET-design-basic-palette.ticket.md).

## Contract and composition

- Requirements addressed: `REQ-PALETTE-01` through `REQ-PALETTE-05`; supports product principles `REQ-PRD-005` and `REQ-PRD-006`.
- Components selected by the consumer: the existing `@repo/design` package, currently version `0.0.0`, and its public CSS and JSON exports. No new library or runtime API is proposed.
- Environment and executor selected by the consumer: retain the existing pinned pnpm workspace, Turborepo orchestration, and shell entry points. No tooling or version change is needed.
- Extension points and execution lifecycle: edit the authored color-token data; the existing compiler generates both public exports through the established build/watch lifecycle. Consumers retain explicit theme selection.
- Configuration, secret references, and data ownership: the owner supplies the palette. These are versioned design values, not environment configuration or secrets. Generated exports remain derived artifacts.

### Problem and intended result

The design package currently supplies provisional grayscale colors. The owner has now supplied Exphere's basic palette and wants those values centralized in the design tokens so consumers can use one consistent source.

Replace the relevant light-theme defaults and add the missing semantic roles through the existing package contract. The implementation request adopts the draft's light-mode mapping: the supplied palette contains a white background, and the current website explicitly selects light mode. No dark palette was supplied.

### User story

1. As an Exphere interface developer, I want the supplied basic palette available through the shared design tokens so that interface colors remain consistent without duplicating editable values in application code.

### Required palette and public mapping

The roles and hexadecimal values below are owner-supplied. Their placement under `themes.light.color` and the CSS mapping are bounded implementation choices covered by the owner's follow-up request.

| Supplied role | Required value | CSS custom property |
| --- | --- | --- |
| `primary` | `#6D0AD6` | `--design-color-primary` |
| `primaryHover` | `#5408A5` | `--design-color-primary-hover` |
| `background` | `#FFFFFF` | `--design-color-background` |
| `surface` | `#F9F9F9` | `--design-color-surface` |
| `text` | `#27262A` | `--design-color-text` |
| `textSecondary` | `#535257` | `--design-color-text-secondary` |
| `border` | `#DDDDDD` | `--design-color-border` |

### Requirements and acceptance

| ID | Contract | Acceptance criterion |
| --- | --- | --- |
| REQ-PALETTE-01 | Expose all seven supplied colors. | Each supplied role is represented in light-theme color data and generated CSS/JSON with the exact table value. Colors are not approximated, converted to a different palette, or inferred for additional states. |
| REQ-PALETTE-02 | Preserve existing consumer names. | Light-theme `foreground` remains available as an alias of light-theme `text`, resolving to `#27262A`. Existing consumers of background and foreground receive the updated values after regeneration without changing their imports or styles. |
| REQ-PALETTE-03 | Keep the update bounded. | Shared grayscale primitives, existing dark-theme tokens and values, typography, dimensions, effects, and explicit theme selection remain unchanged. The new roles are guaranteed only for light mode; no dark equivalents are invented. |
| REQ-PALETTE-04 | Preserve the package contract. | Public CSS/JSON exports, neutral `--design-` naming, typed metadata, alias preservation, deterministic generation, and validation behavior remain intact. No generator changes, new dependencies, or parallel editable palette are required. |
| REQ-PALETTE-05 | Document and verify the resulting contract. | Package documentation describes the seven light roles and compatibility alias. The existing disposable consumer fixture covers their public values and unchanged dark behavior; old assertions that specifically require the provisional light background are updated. Execution outcomes are recorded only after authorized verification. |

### Implementation decisions

- Author the seven supplied roles as literal color values in the existing light semantic group. Keep the group's inherited color type. An additional primitive brand palette or numeric scale is unnecessary for this request.
- Retain light `foreground` as a same-theme alias of `text`, preserving the website's current consumer contract while also exposing the owner's `text` role. JSON retains the authored alias; CSS retains a variable reference rather than flattening it.
- Use the existing camelCase-to-kebab-case normalization for `primaryHover` and `textSecondary`. Public imports remain `@repo/design/tokens.css` and `@repo/design/tokens.json`.
- Preserve shared grayscale foundations because the existing dark theme references them. Do not repurpose those primitives to encode the new palette.
- Update package documentation and the existing consumer fixture alongside the token data. Correct the root and website README descriptions that still call these colors provisional. Keep unrelated invalid-graph, deterministic-build, and watch coverage; no new test framework or application styling change is proposed.

## Responsibilities

- Consumer: import the public token exports, select the theme, and choose where primary, hover, text, and surface roles apply. Token availability does not itself implement component interactions.
- Platform: preserve the established package generation, validation, workspace conventions, and evidence boundaries. No new enforcement mechanism is introduced.
- Service owners: the project owner decides visual scope and accepts the theme/name mapping; package maintainers implement and record bounded verification. No organizational adoption or measured accessibility outcome is implied.

## Operation and limits

- Resources, isolation, permissions, and capacity: this is a local token-data update with no infrastructure, network service, credentials, production access, or new resource allocation.
- Failures, timeouts, cancellation, and cleanup: retain existing whole-graph validation, nonzero failure results, stale-output diagnostics, and watcher cleanup. No lifecycle or timeout change is proposed.
- Installation, updates, and removal: regenerate owned outputs using the existing package lifecycle; consumers keep their current imports. No installation, version bump, registry publication, or release-policy change is required by this draft.
- Observability and execution correlation: future verification records the source revision, package version, command outcomes, and exported artifact identity. This specification is not evidence of a successful build or rendered interface.

### Out of scope

Dark-theme redesign, additional colors or state palettes, gradients, shadows, typography, spacing, motion, components, website layout or page-copy changes, theme switching, styling-framework migration, and a complete brand system are excluded. The attached frontend role document is reference context, not authorization to expand this palette request. Browser probes, application test infrastructure, SDK/CLI changes, registry publication, and deployment remain outside this implementation. Git commit/push and a PR are explicitly authorized.

## Verification and decisions

- Affected guardrails: [Twelve-Factor local policy v1](../../harness/guardrails/0003-twelve-factor.gr.md), narrowly `12F-01` for source identity and `12F-05` for authored inputs versus generated artifacts. Dependencies and generator diagnostics are preserved, with no new `12F-02` or `12F-11` behavior. [SDD local policy v1](../../harness/guardrails/0002-sdd.gr.md) applies to later implementation review and delivery.
- Applicability, criteria, owners, and planned evidence: package maintainers verify `REQ-PALETTE-01` through `REQ-PALETTE-05` at the public export boundary. Ports, backing services, deployment configuration, process scaling, and production operations are `not-applicable` to this token-data change. The linked ticket records observed package verification; browser and production outcomes remain `not-verified`.
- Cost/consumption impact: no new dependencies, AI consumption, paid services, budgets, or provisioned resources. FinOps resource/cost criteria are `not-applicable`; existing local build work carries no new measured cost or savings claim.
- Open issues and exceptions: `DEC-PALETTE-01` and `DEC-PALETTE-02` are resolved for the bounded implementation request. No additional compiler exception is required; the existing foundation exception remains scoped to its compiler.
- Verification plan: `VER-PALETTE-01` below reuses the existing public-consumer seam. The linked ticket records red/green verification, compilation, static checks, and preservation evidence.
- Trade-offs, decisions, and blocking questions: the compatibility alias avoids consumer edits; retaining dark values avoids inventing an unsupplied palette. The follow-up implementation request resolves these choices without expanding the design scope.
- Technical review: Standards and Spec found no actionable findings in implementation snapshot `26e8d2e61d7aecaff0512af6ec4364ff312fff44c77e128e2a248b4e94df558d`. The linked ticket records the exact scope, verification, and evidence limits. The draft review below is historical.

### VER-PALETTE-01 — Existing public-consumer seam

Reuse the isolated public-export and watch fixture authorized for `SPEC-DESIGN-TOKENS` in root AGENTS and reused by the owner's current implementation request. Its disposable consumer resolves the package exports; no new seam or helper automation is introduced.

Authorized verification:

1. Check the seven light-theme roles and exact values through both public exports. Verify camelCase JSON identities and normalized CSS names, inherited color typing, and the retained foreground-to-text alias. Check the consumer-visible alias relationship without depending on parser internals.
2. Compare existing grayscale foundations, dark tokens, and non-color categories with the pre-change baseline. Keep deterministic generation and invalid-input guarantees covered by the existing fixture.
3. Replace obsolete assertions tied to the provisional light background. Preserve existing watch coverage; edit a supplied light semantic value in the disposable fixture and observe the updated public output to cover the palette's consumer behavior.
4. Record the focused fixture and package build/type-check results for the actual implementation revision. A package export check does not prove browser rendering, hover interactions, accessibility compliance, or production readiness.

Prior art: the [design package contract](../../../packages/design/README.md) and [existing consumer fixture](../../../packages/design/scripts/test.sh). No new application tests or browser checks are proposed.

### Decision register

| ID | Decision | State and authority |
| --- | --- | --- |
| DEC-PALETTE-01 | Apply the supplied palette to the light theme and preserve existing dark values. | Resolved within the owner's October 11, 2026 implementation request following this draft; no dark palette is invented. |
| DEC-PALETTE-02 | Export `text` and retain light `foreground` as its compatibility alias. | Resolved within the same implementation request; preserves the existing website's foreground consumer. |
| DEC-PALETTE-03 | Use the seven supplied hexadecimal values without substitutions. | Explicit owner palette input on October 11, 2026, followed by implementation authorization. |

### Inspected source context

Read-only inspection used repository base `89e4bd796d3ec8ff76bed414c39f19be2d365b7e`, the [authored color data](../../../packages/design/tokens/color.json), [compiler](../../../packages/design/src/compiler.ts), [package contract](../../../packages/design/README.md), and the [website's public token mapping](../../../apps/website/app/globals.css). The inspected compiler already supports the needed literals, normalization, and same-theme aliasing. Historical foundation verification remains attached to its original spec and is not evidence for this palette update.

### Draft review record — October 11, 2026

Two independent reviewers inspected this specification addition against base `89e4bd796d3ec8ff76bed414c39f19be2d365b7e`. Both confirmed candidate SHA-256 `1e834eedb6fc93b8b6291901c2c9872ba8ea2c7ad900f92715d4901f15fb8324`, before this evidence record and the technical-review status update. All preexisting changes were excluded.

- Standards: no actionable findings. The candidate follows the tracker, canonical template, language, draft status, existing verification authority, and evidence boundaries.
- Spec: no actionable findings. All seven supplied values are exact; light-mode placement and the compatibility alias remain proposals, and the scope stays within the design package's existing contract.

Summary: Standards — 0 findings; Spec — 0 findings. Static whitespace inspection reported no diagnostics. No tokens were changed and no builds, fixture tests, or browser checks were executed. Human acceptance and implementation remain pending.
