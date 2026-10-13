# Consumer reference contract

Reference format 1.0.0 is manually authored test input. config.json owns consumer
selections. lock.json is a reference inventory of selected files, excluding itself
and editable config.json. An inventory mismatch detects modification; it never
repairs or overwrites a consumer file. Runtime schema.json remains descriptor v2.

References in new JSON contracts are consumer-root-relative. Runtime component
paths remain project-relative and native/hook paths remain runtime-relative.
All selected dependencies resolve here. Missing required handlers are declared
unavailable, not silently replaced by the maintainer checkout.
