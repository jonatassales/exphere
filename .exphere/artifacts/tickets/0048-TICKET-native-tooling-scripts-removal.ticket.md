# TOOLS-NATIVE-01: Eliminate project wrapper-script directories

**Spec:** [SPEC-NATIVE-TOOLING-NO-SCRIPTS v1](../specs/0026-SPEC-native-scripts-retirement.spec.md)
**Status:** ready-for-agent
**Approval:** Owner's explicit October 13, 2026 repository-wide scripts-directory removal.
**Blocked by:** [CLI-GO-01](0047-TICKET-go-cli-scaffold.ticket.md) must provide a native Go entrypoint.

**What to build:** Delete scripts directories outside the Go CLI package, replace wrapper calls with native CLI/pnpm/Husky/Next/Turbo equivalents, revise GitHub Actions, and correct live documentation references.

- [ ] No `scripts/` path except allowed Go CLI ownership appears in the committed Git tree.
- [ ] Root/workspace package scripts use direct Turbo/Next/TypeScript/Go commands.
- [ ] Husky and CI run native commands and contain no deleted path references.
- [ ] Removed shell-only tests and independent-agent review jobs are documented with honest coverage gaps.
- [ ] Applicable native build/test commands are executed or explicitly reported blocked.
