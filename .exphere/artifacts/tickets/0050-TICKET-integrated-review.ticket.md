# INTEGRATE-01: Verify the combined docs, Go and skills migration

**Spec:** [SPEC-PR19-COMPLETION v1](../specs/0028-SPEC-pr19-completion.spec.md)
**Status:** in-review
**Approval:** The owner's request for a complete reviewed feature branch and PR.
**Blocked by:** WEB-DOCS-01, CLI-GO-01, TOOLS-NATIVE-01 and SKILLS-OWN-01.

**What to build:** Validate the combined branch without suppressing missing evidence. Reconcile dependency lock changes, inspect the built Nextra/Orbo/docs experience within authorized static/build scope, run Go tests, verify no dead script or skill links, record Standards+Spec reviews and publish one PR.

- [x] All newly enabled Nextra/Orbo dependencies pinned and frozen-lock install verified.
- [x] Go tests/vet and native package tasks run or errors/blockers recorded.
- [x] Website SSR, generated Nextra route, links and source accessibility/motion contracts inspected; website browser interactions remain not verified.
- [x] Tree contains no unwanted `scripts/`, duplicate AIHero skills or obsolete writing-for-agents/adr.
- [x] PR declares SPEC-PR19-COMPLETION and links included focused contracts/tickets with exact evidence/status; no merge/deploy.

## Local verification — October 13, 2026

Observed on macOS arm64 with Node 26.8.2, pnpm 12.4.2 and Go 1.27.1. The
proposed hosted CI uses Node 22.22.1 and the Go module minimum; hosted evidence
is recorded separately and is not inferred from this local run.

- `pnpm test`: seven successful Turbo tasks. Go CLI tests, 76 source-contract
  checks, six disposable hook-contract groups, design public-export/watch
  contracts, and all ten existing shader browser tests passed. The shader
  fixture is not a browser test of the new website.
- `go -C packages/cli vet ./...` and native Go compilation passed.
- `pnpm check`: 114 files passed. Hash-pinned fixture bytes are preserved by a
  formatting-only exclusion; parsing and linting remain enabled.
- `pnpm peers check`: no peer dependency issues after selecting the website's
  supported TypeScript compiler and scoped Nextra Zod dependency.
- Generated `/` and `/docs` HTML each contains one correct h1, two decorative
  listening orbs and the requested footer. The home links to `/docs`, includes
  the exact command, and omits rejected copy. Both pages retain noindex and
  omit unapproved canonical/social-image URLs.
- All 46 Go/workflow skill entrypoints have parseable YAML, nonempty descriptions
  and matching directory identities. Go support-file provenance, the complete
  AIHero catalog and MIT licenses are recorded in SKILLS-OWN-01.
- Physical/source inventory contains no scripts directory outside the CLI,
  retired Bash dispatch, writing-for-agents, or `.agents/adr`.

Website clipboard interactions, responsive visual appearance, Orbo animation and
assistive-technology behavior remain not verified in a browser under this cycle's
scope. No npm publication, provisioning, microphone integration or deployment was
performed. The Go command remains a scaffold; copied installation text does not
claim `init` is available.

- Final `pnpm install --frozen-lockfile --ignore-scripts`, `pnpm check`,
  `pnpm typecheck` (six tasks) and `pnpm build` (five tasks) passed. The
  production build statically generated both `/` and `/docs`.

## Review snapshot

Both independent axes reviewed the complete branch and staged task changes against
`d6b3c8abff240c54011f81f7088f445e3fbabef4`. The initial tree was
`f3b0b67761898637e190804323c7aa2ee93733a8`; the final reviewed source tree is
`3d075c0071f533505da8a52efd4496a72798cca2`. The latter changes only the two
active policy documents identified by Standards. Both reviewers refreshed that
delta. Generated dependencies/build output were excluded; requested vendor skill
integrity, licenses and ownership were included. This outcome record and ticket
state updates follow the review and are evidence-only changes.

## Standards

The full review identified one alignment defect: the frontend rule and rule index
still required retired shell wrappers. Their instructions now consistently use
native tool commands and retain the authorized CLI, Husky and test boundaries.
The targeted refresh confirmed the finding resolved. No other actionable
standard violations or material Fowler heuristic findings were identified.

Standards: **0 unresolved findings**.

## Spec

The full review found no actionable missing, incorrect or out-of-scope product
requirements. Website source, Go scaffold, skill ownership and supporting
PRDs/DDs/specs/tickets agree with the requested integration scope. The targeted
policy refresh introduced no requirement regression. Publication and hosted
results are separate delivery evidence; review does not verify browser behavior.

Spec: **0 findings**.

Review summary: Standards 0 unresolved; Spec 0. Neither axis establishes owner
acceptance, website browser outcomes or hosted execution.

## Delivery evidence

- The existing [PR #19](https://github.com/jonatassales/exphere/pull/19) remains open
  against `main`. Its title/body now declare `SPEC-PR19-COMPLETION`, focused
  contracts, all five tickets and the actual local verification limits.
- Git author/committer configuration was checked as Jonatas Sales
  `<6073626+jonatassales@users.noreply.github.com>`; the authenticated GitHub
  account is `jonatassales`.
- This evidence is prepared for the authorized normal commit/push to the existing
  feature branch. The publication hash and current hosted check results are
  observable on PR #19; they are not inferred from the older provider-review
  checks or the local test run. Owner acceptance remains pending.
- No merge, force push, npm publication, provisioning or deployment is authorized
  or claimed by this record. The primary checkout's unrelated deletion remains
  preserved.

