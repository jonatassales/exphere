# Research — Sedai, CAST AI, ProsperOps, Infracost, and Port

- **Research date:** October 10, 2026, America/Sao_Paulo.
- **Status:** documentary research for discussion. This is not an architecture decision, an approved specification, or evidence of execution.
- **Question:** which capabilities do these five products share, in what proportions, and with what differences in scope?
- **Context:** investigate the platform, DevEx, and FinOps landscape before defining a microruntime prototype.
- **Research boundary:** documentation only. Infrastructure consumption impact: **not applicable**; no account, integration, cloud resource, or automation was activated.
- **Freshness:** findings and availability classifications reflect the research date. Translation and document reorganization do not constitute a new verification of the products.

## 1. Main findings

All five products document access controls, operating constraints, some history of changes, and data extraction. Cost visibility also appears in all five, although Port depends on external sources for that information. Financial grouping or allocation was confirmed in four. These overlaps do not make the products equivalent: the controlled object may be a financial commitment, a workload, an IaC change, or a platform action.

The most useful grouping for understanding the competitive landscape is:

| Product | Demonstrated focus | Relationship to the engineering workflow |
|---|---|---|
| **Sedai** | Optimization of running resources, operational observability, and FinOps. | Connects runtime optimization to policies and, in supported integrations, IaC changes through PRs. [Modes][S-modes] · [IaC][S-iac] |
| **CAST AI** | Efficiency, costs, and automation for Kubernetes workloads and nodes. | Operates on running environments through APIs, CLI, MCP, and policies; PR automation through APA remains in private preview. [Autoscaler][C-autoscaler] · [APA][C-apa] |
| **ProsperOps** | Commitment/discount optimization and resource scheduling. | Automates financial decisions and operating schedules, including configuration through tags set by resource owners. [ADM][R-approval] · [Scheduler][R-scheduler] |
| **Infracost** | Cost and policies integrated into code, PRs, and waste remediation. | Provides the most direct overlap with FinOps in developers' daily work; also uses production data. [Platform][I-platform] · [Fix][I-fix] |
| **Port** | Catalog, context, self-service, and orchestration of platform workflows. | Coordinates people, agents, actions, and external systems. Provides the most direct overlap with an integrated software factory workflow. [Resource management][P-overview] |

**Implications for microruntimes:** combining FinOps, agents, guardrails, and workflows already has substantial overlap with existing products, particularly Infracost and Port, as well as Sedai's connections to code. The more specific hypothesis of a portable contract per use case, installed through an SDK and executable locally and remotely, remains a research question. This study does not demonstrate commercial exclusivity for that hypothesis.

## 2. Method and interpretation of percentages

Sources included official product documentation, API references, integration guides, and vendor-maintained repositories. Official announcements were used to distinguish documented features from preview and roadmap items.

No demos, installations, authenticated calls, product tests, or price/contract validation were performed. Documentation alone does not demonstrate operational quality, coverage across all plans, or availability to every customer.

### Legend

| Symbol | Meaning | Included in the percentage? |
|---|---|---|
| **D** | Documented native capability within the stated scope. May depend on cloud APIs, Git, or an identity provider as part of normal operation. | Yes |
| **I** | A documented specific integration in which another tool or backend supplies an essential part of the capability. Requires configuration; does not mean the integration is installed. | Yes, only under “Documented” |
| **P** | Explicitly identified preview, early access, or roadmap item. The note identifies which one; these states are not equivalent. | No |
| **?** | Unconfirmed within the sources reviewed, or the available evidence does not satisfy the row's exact definition. | No |
| **No** | Official documentation explicitly denies the capability. | No |

- **Documented = (D + I) ÷ 5 × 100.**
- **Native = D ÷ 5 × 100.**
- Sort order: descending “Documented”; ties are sorted by descending “Native.”
- Each product counts once per row. Multiple modules do not count as additional products.
- The denominator remains five even when information is unconfirmed. Results represent **documented coverage within this sample**, not estimated coverage across the market.
- **100% does not imply equal depth, mechanisms, plans, or end-to-end integration.**
- **20% does not mean only one vendor exists in the market.**
- Capabilities are deliberately separated. Rows are neither independent nor equal in commercial value; adding them into a product score would be misleading.
- Extensibility does not earn credit for everything a customer could build. Templates with illustrative execution alone do not establish the completed capability.

## 3. Matrix ordered by shared capabilities

Each linked symbol points to the main supporting evidence. Qualifications in the following sections are part of the table's interpretation.

