# Go CLI scaffold and native tooling architecture

- ID: `DD-0011`
- Decision ID: `ADR-0003`
- Status: `accepted for the owner-authorized scaffold scope; prior CLI behaviors explicitly deferred`
- Owner: Exphere project owner
- Date: October 13, 2026
- PRD: [PRD-GO-CLI-NATIVE-TOOLING](../prd/0007-PRD-go-cli-and-native-tooling.prd.md)

## Context

The repository's shell-based `ex` CLI, Bash/jq adapters and setup scripts constitute a non-Go runtime with many linked test and packaging helpers. The user selected Go as the sole Exphere CLI implementation language and asked for only the scaffold in this phase. Independently, the owner wants every project/package-specific `scripts/` directory eliminated except one optionally inside the CLI.

## Options

1. Retain the Bash CLI and add a Go wrapper. Rejected: not fully Go, misleading behavior boundary.
2. Port existing Bash v1/v2 runtime semantics to Go immediately. Rejected: expressly beyond scaffold scope, safety invariants cannot be preserved by superficial translation.
3. Retire old shell executables, retain history and schemas as needed, introduce stdlib Go root CLI with explicit unimplemented commands, and replace wrappers with direct native tool invocations. **Selected**.

## Decision

- `packages/cli` is the sole future CLI source root; use a standard Go module and `cmd/ex` executable. Implement usage/version and explicit unsupported `init` status only. No side effects or consumer file generation.
- The pnpm workspace may keep a private `@exphere/cli` manifest only as a task bridge to native `go` commands. A manifest is not a second CLI implementation.
- A documented Go scaffold is not evidence that `npx exphere init` is published. The website's copy-to-clipboard box previews a future invocation, with documentation distinguishing it from a working installer.
- Remove legacy shell CLI command sources and wrappers in root/web/design/sdk. Do not preserve silent fallback to Bash.
- Replace root/package scripts with native Turbo, pnpm, Next.js, TypeScript and Husky operations; package.json `scripts` keys are supported as task aliases and do **not** create `scripts/` folders.
- GitHub Actions should use native commands; preserve quality gates where possible. If shell-only agent-review and disposable test fixtures cannot be retained under the new policy, remove their execution claims explicitly rather than pretending their replacement exists.
- Historical JSON schemas/fixtures may remain as design/test reference but are not connected to a working Go generator until future tickets implement the contracts.

## Consequences / limitations

- Breaking behavior: earlier `ex runtime`, `ex setup`, shell adapters and user PATH mutation are no longer available until explicitly implemented in Go.
- Temporary test coverage lost by deleting shell-only harnesses must be identified; existing supported package tests should be retained or replaced with actual native test commands rather than green no-ops.
- Root install no longer mutates user profiles; Husky uses its own documented setup command.
- Go CI can run `go test ./...` without Terraform/Kubernetes provisioning.
- The project remains nonproduction; no migration/compatibility assurance is made for users of the previous experimental CLI.
