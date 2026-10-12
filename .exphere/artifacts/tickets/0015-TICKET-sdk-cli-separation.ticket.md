# SPLIT-01: Separate the SDK and CLI without breaking local installation

**Document number:** `TICKET-0015`

**Spec:** [SPEC-SDK-CLI-SEPARATION v1](../specs/0006-SPEC-sdk-cli-separation.spec.md).

**What to build:** Contributors can build the SDK and run or update the existing CLI under separate private, versioned package identities.

**Blocked by:** None.

**Status:** done

**Approval:** On October 11, 2026, after the four specifications and proposed verification seams were presented, the owner explicitly invoked `to-tickets` and `implement` together and authorized commits and a push on a separate branch. This ticket is the complete, bounded delivery slice for its parent spec. The request authorizes this execution sequence; no npm publication, deployment, or additional PR is included.

## Acceptance criteria

- [x] The SDK and CLI have the requested names, private visibility, explicit versions, and separate package ownership; the SDK API remains empty and the CLI has no invented SDK dependency.
- [x] The CLI reports its own version and keeps the ex command, descriptor handling, and required shell assets. Root installation, workspace dependencies, and hook fixtures resolve the new CLI.
- [x] Fresh and repeated setup work; only verified legacy links for the same checkout are migrated. Unrelated files, links, and installations are preserved, and partial failure is recoverable.
- [x] Current documentation and future distribution drafts reflect the new boundary; historical verification evidence keeps its original source identity.
- [x] Isolated package-consumer checks, SDK compilation, and both code-review axes provide identified evidence before the ticket commit and normal branch push.

## Evidence

SDK build and public export import passed; the API remains empty. CLI shell contracts passed for version/help, same-checkout migration, repeated setup, interruption and partial-write recovery, conflicting paths, CI skip, descriptors, consumer hooks, and controlled adapter dispatch. Red/green regressions covered the relocated entry, legacy links, rollback, and directory-link refusal. No personal shell or infrastructure was changed.

Integration baseline: `300c25cd77f5acfda5f0e35f1b9f99250b411643` on `codex/package-foundations`, with scoped working changes. Pinned pnpm installation, root Biome check, workspace type checking, production builds, and the full hook/CLI/design suite passed on October 11, 2026. User PATH setup was explicitly skipped when verifying Husky activation. Verification ran on Node 26.9.0; the minimum Node version was not separately executed. Standards and Spec reviewers examined snapshot `c5f15b459bfc415172764c4aa16d39fb9ac437207a709e11c0ae471751d3f63d` against the recorded baseline. Standards: zero actionable findings. Spec: one missing-CLI-asset failure was corrected and its public regression passed; follow-up review found zero remaining findings. Unchanged scope retained its first review. Completion is limited to this ticket; runtime browser behavior, real infrastructure, npm release, and production readiness are not claimed.

Review correction: setup now validates required CLI/environment assets before any link or shell mutation. A missing-environment fixture failed before the fix and passed afterward while preserving both legacy links; all eleven CLI contract groups passed.

SDD v1: the ticket-scoped commit must retain its single Ticket trailer. Hosted PR association (SDD-02) remains not-verified because this delivery creates no PR; pre-push checks remain mandatory for the final outgoing revision.
