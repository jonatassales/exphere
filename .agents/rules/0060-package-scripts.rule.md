# Package scripts

## Applies when

Creating or changing package manifest task aliases, native tool entrypoints or workspace orchestration.

## Command ownership

Package manifest task aliases call the owning native CLI directly: pnpm/Turborepo for workspace orchestration; Next.js, TypeScript, Biome, Go, Husky and the existing test runners for their operations. Avoid redundant shell wrappers for a single native command.

Workspaces own their dependencies and actual internal dependencies use `workspace:*`. Read the installed-version Turborepo documentation described in [root AGENTS](../../AGENTS.md) before changing its configuration or commands. App-local configuration should contain meaningful overrides rather than copies of root behavior.

The owner retired `scripts/` directories outside `packages/ex/` on October 13, 2026. Substantive Husky hooks and native test files retain their framework-defined owners; do not recreate deleted task wrappers under different names. CLI-owned verification helpers can remain `.sh` files when required by their authorized contract. Application source, the design token compiler and framework configuration retain their required languages.

## Provenance and amendments

Originally imported from [the package scripts rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/60-package-scripts.mdc). The October 13 owner request supersedes the earlier Exphere manifest-to-shell adaptation recorded in [SPEC-AGENT-RULE-IMPORT](../../.exphere/artifacts/specs/0007-SPEC-agent-rule-import.spec.md). See [the native tooling decision](../../.exphere/artifacts/design/0011-DD-go-cli-native-tooling.dd.md).
