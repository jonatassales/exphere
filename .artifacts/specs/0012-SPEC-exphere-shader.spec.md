# Exphere shader motion surface

- ID: `SPEC-EXPHERE-SHADER`
- Version: `2`
- State: `approved`
- PRD: No approved PRD version covers this component. The owner's October 11, 2026 request is the direct requirement source.
- Technical owners: Exphere owner for visual acceptance and consumer composition; implementation ownership remains with the shared web package.
- Authorization: Following review of this v1 specification, the owner's October 11, 2026 combined `to-tickets` and `implement` request authorizes its implementation and the proposed VER-SHADER-01 consumer/browser seam. SHADER-01 preserves the scope as one complete vertical slice. The later instruction to proceed directly to a PR authorizes the shader commit, push, and PR; it also removes preview-video delivery from this cycle. Visual acceptance of the resulting implementation remains separate.
- Related specifications: [design tokens](0003-SPEC-design-token-foundation.spec.md), [web foundation](0004-SPEC-web-package-foundation.spec.md), [website foundation](0005-SPEC-website-foundation.spec.md), and [basic palette](0011-SPEC-design-basic-palette.spec.md).
- v2 scope authorization: The owner's subsequent October 11, 2026 request to import the component into the `apps/website` layout extends SHADER-01 to that consumer integration. Keep the existing root layout and page server-rendered, import the public component, and wrap layout children once. Declare the actual workspace dependency. This supersedes v1's website-integration exclusion without authorizing deployment or page-content changes.

## Contract and composition

### Problem and intended result

