# Consumer harness contracts — source verification v1

Implements the pre-generation contract/reference surface of CHL-01 through CHL-08. CHL-09 has a versioned candidate and an explicit incomplete independent-review gate; the generator is not released by these files. The current `ex` command, runtime v2 schema, legacy compatibility, package manifest and existing tests are unchanged.

## Run from a source checkout

```sh
sh packages/cli/scripts/verify-consumer-harness.sh \
  --root packages/cli/fixtures/consumer-harness

sh packages/cli/scripts/verify-consumer-harness.sh \
  --root packages/cli/fixtures/consumer-harness \
  --scenario packages/cli/fixtures/consumer-harness-scenarios/resumed-cycle

sh packages/cli/scripts/test-consumer-harness.sh
```

The verifier consumes explicit roots. It does not discover another checkout, download dependencies, source consumer data, run hooks, invoke configured MCP tools or call a provider. Only the existing public runtime `validate` operation is used for native descriptor/reference compatibility. A successful result explicitly returns `executionReady: false` and `financialEnforcement: false`. `--require-ready` returns status 3 because the required engines/handlers are unavailable. It cannot turn the fixture into an executing installation.

The test suite additionally invokes existing manual/guided/legacy initialization in owned temporary consumers and checks Git ignore behavior in a disposable Git repository. Nothing changes a real user shell profile. Tests of invalid data intentionally replace files only in these disposable consumers.

Dependencies are explicit: POSIX `sh`, jq 1.7 or newer, standard Unix file/text tools, and either `sha256sum` or `shasum`. Tests also require Git and `mkfifo`. Linux is the observed platform. POSIX-style source and SHA utility fallback are not evidence of macOS execution. No Node, Python, Go module, database or new runtime service is required by this verifier. Existing package tools remain separate.

## Contracts and ownership

| Contract | Producer | Consumer | Authority |
| --- | --- | --- | --- |
| harness-config | Consumer/reference author | Contract verifier; future orchestrator | Selected configuration, not execution approval |
| harness-lock | Reference author; future explicit installer | Integrity verifier; future updater | Reference inventory only, not a skill lock restoration |
| harness-workflow | Selected workflow author | Verifier; future graph adapter | Common SDD transitions, never executable by declaration |
| harness-agent / harness-sensors | Configuration author | Verifier; future executor | Scoped bindings; all handlers unavailable in v1 |
| cycle-context | Future executor; synthetic fixture author here | Verifier; planner | Revision/source snapshot, not editable policy |
| execution-plan | Future planner; fixture author here | Verifier; future admission | Proposal, not a financial grant |
| accounting-event | Future controlled writer; fixture author here | Synthetic replay verifier | Audit/export shape, not a transactional database |
| cycle-event | Future executor; fixture author here | Receipt renderer | Observations and unresolved obligations |
| harness-scenario | Fixture author | Source-only test verifier | Explicitly synthetic reference manifest |

Every schema declares a version, rejects extra fields and is independently versioned from the unchanged microruntime v2 descriptor. Authored intent keeps typed Markdown identities in the consumer's authored collections. Machine accounting/cycle data has separate producers and retention; no such data is created in the fresh fixture and no change is made to the repository's DD-0006 or historical evidence paths.

## Validator selection and supported semantics

The selected validator is a package-owned, bounded jq interpreter (`schema.sh`, v1), not a new package dependency and not a general JSON Schema implementation. This keeps the existing shell/jq toolchain and avoids an installation side effect. Schemas are standard Draft 2020-12 documents; the helper executes only the vocabulary actually used or explicitly supported below, rejects unknown assertions, and never resolves remote schema references.

Supported keywords: `$schema`, `$id`, `$comment`, `title`, `description`, `$defs`, local `$ref`, `type`, `const`, `enum`, `required`, `properties`, `additionalProperties`, `propertyNames`, `minProperties`, `maxProperties`, `items`, `minItems`, `maxItems`, `uniqueItems`, `minLength`, `maxLength`, `pattern`, `minimum`, `maximum`, `allOf`, `anyOf`, `oneOf`, and `not`. Only bundled, trusted schemas are used by the consumer-root entry point. The private helper is not an extension mechanism for arbitrary recursive schemas. Regex assertions use jq's engine; bundled patterns are deliberately restricted and cross-checked, not a promise of arbitrary ECMAScript regex compatibility.

Structural validation rejects duplicate JSON keys before normal object parsing, including duplicate containers with different children. Input limits are one JSON object, 1 MiB per input, depth 32 and 20,000 streaming events. JSONL files are limited to 1,000 single-line events. Blank or multiline records are invalid. The reference is limited to 512 files.

Semantic validation additionally checks identity uniqueness, the funding-window → feature → cycle hierarchy, revisions, profile/effort capabilities, protected balances, source scope, installed dependency closure, hashes and native runtime paths. Unknown model prices may be represented by omission in configuration; hypothetical dispatch then rejects them, rather than converting missing data into zero. Unavailable execution handlers are a separate readiness result from structurally valid configuration.

