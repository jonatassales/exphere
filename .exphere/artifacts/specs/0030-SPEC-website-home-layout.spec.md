# Website home layout

- ID: `SPEC-WEBSITE-HOME-LAYOUT`
- Version: `v1`
- State: `approved for implementation`
- PRD: Existing website foundation; this bounded correction is authorized directly by the owner, without a new PRD.
- Technical owners: Website consumer; no shared platform changes.

## Contract and composition

- REQ-HOME-01: Home has exactly three grid rows: header, hero, footer. Balanced flexible outer tracks center the hero in the viewport when content fits. Use a minimum height of 100dvh and natural document growth on short screens; never clip content or overlap rows.
- REQ-HOME-02: Preserve the owner's borderless hero, animated background, current headline/description, header Docs navigation and GitHub/LinkedIn links. Center horizontally without absolute positioning or JavaScript measurement.
- REQ-HOME-03: Restore the shared centered footer on Home and Docs with the exact text “Grupo OLX © 2026”. Repair component references and replace the invalid text-1xl utility with text-xl.
- REQ-HOME-04: The command box is at most 360px wide, adapts to narrow containers, has reduced padding, and uses 12px monospace command text at every breakpoint. Retain the 44px copy-button target, visible focus, horizontal code overflow, disabled copying state, and accessible success/error feedback.
- REQ-HOME-05: Preserve the latest main branch's src/app layout, @app alias, next.config.mjs rename and MDX alias. Preserve its corrected executable clipboard value, npx exphere init, without a shell prompt prefix. No API, dependency, shader, metadata, or clipboard state-machine changes.
- Components: Existing Next.js website, Tailwind utilities, shared WebsiteFooter and CopyCommand. No new abstraction or public interface.
- Environment and executor: Existing pinned pnpm/Turborepo tasks on the local development host.
- Extension points and execution lifecycle: Existing page composition and client clipboard event handler only.
- Configuration, secrets and data: No new inputs, secrets, persistence or service integrations.

## Responsibilities

- Consumer: Implement the website layout and shared footer, and retain ownership of browser clipboard state.
- Platform: Existing design tokens, shader exports, native tooling and review policies remain unchanged.
- Service owner: The user authorizes scope, branding exception, local implementation and PR delivery. Merge and deployment are not authorized.

## Operation and limits

- Resources, isolation and capacity: Work on an isolated feature branch from main. Preserve the original dirty checkout and unrelated user edits. No infrastructure or runtime resource changes.
- Failures, cancellation and cleanup: Preserve clipboard success/error handling and disabled button behavior. Short viewports scroll naturally; do not force fixed-height clipping. Long code remains horizontally scrollable within its panel.
- Installation and updates: Use the pinned manifest and lockfile. Reuse the config rename already present upstream; do not restore the obsolete app tree or MDX alias.
- Observability and execution correlation: Record source base, source file hashes, checks and both review outcomes here. No runtime telemetry changes.

## Verification and decisions

### Authorization and source

The owner selected viewport centering and explicitly chose “Preserve current branding” during this conversation. On October 13, 2026, the owner requested spec, tickets, implementation and a PR, then explicitly instructed “PLEASE IMPLEMENT THIS PLAN” with this exact two-ticket breakdown. This covers artifact creation, implementation, normal commits/push and PR publication to jonatassales/exphere. It does not authorize merge or deployment.

The branding decision is a scoped exception to general Exphere-only guidance. Preserve Grupo OLX attribution and LinkedIn only within the authorized website scope; it does not establish organizational adoption or other commercial claims.

Baseline: main at `8251f7851fb9b2be9067782c178fe814ca5cc295`. The original checkout contained homepage edits against an older app tree. Carry over the approved visual intent while keeping current upstream structure, corrected clipboard value and configuration references. Existing DESIGN.md and IDENTITY.md are already present in this baseline; do not overwrite them with unrelated local copies. This spec supersedes earlier homepage panel, scale and footer-placement instructions only for the stated requirements.

### VER-HOME-01: bounded verification

- Run scoped Biome checks, website type checking and production compilation using existing native tools and Turborepo.
- Inspect generated Home/Docs HTML and CSS for the three-row layout, minimum viewport height, equal outer tracks, compact command styles, shared footer, navigation and preserved metadata.
- Assess short/narrow layouts and clipboard feedback from source and generated output. Do not claim observed browser behavior.
- Add no application tests or browser probes. Existing pre-push build/test gates remain authorized by the repository hook contract.
- Run independent Standards and Spec reviews against the same source snapshot before completion/commit/push, fix actionable findings, and refresh affected review after material edits.

