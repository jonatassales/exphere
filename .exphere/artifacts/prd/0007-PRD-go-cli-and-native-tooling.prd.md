# PRD — Go-only Exphere CLI scaffold and native repository tooling

- ID: `PRD-GO-CLI-NATIVE-TOOLING`
- Document number: `PRD-0007`
- State: `draft`
- Owner: Exphere project owner
- Sources: owner's October 13, 2026 Go-only CLI and `scripts/` deletion request; current shell CLI, package scripts, Husky and GitHub CI inventory.
- Baseline: `d6b3c8abff240c54011f81f7088f445e3fbabef4`.

## Problem and outcome

The existing Exphere CLI is a Bash/jq implementation plus many project-specific `scripts/` runners across packages. The owner wants the CLI rewritten entirely in Go; this cycle authorizes **only a Go scaffold**, not porting v1/v2 behaviors. Elsewhere, pnpm/Turbo/Next/Husky should execute their native commands without wrapper `scripts/` directories.

The expected outcome is a compilable, testable Go CLI root with explicit unimplemented commands; the old shell CLI is retired rather than falsely presented as Go. Package entrypoints use native tool commands. No `scripts/` directory remains outside the Exphere CLI ownership boundary.

## Scope and impacts

Included: Go module/CLI scaffold with `--help`, `version`, explicit `init` placeholder and nonzero unsupported-command exit; versioned shell CLI retirement; root/package native script entrypoints; Husky direct commands; updated CI and package documentation; remove wrapper/test-runner scripts and obsolete shell tests or move required test scaffolding into legitimate test owners.

Important breaking change: former shell `ex runtime` generation, validation, Terraform/Kubernetes adapters, setup/PATH mutation, consumer fixtures and legacy tests are **not migrated** in this cycle. They must not be claimed working. Historical contracts/specs can stay as records, but live documentation and CI must state what is actually executable.

Excluded: implementing Go microruntime commands, deploying Terraform/Kubernetes, registry publication, automatic npm `exphere` package, reviving deleted helpers with disguised names.

## Requirements

| ID | Criterion |
| --- | --- |
| GO-01 | Pure Go CLI scaffold builds with stdlib, explicit help/version, honest init-unimplemented result, no hidden shell runtime. |
| GO-02 | Root `ex` command resolves Go CLI; no postinstall user PATH changes. |
| GO-03 | Repo package scripts use native pnpm/Turbo/Next/tsc/Biome/Husky commands; no wrapper `scripts/` dirs outside CLI. |
| GO-04 | CI and hooks use direct commands and do not reference removed paths; removed agent-review automation is documented if no native replacement. |
| GO-05 | Existing Go tests cover help/version/init error and unexpected args, without paid or external APIs. |
| GO-06 | README/AGENTS/SDD rules explicitly distinguish previous functionality from new scaffold and verification gaps. |

## Decision

Owner authorizes Go as sole future Exphere CLI implementation language, with only scaffold now. Previous Bash command compatibility and shell test infrastructure are deliberately retired, not silently emulated. See [ADR-0003](../design/0011-DD-go-cli-native-tooling.dd.md), [SPEC-GO-CLI](../specs/0025-SPEC-go-cli-scaffold.spec.md), and [SPEC-NATIVE-SCRIPTS](../specs/0026-SPEC-native-scripts-retirement.spec.md).
