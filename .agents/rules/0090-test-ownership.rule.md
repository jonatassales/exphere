# Test ownership and evidence

## Description

Classify tests by the behavior and context they exercise, preserve execution permissions, and distinguish local output from reviewable evidence.

## Applies when

Creating, changing, moving, classifying, or running tests; changing test dependencies, package commands, or ignore policy; and preparing validation evidence. These ownership and authorization constraints apply throughout repository work.

## Ownership and classification

Keep unit/component tests and native service integration tests with the application or package that owns the behavior. A native service integration test does not become E2E merely because it exercises HTTP.

End-to-end tests belong with the responsible context that owns the complete interaction. When an approved microruntime owns that orchestration, place its E2E coverage at that boundary rather than inside an application. Resolve the location from the actual owner and accepted contract. Do not create a speculative runtime test tree to reproduce a source example.

A correction that removes incorrectly placed application E2E does not itself authorize moving suites or introducing a replacement runner. Inert upstream development or optional-peer metadata in reviewed dependencies does not establish installed test infrastructure.

## Execution permissions

Follow the current scoped permissions in [root AGENTS](../../AGENTS.md) before adding or running tests, introducing a browser runner or its dependencies, or changing test commands. This imported rule does not impose a platform-wide ban on a browser tool or select one for consumers.

The existing hook contract authorizes build/test in pre-push and scoped hook-contract tests in disposable local Git repositories, including a local bare remote. Unrelated application tests, service probes, and remote publication retain their authorization requirements. Removing a test or importing a document does not expand those permissions.

Use only checks that exist in the current repository and are authorized for the change. If required validation is unavailable, record the gap. Do not describe an absent boundary-check command as executable enforcement.

## Evidence ownership

The former `.audits/evidence/README.md` is unavailable; no replacement general evidence contract is asserted here. Execution logs and reports keep the existing `.audits/evidence/runs/<run-id>/` destination, preserved by [Git ignore configuration](../../.gitignore) and the browser-output configuration. Use the surviving [verification plan](../templates/verification-plan.md) and [review format](../templates/review.md) to record authorized scope, revision, methods, outcomes, and limitations in the owning artifact. These formats do not recreate the removed contract. Do not apply a blanket Git ignore policy to `.audits/`.

Select publishable evidence deliberately and sanitize sensitive data. A local output may reference other local outputs, but an ignored local path is not accessible publication evidence. Summarize validation in the delivery record and link only selected evidence that recipients can inspect.

Record the actual scope, source revision, checks, results, and remaining gaps. A rule, a plan, a passing check, and an authenticated approval are different kinds of evidence. Static review does not prove application execution or service compliance.

## Provenance and adaptations

Imported from [the test ownership source rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/90-test-ownership.mdc) at revision `e518dace741d8b9b44dd0a9d851fa3f42506320a`.

The [adaptation register](../../.exphere/artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register) replaces an assumed runtime path, source-specific browser-runner ban, unavailable boundary-check command, and blanket audit exclusion with Exphere's actual ownership, permissions, and evidence contracts. This document creates no tests, runner, directories, or enforcement.