| # | Capability — abbreviated definition | Sedai | CAST AI | ProsperOps | Infracost | Port | Documented | Native |
|---:|---|:---:|:---:|:---:|:---:|:---:|---:|---:|
| 1 | Role- and scope-based access control (RBAC) | [D][S-rbac] | [D][C-rbac] | [D][R-rbac] | [D][I-rbac] | [D][P-rbac] | **100% (5/5)** | 100% |
| 2 | Configurable constraints on product actions and decisions | [D][S-modes] | [D][C-policies] | [D][R-settings] | [D][I-guardrails] | [D][P-governance] | **100% (5/5)** | 100% |
| 3 | History or evidence of changes within the product's scope | [D][S-activity] | [D][C-audit] | [D][R-scheduler] | [D][I-guardrails] | [D][P-audit] | **100% (5/5)** | 100% |
| 4 | Data export or programmatic extraction | [D][S-ticketing] | [D][C-api] | [D][R-export] | [D][I-api] | [D][P-cli] | **100% (5/5)** | 100% |
| 5 | Visibility into estimated or observed costs | [D][S-finops] | [D][C-cost] | [D][R-showback] | [D][I-budgets] | [I][P-business] | **100% (5/5)** | 80% |
| 6 | Identification of cost optimization opportunities | [D][S-optimization] | [D][C-opportunities] | [D][R-analysis] | [D][I-idle] | ? | **80% (4/5)** | 80% |
| 7 | Comparison of savings or avoided cost against a stated baseline | [D][S-optimization] | [D][C-savings] | [D][R-savings] | [D][I-guardrails] | ? | **80% (4/5)** | 80% |
| 8 | Native public API for automation | [D][S-api] | [D][C-api] | ? | [D][I-api] | [D][P-cli] | **80% (4/5)** | 80% |
| 9 | Cost grouping/allocation by organizational context | [?][S-groups] | [D][C-allocation] | [D][R-azure] | [D][I-properties] | [I][P-kubecost] | **80% (4/5)** | 60% |
| 10 | Execution of changes to cloud resources or commitments | [D][S-execution] | [D][C-autoscaler] | [D][R-approval] | ? | [I][P-resources] | **80% (4/5)** | 60% |
| 11 | Use of workload operational metrics, such as CPU and memory | [D][S-kubernetes] | [D][C-efficiency] | ? | [I][I-datadog] | [I][P-kubecost] | **80% (4/5)** | 40% |
| 12 | Executable schedules for scaling down, stopping, or hibernating resources | [D][S-schedules] | [D][C-hibernate] | [D][R-scheduler] | ? | [?][P-environments] | **60% (3/5)** | 60% |
| 13 | Monetary infrastructure consumption budget with tracking/notifications | [D][S-finops] | [D][C-budgets] | [?][R-budget] | [D][I-budgets] | [?][P-environments] | **60% (3/5)** | 60% |
| 14 | LLM-based assistant or agent | [P][S-sed] | [D][C-opspilot] | [No][R-noai] | [D][I-fix] | [D][P-ai] | **60% (3/5)** | 60% |
| 15 | Official product MCP server | [P][S-sed] | [D][C-mcp] | ? | [D][I-mcp] | [D][P-mcp] | **60% (3/5)** | 60% |
| 16 | Official CLI for operating the product | ? | [D][C-cli] | ? | [D][I-cli] | [D][P-cli] | **60% (3/5)** | 60% |
| 17 | Recommendation or use of cloud commitments/discounts | [D][S-finops] | [D][C-commitments] | [D][R-approval] | ? | ? | **60% (3/5)** | 60% |
| 18 | Generation/synchronization of code changes through PRs | [D][S-iac] | [P][C-apa] | ? | [D][I-fix] | [I][P-iac] | **60% (3/5)** | 40% |
| 19 | Automatic rightsizing of running Kubernetes workloads | [D][S-kubernetes] | [D][C-workloads] | ? | [?][I-fix-ga] | ? | **40% (2/5)** | 40% |
| 20 | Cloud spending forecast based on observed history | [D][S-finops] | [D][C-cost] | [?][R-noai] | ? | ? | **40% (2/5)** | 40% |
| 21 | Detection of financial consumption anomalies | ? | [D][C-notifications] | ? | [I][I-anomalies] | ? | **40% (2/5)** | 20% |
| 22 | Monetary estimate from IaC before deployment | ? | ? | ? | [D][I-docs] | [?][P-terraform] | **20% (1/5)** | 20% |
| 23 | Merge blocking based on an estimated cost threshold | ? | ? | ? | [D][I-guardrails] | ? | **20% (1/5)** | 20% |
| 24 | Automatic purchase/adjustment of financial commitments | ? | [?][C-commitments] | [D][R-approval] | ? | ? | **20% (1/5)** | 20% |
| 25 | Budget combining observed spending and estimated PR impact | ? | ? | ? | [D][I-budgets] | ? | **20% (1/5)** | 20% |
| 26 | Software catalog and developer self-service actions | ? | ? | ? | ? | [D][P-overview] | **20% (1/5)** | 20% |
| 27 | Standards scorecards for catalog entities | ? | ? | ? | ? | [D][P-scorecards] | **20% (1/5)** | 20% |

