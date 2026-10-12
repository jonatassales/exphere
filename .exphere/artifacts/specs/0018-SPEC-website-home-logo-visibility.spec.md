# Temporarily comment out the website home logo

- ID: `SPEC-WEBSITE-HOME-LOGO-VISIBILITY`
- Document number: `SPEC-0018`
- Version: `1`
- State: `approved for scoped implementation; verification pending`
- PRD: [PRD-0001 v1](../prd/0001-PRD-exphere.prd.md); broad product approval remains unrecorded. This correction follows the owner's direct request.
- Technical owners: project owner for the visibility decision; implementing agent for the bounded change and evidence.
- Authorization: on October 12, 2026, the owner requested commenting out the logo on the website home page and creating a PR. The existing scoped autonomous-delivery authorization remains valid. This covers this specification v1, its single ticket, local source checks, commits, and a separate PR; not merge, deployment, new dependencies, or production access.
- Baseline: main `8ec2e5175c74711bd2a210fd92e59fde24f1da9b`.
- Ticket: [WEB-ID-02](../tickets/0040-TICKET-comment-home-logo.ticket.md).

## Contract and composition

The owner wants the home logo disabled in source without deleting the artwork or changing the SEO foundation. Retain the current logo and its complete heading wrapper inside a JSX comment. Comment out its now-unused image import. Keep the existing main container; do not replace the logo with text or leave an empty rendered heading.

This instruction supersedes only the visible-home-logo requirement of [SPEC-WEBSITE-IDENTITY-SEO v1](0017-SPEC-website-identity-seo.spec.md). Preserve that historical specification, its tickets, all assets, metadata, document layout, shader, and indexing decisions.

| Requirement | Acceptance criterion |
| --- | --- |
| REQ-HOMELOGO-01 | The home logo and its heading are commented out, not removed from the source; no active image import, empty heading, or replacement content remains. |
| REQ-HOMELOGO-02 | Page metadata is byte-for-byte unchanged. Root layout, shader, SVG, favicons, Apple/application icons, manifest, robots, and social files are outside the diff. |
| REQ-HOMELOGO-03 | Website documentation describes the disabled logo and how to restore it. Existing specs and tickets are not edited. |
| REQ-HOMELOGO-04 | A feature-branch PR records the source revision, Ticket/Spec associations, scoped review, checks, and limitations without claiming unexecuted checks passed. |

Selected components and executor remain the existing Next.js/pnpm workspace. There are no new interfaces, extension points, services, dependencies, environment variables, secrets, or data stores. Allowed changes are the home page, its README, this specification, and its new ticket.

## Responsibilities

- Consumer: authorizes hiding the logo and any later restoration.
- Platform: preserves existing framework, metadata, asset, and review boundaries.
- Service owners: no production service or deployment decision is changed.

## Operation and limits

The existing page remains server-authored and keeps its main container inside the unchanged shader layout. No new client code, runtime switch, CSS hiding rule, loading behavior, or resource is introduced. Restore the logo by uncommenting the existing import and complete heading block together. Existing command failures remain failures. Logs and source hashes are verification evidence, not production telemetry.

## Verification and decisions

- Decision: comment out the entire heading rather than only its image, avoiding an empty rendered heading. Preserve the exact image props and source artwork for reversal.
- Affected guardrails: SDD v1 for source review, commit trailers, and PR scope; existing frontend and test-ownership rules for verification. Dependency, configuration, build/run, and resource contracts are unchanged; no new FinOps or Twelve-Factor compliance claim is made.
- Verification plan: use the existing application boundary. Compare the page metadata and preserved JSX with the baseline; check TSX syntax and emitted code where tooling is available. Run the existing website typecheck, production build, Biome check, and authorized build/test gate when the project's toolchain is available. No new test framework or browser/production audit is added.
- Review: perform separate Standards and Spec assessments against the same source snapshot; record unavailable independent review explicitly. Missing required build/review evidence keeps the ticket in review and the PR draft.
- Cost/consumption: local inspection and authorized GitHub publication only; no paid service, provisioned resource, or cost measurement.
- Out of scope: restoring or completing the earlier SEO launch, changing assets or metadata, adding content or accessibility substitutes, redesign, package changes, merge, deployment, and unrelated ticket edits.
- Planned evidence location: the linked ticket. Planning-source self-review found the requested visibility change bounded and reversible; implementation evidence remains pending. Independent review is not asserted.
