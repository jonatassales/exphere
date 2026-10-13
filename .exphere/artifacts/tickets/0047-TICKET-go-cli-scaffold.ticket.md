# CLI-GO-01: Establish the Go-only Exphere CLI scaffold

**Spec:** [SPEC-PR19-COMPLETION v1](../specs/0028-SPEC-pr19-completion.spec.md)
**Focused contract:** [SPEC-GO-CLI-SCAFFOLD v1](../specs/0025-SPEC-go-cli-scaffold.spec.md)
**Status:** in-review
**Approval:** Owner's October 13, 2026 Go-only CLI direction and scaffold-only limit.
**Blocked by:** None.

**What to build:** Go module/binary with help/version/explicit unsupported init, tests, no Bash CLI dispatch or side effects, and up-to-date user-facing current-state documentation.

- [x] Go CLI builds and tests via `go test ./...` and supports help/version.
- [x] `init` and unknown commands return explicit nonzero errors, no writes.
- [x] Retire the current shell executable/adapters, keeping history/schema reference where appropriate.
- [x] Native pnpm `ex` bridge points to Go, not old Bash entrypoint.
- [x] README differentiates prior v1/v2 shell abilities from not-yet-implemented Go equivalents.