The matrix covers **27 capabilities**: five with 100% documented coverage, six with 80%, seven with 60%, three with 40%, and six with 20%. This distribution depends on the definitions and conservative treatment of preview features and incomplete evidence.

## 4. Differences the percentages do not show

### 4.1 What the shared 100% core actually means

**RBAC:** all five document roles and some access scope. Equivalence between organization, billing account, cluster, resource group, and team isolation was not demonstrated. See the five links in the first row.

**Constraints:** Sedai limits modes and resources; CAST AI constrains operating policies; ProsperOps configures commitment decisions; Infracost controls changes and costs in PRs; Port governs actions and organizational context. This row does not claim a common policy-as-code language or equivalent blocking controls. [Sedai][S-modes] · [CAST AI][C-policies] · [ProsperOps][R-settings] · [Infracost][I-guardrails] · [Port][P-governance]

**History:** all five offer evidence, but the recorded object differs. Infracost's supporting evidence is the PR change/cost trail; a universal administrative audit log was not confirmed. ProsperOps provides the concrete example of the Scheduler event log. CAST AI distinguishes cluster auditing from organizational auditing, which is in early access. [Infracost][I-guardrails] · [ProsperOps][R-scheduler] · [CAST AI][C-audit]

**Extraction:** includes a documented API or export. ProsperOps exports CSV to S3; that does not establish a native public API, CLI, or MCP. Public API coverage therefore remains 80% even though extraction reaches 100%. [ProsperOps Data Export][R-export]

**Cost visibility:** includes estimates and observed spending. CAST AI reports cluster compute; Infracost combines change estimates and, in specific features, actual billing; ProsperOps allocates costs/discounts; Port presents data from sources such as AWS Cost and Kubecost. These are not five equivalent billing engines. [CAST AI][C-cost] · [Infracost][I-budgets] · [ProsperOps][R-showback] · [Port][P-business]

The separate **financial grouping/allocation** row reaches 80%. Sedai documents resource grouping by tags, owner, and environment, but the reviewed sources do not sufficiently demonstrate that these groups define cost allocation. It is therefore unconfirmed for that row. [Sedai Groups][S-groups]

### 4.2 Savings, forecasts, and budgets describe different things

The savings comparison row includes both observed results against a baseline and estimated avoided cost because both have an explicit reference. **These figures must not be aggregated as realized savings.**

- Sedai separates opportunities from completed optimizations and presents current cost/estimated savings; a complete baseline methodology was not verified. [Optimization][S-optimization]
- CAST AI uses a counterfactual/modeled baseline to report savings, requiring evaluation of that baseline's assumptions. [Savings report][C-savings] · [Savings baseline][C-baseline]
- ProsperOps exposes paid cost, gross/net savings, normalizations, and data finalization status. [Savings v2][R-savings]
- Infracost may calculate prevented cost from the difference between estimated PR versions. That difference is not a demonstrated bill reduction. [Guardrails][I-guardrails]

The **forecast** row requires a projection of cloud spending based on observed history. CAST AI documents a monthly projection using a moving average; Sedai includes forecasting in FinOps onboarding. A monthly price calculated from IaC alone does not meet the definition. Internal forecasting in the ProsperOps algorithm also does not establish a customer-facing overall spending forecast. [CAST AI][C-cost] · [Sedai][S-finops] · [ProsperOps][R-noai]

The **infrastructure budget** row excludes ProsperOps' prepayment budget: it limits commitment prepayments, not a project's total consumption. CAST AI's evidence is a budgets API labeled v1beta; broad commercial availability and an equivalent UI were not confirmed. Infracost documents budgets for AWS. None of these records establishes a universal ceiling that stops runtime consumption. [ProsperOps][R-budget] · [CAST AI][C-budgets] · [Infracost][I-budgets]

### 4.3 Autonomy, AI, and MCP are not synonyms

ProsperOps explicitly states that its platform does not use GenAI, ML, or LLMs and is not an agentic system; it describes mathematical optimization, constraints, and statistical forecasting. Its automation counts under execution, but not under LLM agents. [Official FAQ][R-noai]

Sedai presents Sed and its MCP as early access in the reviewed announcements. CAST AI, Infracost, and Port document official MCP support. For Infracost, the evidence is the official repository describing `infracost mcp`, rather than an inferred community server. [Sedai][S-sed] · [CAST AI][C-mcp] · [Infracost][I-mcp] · [Port][P-mcp]

MCP exposes tools and context. It does not establish correct permissions, approval policy, execution safety, or agent decision quality. Those properties require their own evidence.

### 4.4 A PR is not an applied infrastructure change

