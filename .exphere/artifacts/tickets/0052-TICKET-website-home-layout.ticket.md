# HOME-01: Center the homepage and restore shared references

**Spec:** [SPEC-WEBSITE-HOME-LAYOUT v1](../specs/0030-SPEC-website-home-layout.spec.md)
**What to build:** Deliver a viewport-centered three-row homepage with the owner’s borderless design, header navigation and shared centered footer.
**Blocked by:** None.
**Status:** in-review
**Approval:** The owner explicitly authorized this two-ticket plan, implementation, commits, push and PR in this conversation on October 13, 2026. Branding preservation is explicit. Merge and deployment remain outside scope.

- [x] REQ-HOME-01: balanced rows, minimum viewport height and natural overflow.
- [x] REQ-HOME-02: preserve hero, animation, header links and copy.
- [x] REQ-HOME-03: Home and Docs share the requested footer; valid typography utility.
- [x] REQ-HOME-05: preserve upstream src/app, aliases and configuration rename.
- [x] Scoped checks and independent Standards/Spec reviews recorded against the final source.

## Evidence

See VER-HOME-01 and the evidence section of the parent spec. Scoped formatting, website type checking, production compilation and generated-output inspection passed. Independent Standards and Spec reviews reported zero actionable findings against the parent spec’s recorded source hashes. Browser behavior and production remain unverified. PR acceptance is pending.


## PR check repair

The October 13, 2026 failure report authorizes REQ-HOME-06 in the parent spec: repair baseline synchronization in the existing reduced-motion contract test without changing shader behavior or weakening the stop/resume assertions. Scoped formatting and package type checking passed; the existing failing test passed 10 consecutive repetitions. Refreshed Standards and Spec reviews each reported zero actionable findings against the source hash in the spec. Required push gates and the new CI run remain pending. This is a delivery correction under HOME-01.

The first correction still failed in GitHub run 38403213470. REQ-HOME-06 now also requires observing native canvas resize/intersection callback completion before the baseline; quiet time alone is insufficient. Refreshed validation for this revision is pending.

Revised synchronization passed 10 normal repetitions and three delayed-intersection repetitions; a disposable diagnostic without the readiness barrier reproduced CI's exact 4-to-5 mismatch. Package type checking, Biome and refreshed independent reviews passed. See the parent spec for the source hash and the distinction between failed prior CI and pending updated CI.
