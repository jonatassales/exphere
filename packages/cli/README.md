# Exphere CLI — Go scaffold

The project owner selected Go as the sole implementation language for the next Exphere CLI. **This package is a scaffold only.** The previous experimental Bash/jq `ex runtime` and `ex setup` implementations are retired as part of the native-tooling cleanup. Their former functionality is **not** available through Go yet.

## Commands

From the repository root with Go 1.23+:

```sh
go -C packages/cli run ./cmd/ex --help
go -C packages/cli run ./cmd/ex version
go -C packages/cli test ./...
go -C packages/cli vet ./...
```

`ex init` currently prints an explicit **not implemented** error, exits nonzero, and does not create or modify files. `npx exphere init` shown on the website is a preview of a future npm-distributed command, **not a published installer**.

The `packages/cli/package.json` package exists as a private pnpm workspace task bridge; it does not implement a JavaScript or shell CLI.

Future work may add idiomatic Go subcommands, typed microruntime schemas, validation, Terraform/Kubernetes adapters, distribution and compatibility tests. The historic SPECs/fixtures remain evidence of earlier contracts, not an assertion that the Go scaffold satisfies them.

This Go-only scope is defined in [ADR-0003](../../.exphere/artifacts/design/0011-DD-go-cli-native-tooling.dd.md) and [SPEC-GO-CLI-SCAFFOLD](../../.exphere/artifacts/specs/0025-SPEC-go-cli-scaffold.spec.md).
