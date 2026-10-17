# Go CLI flat package layout

- ID: `SPEC-EX-FLAT-LAYOUT`
- Version: `1`
- State: `draft`
- Owner: project owner for scope; implementation agents for local delivery.
- Authorization: on October 17, 2026, the owner requested that `packages/ex`
  keep its layers directly under `src/` without the `cmd` and `internal`
  levels, remove `bin/`, `cli/`, `fixtures/`, and `scripts/`, keep only
  `build.sh` at the package root, and open a pull request. This supersedes the
  October 13 decision that authorized the package `.sh` bridge and the
  `ex-shell-setup` command, and retires the retained consumer-harness source
  contracts.

## Scope and baseline

The baseline is Exphere `main` at
`a33f562c2a04d33c6ba347eb3660b466262f3de0`. `packages/ex` keeps its Go source
under `src/cmd/ex` and `src/internal/{presentation,application,domain,infrastructure}`,
an npm bin bridge in `bin/ex.sh`, historical schemas in `cli/schemas`,
consumer-harness fixtures and their shell verifier under `fixtures/` and
`scripts/`, the shell-profile helper `scripts/setup-shell.sh`, and the
postinstall builder `scripts/build.sh`.

## Required behavior

1. `src/` holds `presentation/`, `application/`, `domain/`, and
   `infrastructure/` directly. The process entry point and its composition
   root move from `src/cmd/ex` to package `main` in `src/`. Package contents,
   names, and behavior are unchanged; only import paths change.
2. Without `internal/`, the Go compiler no longer prevents other modules from
   importing these packages. The module stays private and unpublished, and
   the documentation states that the layer boundary is a convention.
3. `bin/`, `cli/`, `fixtures/`, and `scripts/` are removed. `build.sh` moves to
   the package root, keeps its behavior, and builds `./src`.
4. The `@exphere/ex` manifest builds `./src`, runs `sh build.sh` on install,
   publishes only the source, module files, `build.sh`, and README, and
   declares no bin, because a bin must exist before the install-time build.
   The `test:contracts` task is removed from the package, the root test
   script, and Turbo, and Biome's fixture override is removed.
5. `@exphere/sdk` keeps its `ex` bin. Its bridge executes the CLI package's
   built `dist/ex` directly and reports how to build it when absent. Its
   `ex-shell-setup` bin is removed with the helper it forwarded to.
6. The CLI README, root README, website documentation, and root agent
   instructions describe the new layout, the direct `ex` invocation, and the
   removed shell setup and contract checks.

## Verification and limits

Run formatting, `go vet`, `go test -count=1 ./...`, and a build through the
moved `build.sh`, then exercise only help and version through the built
executable and the SDK bridge. Record any check that cannot run.

No Docker, kind, Terraform, kubectl, Kubernetes, or agent application runs;
no personal shell profile changes; no dependency or lockfile changes. Live
behavior remains unverified as before.

12F-02: dependency declarations stay unchanged. 12F-05: build stays separate
from run; installation still only builds with an existing Go toolchain.
FIN-02/03: no paid resource or AI consumption is introduced.

## Delivery

Tracked by [EX-LAYOUT-01](../tickets/0081-TICKET-ex-flat-layout.ticket.md).
Publish on a feature branch from `main` using normal pushes, the configured
commit identity, one ticket trailer per commit, and this spec ID in the PR body.
