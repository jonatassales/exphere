# Web package

`@repo/web` reserves the shared web boundary for future components and utilities. It is versioned and intended for public distribution; no registry release or usable runtime export is provided yet.

The five source directories (`internal`, `react`, `web-components`, `vendor`, and `utilities`) contain only `.gitkeep`. Add explicit exports when real public implementation exists; internal and vendor code are not public APIs.

SmoothUI's `smoothui-cli` 1.1.3 is installed as a development dependency. No initialization, component acquisition, or generation runs during this foundation. Its package license applies to that dependency; this does not establish a license for this package or future component source.

There is no speculative React, animation, design, SDK, or CLI runtime dependency and no fabricated build task for empty source. The website does not consume this package yet.
