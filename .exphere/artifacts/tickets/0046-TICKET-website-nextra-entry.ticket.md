# WEB-DOCS-01: Convert the homepage into the first Nextra docs entry

**Spec:** [SPEC-PR19-COMPLETION v1](../specs/0028-SPEC-pr19-completion.spec.md)
**Focused contract:** [SPEC-WEB-DOCS v1](../specs/0024-SPEC-website-nextra-getting-started.spec.md)
**Status:** in-review
**Approval:** Owner's October 13, 2026 request explicitly authorizes implementation, commit and PR.
**Blocked by:** None; the current App Router hero and dark motion are on main.

**What to build:** A centered one-card Exphere documentation entry with exact new wording, Nextra Getting Started `/docs`, grayscale listening Orbo, accessible copy command and verified footer icon links.

- [x] Header says Documentation and a small grayscale `<orb-o>` sits to the left of the Exphere mark, `listening` visual state only.
- [x] Single wide centered hero uses exact copy, with right card and obsolete text removed.
- [x] Copy control provides `npx exphere init` with success/error feedback, without executing or asserting publication.
- [x] Nextra Docs Theme renders one Getting Started page under `/docs`; home remains initial entry.
- [x] Footer displays small orb, `exphere by Grupo OLX © 2026` and verified accessible social icon links.
- [x] Existing ExphereShader behavior, noindex policy and black logo identity are preserved. Corrupt baseline assets are retained in public/brand; active icons are recovered as documented in IDENTITY.md. Legacy ICO and unapproved social-image conventions are inactive.
- [x] Dependencies/lockfile and authorized build/static checks are recorded honestly; browser clipboard, visual and motion behavior remain explicitly not verified.

## Website-only corrective cycle — October 13, 2026

The owner rejected the rendered result and authorized rollback followed by a
website-only correction. The preceding source/build evidence did not establish
rendered correctness: browser reproduction showed reset styles overriding the
website utilities. The production domain was restored to the preceding READY
deployment `dpl_9yCnQQJH5FAmUHw3XVeiPjnTSMbc` (`d6b3c8a`). Repository changes
to skills, CLI and tooling are outside this follow-up.

- Application CSS now loads first and establishes canonical Tailwind layer
  ordering before the shared shader imports. The shader implementation is unchanged.
- Native Nextra metadata hides the landing page from the docs sidebar and leaves
  Getting Started as the single section, without redundant breadcrumb/TOC text.
- The hero displays the requested command box and accessible copy feedback; the
  unrequested implementation note is removed. README retains the actual CLI limit.
- Production compilation, website type checking and scoped Biome passed.
- Chromium inspected the built website at widths 1440, 768, 390 and 360px. No
  horizontal page overflow occurred; the heading measured 72px on desktop and
  36px on mobile, and declared page padding applied at each breakpoint.
- Clipboard success copied exactly `npx exphere init`; a denied-write simulation
  exercised visible failure feedback. Home-to-docs-to-home navigation passed.
- Both native orbs registered, retained listening/system attributes and had
  nonzero display sizes. Reduced-motion emulation exposed the system preference;
  this verifies configuration, not pixel-level animation timing. No uncaught
  page errors occurred. Desktop/mobile screenshots were inspected.
- Local evidence remains in the ignored `.audits/evidence/runs/website-pr19-correction/`
  directory. No permanent application test runner or unrelated tests were added.

This record supersedes the earlier static-only verification boundary for the
authorized corrective cycle. Independent reviews and the corrective PR record
the final source snapshot and publication state. Production remains on the
rollback deployment until the corrected result is accepted for release.

## Corrective review snapshot

Base: `e969af6892a7d355f806d9b458eb134b7925d912`. Both independent reviewers
inspected the same eight-file staged tree
`a21e48a981decdd81f1a53455d6202e6045de369`, including browser evidence and
screenshots. This outcome append is evidence-only and follows that review.

### Standards

Pass: **0 findings**. Bootstrap cascade ordering is allowed by the styling rule,
shared shader ownership is preserved, native Nextra metadata owns navigation, and
copy feedback remains accessible. No actionable baseline code smells identified.

### Spec

Pass: **0 findings**. CSS ordering, the sole Getting Started navigation entry,
requested command-only presentation and the scoped browser evidence satisfy the
corrective amendment. No missing, incorrect or out-of-scope change identified.

Review summary: Standards 0; Spec 0. These reviews do not establish production
release acceptance or measured animation timing.
