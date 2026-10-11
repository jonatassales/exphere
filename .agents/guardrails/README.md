# Project guardrails

## Scope

The user adopted FinOps and Twelve-Factor on October 10, 2026 as local work and review policies. Advisory SDD traceability was authorized on October 11, 2026. Other institutional contracts remain proposals. Approval of these policies does not validate the scaffold or imply adoption by another organization. The user's authorization instructions in AGENTS continue to govern the current work.

| Active policy | Scope | Agent application |
| --- | --- | --- |
| [SDD v1](../../.exphere/guardrails/sdd.md) | Commit/ticket and PR/spec traceability; warning-only local checks | [SDD rule](../../.exphere/rules/sdd.md) |
| [FinOps v1](finops.md) | Resources, cost allocation, estimates, budgets, consumption, and results | [rules/finops.md](../rules/finops.md) |
| [Twelve-Factor v1](twelve-factor.md) | Application interfaces with configuration, dependencies, and execution environment | [rules/twelve-factor.md](../rules/twelve-factor.md) |

## Evidence and application

For affected criteria, record the policy ID and version, target/revision, owner, verification method, and evidence. Reuse the [spec](../templates/spec.md), [verification plan](../templates/verification-plan.md), and [review](../templates/review.md); do not create a parallel ticket system or a full report for every documentation edit.

| State | Meaning |
| --- | --- |
| `compliant` | The criterion was met with sufficient evidence within the recorded scope and conditions. |
| `non-compliant` | Evidence shows a violation; record the required correction or decision. |
| `not-verified` | Evidence is missing, or verification has not been authorized or implemented. This is not approval. |
| `not-applicable` | The criterion does not cover this target or change; record the reason. Do not use this state to hide a failure. |
| `authorized-exception` | A valid deviation decision records scope, owner, rationale, compensating controls, and validity/review. This is not technical compliance. |

A violation or missing mandatory evidence prevents a compliance claim. SDD v1 is explicitly advisory: missing SDD links warn without blocking local delivery; this exception does not weaken failed quality checks or other policies. For other mandatory policies, missing evidence prevents a recommendation that the dependent action is ready. The agent continues authorized independent work. Assess the affected changes and record preexisting limitations without automatically expanding the scope.

Exceptions use the existing [decision format](../templates/decision.md); authorizations already given by the responsible person count, without repeated requests. The user decides local exceptions in this project. Organizational owners and the exception process for external adoption remain undefined.

**Technical state:** these rules guide the agent and review. The `ex` CLI and CI do not read or enforce these guardrails. Current `ex runtime validate` checks descriptors and paths, without certifying costs, security, factors, or operational quality. Local Git hooks provide selected blocking developer checks and advisory SDD identity diagnostics. They do not provide a general policy engine or authenticated approval; billing integrations remain absent.

## Boundaries

- Identify sources, owners, versions, and links between objectives, PRD/spec, tickets, changes, and evidence.
- Approval concerns explicit artifacts and scope; an LLM score is not a human decision.
- Consumers choose stack and composition; the contract requires results and instrumentation appropriate to the case.
- The service owner defines targets with business and operations stakeholders, within any agreed organizational requirements.
- Gherkin and PRDs document intent; links to tests do not prove complete semantic equivalence. Review remains necessary.
- Security and quality require checks outside skill text. Prompts do not replace access control, tool restrictions, or executable gates.
- Missing mandatory evidence prevents a compliance claim; the advisory SDD exception above does not weaken other approval conditions. A generator unable to achieve the planned load does not prove application capacity.
- POC results do not prove production availability or scale.

## Extensions and changes

An extension must state which contracts it can meet and its limitations. The proposal does not require every team to use identical internal details. Executor certification and adoption across teams remain open; minimum local exception records are defined above.

## Metrics

Use the [verification plan](../templates/verification-plan.md) for CPU, memory, storage, load, quality, and availability. Each criterion needs a unit, source, conditions, window, and owner. Define the operational response separately from a test result; do not assume automatic production interruption.
