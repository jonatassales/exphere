# Delete wrapper script directories and use native tool entrypoints

- ID: `SPEC-NATIVE-TOOLING-NO-SCRIPTS`
- Document number: `SPEC-0026`
- Version: `1`
- State: `approved for implementation; verification pending`
- PRD: [PRD-GO-CLI-NATIVE-TOOLING](../prd/0007-PRD-go-cli-and-native-tooling.prd.md)
- ADR: [ADR-0003](../design/0011-DD-go-cli-native-tooling.dd.md)
- Ticket: [TOOLS-NATIVE-01](../tickets/0048-TICKET-native-tooling-scripts-removal.ticket.md)
- Blocked by: [CLI-GO-01](../tickets/0047-TICKET-go-cli-scaffold.ticket.md)
- Baseline: `d6b3c8abff240c54011f81f7088f445e3fbabef4`.

## Contract

Remove every tracked `scripts/` directory outside `packages/cli/`,
including repository root, the website, design/web/sdk packages, and any
vendored helper-script folder under FinOps skills. There may be **zero**
`scripts/` directories left; the sole permitted future location is inside
the Exphere CLI package.

Update root/package `package.json` task aliases to call installed native
commands directly: Turbo, Next, tsc, node for token compiler, Biome, Go,
Husky, lint-staged, commitlint. Never silently replace a failing test with a
green `echo`/empty command.

- Preserve blocking build and lint tasks where feasible.
- Replace nonessential shell wrapper setup with `husky` CLI, no automatic
  user-profile mutation.
- Remove/replace the root GitHub workflow that depends on deleted
  `scripts/agent-review` with standard package and Go verification.
  Record explicitly if the independent agent review provider is no longer
  available; do not pretend the workflow still runs.
- Move or remove obsolete Bash-only CLI tests whose runtime was retired.
  Preserve useful fixtures/schemas as historical examples only if clearly
  labeled non-executable.
- Retain meaningful design/web tests under legitimate test ownership when
  practicable, but if their orchestration needs new code, declare any
  residual coverage gap and keep PR draft until resolved.
- Update active README, instructions and hook/path references. Historical
  review records may retain path mentions if marked historical.

## Acceptance

| ID | Criterion |
| --- | --- |
| NO-SCRIPTS-01 | No `scripts/` directories exist outside the Exphere CLI package. |
| NO-SCRIPTS-02 | Every live package.json command resolves to an installed native CLI/Go task; no `scripts/` strings remain in live entrypoints. |
| NO-SCRIPTS-03 | Husky hooks and GitHub Actions reference no deleted files and enforce meaningful checks instead of silent success. |
| NO-SCRIPTS-04 | Go scaffold/website build dependencies in Turbo remain ordered. |
| NO-SCRIPTS-05 | Docs distinguish lost Bash test harness/agent-review provider behavior and unverified replacements. |
| NO-SCRIPTS-06 | No staged deletions of unrelated assets, third-party license text or historical artifacts. |

## Verification

Inspect Git tree for directory names, grep active file sources/entrypoints
for dead paths, run `pnpm check`, `pnpm build`, `pnpm test`,
Go test and CI. A clean source diff does not replace execution; missing
lockfile/toolchain/fixture tests remain blocking gaps.
