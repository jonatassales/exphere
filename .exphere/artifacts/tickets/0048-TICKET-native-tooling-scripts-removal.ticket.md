# TOOLS-NATIVE-01: Eliminate project wrapper-script directories

**Spec:** [SPEC-PR19-COMPLETION v1](../specs/0028-SPEC-pr19-completion.spec.md)
**Focused contract:** [SPEC-NATIVE-TOOLING-NO-SCRIPTS v1](../specs/0026-SPEC-native-scripts-retirement.spec.md)
**Status:** in-review
**Approval:** Owner's explicit October 13, 2026 repository-wide scripts-directory removal.
**Blocked by:** [CLI-GO-01](0047-TICKET-go-cli-scaffold.ticket.md) must provide a native Go entrypoint.

**What to build:** Delete scripts directories outside the Go CLI package, replace wrapper calls with native CLI/pnpm/Husky/Next/Turbo equivalents, revise GitHub Actions, and correct live documentation references.

- [x] No `scripts/` path except allowed Go CLI ownership appears in the committed Git tree.
- [x] Root/workspace package scripts use direct Turbo/Next/TypeScript/Go commands.
- [x] Husky and CI run native commands and contain no deleted path references.
- [x] Removed shell-only tests and independent-agent review jobs are documented with honest coverage gaps.
- [x] Applicable native build/test commands are executed or explicitly reported blocked.