Sedai documents synchronization of optimizations with IaC through PRs/MRs. Infracost Fix produces outputs such as PRs, tickets, and agent handoffs; its documented AWS connection is read-only, and Notify mode requires action approval. This study therefore does not credit Infracost with directly changing cloud resources. [Sedai IaC][S-iac] · [Infracost Fix][I-fix]

CAST AI APA includes PRs, but is in **private preview**. Port has a guide for generating IaC through GitHub Copilot, classified as an integration; it establishes a path to a PR rather than a native FinOps remediation engine. [CAST AI APA][C-apa] · [Port IaC][P-iac]

Infracost's financial blocking control is a **PR check**, dependent on approval configuration and branch protection in the Git provider. It does not stop spending by infrastructure already running. [Guardrails][I-guardrails]

### 4.5 Orchestrating an operation does not supply its executor

Port documents resource actions executed through GitHub Actions and AWS CLI; this capability is classified as **I**. Its developer environments guide, however, illustrates parts of infrastructure execution with `echo`, which customers must replace with Terraform, Helm, or Pulumi. It was not counted as ready-to-run teardown under scheduling. [Cloud resources][P-resources] · [Developer environments][P-environments]

Similarly, a Terraform plan/apply workflow does not establish price calculation. Port was not credited with a monetary estimator before deployment merely because it can orchestrate Terraform. [Terraform workflow][P-terraform]

### 4.6 Operational metrics do not establish automatic control

Infracost documents read-only ingestion of Kubernetes metrics through Datadog, which does not establish available automatic rightsizing. Port receives metrics and costs through integrations such as Kubecost; no native autoscaler was identified. [Infracost Datadog][I-datadog] · [Port Kubecost][P-kubecost]

For financial detection, CAST AI documents anomaly notifications. Infracost Fix retrieves AWS anomalies and investigates their causes: **external detection and native investigation**. Generic data or dashboard access was not counted as a detector for the remaining products. [CAST AI][C-notifications] · [Infracost][I-anomalies]

## 5. Product analysis

### 5.1 Sedai

The reviewed capabilities combine billing analysis, resource grouping, optimization, and controlled execution. Datapilot, Copilot, and Autopilot modes represent different degrees of autonomy; actual limits depend on supported services and granted permissions. [FinOps][S-finops] · [Operation modes][S-modes]

For Kubernetes, workload documentation covers CPU, memory, replicas, and HPA interaction. This support must be distinguished from node optimization: availability varies across providers and autoscalers. EC2 documentation, for example, does not establish that every resource can operate in Autopilot. [Kubernetes][S-kubernetes] · [EC2][S-ec2]

The connection relevant to the software factory is the cycle between production observation, optimization, policy, and infrastructure code updates. The IaC integration associates a change with a repository and can generate a PR/MR. This addresses a central project concern: keeping runtime operations connected to the artifact that declares the infrastructure. [IaC][S-iac]

Activity Hub records action states and provides verification/rollback mechanisms in supported scopes. Release Intelligence compares release behavior, including traffic, errors, and latency; its score describes deviation and does not automatically establish improvement or causation. [Activity][S-activity] · [Release Intelligence][S-release]

**Evidence limits:** Sed/MCP is in early access; Impact is in private beta. A general CLI, automatic commitment purchasing, and a portable test package per use case were not confirmed. Uniform autonomy across all cloud services is also unsupported. [Sed][S-sed] · [FinOps][S-finops] · [API/SDK][S-api]

### 5.2 CAST AI

The product concentrates concrete Kubernetes operating capabilities. Its compute cost report estimates provisioned cluster compute from inventory and pricing, with projections and aggregations. **It does not necessarily represent the entire cloud bill.** Discounts and negotiated prices require separate treatment. [Cluster total compute cost][C-cost] · [Discount Engine][C-discounts]

Workload decisions differ from node decisions. Workload Autoscaling adjusts resource requests according to policies; the cluster autoscaler creates/removes nodes and coordinates consolidation, Spot, and fallback. This distinction informs microruntime contracts without deciding the project's architecture. [Workloads][C-workloads] · [Autoscaler][C-autoscaler]

The product provides a CLI, API, MCP, RBAC, and operation history. OpsPilot offers natural-language assistance, and a policy generation/review workflow is documented. This does not establish unrestricted assistant autonomy. [CLI][C-cli] · [API][C-api] · [MCP][C-mcp] · [OpsPilot][C-opspilot]

Use of existing commitments is documented; automatic purchasing was not confirmed. Hibernation can reduce compute, while control planes and persistent volumes may continue to incur costs. [Commitments][C-commitments] · [Hibernation][C-hibernate]

