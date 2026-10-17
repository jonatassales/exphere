# EX-STANDALONE-01: Harden the standalone CLI refactor

**Spec:** [SPEC-STANDALONE-CLI-HARDENING v2](../specs/0036-SPEC-standalone-cli-hardening.spec.md)
**State:** in-review

## Delivery criteria

- Restore implemented commands and their public CLI contracts.
- Preserve persisted ownership evidence and exact configuration fingerprints.
- Keep domain rules and concrete effects separated behind private Go packages.
- Restore the existing native command checks and agent instructions.
- Record passing local checks and independent Standards/Spec source reviews.
- Replace `packages/ex` with the reviewed candidate while preserving workspace
  package integration and existing source-contract checks.
- Publish the integrated replacement as a PR to `jonatassales/exphere`, as
  subsequently requested by the owner; the separate repository publication
  remains stopped.

## Verification record

Standalone source verification completed October 17, 2026. The owner then
stopped publication and requested integration into `packages/ex` instead.
The following source evidence predates that integration and is retained for
the unchanged Go source.

- Source: 117 files, comprising `go.mod`, `go.sum`, and every file under `src`.
  SHA-256 `c5dddf779519d3edf6da4c8b7c873e27c1a889c918cb2bf146cc61cab774139b`,
  calculated from sorted relative paths, NUL, bytes, and NUL.
- Formatting: `gofmt -l src` reported no files.
- Existing checks: `go test ./...` passed after adapting only composition/import
  wiring in the original `TestCommand` and `TestOutputFailure`. All original
  cases and assertions remain. No new suites or scenarios were added.
- Static checks: `go vet ./...` passed.
- Builds: native macOS build and Linux amd64 cross-compilation passed.
- Presentation checks: `version`, `-V`, JSON `--version`, unknown help, and runtime
  help showed the restored command contract. These invoke no infrastructure.
- Standards review: zero actionable findings in the reviewed scope. The lead
  separately inspected the seven files authored by that reviewer. A third
  reviewer independently checked lifecycle transitions and restored operations.
- Spec review: zero actionable findings against the same source snapshot and
  SPEC-STANDALONE-CLI-HARDENING v1, with original Exphere contracts as baseline.
- Resolved findings: cluster-record compatibility, exact cleanup fingerprints,
  observation DTOs, missing commands, invalid-help behavior, exact argument
  diagnostics, missing agent instructions, private package boundaries, consumed
  process interfaces, startup transitions, and legacy-runtime refusal.

The initial existing-test run caught three presentation regressions; code was
corrected without weakening the tests, and the full existing Go suite passed.
Checks ran with the local toolchain and offline module resolution. No native
infrastructure tools, hooks, agent applications, personal profiles, or paid
services were executed. Live startup, recovery, cleanup, production behavior,
and expanded regression coverage remain unverified. This evidence does not
claim a perfect quality score or production readiness.

SDD identity is local and advisory until actual commits and the PR establish
links. Publication must use a feature branch from `main`, one ticket trailer
per commit, the same spec declaration in the PR body, and normal pushes.

## Workspace integration

Authorized October 17, 2026 by the explicit request to replace `packages/ex`.
The old Go implementation is removed. The existing package manifest, bins,
build/setup helpers, source-contract schemas, and fixtures are retained byte
for byte, including executable permissions. The standalone module identity
remains unchanged. Independent reviewers remain stopped as requested.

- Integrated package snapshot: 237 source/documentation/fixture files, excluding
  generated `dist`, SHA-256
  `3386cf51050e75602c44115af0fe53ac168a929100aed5c6344f6dc591afdf39`.
  Hashing uses the same sorted path, NUL, bytes, NUL convention as above.
- The 117-file Go source snapshot exactly matches the independently reviewed
  candidate. The former adapters/core/commands/kernel/templates trees are absent.
- `go test ./...` and `go vet ./...` passed from the replacement package with
  the local toolchain and offline dependency resolution; formatting is clean.
- The existing `scripts/build.sh` built `dist/ex`. The package bin returned JSON
  version output and runtime help. `pnpm --filter @exphere/ex exec ./bin/ex.sh
  --version --json` confirmed workspace package selection and the executable
  bridge. Shell-setup help passed without changing a profile.
- At initial integration, workspace Node dependencies were not installed, so
  Turborepo and the SDK's runtime dependency resolution were not executed.
  Their manifests and SDK
  bridges were inspected; their dependency paths and package entry points are
  unchanged. Native Go tools performed the package checks directly.
- Standards review by the lead: no actionable integration findings. The private
  Go boundary, native build ownership, unchanged executable packaging, and
  root artifact numbering/IDs are preserved. This is not a new independent
  Standards review of the integration.
- Spec review by the lead: no actionable integration findings. The replacement
  matches the reviewed candidate exactly, removes the former implementation,
  and preserves existing SDK/package contracts as required by revision 2.
  This is not a new independent Spec review of the integration.
- Twelve-Factor local policy v1: 12F-01/02/05/12 assessed through source identity,
  unchanged dependency/build declarations, successful package build, and explicit
  setup help. No service, provisioning, or live runtime assessment is inferred.
- The unchanged `scripts/test-consumer-harness.sh` passed all 76 existing
  source-contract checks in disposable fixtures. Its forbidden-tool assertions
  confirmed no Terraform, Kubernetes, network-client, Docker, or cluster command
  execution. This is local contract evidence, not live runtime readiness.

Only the package and these relocated spec/ticket records change in the workspace.

## PR delivery

The owner requested a PR for the integrated replacement on October 17, 2026.
The configured destination is `jonatassales/exphere`, base `main` at
`7591d39d8204cbe3f1fcffd86da56b761151788b`. GitHub access and the unchanged remote
base were verified before publication. The branch is
`codex/integrate-hardened-ex-cli`; the configured author and committer remain
Jonatas Sales (`6073626+jonatassales@users.noreply.github.com`).

The package source snapshot and prior source/integration reviews remain
unchanged. The lead reviewed the delivery-only artifact changes against both
Standards and Spec; no additional independent reviewers were started.
Locked dependency installation completed without changing the lockfile. The
workspace `pnpm check` and `pnpm typecheck` commands passed. The installed SDK
bridge also returned the expected JSON version output. The repository's normal
commit hooks and full build/test pre-push hook remain enabled; their publication
outcome will be recorded in the PR rather than inferred from these earlier checks.
