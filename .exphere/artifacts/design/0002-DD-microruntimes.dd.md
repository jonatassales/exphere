# Microruntimes — requirements and hypotheses

Consolidated from discussions with the user. **Evolving draft.** The separate `packages/cli/` now contains only a Go `ex` scaffold; former shell runtime commands are retired. The SDK TypeScript API remains empty. Requirements below remain proposed contracts, not current Go capabilities. The current institutional proposal is documented in [the institutional workflow design](0003-DD-institutional-workflow.dd.md); agent conduct is governed by the root AGENTS file.

The architecture proposal is consolidated in [the microruntime architecture decision](0005-DD-microruntime-architecture.dd.md), which retains the legacy decision ID `ADR-0001` and the `proposed` state. This document records requirements and measurement details.

**Implementation status:** `packages/cli/cli/` reads local descriptors, forwards explicit commands to Terraform or Kubernetes, and runs consumer-provided `.sh` hooks. The `components` map is opaque: it does not generate infrastructure, inject resources, or enforce policies. The quality, observability, evidence, distribution, and complete lifecycle contracts below remain requirements or proposals. The existence of the CLI does not establish any operational result. See [the initial CLI contract](../../../packages/cli/cli/README.md).

## Intent and requirements expressed by the user

1. Support installation and removal across projects; explore SDK distribution. The language, package manager, and distribution mechanism for the broader capability have not yet been selected.
2. Provide inversion of control and decision ownership: the consumer defines the stack, components, configuration, computing resources, and use case details within organizational requirements. Avoid making one application's architecture mandatory for every repository.
3. Allow each microruntime to bring together the tests relevant to its use case: smoke, load, stress, and end-to-end tests, with their supporting artifacts.
4. Use scenarios in Gherkin files to document test intent and criteria. This does not adopt BDD, select Cucumber, or require direct execution of `.feature` files.
5. Allow resource configuration and require compliance with measurable criteria for load, quality, CPU, memory, storage, and latency. Document availability and recovery according to service criticality. Concrete targets depend on the product and execution conditions.
6. Develop a reusable platform capability that increases consumer autonomy and supports sharing across repositories.
7. Connect execution and verification to guardrails, traceability, and evidence. Local execution should use criteria consistent with production needs, without claiming to reproduce production capacity or prove operational readiness.
8. Define use cases with the teams involved through discovery, PRDs, and joint technical design.
9. Require observability, tests, and security guardrails as platform contracts. Facilitate decisions, adoption, and automation across teams while respecting each consumer's technical leadership and domain knowledge.
10. Treat memory leaks as defects to detect, diagnose, and correct. Turn the intent to prevent them into verifiable criteria without promising that a finite execution proves the complete absence of leaks.

## Architecture principle defined by the user

Initial statement, translated: “Build the platform without making the decisions; delegate the decisions to the people using the platform.”

The subsequent clarification guides this project: delegate stack, component, and composition decisions to the consumer's technical leads and architects; require platform contracts for security, tests, observability, resources, and quality that protect the business. The user has already established this division. Do not reopen it as though the intent were to remove governance or transfer every responsibility to the consumer.

The platform's role is to facilitate decisions, adoption, and automation by establishing verifiable requirements and enforcement mechanisms. Do not assume hierarchical authority over every team's architects or organizational adoption of this proposal.

| Decision or responsibility | Owner in the proposed model |
| --- | --- |
| Stack, application components, composition, and execution choice, such as Compose or Kubernetes | Technical leadership or architecture of the consuming project, within supported capabilities and organizational policies |
| Mandatory contracts, required tests, observability, security, resource protection, and verification automation | The microruntimes platform, aligned with the organizational owners of each policy |
| Concrete targets for latency, availability, capacity, and recovery | Product and architecture owners, aligned with the business and the teams operating the service |
| Resource configuration to meet the targets | The consumer team; the platform verifies compatibility, quotas, and applicable policies |
| Domain-specific instrumentation and criteria | The consumer team supplies them; the platform requires, integrates, and verifies evidence |