**Evidence limits:** APA is in private preview; organizational auditing is in early access; budget evidence concerns a v1beta API. An IaC estimate before deployment equivalent to Infracost, and a portable use-case/test SDK, were not confirmed. [APA][C-apa] · [Audit log][C-audit] · [Budgets API][C-budgets]

### 5.3 ProsperOps

Financial commitment optimization is the product's most distinctive focus. The system purchases/adjusts commitments within agreed settings, including payment preferences and tolerance for declining consumption. This differs from deciding application CPU, memory, or architecture. [Approvals][R-approval] · [Settings][R-settings]

Scheduler extends the scope to running resources: it starts, stops, or hibernates supported resources through tag-based configuration and event history. Resource owners can participate without operating the central console directly. This is a concrete example of delegating decisions to consumers through shared execution mechanisms. [Scheduler][R-scheduler]

Documented permissions include EC2 and RDS operations, but not resource deletion or instance type changes. Scheduler acts on schedule transitions; if someone restarts a machine after a stop event, documentation explains that it may remain on until the next event. It is therefore neither a continuous desired-state controller nor demand-based autoscaling. [IAM][R-iam] · [Schedules][R-schedules]

Showback and exports detail costs, discounts, and savings. Coverage must be checked per module: the website presents ADM for AWS/Azure/GCP; reviewed sources document Scheduler for AWS and Showback for AWS/Azure. [Product][R-home] · [Showback][R-showback] · [Export][R-export]

**Evidence limits:** the official FAQ says it does not use LLMs. Native MCP, CLI/API, monetary PR estimates, and Kubernetes rightsizing were not confirmed. Discounting EC2/Fargate used by containers does not mean changing requests, limits, or replicas. [Technology][R-noai] · [Containers][R-containers]

### 5.4 Infracost

Infracost provides the most direct evidence of FinOps integrated into development in this sample. IaC cost calculation connects to CLI, IDE, skills, PR comments/checks, and policies. This already covers part of the proposition that developers receive financial context before deployment. [Documentation][I-docs] · [Platform][I-platform] · [Agent skills/MCP][I-mcp]

The platform also covers production data. Documented AWS budgets combine accumulated consumption and the estimated impact of a change. Fix investigates idle resources, tagging issues, and anomalies, linking evidence to code and remediation actions. The reviewed announcement declares Fix generally available, so it was not classified entirely as beta. [Budgets][I-budgets] · [Idle resources][I-idle] · [Fix GA][I-fix-ga]

Autonomy remains bounded: Fix's AWS integration is read-only, and the getting-started guide describes Notify mode with approval. This supports investigation and remediation preparation without establishing that the product changes arbitrary infrastructure on its own. [Fix getting started][I-fix]

For Kubernetes, static YAML/Helm/Kustomize estimates work without a cluster, using pricing assumptions. Datadog ingestion is also available. Neither establishes available automatic rightsizing. The announcement places a rightsizing agent among future capabilities without confirming its execution mode. [Kubernetes][I-kubernetes] · [Datadog][I-datadog] · [Fix GA][I-fix-ga]

**Evidence limits:** an estimate is not an actual bill, an approved PR is not realized savings, and a budget is not a hard stop. The separate Infracost AI product describes scenarios in early access; this was not used to attribute general cloud forecasting to the product. [Scenarios][I-scenarios]

### 5.5 Port

Port is close to the architecture of an institutional platform workflow: catalog/context, self-service actions, automations, scorecards, permissions, and auditing. The reviewed documentation describes resources and agents within engineering workflows, integrating with tools that execute operations. [Overview][P-overview] · [Governance][P-governance] · [Audit log][P-audit]

Port can connect owner, service, cost, state, and standards while Kubecost/AWS Cost supply financial information and external pipelines apply infrastructure. Building this connection has value without turning Port into a native pricing, forecasting, or autoscaling engine. [Business context][P-business] · [Cloud resources][P-resources]

AI capabilities include agents, invocation logs, tools, and MCP integration. Guides cover preparing work, generating IaC through coding agents, and investigating incidents using external telemetry. Port invocation traceability is not equivalent to natively collecting traces from every application service. [AI work items][P-ai] · [IaC][P-iac] · [Dynatrace][P-dynatrace] · [MCP][P-mcp]

A guide also covers distributing agent rules across repositories. This overlaps with context/harness governance, but checking a rule's presence does not prove every execution complied with it. [Coding rules][P-rules]

**Evidence limits:** the environments guide requires implementation of the provisioning backend; its budget example is a suggested extension. AI Gateway integration can expose provider limits such as LiteLLM's, but that does not establish general infrastructure budgets enforced by Port. [Environments][P-environments] · [AI Gateway][P-gateway]

## 6. Scope and availability requiring confirmation

