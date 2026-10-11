# Environment and runtime inputs

## Description

Handle environment variables and other external inputs at the operation that uses them, while preserving the selected configuration contract.

## Applies when

Changing JavaScript or TypeScript operations that consume environment variables, response bodies, network calls, filesystem reads, or third-party SDK results. Apply the [Twelve-Factor policy](twelve-factor.md) when the change affects configuration or service lifecycle.

## Configuration access

The operation that uses an external value is its defensive boundary. For environment-backed configuration in applicable JavaScript or TypeScript code, read `process.env.NAME` at that operation. Keep the property access static so Next.js can inline public environment variables when applicable.

Keep server-only configuration at the server boundary. Expose a value to client code only when that client has a real need for it; a URL alone establishes neither secrecy nor a client requirement.

Do not introduce a central environment module, registry, service, `getEnv`, `requireEnv`, `readEnv`, schema-validation environment object, adapter, hydration step, or proxy whose responsibility is reading or checking environment variables. A local check beside the operation is allowed when an API requires a string or the failure message must identify the missing variable. Keep that check with its operation instead of extracting a shared environment utility.

Preserve the configuration mechanisms selected under Twelve-Factor: environment variables, mounted configuration files, secret references, and explicitly safe local defaults. Direct environment access does not replace a mounted-file or secret-reference contract or authorize a configuration migration.

Never fabricate a credential, endpoint, or other required value to conceal missing configuration. A placeholder credential such as a development key is not a safe local default. Use a default only when the applicable configuration contract explicitly allows it and its local safety is established.

## Operation failures

A missing or malformed external value fails inside the operation that needs it. Wrap the external or runtime operation in `try/catch`. Translate its failure into the operation's application result, report it through the existing observability path, apply a product-approved fallback, or rethrow with context that does not leak secrets. Do not swallow failures.

Use `try/catch` for external or runtime boundaries. A pure internal function fails normally; an internal invariant is not an external failure. Tests, guardrails, build scripts, and startup validators do not replace the defensive boundary at the consuming operation.

## Provenance and adaptations

Imported from [the environment and runtime source rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/20-environment-runtime.mdc) at revision `e518dace741d8b9b44dd0a9d851fa3f42506320a`.

The [adaptation register](../../.artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register) preserves mounted files, secret references, and explicitly safe local defaults under Exphere's Twelve-Factor contract. Applicability follows the actual language and operation rather than obsolete source-tree globs. No wrapper, configuration migration, or runtime implementation is introduced by this document.
