# Web package

`@repo/web` provides `ExphereShader`, a React wrapper that renders a pastel purple motion background behind its children. Its procedural folds and moving light follow the Codex background reference, using Exphere design tokens. The implementation does not use the reference video, external media, or SmoothUI component source.

```tsx
import { ExphereShader } from "@repo/web/react/exphere-shader";

export default function Page() {
  return (
    <ExphereShader>
      <main>Your page content</main>
    </ExphereShader>
  );
}
```

The only prop is `children`. The component is a client entry that accepts server-rendered children from a Next.js App Router page or layout. Importing it includes the public design-token CSS and its generated, prefixed Tailwind utilities. No extra stylesheet import, Tailwind scan configuration, animation provider, or page-level client directive is required. React is a peer dependency; Next.js is only a development dependency for the disposable consumer verification.

Place one wrapper at the page/layout shell, outside transformed or clipped ancestors that change viewport-fixed positioning. Its decoration is fixed to the viewport; children retain their natural height and scrolling. It does not set page height, lock document scrolling, intercept input, or fade content. Opaque child backgrounds can cover the effect. The wrapper creates an isolated stacking context, so child stacking remains local to that shell.

The light surface consumes `primary`, `primaryHover`, `background`, and `surface` from `@repo/design`, without changing the source tokens or forcing children's theme. Runtime token overrides and dark-theme design are outside the current contract. Missing/invalid color inputs leave the CSS fallback; the shipped six-digit color tokens are the supported renderer input.

Reduced motion uses a still frame, including preference changes after mounting. Hidden documents and non-intersecting surfaces stop continuous rendering. WebGL2 unavailability or context loss leaves a static token-based background; children remain usable. Unmount cancels animation, disconnects observers/listeners, deletes the program and shaders, and shrinks the drawing buffer. The buffer is capped at 2,073,600 pixels and DPR 2. These bounds are not an FPS or energy guarantee.

## Local verification

From the repository root, use `pnpm build --filter=@repo/web` and `pnpm typecheck --filter=@repo/web`. For the browser suite, install the pinned browser once with `pnpm --dir packages/web exec playwright install chromium`, then run `sh scripts/turbo.sh test --filter=@repo/web`. This Turbo task builds the web/design artifacts before testing their public exports. `pnpm test` runs the full repository suite, including its existing hook checks, and does not implicitly install browsers.

The package shell entry point constructs a disposable Next.js app from the public manifests and build outputs, compiles it, runs Playwright, and removes it. It does not change the website app. Chromium verification covers SSR/hydration, interaction, dimensions/scrolling, motion preferences, visibility, context loss, cleanup/remount, and the buffer cap. Timed desktop/mobile screenshots are written to the ignored evidence directory for visual review. A frame difference proves animation, not fidelity; fidelity requires comparing the captures with the Codex reference. Other browsers and physical mobile devices are not yet verified.

This package is versioned and intended for public distribution; no registry release is provided by this work. SmoothUI's existing CLI remains a development dependency; no initialization or component acquisition is performed. Its license applies to that dependency and does not establish a license for this package's source.