| Topic | What the source supports | What must not be assumed |
|---|---|---|
| Sedai Sed / MCP | Early access in the reviewed announcements. [Source][S-sed] | General availability or parity with every product executor. |
| Sedai Impact | Private beta in FinOps onboarding. [Source][S-finops] | Business value metrics already validated for any customer. |
| Sedai Autopilot | Support varies by resource. [Source][S-execution] | Uniform autonomy for EC2, storage, nodes, and workloads. |
| CAST AI APA | Private preview. [Source][C-apa] | Broad availability of automated PRs. |
| CAST AI audit log | Cluster auditing documented; organizational auditing in early access. [Source][C-audit] | Identical auditing scope across all plans. |
| CAST AI budgets | Documented v1beta API. [Source][C-budgets] | Confirmed commercial maturity, UI, or hard stop. |
| ProsperOps budgets | Commitment prepayment limit. [Source][R-budget] | Total spending limit per feature/runtime. |
| Infracost Fix | GA in the announcement; Notify/approval in the guide. [Announcement][I-fix-ga] · [Guide][I-fix] | General autonomy to modify cloud resources. |
| Infracost Kubernetes | Estimates and ingestion exist; a rightsizing agent is announced, with execution mode unconfirmed. [Documentation][I-kubernetes] · [Roadmap][I-fix-ga] | Ingestion or recommendations establish automatic application. |
| Port environments | Documented orchestration; execution backend still requires implementation. [Source][P-environments] | A complete working environment obtained simply by using the example. |

When marketing and documentation differ in granularity, this document favors the more specific technical boundary. Publication dates do not replace contractual availability confirmation or observed execution.

## 7. Implications for microruntime research

These are **inferences**, not architecture decisions or an approved backlog:

1. **The shared core is necessary but weakly distinctive:** permissions, limits, history, and data extraction appear in all five products. Combining those labels does not demonstrate microruntime differentiation.
2. **Position in the workflow matters:** Infracost has a strong code/PR presence; Sedai and CAST AI act more directly on running environments; ProsperOps automates commitments and schedules; Port coordinates context and workflows. These boundaries suggest competitive overlap and potential composition, rather than integration decisions.
3. **Consumer-owned components can coexist with central governance:** tag-based configuration, policies, and self-service actions already provide examples. Research should identify which decisions a microruntime contract makes portable and verifiable without duplicating the executor's engine.
4. **The “feature/use case” unit needs definition:** allocation by tag, namespace, account, or repository does not establish incremental feature cost. Shared resources, idle capacity, traffic, discounts, and measurement windows can change attribution.
5. **Estimation, observation, and attribution must remain separate:** predicted cost, actual consumption, forecast, budget, potential savings, prevented cost, and realized savings are not interchangeable.
6. **MCP facilitates access without completing the contract:** identity, permissions, evidence versioning, and acceptance criteria still need definition. This conclusion does not authorize an executor or policy engine.
7. **The portability hypothesis remains open:** reviewed sources did not confirm a package combining SDK installation, consumer-defined composition, local/remote execution, and test/resource/cost evidence within one use-case contract. This is absence of confirmation in this research scope, **not proof of nonexistence or market validation**.

### Questions without sufficient documentary answers

- Which tool serves the same complete use case with a comparable adoption effort?
- Which features depend on plan, license, cloud provider, region, or early access?
- How much customer work separates a documented integration from reliable operation?
- How should shared costs, billing delays, discounts, and baselines be handled when attributing cost to a feature?
- Which decisions belong to the consumer team, and which constraints are defined institutionally?
- Is there concrete demand for a portable microruntime contract beyond what CLI, IaC, portals, and CI already provide?

Answering these questions would require further research or authorized validation. **No implementation was initiated from this study.**

## 8. Official sources

Links support the claims and matrix cells above. The following index groups the sources by product.

### Sedai

- [Augmented FinOps][S-finops]
- [Groups][S-groups]
- [SSO / RBAC][S-rbac]
- [Operation modes][S-modes]
- [Optimization settings][S-execution]
- [Optimization overview][S-optimization]
- [Kubernetes][S-kubernetes]
- [EC2][S-ec2]
- [Activity Hub][S-activity]
- [IaC integration][S-iac]
- [Onboarding, API, and SDK][S-api]
- [Schedules][S-schedules]
- [Ticketing and service management][S-ticketing]
- [Release Intelligence][S-release]
- [Introducing Sed][S-sed]
- [Ask Sed][S-ask]

### CAST AI

- [Cluster total compute cost][C-cost]
- [Allocation groups][C-allocation]
- [Budgets API][C-budgets]
- [Available savings][C-opportunities]
- [Savings report][C-savings]
- [Savings baseline][C-baseline]
- [Discount Engine][C-discounts]
- [Cluster efficiency][C-efficiency]
- [Workload Autoscaling][C-workloads]
- [Autoscaler][C-autoscaler]
- [Autoscaler settings][C-policies]
- [Hibernation][C-hibernate]
- [Commitments][C-commitments]
- [Notifications][C-notifications]
- [castctl][C-cli]
- [API access][C-api]
- [MCP][C-mcp]
- [OpsPilot][C-opspilot]
- [RBAC][C-rbac]
- [Audit log][C-audit]
- [APA overview][C-apa]

