# Ownership, creation and retention

| Content | Writer | Creation | Source retention |
| --- | --- | --- | --- |
| Configuration and native runtime files | Consumer | Explicit selection | Versioned |
| Selected skills, templates, guides and bindings | Future installer; reference author here | Explicit setup | Versioned with provenance |
| Installation inventory | Future installer; reference author here | Explicit setup | Versioned; not financial state |
| Typed intent in artifacts/prd, specs, tickets | Authorized author | Actual authored intent | Four-digit typed Markdown identities |
| artifacts/accounting | Controlled accounting writer | First actual financial activity | Excluded; access/retention owner required |
| artifacts/cycles | Executor; planner proposes plan only | Actual cycle | Excluded; sanitize explicit exports |
| state/graph | Graph executor | Actual checkpoint | Excluded; never a second ledger |
| cache, logs, secrets | Scoped owners | Actual use | Excluded; raw prompts are not retained by default |

This consumer contract separates typed authored collections from machine records.
It does not change Exphere root DD-0006 or move .audits/evidence/runs. No machine
records are created in this fresh reference. Separate synthetic scenarios may be
versioned as deliberate fixtures, never as authentic billing or execution evidence.

Keep credentials and kubeconfig external. Preserve a legitimate .terraform.lock.hcl;
it is a dependency lock, not Terraform state or the harness inventory. Git ignore
rules and package contents are separate checks. The current CLI packages cli only;
these source fixtures and verification scripts are not installation assets.
