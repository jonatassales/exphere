# Standalone CLI refactor hardening

- ID: `SPEC-STANDALONE-CLI-HARDENING`
- Version: `2`
- State: `implemented`
- Owner: project owner for scope; implementation and review agents for local delivery.
- Authorization: the owner requested improving the reviewed refactor on October 16, 2026. On October 17, 2026, the owner explicitly requested replacing `packages/ex` in the Exphere workspace with the updated CLI, then requested a PR for that replacement. This revision records integration and PR delivery to the workspace's configured `jonatassales/exphere` repository. The earlier separate `exphere/ex` publication was stopped and is superseded by this destination.

## Scope and baseline

Replace the existing Go implementation in `packages/ex` with the reviewed
standalone refactor. Retain the workspace package manifest, executable bridges,
build/setup helpers, and existing contract fixtures and schemas so the SDK and
workspace commands keep their current integration. The comparison baseline is
Exphere commit `7591d39d8204cbe3f1fcffd86da56b761151788b`, `packages/ex`.
The original standalone source snapshot is SHA-256
`4ebfc2d419644924b6b838b72d11caed9fff045d1cc351b79c122c4ae54ccf65`,
computed from sorted relative paths, NUL, file bytes, and NUL for every file.

## Required behavior

1. Preserve the refactor's domain/application/infrastructure/presentation separation,
   explicit composition, and narrow consumer-owned interfaces. Put private code
   under `src/internal` and the process entry under `src/cmd/ex`.
2. Restore `runtime logs`, `runtime forward`, and `runtime hook` with the baseline
   flags, output, ownership checks, project locking, cancellation, and bounded
   execution. Hooks remain explicitly invoked trusted scripts.
3. Restore `version`, `--version`, `-V`, JSON version output, invalid-help errors,
   and agent scaffold instructions. Help and version need no project or tools.
4. Read original cluster/execution records without silently discarding evidence.
   Retain the original configuration fingerprint and inspectable wire fields.
   Recognize the reviewed standalone draft's known format and recomputed exact
   fingerprint without bypassing target or ownership checks. Unknown or
   contradictory records must not grant destructive authority.
5. Keep startup state transitions with the domain and prevent incomplete
   ownership bookkeeping from reporting successful startup.
6. Retain and adapt the existing command tests. Add standalone and workspace build/use guidance
   and record the exact checks, reviews, and remaining verification limits.

## Verification and limits

Adapt existing tests only; add no new suites or scenarios. Run formatting,
compilation, static checks, and the existing command cases. Review Standards and
Spec against the same identified final snapshot, resolve actionable findings,
and refresh affected reviews after material changes.

No live Docker/kind/Terraform/Kubernetes/agent execution, personal shell changes,
dependency upgrades, SDK expansion, cloud operations, model calls, or paid
services are included. Existing native tools, consumer-built images, private
project targets, and source/evidence ownership remain unchanged.

FIN-01/05 applies to ownership and scoped cleanup; this change authorizes no paid
execution or savings claim. 12F-01/02/03/05/09/11/12 applies to source identity,
dependencies, explicit configuration, build/run separation, cancellation,
diagnostics, and administrative operations. Source review and local checks are
not operational compliance or production readiness evidence.

## Delivery

Tracked by [EX-STANDALONE-01](../tickets/0074-TICKET-standalone-cli-hardening.ticket.md).
Publish on a feature branch from `main` using normal pushes, the configured
commit identity, one ticket trailer per commit, and this spec ID in the PR body.

## Integration review

The unchanged Go source retains the prior Standards and Spec reviews of snapshot
`c5dddf779519d3edf6da4c8b7c873e27c1a889c918cb2bf146cc61cab774139b`.
The owner stopped all subagents before requesting this integration; they remain
stopped. The lead reviews the package integration against both axes, without
claiming a fresh independent review. Local verification is recorded in the ticket.