### Policies and boundaries

- Twelve-Factor local policy v1: 12F-01 identifies this website/base; 12F-02 retains manifests and lockfile; 12F-05 distinguishes a locally compiled candidate from a deployment. Remaining factors are unaffected by this presentation-only correction. The checks below provide local evidence for 12F-01/02/05, without deployment or runtime certification.
- FinOps: No new infrastructure, application AI consumption, paid integrations, budget claims or runtime allocations. No savings or production readiness claims.
- SDD local policy v1: Each commit declares one HOME ticket. Both tickets declare this spec. The PR declares Spec: SPEC-WEBSITE-HOME-LAYOUT. Identity warnings do not substitute for review evidence.
- No public API changes, new application tests, dependency additions, remote issues, merge or deployment.

### Evidence

Local implementation and bounded verification completed on October 13, 2026:

- Pinned dependency installation passed with an unchanged lockfile.
- Scoped Biome check passed for all three changed TSX files; git diff --check passed.
- `pnpm exec turbo run typecheck build --filter=website` passed: four tasks succeeded, including two cached dependency builds; Home and Docs were statically generated.
- Generated HTML inspection confirmed both footer instances, the hero landmark, Docs/GitHub/LinkedIn links and retained noindex. Generated CSS contains min-height:100dvh, symmetric minmax(max-content,1fr) outer rows, max-w-90 (360px), text-xs (12px), and min-h-11/min-w-11 (44px). This verifies emitted output, not browser geometry.
- Nextra emitted a non-blocking last-modified timestamp warning for Docs in the worktree; compilation and route generation passed.
- React checklist: server page/footer retained, client state remains local to the clipboard interaction, accessible labels/focus/status and disabled state retained; no extra hooks or state abstraction.

Independent Standards and Spec reviewers examined the same six-file working snapshot (three sources and this spec/two tickets) against the baseline above. Standards: zero actionable findings and zero heuristic smells. Spec: zero actionable findings across REQ-HOME-01 through REQ-HOME-05. Reviews covered untracked artifacts and the entire relevant source diff; generated output and unrelated original-checkout edits were excluded. Subsequent artifact edits only record these outcomes and ticket state; source and requirements are unchanged.

Reviewed implementation SHA-256:

| Source | SHA-256 |
| --- | --- |
| Home page | `8a0bfffc65919e7261def9e063855c51afde2644bc99a954428b4351cd465cdf` |
| CopyCommand | `d9c75f69fd3e4b359fd2e42dc1f028341f558bf910681e11c9abbb960756358c` |
| WebsiteFooter | `3944cf6c985b9134573ffc670f44a3e79322c1cfbb31826544a92f9fbcfe90c1` |

Browser rendering, actual clipboard interaction, deployment and production outcomes remain unverified. No application tests or browser probes were added. Existing push gates execute separately at delivery. Tickets remain in-review for PR acceptance; local completion does not claim merge or deployment.


### PR check repair (October 13, 2026)

The owner's report that PR #24 failed authorizes a bounded correction to its existing verification. CI run 38401865040 passed formatting, type checks and builds, then failed the existing shader reduced-motion check: an expected draw count of 4 became 5. Startup resize/intersection notifications can legitimately draw a static frame after the test's fixed 200ms delay. Nine other shader cases passed; the CLI contract job was interrupted when Turbo failed.

Repair requirement REQ-HOME-06: update only the existing reduced-motion test's baseline synchronization to wait for an observed 300ms quiet period, bounded by a 5-second timeout, before recording each reduced-motion baseline. Retain the subsequent strict no-additional-draw assertion and all resume, hidden and unmount checks. No retries, skipped assertions, new application tests, product shader changes or workflow relaxation. This extends VER-HOME-01 solely to repairing and repeating the existing failing contract test; the homepage browser verification boundary is unchanged.

Repair validation: scoped Biome and @repo/web type checking passed. The existing reduced-motion contract passed 10 consecutive repetitions with one worker (40.1 seconds total, including fixture startup). Independent Standards and Spec reviewers both reported zero actionable findings against the same correction snapshot, based on commit 88546afa5ffaf34bdeaa396d1e0adc769405d613. Reviewed shader.spec.ts SHA-256: `0da9bc040f0e12f646eabecf27355bc33299c418db68998eb81393b4c756eaf5`. Only evidence text was updated afterward. Required push gates and the new GitHub CI run remain pending at this record; the previous CI failure is not represented as passing.