Design details still to develop include supported adaptations, the process for new integrations, policy versioning, and exceptions. Consumer choice does not automatically imply support for every technology: a missing capability must be declared, never presented as satisfied. Defaults help adoption without replacing the consumer's stack decisions.

## Assistant proposals for discussion — not approved decisions

- Make inversion of control explicit throughout the lifecycle: prepare, start, wait for readiness, perform checks, collect evidence, and clean up; invoke consumer-provided extensions and tests.
- Offer useful initial profiles and optional advanced configuration while preserving the decision ownership defined above.
- Separate generic tools and checks from each application's scenarios, data, and success criteria.
- Connect Gherkin scenarios, executable tests, and evidence through stable identifiers without imposing a Gherkin runner.
- Define ownership and isolation for created resources. Distinguish removing the tool, ending an execution, and deleting persistent data.
- Share intent and criteria across local, CI, and remote profiles while stating each executor's differences and capabilities. The CLI offers a Kubernetes adapter; adoption remains optional and belongs to the consumer.
- Measure the load generator separately from the application and record intended versus actual load.

## Quality contract: criteria to specify

The dimensions below are part of the requested requirements. Their measurement methods are an initial documentation refinement; field names, instruments, values, and profiles still need specification. They are not confirmed organizational targets.

| Dimension | What to declare | What to measure and verify |
| --- | --- | --- |
| CPU | Requested resources, limits, load conditions, and tolerance for CPU restrictions | Average and peak usage, throttling, and saturation; relate usage to latency and throughput without imposing a universal percentage |
| Memory | Capacity, limits, warmup, duration, and growth tolerance per scenario | Resident memory and, where available, heap or retained memory, peaks, sustained growth, OOMs, and restarts; apply specific leak criteria |
| Storage | Capacity, persistence, temporary space, data volume, and input/output targets | Occupancy, growth, read/write latency, throughput, and IOPS where relevant; behavior near limits and cleanup limited to owned resources |
| Load | Arrival rate or concurrency, operation distribution, duration, warmup, ramps, and data | Actual load, throughput, iterations that did not start, queues, timeouts, and errors; also verify load generator capacity |
| Functional quality | Critical scenarios, inputs, expected results, and required tests | Correct behavior, business invariants, and successful scenarios; link each requirement to its test and evidence |
| Latency and errors | Relevant operations or journeys, percentiles or share below a threshold, window, and load | p95/p99, share of operations within the objective, errors, and timeouts; distinguish success from failure and avoid a global average that hides degradation |
| Availability | SLI, SLO, covered population or journey, window, and error budget | Availability experienced by users in operation and error budget consumption; recovery tests provide complementary evidence, not proof of uptime |
| Recovery | Failures to exercise and restoration or data-loss objectives where applicable | Recovery time and data integrity; RTO and RPO are distinct from availability |
| Dependencies | Queues, connections, timeouts, and services used by the case | Consumer lag, queue depth, connection wait time, and failure propagation |
| Cost and lifecycle | Budget, maximum duration, expiration, and ownership | Usage per execution, resources left behind, and estimated cost with explicit assumptions |

Each criterion must record its owner, scope, indicator and unit, measurement source, load condition, window or duration, approval rule, and response to a violation. When it does not apply, record the rationale under the profile's policy. This is an initial semantic contract, not a final schema definition.

### Memory and prolonged tests

Include soak tests for scenarios where leaks or degradation over time matter, alongside smoke, load, stress, and end-to-end tests. Define duration, warmup, load, data, and criteria with the service owner.

- Look for sustained, unintended memory growth after warmup and across comparable cycles; account for caches and the chosen technology's garbage collection and allocation behavior.
- Combine memory metrics with allocator or heap profiles or snapshots when supported and needed for diagnosis. Traces help correlate operations; they do not, on their own, establish the presence or absence of leaks.
- A confirmed leak or violation of the defined criterion fails verification. Restarts must not conceal growth; evidence must include OOMs, restarts, and truncated tests.
- A passing result means the criteria were met under the observed conditions. Do not claim a “guarantee of zero memory leaks.”

