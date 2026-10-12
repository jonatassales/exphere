# GitHub agent review

The `agent-review` job in [ci.yml](../../.github/workflows/ci.yml) runs the trusted [code-review skill](../../.exphere/harness/skills/code-review/SKILL.md) against an immutable pull request snapshot. Two independent, concurrent OpenAI Responses API requests produce Standards and Spec assessments. The requests have no tools and receive no previous reviewer output. They cannot execute repository code, edit files, install dependencies, publish comments, or approve a PR.

The adapter is an implementation of [SPEC-GITHUB-AGENT-REVIEW](../../.exphere/artifacts/specs/0008-SPEC-github-agent-review.spec.md), not a general CI policy engine. Substantive findings are informational. A successful job is not human approval or proof that the application works.

## Events and trust boundary

The workflow listens to `pull_request_target` for PRs targeting `main`: opening, reopening, new commits, becoming ready for review, conversion to draft, and editing. It has no separate `push` trigger. An edit that does not change the relevant Spec declaration or base is ineligible for another paid review.

A short `review-scope` job reads event metadata using trusted code before selecting the review job's concurrency group. Source, relevant Spec/base, and draft-state changes share a group for the PR, allowing new relevant work to cancel its predecessor. Unrelated title or body edits receive an isolated run group and a visible skipped report; they cannot cancel an active review. This metadata job performs no agent requests. Its shell step receives a read-only GitHub token to check current PR metadata, and no provider credential.

`actions/checkout` checks out `github.sha`, the trusted workflow revision. The adapter reads PR objects as data without checking out or executing the PR tree. Workflow logic, shell helpers, the skill, and applicable policies come from the trusted revision; proposed instruction changes remain review data. GitHub permissions are limited to `contents: read` and `pull-requests: read`. Checkout does not persist its token. The GitHub token is scoped to metadata, collection, and review steps, and the OpenAI key is scoped to the review step.

Artifact discovery reads `.exphere/artifacts/` and historical `.artifacts/` in the PR head and each included commit. A duplicate identity across roots remains ambiguous even when the blobs are identical or a later commit repairs the duplication. Ticket spec links resolve from each ticket's actual directory; a Markdown fragment is not part of the Git file path. Absolute, external, and repository-escaping links are not local artifact evidence. The collector verifies the linked document's stable identity; it does not validate section contents or semantic fulfillment.

Trusted policy discovery includes `.exphere/harness/rules/` and `.exphere/harness/guardrails/`, retained local guidance, and legacy policy locations. Instructions are read only from the trusted revision: prefer `.exphere/harness/skills/code-review/SKILL.md`, falling back to `.agents/skills/code-review/SKILL.md` only when the new path is absent from that same revision. PR, index, and working-tree copies cannot supply a missing trusted skill. Missing skills and oversized trusted input fail before provider calls; a read failure at the preferred path does not trigger fallback.

Draft PRs, forks, Dependabot PRs, irrelevant edits, and disabled configuration receive explicit skipped outcomes with no provider calls. Eligible runs resolve the actual PR `Spec:` declaration and included commits' `Ticket:` trailers. Missing or inconsistent SDD identities remain advisory. Without an authoritative spec, Standards can run while Spec is explicitly `not-verified`.

Reports identify the repository, PR, event, run/attempt, base, head, merge-base, commits, changed paths, exclusions, trusted revision, and model. The scope job checks current PR identity before selecting a cancelling group, isolating already-stale reruns; the adapter checks again before and after reviewing. Freshness checks are observations, not an atomic lock with GitHub scheduling. A superseded result retains its original identity and cannot stand for the current revision. Oversized or incomplete context fails visibly; the adapter does not silently truncate input.

Because the workflow executes trusted default-branch code, this PR cannot validate its own new workflow before it is merged into `main`. Hosted review of a layout migration may remain incomplete while the older adapter is trusted; do not read the contribution's adapter or skills to bypass that boundary. The existing 100-path and request-size limits still apply to the migration. A local fixture does not prove GitHub event delivery, actual token permissions, provider authentication, or model quality.

## Activation

Paid review is disabled unless `AGENT_REVIEW_ENABLED` is exactly `true`. Creating this workflow does not configure a provider account, set secrets, select a paid model, or authorize spending. Before enabling it, the repository owner must:

1. Assign a CI/AI owner and approve sending the scoped repository content to the provider, including its applicable data-handling terms.
2. Record a dated consumption decision with the provider/project, a supported dated model snapshot, price source/date/currency, expected PR and manual-rerun volume, input/output assumptions, runner minutes for both metadata and review jobs, artifact storage, approved budget and duration, monitoring owner, and response to deviations. Include metadata-only events and simultaneous PRs; the review job's shared concurrency group only limits one PR.
3. Establish and verify a provider-side consumption cutoff covering that project's total concurrent usage. An alert-only project budget, a request timeout, and a token limit do not prove a hard monetary cap. If no suitable cutoff is available, keep this integration disabled until the owner selects an approved control. The adapter validates the decision reference and expiry, not external billing state.
4. Configure the following repository variables and secret, then enable the workflow for an authorized pilot. Use a key restricted to the approved project and required API access. Never commit credential values.
5. Confirm repository Actions event policy allows this specific `pull_request_target` workflow. GitHub's default policy for affected public repositories is scheduled for enforcement on November 2, 2026; its absence of a run must not be interpreted as a successful review. See [GitHub's event-policy guidance](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target).

