# CLI-INSTALL-01: Isolate website installation from CLI compilation

**Spec:** [SPEC-GO-CLI-FOUNDATION v1](../specs/0032-SPEC-go-cli-foundation.spec.md)
**Status:** done
**Origin:** Owner-reported Vercel deployment failure on October 13, 2026, after PR #30 was merged.

## Problem

Deployment `dpl_9TsuBC1umwVGjgjM3v7p7hUijDEA`, commit `effb0ba5ba992c001aa31816c027fca795ae9279`, failed during `pnpm install`. The workspace ran `packages/cli` postinstall and rejected the missing Go toolchain. The Next.js website does not require the CLI.

## Acceptance

- [x] Explicit website-only opt-out skips CLI compilation before looking up Go or writing build output.
- [x] Ordinary source installation retains the existing required Go build and explicit missing-tool error.
- [x] Website configuration keeps other lifecycle scripts enabled and builds only the website dependency closure.
- [x] Documentation describes the opt-out, its scope, and the explicit CLI build remedy.
- [x] Existing applicable checks and independent Standards/Spec review are recorded without new test scenarios.

## Boundaries

Do not install Go automatically, alter shell profiles, change runtime orchestration, disable all dependency scripts, or modify the unrelated root Vercel services configuration. Keep the previous lifecycle operational-verification limits. A successful local build does not establish hosted deployment readiness.

## Verification

- Inspected failed Vercel metadata/logs and verified project root `apps/website`; no confidential environment values were needed.
- `EXPHERE_SKIP_CLI_BUILD=1 pnpm install --frozen-lockfile` passed in a fresh checkout, reporting the explicit CLI skip and retaining the root prepare hook.
- `sh -n packages/cli/scripts/build.sh` and scoped Biome validation passed.
- The initial `website...` build selection unexpectedly included the CLI; this was corrected before delivery. The final `--filter=website` dry run selected the website task plus existing design/web prerequisites. Its forced build passed all three tasks and indexed five documentation pages, without scheduling CLI compilation.
- The normal explicit source build and CLI version command passed with Go available. No source-build steps changed after the opt-out guard.
- Standards and Spec independently verified six-file snapshot `a0d3f2194e9ecbcac5d5b19176dd6038d70f760c397c5003a5174824f43ae07b` against base `effb0ba5ba992c001aa31816c027fca795ae9279`, with zero actionable findings on either axis. Subsequent edits to this record are verification bookkeeping only.
- Existing pre-push build/test checks and hosted deployment status are reported in the follow-up PR. Hosted readiness remains pending at commit preparation; source completion is not a production release.