### Availability and business objectives

Turn “almost 100%” into an explicit service or journey objective. Define eligible events or populations, the measurement point, window, acceptable error, and owners. Business, architecture, and operations agree on the target; the platform requires its declaration and supports measurement and associated policies.

Illustrative example only: at least 99.95% of eligible requests in a journey succeed over a rolling 30-day window. The corresponding error budget is 0.05% of eligible requests. This is an event-based SLO; it does not automatically translate into a number of downtime minutes. Eligibility and success criteria would still need to be defined.

Local and CI tests verify behavior, performance, and recovery under their test conditions. Meeting an operational SLO requires telemetry from operation throughout the defined window. A passing health check or running containers do not establish availability of the user's journey.

### Observability, evidence, and enforcement

Require signals appropriate to the case and collected in a verifiable way: resource and service metrics, event and failure logs, journey tracing, and profiling when needed. Correlate evidence with the execution, component versions, effective configuration, load profile, and policy version. Define sampling, coverage, and sensitive-data handling. No observability provider has been selected.

Separate resource configuration, measured behavior, and the compliance decision. A declared memory limit does not prove healthy usage; an existing test does not prove a pass; an available trace does not replace every other form of evidence.

The refinement proposes three results for each verification: **passed**, **failed**, and **inconclusive**. Missing mandatory evidence, unmet load, or invalid measurement prevents approval; the policy determines whether the occurrence is a requirement failure or an inconclusive result. Closing a mandatory verification in these conditions blocks its approval without prescribing automatic interruption of a production service.

For CI, violating a mandatory criterion must block the corresponding approval. For operations, define an alert, owner, and response appropriate to the impact; actions such as rollback or interruption need their own policy. Do not automate destructive actions merely because a metric exceeds a value.

Define the exception process later: authorized owner, rationale, deadline, and evidence. The consumer cannot silently weaken a mandatory policy by changing its descriptor.

### Limits and portability

In Kubernetes, requests participate in scheduling; limits constrain usage, with different behavior for CPU and memory. Quotas limit aggregate usage per namespace. Other executors may provide different mechanisms and guarantees; document each integration's capabilities and limitations. Do not impose Kubernetes as a prerequisite for the concept.

Do not present generic CPU, memory, or traffic numbers as recommended sizing for an organization. Record computing resources and execution conditions to support valid comparisons. Local tests do not establish production capacity, and documentary Gherkin files do not prove execution.

## Research sources

- [Platforms, composition, autonomy, standards, and cognitive load](https://tag-app-delivery.cncf.io/whitepapers/platforms/)
- [Container and Pod resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Namespace quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [Latency, traffic, errors, and saturation](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Load-test thresholds](https://grafana.com/docs/k6/latest/using-k6/thresholds/)
- [Load models and arrival rates](https://grafana.com/docs/k6/latest/using-k6/scenarios/concepts/open-vs-closed/)
- [Gherkin and its relationship to execution](https://cucumber.io/docs/)
- [BDD as a process](https://cucumber.io/docs/bdd/)
- [Inversion of control](https://martinfowler.com/bliki/InversionOfControl.html)
- [SLOs, SLIs, error budgets, and stakeholder agreement](https://sre.google/workbook/implementing-slos/)
- [Metrics, logs, traces, and profiles](https://opentelemetry.io/docs/concepts/signals/)
- [Soak tests](https://grafana.com/docs/k6/latest/testing-guides/test-types/soak-testing/)

## Next open decisions

Pilot use case; boundary between the SDK and its configured instance; contract or schema; installation and removal mechanism; supported execution integrations; runners and instrumentation; operational ownership; resource and quality values and profiles; policy versioning and exceptions; portal, CI, and observability integration; and measures of developer benefit. The division between consumer decisions and platform requirements is already defined above.
