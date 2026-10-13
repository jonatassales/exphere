# CHL-09 — Candidate reference and incomplete acceptance gate

- Reference version: `1.0.0`; all new schema format versions: `1`.
- Source baseline: `jonatassales/exphere`, `2865485fece84a39b49d2d28268f692b538bd283`.
- Observation date: October 12, 2026.
- Candidate source-manifest SHA-256: `07cd6d9a7d65633056ae32e06d2d7deecc44ccff482f7b4c955a592f7986a98f`.
- Manifest definition: sorted `SHA256  repository-relative-path` lines for the new CLI-package schemas, fixtures, verifier, tests and their source-contract README; this handoff file and ticket review records are excluded to avoid self-reference. The delivery bundle includes this exact manifest plus a complete changed-file manifest.
- Disposition: implementation candidate, **not accepted for generator development**. Independent parallel Standards/Spec review remains unavailable. No gate bypass, code commit, push or remote PR is claimed.

## Implemented slices

| Ticket | Implemented result | Observed evidence |
| --- | --- | --- |
| CHL-01 | Versioned config and integrity inventory; bounded offline structural/semantic validation | Valid reference; unsupported formats, duplicate fields/IDs, missing sources and integrity changes rejected |
| CHL-02 | Ten common SDD stages; selected skill, supporting criteria, templates, guides and sensor bindings | Dependency removal and transition/scope corruption fail; unavailable handlers return readiness status 3 |
| CHL-03 | Scoped retrieval contract, two synthetic model/effort profiles and bootstrap allowance | Unsupported effort, missing prices/context, cross-repository sources, unfunded planning and excluded content rejected |
| CHL-04 | Cycle/context/plan/event/accounting schemas; synthetic interpretation with exact integer units | Reservations, reconciliation, duplicates, pending charges, overage, parent caps and protected allowance verified |
| CHL-05 | Manually authored website runtime with native Terraform/Kubernetes configuration | Existing public runtime v2 validation passes; no app source duplication or provider execution |
| CHL-06 | Ten separate simulated histories with literal expected results and deterministic receipts | Accepted/rejected, missing-context, paused/resumed, duplicate, pending, overage and protected-verification examples match their oracles |
| CHL-07 | Closed asset/provenance inventory and explicit creation/retention rules | Portability, required supporting files, no unselected placeholders, Git ignore and package boundary checked |
| CHL-08 | Configuration-only public CLI regressions and non-mutation/cancellation checks | Existing manual/guided/legacy behavior, collision refusal, descriptor errors, native preservation and coordinated TERM verified |
| CHL-09 | Versioned candidate, cross-slice evidence and precise incomplete-gate handoff | Technical checks pass locally; independent review and final acceptance remain inconclusive |

## VER-CHV coverage

| Criterion | Owner | Executed surface | Result and limitation |
| --- | --- | --- | --- |
| VER-CHV-001 — valid reference | CHL-01/05 | Explicit-root verifier and existing `ex runtime ... validate` | Passed; contract/reference validity only |
| VER-CHV-002 — fields/versions | CHL-01/08 | Schema and public CLI negative cases | Passed; v2 schema and commands unchanged |
| VER-CHV-003 — IDs/paths | CHL-01/08 | Duplicate keys/IDs, containment, missing files and symlink cases | Passed; source-only verifier conservatively rejects all symlinks |
| VER-CHV-004 — dependency closure | CHL-02/07 | Remove selected skill support/template and corrupt transitions | Passed; no fallback to maintainer files |
| VER-CHV-005 — optional capabilities | CHL-02/05 | Inspect absent hooks/diagnostician and present selected files | Passed; missing executable handlers remain unavailable |
| VER-CHV-006 — pricing/currency/effort | CHL-03/04 | Literal rejection scenarios and invalid plan/config cases | Passed; synthetic catalog, no live provider prices |
| VER-CHV-007 — paid planning allowance | CHL-03 | Zero-bootstrap allowance and valid funded planning fixture | Passed; hypothetical admission only |
| VER-CHV-008 — duplicate/timeout/resume | CHL-04/06 | Synthetic replay and conflicting/no-charge negatives | Passed; no concurrency or transactional durability proof |
| VER-CHV-009 — remaining infrastructure | CHL-04/06 | Paused and resumed scenario receipts | Passed; retained obligations, no actual shutdown |
| VER-CHV-010 — fresh setup | CHL-06/07 | Reference inventory versus separate scenario roots | Passed; no fabricated installed history |
| VER-CHV-011 — repeat/non-mutation | CHL-01/08 | Repeated output, whole-file checksums, failure and coordinated TERM | Passed in isolated Linux consumers |
| VER-CHV-012 — v1/v2 compatibility | CHL-05/08 | Existing public manual/guided/legacy/list validation seam | Passed for exercised operations; not the entire prior CLI test suite |
| VER-CHV-013 — source/package boundary | CHL-02/07 | Inventory, Git ignore tests, unchanged package allowlist, isolated npm dry run | Passed for the inspected subset and changes; not a complete release-package certification |

