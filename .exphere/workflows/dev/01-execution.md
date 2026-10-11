# Execution

**Input:** an identified spec or ticket revision, satisfied blocking dependencies, and authorization for the implementation scope. Follow the [cycle contract](CYCLE.md).

## Work

1. State the selected ticket or scope. Load [implement](../../../.agents/skills/implement/SKILL.md), relevant [working rules](../../../.agents/rules/README.md), and only the needed skills. Inspect current files and applicable local instructions before editing.
2. Preserve user changes and identify the comparison baseline. Use Git when available; otherwise capture the task's file manifest and relevant contents or hashes. An absent repository does not authorize initializing one.
3. Implement the smallest complete deliverable. Keep consumer choices separate from platform contracts. Use [codebase-design](../../../.agents/skills/codebase-design/SKILL.md) when an interface decision warrants it; use [writing-for-agents](../../../.agents/skills/writing-for-agents/SKILL.md) for agent guidance.
4. Update affected references and state descriptions together with the change. Work artifacts follow the [tracker](../../../.artifacts/agents/0006-DD-artifact-tracker.dd.md) and use en-US. Record new scope or assumptions before they become hidden dependencies.
5. Perform only relevant authorized checks. For documents, inspect structure, links, anchors, paths, terminology, and applicable JSON. For code, select available formatting or compilation checks if appropriate. Inspect manifest commands before using them; do not repair absent helper scripts outside the ticket's scope.
6. Make the final changed scope available for [review](02-review.md), including relevant uncommitted and newly created files. Record checks performed, failures, skipped verification, and limitations.

The current test prohibition overrides testing defaults in implementation skills. Do not load or execute TDD to evade it, add tests, run existing tests, or substitute smoke checks or HTTP probes. No commit, publication, provisioning, or production action is implied by completing local work.

**Output:** the implemented deliverable, updated artifacts, and a reviewable snapshot with a concise verification record.

**Completion:** the authorized changes are ready for technical review. Advance the ticket to `in-review`; review and audit determine whether its criteria are satisfied.

**Return condition:** a scope change returns to planning; an implementation defect remains execution work. Record any external dependency or unavailable mandatory check instead of declaring success.
