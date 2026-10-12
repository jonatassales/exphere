# Domain documentation

- ID: `DD-0007`
- Status: `active configuration`

Use **microruntimes**, singular **microruntime**, throughout project content. Consumers choose their stack, components, and composition. Platform contracts describe security, observability, resources, quality, and evidence. Do not turn proposed capabilities into claims of implemented enforcement or organizational adoption.

The [product PRD](../prd/0001-PRD-exphere.prd.md), [design overview](0001-DD-exphere.dd.md), and [microruntime requirements](0002-DD-microruntimes.dd.md) contain the available domain context. There is currently no standalone glossary. Do not depend on an absent file or recreate a removed glossary without an explicit need and authorized scope.

Use the `domain-modeling` skill for terminology and consequential architectural decisions. Keep glossary definitions short and decisions separate. Architectural decisions use the DD filename pattern in the design directory, with explicit `proposed`, `accepted`, `deprecated`, or superseded status as appropriate. Existing decision IDs remain traceable inside their documents.

Create a decision record only when the choice is difficult to reverse, surprising without context, and the result of a real trade-off. A proposal is not an accepted architecture. Research uses the RSC pattern and the research directory. See the [artifact tracker](0006-DD-artifact-tracker.dd.md) for numbering and all filename conventions.

The [institutional workflow](0003-DD-institutional-workflow.dd.md) remains a proposal. Do not treat hypotheses, example tools, or named providers as approved choices, and do not select one stack for all consumers.
