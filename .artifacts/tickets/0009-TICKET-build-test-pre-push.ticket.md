# HOOK-03: Gate code pushes on real build and test results

**Document number:** `TICKET-0009`

**Spec:** [SPEC-GIT-HOOKS-SDD v1](../specs/0002-SPEC-git-hooks-sdd-traceability.spec.md).

**Requirements:** REQ-HOOK-05 and the build/test and push-verification portion of REQ-HOOK-08.

**What to build:** a contributor's code push runs the real root build and test commands for the intended revision and stops when those checks fail or cannot verify that revision.

**Blocked by:** HOOK-01 — Activate Conventional Commits through local installation, which provides hook activation and a meaningful hook contract suite. HOOK-02 is not a prerequisite for building or verifying a push.

**Status:** draft

**Approval:** Not recorded for this breakdown or implementation. The current `to-tickets` invocation does not confirm the proposed test seam or authorize execution.

## Acceptance criteria

- [ ] The root build command has its required shell adapter and runs declared workspace builds through Turborepo, retaining the SDK's existing build behavior. Missing root automation is repaired only as required by this ticket.
- [ ] The root test command runs the meaningful hook contract suite and declared workspace tests through the appropriate shell/Turborepo entry points. No empty runner, unconditional success, missing task, or recursive root dispatch substitutes for testing.
- [ ] Pre-push runs `pnpm build` followed by `pnpm test`. Build failure stops the sequence; either command's failure or absence prevents the code push and remains visible in the exit status and output.
- [ ] The gate identifies proposed ref updates and the checked revision. Its initial build/test support requires the checked-out commit and a clean tracked source state; pushing other source revisions fails with an actionable scope error rather than claiming they were tested.
- [ ] Multiple updates, new branches, force-updates, deletion-only updates, and tags receive the spec's explicit scope treatment. Deletion-only updates need no source build; tags are identified separately from branch work.
- [ ] The hook does not silently stash, switch branches, discard changes, fetch remote objects, or bypass failed checks. Temporary verification resources belong to the task and are cleaned without touching user data.
- [ ] Dev execution, audit, and delivery guidance describes the commands, exact-revision limits, blocking failure behavior, and scoped permission for these tests, without turning other restrictions into blanket permission.
- [ ] The shared contract suite exercises successful and failed commands, missing tooling, dirty tracked state, non-checked-out revisions, and the supported ref-update cases. Push fixtures use a local bare remote and avoid recursively invoking the suite.
- [ ] Final evidence includes an actual build and meaningful test result at the identified revision when authorized, distinguishing these from controlled command-failure fixtures. Unavailable mandatory evidence stays explicit and cannot close the ticket as successfully verified.

## Verification and handoff

Use the proposed `VER-GIT-HOOKS-SDD` boundary after confirmation, keeping installation side effects and commits/pushes inside disposable fixtures. This does not require initializing Git in the current workspace or publishing a real branch. Ticket creation performs no build, test, installation, commit, or push.

The resulting pre-push entry exposes a working blocking quality sequence that HOOK-04 can extend with advisory diagnostics. SDD warnings must later preserve this gate's failures. Staged linting and scoring can be delivered independently by HOOK-02; they are not artificial blocking edges here.
