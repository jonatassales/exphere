# React async UI

**Description:** React async sections and transitions use the framework's existing boundaries.

**Applies when:** Changing React UI, with route-file conventions applying to Next.js App Router applications and Server Component defaults applying where the framework supports them.

Server Components are the default where supported. Add `'use client'` only for browser APIs, interactivity, client state, or a client-only library. Keep the client boundary narrow.

Use `useTransition` or `startTransition` for non-urgent updates that should keep the current interface responsive. A `useState` loading flag models real application state; do not duplicate a transition already represented by `isPending`.

Put `<Suspense>` around an asynchronous section that can render independently. Keep one section's wait from blocking the entire page, and avoid wrapping every component without an independent loading responsibility.

A route that can suspend during navigation gets `loading.tsx`. A route segment requiring a runtime error boundary gets `error.tsx`. The error boundary handles render failures; `try/catch` handles imperative external calls. Preserve that distinction and follow [environment and external input](0020-environment-runtime.rule.md) for operation-boundary failures.

Add `template.tsx` only when a route must remount on navigation. Use the framework convention instead of imitating it with an effect or a key workaround. A future application's requirements determine whether such a route exists; this rule introduces none.

## Provenance and adaptations

Source at `e518dace741d8b9b44dd0a9d851fa3f42506320a`: [React async UI rule](https://github.com/jonatassales/langdrift/blob/e518dace741d8b9b44dd0a9d851fa3f42506320a/.cursor/rules/50-react-async-ui.mdc).

Adaptation: obsolete source globs become technology-based applicability, and the source website's route state is replaced by a conditional requirement. Server Component and route-file guidance applies only where the selected framework supports it. See [DEC-RULE-01](../../.exphere/artifacts/specs/0007-SPEC-agent-rule-import.spec.md#dec-rule-01--adaptation-register).
