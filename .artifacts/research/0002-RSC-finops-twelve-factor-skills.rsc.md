# Research — FinOps and Twelve-Factor skills

Reviewed on **October 10, 2026**. Status at the time of this research: candidates evaluated through reading; none of the candidates below was installed, executed, or added to the lock file. The [local guardrails](../../.agents/guardrails/README.md) are independent of this candidate selection. See the [agent skills record](../agents/0008-DD-agent-skills.dd.md) for the separately selected skills currently recorded in the project.

This document preserves the historical research findings. Translation and reorganization do not constitute a new verification of availability, popularity, or licensing terms.

## Method and limitations

The review covered the skills.sh catalog, `skills find finops`, `skills find twelve-factor`, public repositories, and `SKILL.md` files. CLI discovery succeeded after network access was enabled. Google's and pproenca's entry files were read directly from their public repositories after browser access failed. The figures below are snapshots returned by the catalog/GitHub; they may change and do not demonstrate quality, security, or production adoption. Star counts apply to entire repositories, not individual skills.

## Shortlist

| Candidate and publisher | Observed scope | Signals reviewed | Assessment for this project |
| --- | --- | --- | --- |
| [google-cloud-waf-cost-optimization — Google](https://github.com/google/skills/blob/main/skills/cloud/google-cloud-waf-cost-optimization/SKILL.md) | The entry declares v1.0.1; GCP cost assessment using the Well-Architected Framework, recommendations, and a checklist. | Catalog: 13.4K installs; repository: approximately 21.1K stars; Apache-2.0 license declared by the repository. | Useful GCP-specific reference. Prescriptive defaults for tools, high availability, and recommendations before diagnosis require context; they must not become universal harness requirements. |
| [cloud-finops — OptimNow](https://github.com/OptimNow/cloud-finops-skills/blob/main/skills/cloud-finops/SKILL.md) | Routes readers to references on cloud, Kubernetes, AI costs, attribution, and optimization. | Catalog: 22 installs; repository: 58 stars; [declared CC BY-SA 4.0 license](https://github.com/OptimNow/cloud-finops-skills/blob/main/LICENSE.md). | Candidate for studying multicloud and agent costs, with limited public adoption. Vendor-maintained; not an official FinOps Foundation skill. Review was limited to the entry file, README, and license; the full library was not audited. |
| [12-factor-app — pproenca](https://github.com/pproenca/dot-skills/blob/master/skills/.experimental/12-factor-app/SKILL.md) | The entry organizes 51 rules into 12 categories, with references loaded according to the decision. | Catalog: 303 installs; repository: 215 stars; MIT license declared by the repository; labeled experimental by its author. | Candidate for assisted architecture review. Repository, configuration, artifact, and administrative access rules particularly need review against the monorepo and local contracts. SKILL.md and README were read; the 51 references were not individually audited. |

Catalog install figures: [Google](https://skills.sh/google/skills/google-cloud-waf-cost-optimization), [OptimNow](https://skills.sh/optimnow/cloud-finops-skills/cloud-finops), [pproenca](https://skills.sh/pproenca/dot-skills/12-factor-app). Repositories: [Google](https://github.com/google/skills), [OptimNow](https://github.com/OptimNow/cloud-finops-skills), [pproenca](https://github.com/pproenca/dot-skills). Publisher and scope matter more than install counts.

## Other options found

- [Jamie-BitFlight/twelve-factor-app](https://github.com/Jamie-BitFlight/claude_skills/blob/main/plugins/twelve-factor-app/skills/twelve-factor-app/SKILL.md): describes the twelve factors plus three extensions. Discovery does not make it an official update to the manifesto; deeper review remains pending.
- [@dzhechkov/skills-12factor](https://www.npmjs.com/package/%40dzhechkov/skills-12factor): its README declares automated generation and no human review (`trust_tier 0`). It was not selected for adoption; the package was neither installed nor fully inspected.

## Recommendation

Keep guardrails grounded in primary sources. For a skill pilot, evaluate pproenca in a bounded service review; for GCP, evaluate Google's skill only when that provider is part of the use case. OptimNow merits focused reading on the relevant topic, with data and references checked before using an economic recommendation. This is not an installation decision.

A skill guides analysis; it does not enforce budgets, access policies, or CI gates. Its results must identify evidence and assumptions, use the local FIN/12F IDs, and acknowledge missing controls. Adoption of these candidates remains open; this research does not prescribe a cloud or telemetry vendor.

## Installation commands for reference — not executed

```sh
npx skills add google/skills --skill google-cloud-waf-cost-optimization
npx skills add OptimNow/cloud-finops-skills --skill cloud-finops
npx skills add pproenca/dot-skills --skill 12-factor-app
```

Before adding a candidate, select only the relevant skill, review its references and license terms, choose a revision, and record its public source and adaptations in the existing provenance mechanism. The commands above are upstream discovery/installation routes without pinned revisions; they are not an approved reproducible procedure for this repository. No MCP connection is required to use the local guardrail documents.
