# REFRESH-03: Build readable documentation with working search

**Spec:** [SPEC-WEBSITE-DOCS-REFRESH v1](../specs/0031-SPEC-website-docs-refresh.spec.md)
**What to build:** Build readable documentation with working search, satisfying REFRESH-04, REFRESH-05, REFRESH-06 in the approved parent spec.
**Blocked by:** REFRESH-01.
**Status:** in-review
**Approval:** Owner approved the plan and explicitly authorized implementation and PR delivery in this conversation on October 13, 2026. These artifacts were drafted from that decision and advanced to execution; no new approval is inferred from their creation.

- [x] Implement the assigned parent requirements.
- [x] Complete applicable VER-REFRESH-01 checks.
- [x] Resolve independent Standards and Spec findings against the identified snapshot.

## Evidence

Applicable local formatting, type checking, production build, reference and browser checks passed; see VER-REFRESH-01 in the parent spec. Initial Spec review found no source defects. Standards identified one historical reference-wording defect, now corrected; both refreshed review axes passed with zero remaining findings against manifest `1bd79e53144763767e95e4d946500bac2d74e999740c33a328a662d262152269`. PR publication is the remaining delivery step.


## Deployment correction

The owner's deployment failure report extends this ticket with REFRESH-09 in the parent spec. The deployment ignore filter excluded the two architecture diagrams even though local/CI compilation passed. Include only those assets in the deployment input and verify a disposable filtered build. Filtered baseline reproduced both missing-module errors; the corrected fixture build passed and emitted both original PNGs plus the five-page search index. Only the two required images are newly included. Independent Standards and Spec reviews passed with zero remaining findings against manifest `caab755d49c6eba4d5bd7cc685802be7498fcf7c63e56a7cf3d9bb244aa6ca84`; the evidence-retention finding is resolved. Only review-closure records changed after that snapshot. Follow-up PR delivery remains pending; production recovery requires a corrected deployment.
