# WEB-BRAND-PLAN: Specify the website design and branding refresh

**Spec:** [SPEC-WEBSITE-BLACK-SEO v1](../specs/0020-SPEC-website-black-seo.spec.md)
**What to build:** Record the product requirement, architectural decision, website design contract, implementation specification, and delivery tickets before changing website identity assets.
**Blocked by:** None; owner direction and source assets are available.
**Status:** done
**Approval:** Owner request on October 13, 2026 authorizes this planning and the bounded implementation/PR described by the parent spec.

- [x] PRD-WEBSITE-DESIGN-BRANDING records outcome, scope, acceptance, and exclusions.
- [x] ADR-0002 records the decision to adapt the ClickHouse structural design language while replacing its yellow accent with black Exphere branding.
- [x] SPEC-WEBSITE-DESIGN-SYSTEM separates the website-specific design contract from the public shared token package.
- [x] SPEC-WEBSITE-BLACK-SEO defines the exact implementation manifest and verification plan.
- [x] Final PR traceability and published implementation evidence are recorded.

## Delivery evidence

- Planning/governance was committed first at `6a67e1d4aa90bb1525bb206d4d9d83acb958259f` with this ticket as the single `Ticket:` trailer.
- The bounded implementation followed at `1d841a550e44520a97d13eeb285bf399c0bc0897`.
- Pull request #14 targets `main` from `feat/website-black-seo-branding` and declares `Spec: SPEC-WEBSITE-BLACK-SEO`.
- The GitHub comparison at the reviewed implementation snapshot was two commits ahead, zero behind, with only the declared artifact and website-branding paths changed.
- Manual Standards and Spec reviews found no actionable finding. Repository CI run #19 completed successfully for that snapshot, but its paid independent agent review was explicitly skipped because `AGENT_REVIEW_ENABLED` was unset; zero provider requests were made and that artifact reports both axes as `not-verified`.

Planning therefore precedes implementation and its publication evidence is explicit without treating a skipped independent review as approval.