### ProsperOps

- [Product][R-home]
- [Showback][R-showback]
- [Azure Showback][R-azure]
- [Savings export schema][R-savings]
- [Savings Analysis / Azure][R-analysis]
- [Approval model][R-approval]
- [Settings][R-settings]
- [Budget][R-budget]
- [Scheduler][R-scheduler]
- [How schedules work][R-schedules]
- [Scheduler IAM][R-iam]
- [Roles][R-rbac]
- [Data export][R-export]
- [AI technology FAQ][R-noai]
- [Containers FAQ][R-containers]

### Infracost

- [Documentation][I-docs]
- [Platform][I-platform]
- [Guardrails][I-guardrails]
- [Budgets][I-budgets]
- [Fix getting started][I-fix]
- [Fix generally available][I-fix-ga]
- [Cost anomaly investigation][I-anomalies]
- [Idle and unused resources][I-idle]
- [Business properties][I-properties]
- [Permissions / key concepts][I-rbac]
- [API][I-api]
- [CLI][I-cli]
- [Agent skills and official MCP][I-mcp]
- [Kubernetes][I-kubernetes]
- [Datadog][I-datadog]
- [Infracost AI scenarios][I-scenarios]

### Port

- [Getting started][P-start]
- [Agentic resource management][P-overview]
- [Governance at scale][P-governance]
- [Business context][P-business]
- [Kubecost integration][P-kubecost]
- [Permissions][P-rbac]
- [Audit log][P-audit]
- [Scorecards][P-scorecards]
- [CLI][P-cli]
- [MCP][P-mcp]
- [Prepare work items with AI][P-ai]
- [Manage cloud resources][P-resources]
- [Developer environments][P-environments]
- [Terraform plan/apply][P-terraform]
- [IaC with AI][P-iac]
- [AI Gateway][P-gateway]
- [Incident triage / Dynatrace MCP][P-dynatrace]
- [Standardize AI coding rules][P-rules]

