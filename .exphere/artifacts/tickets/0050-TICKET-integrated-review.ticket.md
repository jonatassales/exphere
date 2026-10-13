# INTEGRATE-01: Verify the combined docs, Go and skills migration

**Spec:** [SPEC-NATIVE-TOOLING-NO-SCRIPTS v1](../specs/0026-SPEC-native-scripts-retirement.spec.md)
**Status:** ready-for-agent
**Approval:** The owner's request for a complete reviewed feature branch and PR.
**Blocked by:** WEB-DOCS-01, CLI-GO-01, TOOLS-NATIVE-01 and SKILLS-OWN-01.

**What to build:** Validate the combined branch without suppressing missing evidence. Reconcile dependency lock changes, test the Nextra/Orbo/docs experience, run Go tests, verify no dead script or skill links, record Standards+Spec reviews and publish one PR.

- [ ] All newly enabled Nextra/Orbo dependencies pinned and frozen-lock install verified.
- [ ] Go tests/vet and native package tasks run or errors/blockers recorded.
- [ ] Website SSR, Nextra MDX route, Docs navigation, accessible footer/copy and motion verified where possible.
- [ ] Tree contains no unwanted `scripts/`, duplicate AIHero skills or obsolete writing-for-agents/adr.
- [ ] PR shows all linked parent specs/tickets and exact evidence/status; no merge/deploy.
