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