[S-finops]: https://docs.sedai.io/get-started/onboarding/augmented-finops
[S-groups]: https://docs.sedai.io/get-started/platform/settings/groups
[S-rbac]: https://docs.sedai.io/get-started/platform/single-sign-on-rbac
[S-modes]: https://docs.sedai.io/get-started/onboarding/readme/understanding-operation-modes
[S-execution]: https://docs.sedai.io/get-started/platform/settings/features/optimization
[S-optimization]: https://docs.sedai.io/get-started/platform/optimization
[S-kubernetes]: https://docs.sedai.io/get-started/platform/optimization/kubernetes
[S-ec2]: https://docs.sedai.io/get-started/platform/optimization/aws/ec2
[S-activity]: https://docs.sedai.io/get-started/platform/activity
[S-iac]: https://docs.sedai.io/get-started/platform/integrations/infrastructure-as-code-iac
[S-api]: https://docs.sedai.io/get-started/onboarding/autonomous-cloud-management
[S-schedules]: https://docs.sedai.io/get-started/platform/settings/schedules
[S-ticketing]: https://docs.sedai.io/get-started/platform/integrations/ticketing-and-service-management
[S-release]: https://docs.sedai.io/get-started/platform/release-intelligence
[S-sed]: https://sedai.io/blog/introducing-sed
[S-ask]: https://sedai.io/blog/ask-sed
[C-cost]: https://docs.cast.ai/docs/cluster-total-compute-cost
[C-allocation]: https://docs.cast.ai/docs/cluster-allocation-groups
[C-budgets]: https://docs.cast.ai/reference/budgetsapi_createbudget
[C-opportunities]: https://docs.cast.ai/docs/available-savings
[C-savings]: https://docs.cast.ai/docs/savings-report
[C-baseline]: https://docs.cast.ai/docs/savings-baseline
[C-discounts]: https://docs.cast.ai/docs/discount-engine-overview
[C-efficiency]: https://docs.cast.ai/docs/cluster-efficiency-report
[C-workloads]: https://docs.cast.ai/docs/workload-autoscaling-configuration
[C-autoscaler]: https://docs.cast.ai/docs/autoscaler
[C-policies]: https://docs.cast.ai/docs/autoscaler-settings
[C-hibernate]: https://docs.cast.ai/docs/autoscaling-cluster-hibernation
[C-commitments]: https://docs.cast.ai/docs/commitments
[C-notifications]: https://docs.cast.ai/docs/notifications
[C-cli]: https://docs.cast.ai/docs/castctl-reference
[C-api]: https://docs.cast.ai/docs/api-access
[C-mcp]: https://docs.cast.ai/reference/mcp
[C-opspilot]: https://docs.cast.ai/docs/opspilot
[C-rbac]: https://docs.cast.ai/docs/role-based-access-control-rbac
[C-audit]: https://docs.cast.ai/docs/audit-log
[C-apa]: https://docs.cast.ai/docs/apa-overview
[R-home]: https://www.prosperops.com/
[R-showback]: https://help.prosperops.com/showback-intro
[R-azure]: https://help.prosperops.com/intelligent-showback-additional-azure-features
[R-savings]: https://help.prosperops.com/data-export-format-adm-for-aws-savings-v2
[R-analysis]: https://help.prosperops.com/limited-iam-permissions-for-savings-analysis-azure
[R-approval]: https://help.prosperops.com/do-customers-approve-prosperops-actions
[R-settings]: https://help.prosperops.com/what-are-the-settings-to-configure
[R-budget]: https://help.prosperops.com/can-i-set-a-budget
[R-scheduler]: https://help.prosperops.com/prosperops-scheduler-introduction-and-overview
[R-schedules]: https://help.prosperops.com/how-schedules-work-in-prosperops-scheduler
[R-iam]: https://help.prosperops.com/iam-permissions-for-enabling-prosperops-scheduler
[R-rbac]: https://help.prosperops.com/prosperops-roles-for-console-access
[R-export]: https://help.prosperops.com/data-export-intro
[R-noai]: https://help.prosperops.com/does-the-prosperops-platform-use-artificial-intelligence
[R-containers]: https://help.prosperops.com/does-prosperops-work-with-container-services-like-eks-and-ecs
[I-docs]: https://www.infracost.io/docs/
[I-platform]: https://www.infracost.io/product/platform
[I-guardrails]: https://www.infracost.io/docs/infracost_cloud/guardrails/
[I-budgets]: https://www.infracost.io/docs/infracost_cloud/budgets/
[I-fix]: https://www.infracost.io/docs/infracost_cloud/fix_getting_started/
[I-fix-ga]: https://www.infracost.io/resources/blog/infracost-fix-is-now-generally-available
[I-anomalies]: https://www.infracost.io/docs/infracost_cloud/fix_agents_cost_anomaly_investigation/
[I-idle]: https://www.infracost.io/docs/infracost_cloud/fix_agents_idle_unused_resources/
[I-properties]: https://www.infracost.io/docs/infracost_cloud/repo_business_properties/
[I-rbac]: https://www.infracost.io/docs/infracost_cloud/key_concepts/
[I-api]: https://www.infracost.io/docs/infracost_cloud/api/
[I-cli]: https://www.infracost.io/docs/features/cli_commands/
[I-mcp]: https://github.com/infracost/agent-skills/blob/main/README.md
[I-kubernetes]: https://www.infracost.io/docs/features/kubernetes/
[I-datadog]: https://www.infracost.io/docs/integrations/datadog/
[I-scenarios]: https://www.infracost.io/docs/infracost_ai/scenarios/
[P-start]: https://docs.port.io/getting-started/overview/
[P-overview]: https://docs.port.io/solutions/agentic-resource-management/overview/
[P-governance]: https://docs.port.io/solutions/agentic-resource-management/governance-at-scale/
[P-business]: https://docs.port.io/context-lake/business-context/overview/
[P-kubecost]: https://docs.port.io/context-lake/ingestion/ingest-data-into-port/native-integrations/available-integrations/cloud-cost/kubecost/
[P-rbac]: https://docs.port.io/governance/governance-across-pillars/scope-building-permissions-across-teams-and-users/
[P-audit]: https://docs.port.io/platform-administration/audit-log/
[P-scorecards]: https://docs.port.io/governance/standards-and-compliance/concepts-and-structure/
[P-cli]: https://docs.port.io/port-ai/interfaces/port-cli/
[P-mcp]: https://docs.port.io/agent-management/port-mcp-server/overview/
[P-ai]: https://docs.port.io/guides/all/prepare-work-items-with-ai/
[P-resources]: https://docs.port.io/guides/all/manage-and-visualize-cloud-resources/
[P-environments]: https://docs.port.io/guides/all/manage-developer-environments/
[P-terraform]: https://docs.port.io/guides/all/terraform-plan-and-apply-aws-resource/
[P-iac]: https://docs.port.io/guides/all/streamline-iac-with-ai/
[P-gateway]: https://docs.port.io/agent-management/ai-gateway/
[P-dynatrace]: https://docs.port.io/guides/all/triage-incidents-with-dynatrace-mcp/
[P-rules]: https://docs.port.io/guides/all/standardize-ai-coding-rules/
