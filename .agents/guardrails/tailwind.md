# Tailwind

Applies to application styling and shared UI styling. Component ownership remains in [frontend.md](frontend.md#shared-ui-ownership).

## Application styling and integration surfaces

Tailwind is the application styling system. Use its utilities for component, feature, layout and responsive styling.

No pure or vanilla css is allowed.

## Class composition and theme roles

Use `cn` built with `clsx` and `tailwind-merge` when conditional classes or defaults/consumer overrides need conflict-aware composition. A static class string does not need a wrapper solely for consistency. The helper's exact directory and suffix are not prescribed.

Where colors/fonts represent shared surface roles across themes, expose those roles through semantic Tailwind utilities backed by theme tokens. Keep components expressed in those roles instead of repeating unrelated palette literals. Exact palettes, token names and the current CSS decomposition are not standardized here; this is not a blanket prohibition of arbitrary-value utilities.
