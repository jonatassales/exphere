# Project context

Exphere connects engineering objectives, decisions, agent-assisted work, and verifiable evidence. The current workspace contains an empty private TypeScript SDK API in `packages/sdk/`, a Go-only CLI scaffold in `packages/cli/`, design tokens in `packages/design/`, a shared React shader in `packages/web/`, and a Next.js/Nextra documentation entry in `apps/website/`. Native package tasks and local Husky hooks provide bounded developer checks. These controls do not implement the broader workflow engine, organizational quality contracts, or production integrations.

- **Intent:** reduce engineering friction by connecting objectives, decisions, agent-assisted work, and evidence. Consumer teams choose their stack and composition.
- **Current CLI:** help/version and explicit unsupported `init`; the former shell runtime commands, Terraform/Kubernetes adapters, installation and PATH mutation are retired. Retained schemas and consumer-harness verification are source references, not a working Go microruntime generator.
- **Distribution direction:** npm installation and consumer `.exphere` generation remain future work. The website's `npx exphere init` text is a preview, not evidence of a published or functional installer.
- **Workflow:** [SDD documents](../.exphere/workflow/README.md) and domain adaptations remain proposals without an executor. The project maintains `.exphere` while its corresponding Go workflow commands are unimplemented.
- **Skills:** [Go skills](skills/README.md) belong locally to `.agents/skills/`; the [AIHero catalog](../.exphere/workflow/skills/README.md), excluding `writing-for-agents`, belongs to `.exphere/workflow/skills/`. Installation does not authorize running every skill.
- **Adoption:** start with a bounded pilot and responsible owners; profiles and institutional boundaries remain unvalidated.
- **Authoritative configuration:** the [artifact tracker](../.exphere/artifacts/design/0006-DD-artifact-tracker.dd.md), [domain configuration](../.exphere/artifacts/design/0007-DD-domain-model.dd.md), [Go/native tooling decision](../.exphere/artifacts/design/0011-DD-go-cli-native-tooling.dd.md), and root [AGENTS.md](../AGENTS.md). No standalone glossary or `.agents/adr` is present.

This file records consumer context. Future distribution must distinguish it from generic distributed material. Hypotheses, targets and proposed adoption are not established organizational facts.