The owner wants a faithful visual reproduction of the animated background of the [Codex landing page](https://openai.com/codex/), using Exphere's palette softened into pastel, lower-opacity colors. The Codex background is the single visual target: preserve its composition, forms, light distribution, and movement as closely as possible. A generic aurora effect does not satisfy this request. The reusable React wrapper must accept only children and cover the viewport behind a Next.js page or layout without adding document space or scrollbars.

The [SmoothUI Aurora Curtain](https://smoothui.dev/docs/components/aurora-curtain) at grain `0.00` is only an auxiliary reference, as the owner reiterated after the initial specification draft. It does not define the component's visual design or acceptance target. Its controls, dark presentation, and ribbon arrangement are not the requested product. The attached frontend role document is background guidance; it does not independently authorize dependencies, styling exceptions, or implementation.

### User stories

1. As a page author, I want to wrap content in `ExphereShader` with only children, so that I get a consistent Exphere motion background without configuring an animation.
2. As a visitor, I want a soft, unobtrusive background behind readable, interactive content, so that the effect does not interfere with using the page.
3. As a visitor using reduced motion or a browser without the renderer, I want a static decorative background and usable content, so that animation is optional to accessing the page.

### Requirements addressed

| ID | Contract |
| --- | --- |
| REQ-SHADER-01 | Provide the named React component `ExphereShader` in the shared web package. Its only public prop is `children`, typed as `ReactNode`. There are no color, speed, grain, theme, sizing, class, style, or renderer controls. |
| REQ-SHADER-02 | Import the design package through its public token contract. Derive pastel purple/lilac from `primary` and `primaryHover`, softened toward `background` and `surface`. Keep canonical tokens unchanged and avoid duplicating their hexadecimal values in component source. |
| REQ-SHADER-03 | Reproduce the observed Codex background as closely as possible: its spatial composition, large translucent folds, diffuse luminous gaps, overlapping volumes, and motion cadence and deformation. The intended adaptation is Exphere's softened palette with zero visible grain. Visual resemblance to Codex, rather than merely an aurora-like appearance or resemblance to SmoothUI, is the acceptance target across desktop and narrow screens. |
| REQ-SHADER-04 | Cover the viewport, including behind a long page as it scrolls. The decorative layer contributes no width or height to document flow. It must not create horizontal or vertical overflow, and must preserve scrolling that the children legitimately require. |
| REQ-SHADER-05 | Render children normally on the server and keep them usable during initialization, animation, fallback, and teardown. Do not change their opacity, semantics, pointer access, keyboard navigation, selection, or intended positioning. |
| REQ-SHADER-06 | Work from a Next.js App Router page or layout, including server-rendered children passed to the client wrapper. Loading the package or rendering on the server must not access browser-only APIs. |
| REQ-SHADER-07 | Respect initial and changing reduced-motion preferences, suspend continuous rendering while hidden or outside the visible presentation, and release animation and graphics resources on unmount. Missing or failed WebGL must leave a static background and usable children. |
| REQ-SHADER-08 | Deliver an explicit public package export, required generated styles, types, and minimal build/dependency support. The consumer must not need a deep source import, renderer initialization, token duplication, or an undocumented Tailwind source-scanning change. |
| REQ-SHADER-09 | Integrate the public `ExphereShader` component into the existing `apps/website` root layout around its children. Preserve the server layout, document attributes, body styles, and page content; declare `@repo/web` as a `workspace:*` application dependency. |

### Requested location and package boundary

The owner explicitly requested `packages/web/src/react/exphere-shader/exphere-shader.tsx`. The proposed public import is the named export `ExphereShader` from `@repo/web/react/exphere-shader`. This export is a proposal in this draft, not an existing API.

Current source was inspected at `origin/main` revision `f8fd264e184b396abd976ee87a1b4d5898ef088e`. The shared web package is still a scaffold: it has the SmoothUI CLI as a development dependency but no component exports, runtime React dependency contract, or component build. Those minimum capabilities must be supplied with the component rather than assumed to exist.

The design package already exports `@repo/design/tokens.css` and `@repo/design/tokens.json`; it has no runtime JavaScript token API. Its light palette contains the requested colors. The dark palette does not supply all of those semantic roles. This feature therefore defines a light pastel surface, not a new dark palette.

- Components selected by the consumer: React and the Exphere design-token and web packages. The inspected website uses Next.js `16.4.0`, React `19.3.0`, and Tailwind CSS `4.3.3`; recheck the eventual implementation base before selecting dependency versions.
- Environment and executor selected by the consumer: Next.js App Router is the intended integration. Browser graphics execute only after mounting; the existing pnpm/Turborepo workspace owns package construction.
- Extension points and execution lifecycle: Children are the sole composition point. Internal lifecycle is static server output, client initialization, active or suspended rendering, and disposal.
- Configuration, secret references, and data ownership: No credentials, environment variables, remote media, APIs, user-data collection, or persistent state are needed. The design package owns the palette; the consumer owns children and page composition.

### REF-SHADER-01 — observed reference

Live browser inspection on October 11, 2026 found that the Codex hero combines a looping video described by the page as animated blue and white flower petals with an overlaid decorative canvas. The video reported a six-second duration. The public DOM inspection and visual samples do not reveal or prove a proprietary shader implementation. [Primary reference](https://openai.com/codex/)

Three frames sampled within one loop show broad blue/periwinkle volumes, an upper-right curved fold, changing luminous white gaps, and gradual movement across the surface. This is the visual and temporal target, adapted to Exphere purple and without the reference's fine texture. A procedural renderer is the proposed reproduction method; copying or shipping the reference video, branding, text, or canvas output is not part of this feature.

The Aurora Curtain preview was inspected after setting its grain control to `0.00`. Its documentation describes a WebGL2 effect and a static fallback; it serves only as a secondary reference for smooth aurora softness. No SmoothUI source was imported. [Reference and documentation](https://smoothui.dev/docs/components/aurora-curtain)

Local screenshots and sample timestamps are preserved in the ignored [reference observation record](../../.audits/evidence/runs/exphere-shader-reference-2026-10-11/README.md). These are external-reference observations, not Exphere implementation, performance, accessibility, or cross-browser results. The record is local and is not guaranteed to accompany a published specification.

## Responsibilities

- Consumer: Choose placement in a page or layout, supply children, and retain ownership of page structure and content scrolling. Intended placement is the page/layout shell, outside ancestors that redefine the fixed-position containing block or clip the shell. Opaque content surfaces can intentionally cover the background.
- Platform/shared web owner: Own the component, token consumption, package export and styles, rendering lifecycle, fallback, and evidence against this contract. Do not require the consumer to operate a renderer or install a second copy of React.
- Service owners: The Exphere owner accepts visual similarity and any material scope changes. The component creates no service, provisioned infrastructure, or organizational delivery commitment.

## Operation and limits

### DEC-SHADER-01 — proposed implementation decisions

These are draft technical choices to validate during an authorized implementation, not claims that a prototype already exists.

1. Use one original procedural WebGL2 canvas to reproduce the observed Codex composition and motion with Exphere colors. Broad color fields and folds are implementation tools, not substitutes for matching the reference. Prefer direct browser graphics APIs over a new rendering or motion framework. Numerical tuning stays internal; no generic shader framework or exposed presets are needed.
2. Import the public generated token CSS through the web package and declare the actual design dependency with `workspace:*`. Resolve the light semantic colors on the owned decorative surface, mixing them toward the neutral background inside the renderer. Scope light-theme selection to that surface; do not force a theme on children. Lower opacity applies to the decoration, never to the wrapper's content.
3. Position the decorative surface as a fixed inset viewport layer in an isolated stacking context behind the children. Clip only that surface. Do not add viewport height to normal flow, use width that includes the scrollbar gutter, lock body scrolling, or hide document overflow to mask an error. Do not transform/filter the content wrapper or use a global negative stacking order that buries the effect behind the document.
4. Keep framework layout/styling in Tailwind utilities and generated output. Import generated token CSS through the permitted integration boundary; do not introduce handwritten component selectors or a parallel stylesheet system. Package-owned style delivery must be explicit, preserve CSS side effects, and avoid a global reset that changes consumer content.
5. Expose a client entry while preserving the client directive in its delivered output. Render children and a deterministic static surface before effects run. Do not move a consumer layout or its children to client-only rendering merely to initialize the canvas. Official Next.js guidance supports passing server-rendered content through a client component's children. [Next.js composition reference](https://nextjs.org/docs/app/getting-started/server-and-client-components)
6. Keep a named, local props interface containing only children and follow the project's component/import ownership rules. Declare React as a compatible peer dependency with build/type support owned by the package. Add only the dependencies needed for this component, and retain shell entry points for package automation.

### DEC-SHADER-02 — motion, resources, and failure behavior

- Motion: Use continuous, low-frequency deformation with smoothly changing overlaps and luminous areas. Avoid flicker, flashes, sharp borders, visible grain, sudden loop resets, or a rigid image merely translated around the screen. The six-second reference cycle is comparison evidence, not a new public timing option or a promise of an identical algorithm.
- Capacity: One canvas and at most one pending animation callback per mounted wrapper. Propose a device-pixel-ratio cap of `2` and a drawing-buffer ceiling of `2,073,600` pixels, reducing both dimensions proportionally above that ceiling. These are initial local resource bounds, not measured quality or frame-rate guarantees; verify softness on large screens before accepting them. Drawing-buffer resolution can differ from CSS display size. [WebGL guidance](https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API/WebGL_best_practices)
- Rendering work: Avoid React state updates, layout measurements, or token reads on every frame. Update size on relevant resize signals. Consume the current light palette when the surface initializes; live palette editing and theme switching are outside this version.
- Accessibility: Make the decoration absent from the accessibility tree and pointer/focus navigation. A reduced-motion preference produces a static frame or fallback without a continuous animation loop, including when the preference changes after mounting. Content remains fully interactive.
- Suspension: Stop scheduling continuous frames when the document is hidden or the surface is not presented. Resume without accumulating elapsed hidden time into a visible jump. A viewport-fixed layer remains presented while a long page scrolls; document position alone must not incorrectly suspend it.
- Failures: Missing WebGL2, initialization/link failures, or context loss select the token-based static fallback. Missing or invalid color input must not throw through the children or leave them hidden. No retry loop or video/network fallback is needed; a later fresh mount can attempt initialization again.
- Cleanup: Cancel pending animation, disconnect owned observers, remove owned listeners, and release owned graphics resources. Mount/unmount and React development effect replay must not leave duplicate loops or orphan canvases. Do not clean up resources belonging to the consumer or another instance.
- Installation, updates, and removal: Consume a built public package entry with its declared dependencies and styles. Removing the wrapper removes its resources and leaves normal child rendering; package removal follows workspace dependency ownership. No CLI installation, profile changes, or remote provisioning is involved.
- Observability and execution correlation: Use bounded local verification records under the existing evidence contract when execution is authorized. Record runtime, viewport, DPR, build revision, motion preference, outcomes, and limitations. Do not add telemetry or claim a performance result from this draft.

### Out of scope

Dark-mode design, changing canonical tokens, importing the reference video or SmoothUI implementation, visible grain, branding/content replication, pointer-reactive effects, animation controls, general component-library work, and website page-content changes are outside this component specification. Remote deployment, package publication, and new project-wide test infrastructure are also outside this cycle. The v2 scope adds only the existing website's root-layout integration.

## Verification and decisions

### VER-SHADER-01 — proposed verification seam

One new seam is proposed: a disposable Next.js consumer of the built public component export, exercised in a browser. It covers package delivery, server/client composition, visual motion, and layout behavior together. Existing design-token public-export fixtures and website compilation are useful prior art, but they do not establish animated browser behavior.

This seam was authorized with the owner's subsequent October 11, 2026 combined `to-tickets` and `implement` request. Verification is confined to a disposable Next.js consumer of the built public export. The fixture and Playwright test source use their framework conventions; shell files own preparation, tool execution, and cleanup. No production application integration or project-wide browser infrastructure is included.

| Check | Expected observable behavior and evidence |
| --- | --- |
| Public delivery and SSR | A consumer imports only the documented public entry; package styles and tokens load. A server page/layout passes server-rendered children without hydration warnings, browser globals accessed on the server, or an undocumented source scan. Type checks and production compilation use existing workspace tooling where applicable. |
| Layout | Compare the same short, long, and empty-child fixtures with and without the wrapper at narrow and wide viewports, then resize. Document width/height do not increase because of the decoration. Legitimate content overflow and vertical scrolling remain, with no scroll lock or clipping of children. |
| Interaction | Links, buttons, inputs, text selection, keyboard focus, and representative sticky/fixed child content retain their expected behavior. The background adds no accessible or focusable element. |
| Appearance and time | Compare the Exphere result directly with Codex at several points across a reference-length interval, using the saved observations. Check matching spatial composition, fold geometry, light distribution, softness, motion pace and deformation, with the intended pastel Exphere hue and absence of grain. Review both desktop and mobile framing. A visually different but attractive aurora, including a SmoothUI-like curtain, fails this target. Record remaining differences for owner review; no invented numerical similarity score or single still frame proves motion fidelity. |
| Reduced motion and lifecycle | Initial and changed reduced-motion preferences produce a stable surface. Hidden/resumed presentation and repeated mounting preserve children and do not duplicate animation. Observe scheduling/resource disposal without testing private shader constants or pixel-for-pixel implementation details. |
| Fallback and capacity | WebGL unavailability and context loss leave static decoration and usable content. Record actual drawing-buffer dimensions against the proposed ceiling and any visual or frame-time limitations on the tested browser/device. Do not infer broad browser support or performance from one device. |

Good tests assert what the package consumer and visitor observe. Do not mirror shader equations, animation constants, or internal function structure with unit tests. Capture sufficient temporal evidence for visual review; a passing build alone is insufficient.

### Guardrail applicability and remaining decisions

- Affected guardrails: FinOps and Twelve-Factor local policy `v1`, adopted October 10, 2026; SDD local policy `v1` for later delivery. Apply current frontend/styling rules from the eventual implementation base.
- FIN-04/05/08: `not-verified` for the proposed runtime. The shared web owner must verify the bounded browser graphics allocation, suspension/disposal, and quality impact through VER-SHADER-01. The draft itself provisions no resources. No paid service, cloud allocation, AI-call change, savings claim, or authorized monetary budget is introduced; FIN-01/02/03/06/07 are `not-applicable` to paid consumption in this scope. Browser energy and runtime cost remain unmeasured, not zero.
- 12F-01/02/05: `not-verified` for delivery; require the final source revision, dependency/lockfile inspection, and a consumable build. 12F-09 is adapted to browser-resource disposal and remains `not-verified`. Other factors are `not-applicable` to this library change: no backing service, persistence, port, environment-secret contract, service scaling, logging service, or administrative process is added. Test environment limits are still recorded in evidence.
- SDD: No shader commit or PR is created in this phase. Later implementation requires scoped tickets, two-axis review of the actual changed snapshot, and separately authorized delivery under the existing SDD rule. The earlier palette review is not a shader review.
- Cost/consumption impact: The proposed effect uses client GPU/CPU and adds package assets. Exact transfer size, frame time, energy use, and device coverage remain unknown until authorized verification. Resource caps and suspension are proposed controls; no economic or production-readiness claim follows.
- Open issues and exceptions: Visual tuning and package style delivery must be demonstrated through the public consumer. The proposed buffer ceiling may trade detail for softness on large displays; reassess with the owner if meeting the visual target requires materially expanding resource use. There is no new styling or automation-policy exception.
- Verification plan: VER-SHADER-01 in this artifact. Technical choices: DEC-SHADER-01 and DEC-SHADER-02. Reference observations: REF-SHADER-01.
- Technical review: Completed on October 11, 2026 against the untracked draft snapshot with SHA-256 `7ac3be5d435bad8f4f7343eecfbf23a2a9f0c0538b8afdd65111a2b13845ecbe`, before appending this review record. The supporting observation record had SHA-256 `47bb53ccbac563233e21b8b7e1c522831023f5daabc9245dc969015df80cc4a0`. Comparison base: local `HEAD` at `89e4bd796d3ec8ff76bed414c39f19be2d365b7e`; these two additions were the entire review scope. Unrelated local changes were excluded.
- Standards review: `palette_standards_review` reported zero actionable findings, including no applicable code-smell findings in this documentation-only scope.
- Spec review: `palette_spec_review` reported zero actionable findings against the owner's request and subsequent clarification that Codex is the visual target and SmoothUI only a reference.
- Review limits: Both reviewers inspected the same recorded snapshot read-only. This metadata records their outcomes without changing the reviewed contract. No shader implementation, build, or application test was executed; specification review does not establish runtime verification or owner acceptance.

### Implementation evidence — October 11, 2026

- Delivery scope: SHADER-01, implemented as uncommitted changes on `codex/exphere-shader`, based on main revision `d2aefe91915906da846e2940ee13b23e28309976`. The historical draft review above does not cover these implementation changes.
- Implemented contract: Public children-only React export, generated prefixed Tailwind styles without preflight, public token imports, original WebGL2 folds, fixed viewport decoration, reduced-motion/static fallback, visibility suspension, and disposal. The production website and canonical design tokens are unchanged.
- Verification: The first disposable consumer build failed with the expected missing public export. After implementation, the public consumer compiled and the six Chromium checks passed. The complete workspace build and test suite passed, including existing hooks, agent-review, SDK/CLI, and design contracts. Following test readability changes, the scoped consumer suite passed again. TypeScript checks cover the runtime and browser test source; Biome and shell syntax checks passed.
- Environment: macOS arm64, pnpm `12.4.2`, Turborepo `2.11.7`, Next.js `16.4.0`, React `19.3.0`, Tailwind CSS `4.3.3`, TypeScript `7.0.2`, Playwright `1.64.0`, Chromium `156.0.8078.4` with SwiftShader enabled. Desktop 1352 by 605, narrow viewport 390 by 844, and buffer-cap check at 3840 by 2160. This does not establish physical mobile or other-browser results.
- Visual observation: Local timed captures were compared with REF-SHADER-01. The implementation retains a broad upper-right fold, diagonal luminous opening, lower-right volume, and continuous deformation, using softened purple/lilac and omitting grain. It is a procedural reconstruction of the observed video composition, not identical media or pixel output. Fine petal texture and exact video phase correspondence are not reproduced. Final owner acceptance of fidelity remains outstanding.
- Evidence location: Local ignored `.audits/evidence/runs/exphere-shader/` contains build/test logs, screenshots, and review snapshot hashes. Earlier local video output is not selected for delivery; further video capture is disabled. Reference media and local raw evidence are excluded from publication.
- Resource observations: The browser check confirmed a buffer no greater than 2,073,600 pixels at the tested large viewport and no continuing draw calls during reduced motion, simulated document hiding, or unmount. Visibility was simulated at the browser boundary; real OS background-tab policy, GPU energy, and sustained frame-time behavior were not measured. Bundle size and source hashes must follow the final reviewed shader revision; no transfer-budget claim is made.
- Guardrail assessment: FIN-04/05/08 and adapted 12F-09 have bounded local browser evidence for capacity, suspension, fallback, and cleanup; broader performance and device quality remain `not-verified`. 12F-01/02/05 are supported by the recorded base, manifests, lockfile, and disposable public-consumer build. No paid resource or deployment was created. Technical implementation review remains pending below.

### Initial implementation review and PR handoff

- Both axes verified all 27 files in the final source manifest, SHA-256 `c16b1a6cdbc9b1994bfa172247451c0469938bcac0b3626706f4d99a52ae93ba`, against base `d2aefe91915906da846e2940ee13b23e28309976`. This outcome record is appended after review without changing the runtime contract.
- Standards: Zero actionable violations or heuristic findings, including the final shader refinement.
- Spec: One visual finding remains. Curved lighting, rolled edges, and the diagonal sheet improve depth, but the result still has smoother fields and fewer overlapping petal volumes than the Codex reference. REQ-SHADER-03 remains partial. Other reviewed contracts have no actionable gaps.
- Final verification: All six public-consumer browser checks passed again after the shader correction; Biome passed. Those checks do not override the visual finding.
- Handoff: Following the owner's instruction to proceed directly to the PR, publish a draft with the remaining fidelity finding explicit. SHADER-01 stays in-review; neither full visual fidelity nor feature completion is claimed. No video preview is delivered.

### PR revision review — October 11, 2026

- The owner requested review and completion of the already-open [PR #8](https://github.com/jonatassales/exphere/pull/8). The PR is open and not a draft; that observed state supersedes the initial planned draft handoff above. This revision preserves the existing branch and PR.
- Technical corrections: The package's Turbo test task now depends on its own build, preventing the disposable consumer from exercising stale or missing web output. Cleanup unbinds the current WebGL program before deleting it so GPU program/shader disposal is immediate. Browser verification now observes console errors and separately confirms server content with JavaScript disabled.
- Regression evidence: Before the cleanup correction, the new disposal check failed because the program remained current and alive after unmount. After the correction it passed. The Turbo dry-run dependency check changed from false to true for `@repo/web#build` preceding `@repo/web#test`. All eight public-consumer checks passed with the revised source; types and formatting checks passed.
- Visual refinement: Separate curved petals, directional backlighting, overlapping sheets, and a changing central opening replace the earlier flatter field treatment. Final timed desktop/mobile captures and both review axes must assess the delivered revision below; test success alone does not close REQ-SHADER-03.
- Remote evidence: The successful CI run for `ebb89ebc1f3d7677c09a4fd5ce4630fe8389d926` recorded its paid agent review as skipped because execution is disabled. It does not establish a Standards or Spec review. Local independent reviews supply that evidence; no paid review was enabled.
- Final review snapshot: Both axes verified all 28 source files against base `d2aefe91915906da846e2940ee13b23e28309976`, including the new package Turbo configuration and uncommitted corrections. Manifest SHA-256: `bc8067cfe43b001e242044b44329a59b0e09cae1ae574738b9d70ba0a684e3b3`; shader SHA-256: `bc23cd19b9566bef91d5f7a4a63f5b50895b9808e6f82afe7b09400717c25410`. This outcome metadata is appended after review and does not change the reviewed runtime contract.
- Standards: `palette_standards_review` reported zero actionable violations or heuristic findings. All three technical findings are resolved.
- Spec: Independent reviewer `palette_inspection` reported zero actionable findings after comparing all three final desktop samples and the narrow capture with REF-SHADER-01. Opposed lighting across the inward-facing upper-right fold, a distinct lower-right volume, the bowed diagonal opening, and retained narrow-screen composition resolve the earlier missing-curvature finding. The smoother procedural treatment, pastel palette, omitted texture, and nonidentical reference phase remain explicit adaptations or limits, not evidence of pixel-identical reproduction.
- Final verification: All eight public-consumer browser checks, type checking, Biome, and patch-whitespace checks passed on the final shader revision. The ignored `review-curvature-test.log` and `review-curvature-sha256.txt` record that snapshot. Timed still captures support qualitative composition and deformation review; they do not prove every intermediate motion characteristic or owner acceptance.
- Delivery outcome: Implementation and local review are complete for the existing PR. SHADER-01 remains in-review for owner visual acceptance and PR disposition. No merge, deployment, package publication, or video-preview delivery is included.

### v2 website integration — October 11, 2026

- Implemented the owner's follow-up through the public `@repo/web/react/exphere-shader` entry in the existing server root layout. `ExphereShader` wraps layout children once; document attributes, body classes, and page content are preserved. The website declares its actual `workspace:*` dependency, and pnpm updates the corresponding workspace link and deduplicates the existing Next.js peer snapshot without downloading packages.
- Verification: The website and its dependency build/type-check tasks passed. Generated production HTML includes one decorative canvas, the wrapper, the original heading, and the existing document attributes. Bundled CSS includes the component's prefixed fixed-position and isolation utilities. Biome and patch-whitespace checks passed after import ordering. No application browser probe, new test infrastructure, or deployment was added; the unchanged component retains the preceding eight-check consumer evidence.
- Review scope: Follow-up to reviewed commit `f9f7baef6304ccc1c8c8bdad684824c8a3b5907f`, with the complete PR still compared against main base `d2aefe91915906da846e2940ee13b23e28309976`. The v2 contract extension is the owner's explicit layout request, not an inferred change to the component API or visual target.
- Review outcome: Standards (`palette_standards_review`) and Spec (`palette_inspection`) each reported zero actionable findings after verifying all 31 file hashes in manifest `ea38d274a157f5848b3aa9d1e8b4bb2f0c84166381dfcda59d5838dc4cd40bdc`. The component source is unchanged from the prior review. This outcome record is appended afterward without altering the implementation; owner visual acceptance and deployment remain separate.
