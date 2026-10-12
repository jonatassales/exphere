# WEB-ID-02: Comment out the home logo

**Spec:** [SPEC-WEBSITE-HOME-LOGO-VISIBILITY v1](../specs/0018-SPEC-website-home-logo-visibility.spec.md)
**What to build:** Temporarily disable the home logo with a source comment, preserving its artwork, SEO, and shader, and publish a separate PR.
**Blocked by:** None; the logo implementation is already present on the recorded main baseline.
**Status:** in-review
**Approval:** The October 12, 2026 owner request to comment out the home logo and create a PR authorizes this specification v1 and single-ticket correction. Merge and deployment are excluded.

- [x] REQ-HOMELOGO-01: The complete logo heading and its unused image import are commented out; no replacement content is rendered.
- [x] REQ-HOMELOGO-02: Metadata and all other SEO, brand, layout, and shader resources remain unchanged.
- [x] REQ-HOMELOGO-03: The website README explains the disabled logo and restoration; existing tickets/specs remain untouched.
- [ ] REQ-HOMELOGO-04: Review, verification limits, and the separate PR are recorded against the changed snapshot.

## Verification record

Planning commit: `c3f48be045f453a46ef39ae12c911c8a07de9102`, before implementation. The first three criteria are checked at the source/emitted-code level, not through a Next.js build or browser observation. Required execution and independent-review evidence remains outstanding, so this ticket is not done.

Reviewed source snapshot, compared with main `8ec2e5175c74711bd2a210fd92e59fde24f1da9b`:

| File | SHA-256 |
| --- | --- |
| Website home page | `a5e444068a4dd0efdafeafdbe8a7a053e9fdca733f27b6bd788ca72d0ea8a265` |
| Website README | `9afd677d160250f2d14ab164e5df1e7a8803e94b4ce10bcf0ad5cc6a86dbd348` |
| This ticket's parent specification | `90a5210c0fb1db0150bbd7db988292aac3394cdb9359ce0fe61dc9504c4fd2e0` |

Observed on October 12, 2026:

- Original page and README copies match their fetched Git blob hashes.
- TypeScript 5.8.3, available in the executor rather than installed by the project, parsed and transpiled the TSX without diagnostics. Emitted code has only the existing main container: no image import, heading, logo reference, or replacement content. This does not validate Next.js or the project's TypeScript version.
- The description and metadata declarations are byte-for-byte unchanged. Reversing only the added comments restores the exact baseline page source.
- `git diff --no-index --check` passed for the two existing-file changes.
- Project typecheck, production build, Biome, build/test gate, and generated Next.js HTML were not run: no full checkout or installed pnpm/Next toolchain, Node 22.16.0 below the project's >=22.22.1 requirement, and shell DNS lookup for GitHub/npm returned no addresses. No dependency or gate was changed to conceal this limitation.
- No browser audit, deployment, merge, or independent parallel-subagent review was performed. Source copies and compiler inspection stayed outside the repository; no test infrastructure or automation script was added.

### Standards

Sequential self-review of the source snapshot and these artifacts found no actionable source issue. The page remains server-authored, introduces no styling or runtime mechanism, and has no active unused image import. Keeping commented code is explicitly requested here. Planning and implementation stay on a separate branch with a single Ticket trailer per commit; existing tickets and rules are preserved. Missing project-toolchain checks and independent review remain open; this is not blanket standards compliance.

### Spec

Separate sequential self-review of the same snapshot found REQ-HOMELOGO-01 through 03 satisfied in source: the full heading is commented out reversibly, metadata is unchanged, no replacement content is introduced, and the README explains restoration. REQ-HOMELOGO-04 remains pending final PR traceability and required execution/review evidence. This change supersedes only the earlier visible-logo requirement, not SEO or shader behavior.

Publication is limited to a draft PR. Reassess completion after the existing project checks and independent review; no repeated scope approval is needed.
