# CLI-GO-01: Establish the Go-only Exphere CLI scaffold

**Spec:** [SPEC-GO-CLI-SCAFFOLD v1](../specs/0025-SPEC-go-cli-scaffold.spec.md)
**Status:** ready-for-agent
**Approval:** Owner's October 13, 2026 Go-only CLI direction and scaffold-only limit.
**Blocked by:** None.

**What to build:** Go module/binary with help/version/explicit unsupported init, tests, no Bash CLI dispatch or side effects, and up-to-date user-facing current-state documentation.

- [ ] Go CLI builds and tests via `go test ./...` and supports help/version.
- [ ] `init` and unknown commands return explicit nonzero errors, no writes.
- [ ] Retire the current shell executable/adapters, keeping history/schema reference where appropriate.
- [ ] Native pnpm `ex` bridge points to Go, not old Bash entrypoint.
- [ ] README differentiates prior v1/v2 shell abilities from not-yet-implemented Go equivalents.
