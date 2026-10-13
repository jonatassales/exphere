# PR #19 completion: documentation entry, Go scaffold and skill ownership

- ID: `SPEC-PR19-COMPLETION`
- Document number: `SPEC-0028`
- Version: `1`
- State: `draft`
- Owner: Exphere project owner
- Authorization: the October 13, 2026 request to inspect PR #19 against the supplied original request, implement missing work, and align artifacts and PR delivery. Implementation is authorized; this document does not invent approval of an unreviewed revision.
- Inspected incoming PR head: `a572b5f91eebafdc35143f6329a6760e57397b17`.
- Base of the requested initiative: `d6b3c8abff240c54011f81f7088f445e3fbabef4` (`main`).
- Delivery: existing [PR #19](https://github.com/jonatassales/exphere/pull/19), targeting `main`; no merge, deployment or registry publication.

## Purpose and traceability

PR #19 combines one owner request spanning website, Go CLI, native tooling and skills. Its original artifacts split that delivery among four parent specs while the SDD contract expects one PR spec. This integration spec owns the PR and its five existing tickets. Stable ticket/spec IDs are retained. The focused specs remain detailed contracts included by reference; reparenting does not erase their requirements or rewrite historical commit evidence.

| Parent PRD and decision | Included focused contract | Integration ticket |
| --- | --- | --- |
| [PRD-EXPHERE-DOCS-WEBSITE](../prd/0006-PRD-exphere-documentation-site.prd.md), [ADR-0004](../design/0012-DD-documentation-architecture.dd.md) | [SPEC-WEB-DOCS](0024-SPEC-website-nextra-getting-started.spec.md) | [WEB-DOCS-01](../tickets/0046-TICKET-website-nextra-entry.ticket.md) |
| [PRD-GO-CLI-NATIVE-TOOLING](../prd/0007-PRD-go-cli-and-native-tooling.prd.md), [ADR-0003](../design/0011-DD-go-cli-native-tooling.dd.md) | [SPEC-GO-CLI-SCAFFOLD](0025-SPEC-go-cli-scaffold.spec.md) | [CLI-GO-01](../tickets/0047-TICKET-go-cli-scaffold.ticket.md) |
| Same Go/native tooling PRD and decision | [SPEC-NATIVE-TOOLING-NO-SCRIPTS](0026-SPEC-native-scripts-retirement.spec.md) | [TOOLS-NATIVE-01](../tickets/0048-TICKET-native-tooling-scripts-removal.ticket.md) |
| [PRD-SKILL-OWNERSHIP](../prd/0008-PRD-skills-ownership.prd.md), [ADR-0005](../design/0013-DD-skill-ownership.dd.md) | [SPEC-SKILL-OWNERSHIP-MIGRATION](0027-SPEC-skills-relocation.spec.md) | [SKILLS-OWN-01](../tickets/0049-TICKET-go-and-workflow-skills.ticket.md) |
| All included scope | This integration spec | [INTEGRATE-01](../tickets/0050-TICKET-integrated-review.ticket.md) |

The actual PR body must declare `Spec: SPEC-PR19-COMPLETION`. Each corrective commit uses exactly one existing ticket trailer matching its scope. Historical commits are assessed from their own trees; current links cannot retroactively establish associations missing at those revisions. The two-axis review must include the whole final changed scope and uncommitted additions.

## Owner requirement checklist

This table preserves the requested behavior independently of the implementation. Source completion and observed checks are recorded separately in the integration ticket; an unchecked row is not an accepted result.

| ID | Requested outcome | Contract / evidence owner |
| --- | --- | --- |
| REQ-01 | Replace header experimental tagline with `Documentation`. | DOCS-01 / WEB-DOCS-01 |
| REQ-02 | Published `orbo-voice` orb left of the logo, aligned size, black/gray shades, `listening` visual state. | DOCS-01; no microphone/provider integration |
| REQ-03 | Remove `.agents/adr/`. | SKILLS-03 |
| REQ-04 | Remove every tracked `scripts/` directory outside the CLI; use native framework/tool task entrypoints. | NO-SCRIPTS-01/02; CLI verification helpers are the explicit ownership exception |
| REQ-05 | Record PRD/architectural decision selecting a completely Go CLI, scaffold only now. | ADR-0003, GO-CLI-01 through 06; no retired Bash dispatch |
| REQ-06 | Install all 20 distinct requested Samber Go skills in `.agents/skills/`, with their support material and attribution. | SKILLS-01; duplicate golang-cli installs once |
| REQ-07 | Delete `writing-for-agents`. | SKILLS-03; its explicit deletion overrides inclusion in the AIHero catalog |
| REQ-08 | Put the full public AIHero catalog under `.exphere/workflow/skills/`. | SKILLS-02; 27 listed on October 13 minus the explicitly excluded skill = 26 installed |
| REQ-09 | Replace footer developer-experience tagline with accessible social icons following the supplied visual reference. | DOCS-05; use verified destinations |
| REQ-10 | Footer shows an orb followed by `exphere by Grupo OLX © 2026`. | DOCS-05; exact owner wording, no independent endorsement claim |
| REQ-11 | Remove the entire right-side card. | DOCS-02 |
| REQ-12 | Eyebrow becomes `DevEX / FinOps Platform`. | DOCS-02 |
| REQ-13 | Heading becomes `Exphere - Full blast agentic FinOps runtimes`. | DOCS-02 |
| REQ-14 | Remove `Early-stage tools and specifications, not a production automation service.` | DOCS-02 |
| REQ-15 | Description is `Exphere explores FinOps principles, agent-assisted software delivery, and consumer-composed microruntimes.` | DOCS-02 |
| REQ-16 | Remove `Hosted in the repository`. | DOCS-02 |
| REQ-17 | Center and slightly widen the remaining panel; a dark clipboard box copies exactly `npx exphere init`. | DOCS-02/03; accessible success/failure feedback; copying never executes |
| REQ-18 | This page is the first Nextra documentation entry; only Getting Started content is added. | DOCS-04; real Nextra layout/MDX routing, no invented runtime guide |
| REQ-19 | PRDs, DDs, specs, tickets, implementation, commits and PR against main align. | This contract, two-axis review and actual Git/PR evidence |

## Audit findings and bounded corrections

The incoming branch contained missing website dependency/lock updates, retained non-Go runtime sources, dead script references, incomplete native verification, stale current-state documentation and only 11 of the required 26 workflow skills. The Go skill inventory also lacked `golang-benchmark/references/benchstat.md`. Corrections complete the owner request rather than adding CLI functionality or a new product phase.

Preserve existing workflow adaptations and the source schemas/consumer fixtures that remain useful. Omit optional upstream helper shell templates outside the CLI and explain their unavailability in affected skills. Do not replace `writing-for-agents` elsewhere. Preserve pinned upstream MIT licenses. Source availability is not proof of automatic agent discovery.

## Build-enabling corrections included in this delivery

The website scope includes its native Turbopack build and public MDX provider alias, the website-only TypeScript 6.0.3 pin, and Nextra/Docs Theme-specific Zod 4.1.12 overrides in `pnpm-workspace.yaml` plus the synchronized lockfile. These repairs address actual compile/SSR failures without changing other workspaces' compiler or schema-library versions. See [SPEC-WEB-DOCS](0024-SPEC-website-nextra-getting-started.spec.md#native-nextra-build-and-asset-recovery).

The same authorized build exposed six malformed baseline image assets. Preserve their exact original bytes under existing `apps/website/public/brand/`, including the social alt sidecars. Recover the three active Apple/512px icons from existing black-brand revision `706d6dae3eb7a95f68738448ae28e36fefd291a3`; retain the existing valid SVG/PNG favicons. Corrupt ICO/social files no longer occupy Next.js metadata convention paths. The [identity record](../../../apps/website/IDENTITY.md) identifies every recovered/preserved asset and checksum. Legacy ICO-only clients and unpublished social image metadata remain explicit limitations; no logo redesign, indexing or origin decision is added.

Website verification reported successful production compilation/type checking, active image decoding, preserved-original byte comparisons and generated HTML review. The integration ticket owns final command results and review snapshot identity. These static/build observations do not establish website browser interactions or production acceptance.

## FinOps and Twelve-Factor scope

- FIN-01: Exphere repository CI is owned by the project owner. No cloud resource, billing account, paid model provider or telemetry service is added; no organizational cost center is inferred.
- FIN-02/03/06: proposed native GitHub CI has one Ubuntu job capped at 15 minutes and cancels superseded runs. These are execution limits, not a monetary budget. Billable minutes and account allowance are unknown; this specification does not authorize paid consumption beyond existing owner-authorized delivery or claim zero cost. No paid AI review request is configured. Hosted outcomes remain to be recorded.
- FIN-04/05: local checks and disposable fixtures have bounded ownership and cleanup; no persistent infrastructure is provisioned. CI runner sizing is its declared hosted runner, not evidence of capacity.
- FIN-07: no savings claim, baseline or unit-economics result is asserted; economic comparison is not applicable to this completion report.
- FIN-08: preserve real build/lint/test gates and record removed coverage; deleting script wrappers must not create false-green checks. The retired hosted agent provider is recorded as removed automation, while contributor review remains required.
- 12F-01/02/05: versioned source, owned dependencies, a synchronized frozen lockfile, native build/task boundaries and the declared Go version are the applicable criteria. Execute and record checks for the final source.
- 12F-03/04/11/12: no credentials, backing services or persistence are added. CLI output and side-effect-free unsupported commands remain explicit. Hooks/CI do not grant production permissions.
- 12F-06 through 10: no new deployed service, scaling, disposability or availability guarantee is introduced. Existing website runtime assumptions remain; this change does not claim production verification.

## Verification and acceptance record

Use the integration ticket for command results, exact reviewed snapshot, separate Standards/Spec findings and resolutions, and the actual PR declaration/check results. A clean build does not establish browser accessibility or organizational acceptance. Missing evidence remains `not-verified`; do not mark tickets `done` or present the PR as ready solely from this document.