New file references resolve from the explicit consumer root; scenario references resolve from their separately explicit scenario root. Existing runtime component/native path bases are preserved. The source-only reference uses a stricter no-symlink rule, including in-root links; it does not change the public CLI's compatibility contract. Paths reject absolute names, dot/parent traversal, backslashes and control characters. A closed inventory covers every fresh-reference file except the editable config and the inventory itself. SHA-256 hashes detect modification, not author authenticity. Required local Markdown links use the bounded inline-link form demonstrated by the selected skill; network links are attribution only and are not fetched.

The verifier rereads observed file hashes before returning. This detects ordinary changes during verification but is not a secure filesystem sandbox against a hostile concurrent writer racing checks and opens. Use a trusted immutable snapshot or an isolated copy for review. Live concurrency, authenticated approval, provider security and operational admission are later executor responsibilities.

## Exact monetary representation and scope

Amounts and prices are nonnegative base-10 integer strings in microcurrency units: `"1"` is 0.000001 of the declared currency. Each value is at most 12 digits. The bounded replay has at most 1,000 events, keeping aggregate integer arithmetic below 2^53. Token price products are checked before multiplication; each term is limited to 4 × 10^15 and the sum to 8 × 10^15. Exceeding the bound rejects a hypothetical request rather than relying on rounded arithmetic.

No decimal-to-microcurrency adapter is implemented. A later governed price/usage adapter must round a positive upper-bound reservation upward to the next micro-unit and observed fractional amounts half-up to the nearest micro-unit, retaining its raw source and any reconciliation residue. For example, a reservation of 0.0000001 currency requires 1 micro-unit; an observed 0.0000005 rounds to 1 micro-unit. The verifier accepts only already represented integers, not floats, scientific notation or unqualified display credits. No foreign exchange conversion or alternate valuation of the same cost is added.

AI, infrastructure and combined caps have independent checks at every ancestor account. Ordinary proposed work includes consumed observations, outstanding reservations and still-protected verification/cleanup allowance. Protected requests draw against their protected allocation without counting it twice. Planning has a pre-existing profile and allowance, including paid retrieval/embedding and other planning overhead when applicable. In this bounded export model those bootstrap costs use the `planning` purpose; later adapters must normalize all covered overhead there rather than omit it.

The replay accepts historical overages truthfully. `metered` replaces the reservation with observed usage; `reconciled` replaces that observation with the same attempt's invoice-reconciled valuation. Neither adds both valuations. Pending charges retain the reservation; only explicit confirmed-no-charge evidence releases one. Identical duplicate event IDs do not count twice; conflicting duplicates and changed attempt attribution fail. Metered usage is still pending invoice reconciliation. Creating a different graph thread or cycle does not clear the shared account's prior observations.

The fixed timestamp is synthetic fixture data, not current authorization. The context must fall within its declared synthetic funding window. Source hashes and exact revisions are verified. `maxAgeSeconds` declares the future retrieval freshness policy; the fixture contains no live retrieval timestamp and cannot prove time-based freshness or retrieval relevance. Required runtime context and source scope remain explicit.

Hardware is an allocation estimate with horizon, rates, lifetime, inspection cadence, residual storage/network coverage and shutdown ownership. Paused/resumed observations retain every recorded unresolved resource obligation. This format does not implement resource termination or a resolved-resource event. A request for a hard infrastructure cap is rejected because that coverage is unavailable; pausing a graph cannot establish zero continuing costs.

## Observed output and exit behavior

Stdout is the JSON result; stderr contains diagnostics. Exit 0 means the reference and, when selected, its synthetic expected interpretation are valid. It is not execution approval. Exit 1 means a contract, integrity, relationship or expected-result failure. Exit 2 indicates an invocation/dependency/root error. Exit 3 is the explicit unavailable-readiness result. HUP/INT/TERM use 129/130/143 and clean only the verifier's owned temporary directory.

Scenarios contain independent literal expected JSON and checked-in receipts. The verifier recomputes interpretation and receipt text, compares both, and never writes the oracle. Declared failed/inconclusive observations remain visible. Receipts do not claim savings, acceptance, actual invoices or completed cleanup.

## Source, package and future generator boundary

The current package manifest includes only `cli`. Formal schemas are in that existing distribution subtree. Manual references, synthetic histories and source verification helpers stay outside it. Git ignores are checked separately from the package allowlist. A legitimate `.terraform.lock.hcl` remains authored provider dependency data, not an ignored Terraform state file.

The selected `review-plan` skill is new project-authored fixture content, not a renamed or unlicensed copy of an upstream skill. No third-party skill source is redistributed here. Its supporting file, templates and guide dependencies are inventoried. This minimal selection demonstrates closure without claiming installation of every maintainer Pocock skill. Future selection of an upstream skill must preserve its source revision, supporting assets, attribution and required license material before claiming distribution readiness.

A future generator must specify an explicit setup command, selective assets, collision/no-overwrite handling, partial-publication recovery, user modification detection, upgrades, and packed-package consumer checks. This initiative implements none of those commands. A future executor must separately implement LangGraph, MCP, RAG, model adapters, transactional accounting and covered financial enforcement. Their P0 priority is unchanged.
