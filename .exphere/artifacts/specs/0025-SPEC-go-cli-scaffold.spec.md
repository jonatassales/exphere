# Go-only Exphere CLI scaffold

- ID: `SPEC-GO-CLI-SCAFFOLD`
- Document number: `SPEC-0025`
- Version: `1`
- State: `draft`
- Implementation authorization: owner's October 13, 2026 original request and PR #19 completion request; verification/review acceptance recorded separately.
- Integrated delivery: [SPEC-PR19-COMPLETION](0028-SPEC-pr19-completion.spec.md); this remains the focused contract, with the original stable ID preserved.
- PRD: [PRD-GO-CLI-NATIVE-TOOLING](../prd/0007-PRD-go-cli-and-native-tooling.prd.md)
- ADR: [ADR-0003](../design/0011-DD-go-cli-native-tooling.dd.md)
- Ticket: [CLI-GO-01](../tickets/0047-TICKET-go-cli-scaffold.ticket.md)
- Baseline: `d6b3c8abff240c54011f81f7088f445e3fbabef4`.

## Contract

Build a dependency-free Go module in the Exphere CLI package with a root
command `ex` (future `exphere` invocation), `help`, `version` and
explicit `init` scaffold. No shell CLI dispatch, subprocess shell or
Terraform/Kubernetes side effects. `init` exits nonzero with a clear
"not implemented yet" message, and rejects unsupported flags/arguments.
Unknown commands return a useful nonzero usage code. No claimed
npm `exphere` publication is made.

Keep Go command tree simple enough for stdlib; Cobra/Viper from the requested
Go skills are future choices when meaningful nested commands exist. Use
testable `run(args, out, err)` style function, deterministic stdout/stderr,
and `go test` for help/version/errors. The executable Go module is a
scaffold, not a parity migration of the previous shell `ex runtime` CLI.

Keep historical architecture/JSON schemas and fixture evidence separately
from executable Go paths as necessary; scrub live installation docs and
manifest references to retired shell commands. Go installation must not
silently change the user's PATH or source shell scripts.

## Acceptance

| ID | Criterion |
| --- | --- |
| GO-CLI-01 | Go package compiles; `ex --help` and `ex version` return useful deterministic output. |
| GO-CLI-02 | `ex init` communicates scaffold-only unsupported behavior, does not write consumer files and exits nonzero. |
| GO-CLI-03 | Malformed/unknown arguments fail with nonzero status; output streams are consistent. |
| GO-CLI-04 | Existing shell CLI executable/adapter path is retired, not advertised as functional. |
| GO-CLI-05 | Native package/root task aliases invoke Go directly; tests compile via Go toolchain. |
| GO-CLI-06 | Do not advertise `npx exphere init` as currently working; no npm publish. |

## Verification

Use `go -C packages/cli test ./...`, `go -C packages/cli vet ./...`,
and `go -C packages/cli run ./cmd/ex --help` after writing the scaffold.
Review documentation truthfulness and absence of any hidden Bash/runtime
execution. Partial compatibility is never a pass.
