# Website agentic FinOps identity and disabled clipboard

- ID: `SPEC-WEBSITE-AGENTIC-FINOPS-IDENTITY`
- Version: `v1`
- State: `approved for implementation`
- PRD: Existing website requirements; the owner directly authorized this bounded visual/content revision without a new PRD.
- Technical owners: Exphere website consumer and repository maintainers.
- Base: `a2b78dcf8ba60724654760018c589fd2aef008e7` (`main`, October 13, 2026).

## Contract and composition

| ID | Requirement and acceptance |
| --- | --- |
| IDENTITY-01 | Replace the Home hero eyebrow `DevEX / FinOps Platform` with exactly `Agentic FinOps Platform`. Preserve the headline, description, positioning and metadata. |
| IDENTITY-02 | Render the `npx exphere init` clipboard control permanently disabled: native `disabled` semantics, muted disabled colors, and a `not-allowed` cursor. No clipboard writes or click handlers are reachable. Keep the command visible and manually selectable, and retain the compact layout. Do not claim the CLI command is published or functional. |
| IDENTITY-03 | In the shared Home/Docs footer, replace `Grupo XLO © 2026` with the existing decorative `OrboPreview` in its `black-hole` appearance followed by exactly `Neongate © 2026`. Avoid new graphic assets, new animation modes and changes to the Home/Docs header orb appearances. |
| IDENTITY-04 | Set the Home LinkedIn destination to `https://www.linkedin.com/company/exphere` and its accessible label to Exphere/company wording. Set the Home GitHub destination and Docs navbar project link to `https://github.com/jonatassales`. Preserve icon sizes, focus treatment and in-app Docs navigation. Other source-code/documentation links are outside scope. |
| IDENTITY-05 | Update the website README where it describes the former live clipboard, personal LinkedIn destination, and previous footer attribution. Keep historical specifications and their recorded validation evidence unchanged. |

The website remains a Next.js App Router application using existing Tailwind tokens, `@repo/web` and `orbo-voice`. No dependency, shared-token, metadata, endpoint, persistence, service, secret, or public SDK/CLI API change is authorized.

## Responsibilities

- Consumer: Implement and document the Home hero, disabled command panel, social links, Docs project link and shared footer.
- Platform: Retain existing framework ownership, design tokens, reusable orb component, build tasks and SDD review guidance.
- Service owner: The project owner authorized this scope, normal commits and publication of a PR to `jonatassales/exphere`; merge and deployment remain separate decisions.

## Operation and limits

- Resources and isolation: Work on an isolated feature branch from the recorded `main` commit. Preserve unrelated work and historic attribution records. No infrastructure or external service calls are introduced by the application change.
- Failure and accessibility: The copy button must be natively disabled, show no success/error feedback for an unavailable operation, and remain distinguishable by color and cursor. Keep the code readable and selectable. Preserve the orb's existing decorative `aria-hidden` behavior and reduced-motion configuration.
- Lifecycle and cleanup: Reuse the shared footer on Home and Docs. Preserve the existing `npx exphere init` preview text and do not imply installer availability.
- Observability and evidence: Keep verification claims bounded to checks actually performed; a committed change or PR does not establish deployed browser behavior.

## Verification and decisions

### Authorization and precedence

On October 13, 2026, the owner explicitly requested all five changes and the sequence **Spec → ticket → implement → PR**. This supersedes prior website decisions only for the affected hero eyebrow, copy availability, footer attribution, and social/project destinations. Earlier approved specs and historic source hashes describe the snapshots they reviewed and must not be rewritten. Attribution to Neongate is an owner-directed, website-only exception to general Exphere naming guidance.

### VER-IDENTITY-01

1. Inspect the exact rendered source copy and destinations in Home and Docs, and verify the footer has the `black-hole` orb and new text in both contexts.
2. Verify the copy button has native `disabled`, visually muted classes and `cursor-not-allowed`; ensure no clipboard API, click handler or dead state machine remains.
3. Inspect the scoped diff for accidental modifications to shader, logo assets, docs content, metadata, dependencies and tests.
4. When execution is available, run native scoped Biome, website TypeScript type checking and production build, then inspect generated Home/Docs markup. Do not represent unrun checks as passed.
5. Review the same task-scoped source snapshot along Standards and Spec axes, record actual findings, and do not claim independent reviewers or browser evidence without execution.

### Guardrails and exclusions

- SDD v1 (SDD-01/02/03): Use `BRAND-01` as the stable ticket in every authored commit, a parent spec reference in the ticket, and `Spec: SPEC-WEBSITE-AGENTIC-FINOPS-IDENTITY` in the PR. A GitHub PR is not an approval or evidence of deployment.
- Twelve-Factor v1: Existing website codebase, manifest, build and logs are unchanged (12F-01/02/05/11); no new runtime configuration, deploy or release. Deployment outcome not verified.
- FinOps: No new metered feature, paid integration, AI operation, provisioning or cost claim; no incremental spend assessment is required for this content-only revision. Resource impact is not measured.
- No new application tests, browser infrastructure, dependencies, brand asset files, CI policy changes, remote GitHub issue tracker or production deployment.

### Evidence

Initial spec and ticket were authored against the pinned `main` revision. Static source and PR inspection may be recorded here after implementation. Local build, live browser testing and independent sub-agent review are not asserted before they are actually performed.