## Verification record

The command `sh packages/cli/scripts/test-consumer-harness.sh` completed with exit 0 and **80 contract checks passed**. The bundle contains the full final log and exit status. Deliberately invalid cases fail the verifier and pass their rejection assertions. Earlier red/failing runs were development iterations, not acceptance evidence.

All delivered shell files pass `sh -n`. The ten schema documents pass independent Draft 2020-12 meta-schema checks. Thirty-five single-record fixtures plus every JSONL event validate against the independent validator. Forty-nine additional structural valid/invalid comparisons agreed with the bounded jq helper. That cross-check used the container's already installed Python jsonschema solely as an independent development check; Python is not shipped or required by Exphere.

Observed environment: Linux x86_64, jq 1.7, Git, POSIX sh; npm 10.9.2 / Node 22.16.0 were used only for an isolated offline `npm pack --ignore-scripts --dry-run --json` boundary inspection. Node is below the root repository's stated 22.22.1 prerequisite and pnpm is unavailable here. No repository-wide build/typecheck/test or Husky hook was run. ShellCheck and macOS execution remain unverified. This does not block the source-only shell checks but prevents a broader build/portability claim.

Network cloning was unavailable. The working snapshot contains the exact fetched CLI implementation files required by the tested configuration seam, verified against their Git blob identities, plus these changes; it is not a complete repository checkout. The dry run therefore checks the selected changes and `files: ["cli"]` boundary, not completeness of the original package. Unchanged baseline files are excluded from the delivery overlay.

## Review and policies

### Standards — authoring-agent review

Inspected en-US content, shell/jq boundaries, temporary-file ownership, explicit root/argument handling, conservative path rejection, source-only assets and preservation of native/runtime authorities. Corrected the one-character-path assertion, newline-root handling and price-product arithmetic bounds. No consumer input is evaluated as shell. Input hashes and the closed inventory detect ordinary mutation; concurrent-hostile-writer sandboxing remains outside this local fixture contract.

This is self-review, **not an independent reviewer**. The harness-required parallel Standards reviewer has not run.

### Spec — authoring-agent review

Inspected coverage of the nine slices and all thirteen matrix cases against the same candidate. Verified distinct intent/configuration, graph state, ticket/runtime states, simulated financial observations and incomplete operational capabilities. Added a negative check for contradictory financial snapshots. No generator, RAG engine, graph executor, model dispatch, database or hardware controller was introduced. The fresh reference contains no execution history.

This is self-review, **not an independent reviewer**. The harness-required parallel Spec reviewer has not run.

FIN-01–08 are represented as bounded design criteria: explicit synthetic ownership, estimates/coverage, caps, resource assumptions, cleanup obligations, observations, no savings claims and required quality checks. There is no claim of operational FinOps compliance or live budget enforcement. Twelve-Factor 12F-01/02/03/04/05/06/09/10/11/12 are assessed only for source identity, explicit dependencies/configuration, future-store references, packaging separation, scoped temporaries, cancellation and stdout/stderr behavior. Actual service capacity/network/parity outcomes are not assessed. No service was deployed.

SDD traceability remains attached to the existing stable tickets and parent specs. Publication and `done` states are withheld because mandatory independent review evidence is missing. Local implementation authorization does not repair the older planning review record, and no global exception or automatic approval engine is created.

## Resume condition and later work

Have independent Standards and Spec reviewers examine this exact candidate manifest and the governing specs. Resolve findings, refresh changed hashes and rerun affected checks. Before a code push, run the repository's required build/test checks in a complete checkout with the pinned supported toolchain. Then record actual approval/publication authority and follow the one-ticket commit / one-spec PR rules; no force push.

Only after that gate may a separate generator initiative implement explicit setup, no-overwrite behavior, partial-publication recovery, modification detection, upgrades and packed-package consumers. The source reference and formal contracts are its candidate target, not a generator already delivered. LangGraph + MCP + RAG, live routing quality, transactional accounting, hard-cap charge coverage and actual cleanup stay separate P0 execution work.
