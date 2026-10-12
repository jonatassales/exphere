# Package scripts

## Description

Keep package commands atomic while invoking repository automation through shell files and coordinating workspace tasks with pnpm and Turborepo.

## Applies when

Creating or changing package manifest scripts, the shell automation they invoke, or workspace task orchestration.

## Command ownership

Package manifest scripts invoke `.sh` files under the [automation script contract](0000-engineering-core.rule.md#automation-scripts). A leaf operation's shell file invokes the purpose-built tool that performs that operation. Tool-specific flags belong with that invocation.

Give each leaf operation a clear responsibility. Avoid package scripts that call other package scripts or redundant shell layers that obscure the tool invocation. The required manifest-to-shell boundary remains explicit even when the operation needs only one framework command.

The repository root uses the pinned pnpm version and Turborepo to coordinate workspace tasks, with manifest entry points invoking shell files. The task runner coordinates atomic leaf operations; do not introduce an unnecessary chain of package scripts and shell wrappers in front of each tool.

Workspaces own their dependencies, and actual internal dependencies use `workspace:*`. Before changing Turborepo configuration or commands, follow the installed-version documentation instructions in [root AGENTS](../../AGENTS.md). An app-local task configuration contains meaningful app-specific overrides rather than copies of root behavior.

Keep necessary container orchestration at the container boundary. Select commands from the current package and framework contracts; examples and imported guidance do not make absent commands available.

## Provenance and adaptations

Imported from [the package scripts source rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/60-package-scripts.mdc) at revision `e518dace741d8b9b44dd0a9d851fa3f42506320a`.

The [adaptation register](../../.exphere/artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register) replaces the source's shell-wrapper prohibition and direct manifest framework commands with Exphere's required `.sh` boundary. Atomic operations and root workspace orchestration remain intact. This documentation import does not rewrite manifests or add scripts.
