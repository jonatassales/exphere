# EX-LAYOUT-01: Flatten the Go CLI package layout

**Spec:** [SPEC-EX-FLAT-LAYOUT v1](../specs/0038-SPEC-ex-flat-layout.spec.md)
**State:** in-review

## Acceptance

- [x] `packages/ex/src` contains `presentation/`, `application/`, `domain/`,
  `infrastructure/`, and package `main`; `cmd/` and `internal/` are gone.
- [x] `bin/`, `cli/`, `fixtures/`, and `scripts/` are gone; `build.sh` is the
  only script at the package root and builds `./src`.
- [x] Package, root, Turbo, and Biome configuration reference no removed path
  or task.
- [x] The SDK `ex` bridge runs the built CLI; `ex-shell-setup` is removed.
- [x] Documentation and agent instructions match the new layout and usage.
- [x] Formatting, vet, and the full Go suite pass at every commit.

## Verification record

See the spec's verification record for the commands, results, gaps, and
review status of this snapshot.
