# Evidence

No execution results are recorded here. A plan or example is not evidence.

For authorized execution, use `runs/<run-id>/` for local logs and reports. The root `.gitignore` excludes this directory; explicitly select and review publishable evidence, sanitizing sensitive data. An ignore rule is configuration, not proof that an artifact has never entered repository history.

An execution record must identify: initiative/requirements, code and configuration revision, tool and policy versions, environment and resources, load profile, start/end, commands or checks performed, outputs, metrics, and outcome (`passed`, `failed`, or `inconclusive`). Do not invent identities, times, hashes, or numbers to fill the format.

Traces, metrics, logs, and profiles may be correlated. Approvals and workflow state are separate records; a result file does not authenticate the person who accepted the risk.

Retention, shared storage, final format, and authentication remain undefined. The same evidence conditions apply to authorized tests initiated by people and agents. SPEC-GIT-HOOKS-SDD authorizes bounded hook-contract tests and the build/test push gate; unrelated tests and service probes retain their authorization boundary.
