# EX-LAYOUT-01: Flatten the Go CLI package layout

**Spec:** [SPEC-EX-FLAT-LAYOUT v1](../specs/0038-SPEC-ex-flat-layout.spec.md)
**State:** in-progress

## Acceptance

- [ ] `packages/ex/src` contains `presentation/`, `application/`, `domain/`,
  `infrastructure/`, and package `main`; `cmd/` and `internal/` are gone.
- [ ] `bin/`, `cli/`, `fixtures/`, and `scripts/` are gone; `build.sh` is the
  only script at the package root and builds `./src`.
- [ ] Package, root, Turbo, and Biome configuration reference no removed path
  or task.
- [ ] The SDK `ex` bridge runs the built CLI; `ex-shell-setup` is removed.
- [ ] Documentation and agent instructions match the new layout and usage.
- [ ] Formatting, vet, and the full Go suite pass at every commit.

## Verification record

Pending.