| Input | GitHub configuration | Contract |
| --- | --- | --- |
| `AGENT_REVIEW_ENABLED` | Repository variable | Exactly `true` enables eligible runs; any other value skips paid review. |
| `AGENT_REVIEW_MODEL` | Repository variable | Required dated model snapshot supporting Responses structured output. No default or floating alias is selected. |
| `AGENT_REVIEW_OWNER` | Repository variable | Required accountable CI/AI owner. |
| `AGENT_REVIEW_BUDGET_REF` | Repository variable | Required URL or repository path to the approved consumption decision described above. |
| `AGENT_REVIEW_BUDGET_EXPIRES` | Repository variable | Required valid, unexpired UTC date in `YYYY-MM-DD` format. |
| `OPENAI_PROJECT_ID` | Repository variable | Required provider project for allocation and the `OpenAI-Project` request header. |
| `OPENAI_API_KEY` | Repository secret | Required credential for the approved provider project. |

GitHub supplies `GITHUB_EVENT_PATH`, `GITHUB_REPOSITORY`, `GITHUB_SHA`, run identifiers, `RUNNER_TEMP`, and `GITHUB_STEP_SUMMARY`. The workflow injects `GH_TOKEN` from its read-only GitHub token. `INTAKE_OUTCOME` passes collection status to the review step so an intake failure cannot launch provider requests. Missing, invalid, or expired required configuration in an enabled eligible run is a technical failure before paid calls.

The endpoint is fixed to `https://api.openai.com/v1/responses`; configuration cannot redirect credentials to another host. Requests use structured output, no tools, no stored conversation, and no automatic retries. Consult the [Responses API reference](https://platform.openai.com/docs/api-reference/responses/create) and [structured-output guide](https://platform.openai.com/docs/guides/structured-outputs) when selecting or changing the dated model. Provider compatibility still requires an authorized pilot.

## Bounds, results, and operation

| Control | Implemented boundary |
| --- | --- |
| Runners | Ephemeral `ubuntu-24.04` hosted runners; metadata job timeout two minutes and review job timeout 15 minutes. |
| Concurrent work | One active review job per PR's relevant-event group; unrelated metadata edits use isolated run groups and make no provider calls. At most two independent reviewer requests per eligible run. |
| Superseded reviews | GitHub job-level `cancel-in-progress: true` applies after metadata classification; the adapter terminates both request workers on cancellation. |
| Request input | At most 262,144 serialized request bytes per reviewer; excess input fails before sending. |
| Request output | At most 4,096 output tokens per reviewer; incomplete or malformed output fails validation. |
| Request duration | At most 300 seconds per request; no automatic retry. |
| Report retention | Only `report.md` and `report.json` are uploaded; artifact retention is seven days. |

Cancelling the client request does not prove that the provider immediately stops billable processing. Multiple PRs and manual reruns can increase total consumption. Unknown spend is not zero. The owner must reconcile reported request/token usage and runner duration with provider and GitHub billing, including delayed or unavailable usage. This adapter makes no savings claim.

The job summary and artifact keep Standards and Spec separate, with statuses, evidence, severity, file/line references, and totals. Each axis is limited to 400 words. Completed reviews with findings can succeed; transport failures, timeouts, invalid responses, and unexpected missing axes fail. Deliberately unavailable Spec evidence and intentionally skipped runs remain distinct from a clean review. No PR comment, review submission, approval, merge, or branch-protection update is performed.

Only sanitized reports are retained. Temporary prompts, source context, and provider responses remain in the disposable runner and are cleaned up by the adapter. A cancelled or abruptly terminated runner may not finish its summary or artifact upload; the GitHub run status remains authoritative for execution. Reports can contain relevant source excerpts in findings and must remain within the repository's approved access and retention boundary.

To stop new paid reviews, set `AGENT_REVIEW_ENABLED` to `false`. Cancel active workflow runs separately, investigate any residual provider usage, and remove expired retained artifacts under the owner's policy. For dependency updates, review the full commit pins of `actions/checkout` and `actions/upload-artifact`, model compatibility, trusted script changes, and their permissions before rollout.

## Verification

From the repository root, run the authorized local contract fixtures:

```sh
sh scripts/tests/agent-review.sh
```

The fixtures use disposable Git repositories and controlled executor responses. They do not call the paid API, configure credentials, execute contributor scripts, or validate live model quality. Runtime dependencies are a POSIX shell and utilities, Git, jq, curl, iconv for UTF-8 validation, and GitHub CLI on the hosted runner; the report records observed tool/model identity where available. No application dependencies are installed by these jobs.

After trusted-branch deployment and activation authorization, the owner must verify actual trigger eligibility, permissions, before/after revision checks, summary and artifact delivery, cancellation, and usage reporting in a bounded GitHub pilot. Until then, those hosted/provider behaviors remain `not-verified`.
