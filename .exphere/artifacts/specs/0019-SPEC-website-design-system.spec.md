# Website design-system contract

- ID: `SPEC-WEBSITE-DESIGN-SYSTEM`
- Document number: `SPEC-0019`
- Version: `1`
- State: `approved supporting contract`
- PRD: [PRD-WEBSITE-DESIGN-BRANDING v1](../prd/0003-PRD-website-design-branding.prd.md)
- Architecture decision: [ADR-0002](../design/0010-DD-website-design-system-branding.dd.md)
- Technical owners: project owner for visual direction; website maintainers for implementation within the documented system.

## Contract and composition

- Requirements addressed: REQ-BRAND-001 and REQ-BRAND-004.
- Components selected by the consumer: the existing Next.js website, Tailwind consumption of shared tokens, and a website-local visual contract (now retired) for Exphere-specific visual rules.
- Environment and executor selected by the consumer: existing website workspace; no new runtime, package, or design dependency.
- Extension points and execution lifecycle: future website UI changes read the local design source first, then map those roles onto existing/shared tokens or a separately approved website adaptation. Do not silently mutate public package identity.
- Configuration, secret references, and data ownership: no secrets or runtime configuration; design documentation is repository-owned source.

### Required design roles

- Brand: pure black (`#000000`) only for Exphere identity and primary emphasis.
- Canvas: white (`#FFFFFF`) for the light-first website and SEO imagery.
- Surfaces/text: neutral grays may support hierarchy; they are not brand accents.
- Typography: Inter-compatible bold sans hierarchy for display/body intent; JetBrains-Mono-compatible treatment for code/technical labels. This cycle adds no font loader.
- Spacing: 4, 8, 12, 16, 24, 32, 48, and 96px role scale.
- Radius: 4, 6, 8, 12px plus pill/full when semantically required.
- Depth: flat surfaces, 1px hairlines, no drop shadows or glow.
- Responsive: mobile below 768px; tablet 768–1024px; desktop 1024–1440px; wide above 1440px, with composition collapsing before typography becomes unreadable.

## Responsibilities

- Consumer: owns Exphere website composition and any later content/design expansion.
- Platform: preserves shared-package independence and existing framework boundaries.
- Service owners: not applicable; no service or deployment is changed.

## Operation and limits

- Resources, isolation, permissions, and capacity: documentation/source only; no resource change.
- Failures, timeouts, cancellation, and cleanup: invalid or conflicting visual additions are review findings; there is no runtime executor.
- Installation, updates, and removal: no installation. Update the design source and implementation together when a visual decision changes.
- Observability and execution correlation: Git diff/review only.

## Verification and decisions

- Affected guardrails: SDD v1 and frontend ownership rules; FinOps/Twelve-Factor are not materially affected because no service, dependency, configuration, or resource behavior changes.
- Cost/consumption impact: no provisioned resource or paid provider.
- Open issues and exceptions: actual shared-token migration and font loading are deferred; this document must not be interpreted as changing the public `@repo/design` package.
- Verification plan: inspect the retired website visual contract against this contract and ADR-0002.
- Trade-offs: local website guidance avoids leaking Exphere branding into public packages at the cost of a later explicit token-mapping step.
- Technical review: included in the parent implementation review under `SPEC-WEBSITE-BLACK-SEO`.
