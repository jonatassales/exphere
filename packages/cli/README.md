# @exphere/cli — local microruntime pilot

The private CLI package owns `ex`, consumer configuration, and the bounded local microruntime lifecycle. The separate SDK TypeScript API remains empty. See the [CLI configuration and installation guide](cli/README.md) for descriptors, guided initialization, and legacy adapters.

## Local lifecycle

```sh
ex --root /path/to/consumer runtime demo inspect
ex --root /path/to/consumer runtime demo up --timeout 120
ex --root /path/to/consumer runtime demo down --timeout 120
```

These operations require a complete version 2 descriptor under `.exphere/runtimes/<id>/`. `inspect` records preflight and reads existing resources; its successful outcome means that inspection completed, not that absent workloads are running. `up` explicitly prepares and starts the selected composition. `down` explicitly removes resources whose ownership can be established. Failed startup preserves partial resources for inspection and explicit cleanup; it does not perform rollback or automatically retry mutations.

The supported pilot uses an already prepared kind cluster on a local Docker Unix socket. The descriptor must name `kind-<cluster>` and its namespace. The CLI compares the selected API server and CA with kind's own kubeconfig and records the CA fingerprint. It preserves the credentials of the consumer's selected context for subsequent operations. HTTPS endpoints must use `127.0.0.1` or `[::1]` with an explicit port. A familiar context name, a local declaration, or a host image listing does not establish cluster readiness. Alias contexts, credential plugins, remote Docker endpoints, proxies, and insecure TLS are rejected. The user's current context is never switched.

Reference tools are Terraform `1.16.5`, the HashiCorp Kubernetes provider `3.2.1`, kind `0.33.0`, and kubectl `1.37.0`. The shell implementation also uses `jq`, `base64`, `shasum`, `pgrep`, `ps`, and ordinary process/file utilities. Process enumeration must be usable before bounded commands start; enumeration errors during shutdown preserve an uncertain mutation boundary. Tool availability is distinct from a compatible, accessible environment. The CLI does not install tools, create or delete the cluster, build images, or implicitly load images. The operator supplies prebuilt images and loads them into every selected kind node before startup; inspection reports those conditions through the native tool boundary.

## Supported native configuration

Every selected unit references its existing project component and runtime-relative manifest files or directory. JSON, YAML, and YML inputs are parsed recursively, including nested files. Native inputs retain authority over image references, resources, replicas, probes, and ports. The CLI creates a private effective snapshot with the runtime namespace and ownership labels; it does not rewrite the authored files.

The bounded workload surface is at most 64 `apps/v1` Deployments and `v1` Services, applied in deterministic unit/kind/name order:

- Every unit needs a Deployment. Names and namespace-qualified identities must be valid and unique across all units.
- Deployments declare positive replicas, matching label selectors, prebuilt images with `Never` or `IfNotPresent` pull policy, CPU/memory requests and limits, and a readiness probe for each application container. Init containers declare their image policy and resources too.
- Services use `ClusterIP` and nonempty selectors that select Deployments in the same unit. External IPs and cross-unit selectors are unsupported.
- Volumes may use `emptyDir`, ConfigMap or Secret references, projected data, or the downward API. Persistent storage, host volumes, host networking/process namespaces, privileged containers, and added capabilities are outside this pilot.
- Cluster-scoped objects, extra workload kinds, authored server identity/status fields, existing owner references/finalizers, and conflicting reserved ownership labels are rejected. Local structural checks do not replace every Kubernetes API validation rule.

Terraform owns only the runtime namespace and quota through the reviewed `main.tf.json` contract. It uses one private local state and the explicit context, namespace, kubeconfig, and runtime-owner variables. Arbitrary roots, resources, expressions, remote backends, additional Terraform files, and inherited provider/CLI overrides are outside the supported contract. Terraform initialization belongs to explicit startup; inspection does not download providers or initialize a root.

## Evidence, observation, and cleanup

Each operation emits its JSON record and saves it under `.audits/evidence/runs/<run-id>/`. Operational state lives under `.exphere/state/runtimes/<id>/`. These local operational directories are ignored by version control. Keep state until all owned resources have been reconciled; deleting it does not delete infrastructure and can remove the evidence needed for safe cleanup. Local evidence remains until the operator removes it; there is no automatic retention policy or remote publication.

Observation separates desired configured resources, live resource identity/readiness, Kubernetes quota accounting, observed usage, and unavailable measurements. Quota accounting is not a currency budget. Missing metrics are unavailable, not zero. No load test or savings measurement is performed. Event summaries retain reasons and counts for observed resources and their owned ReplicaSets/pods, while omitting arbitrary event messages. `quotaMentioned` records whether an event message contained the native `exceeded quota:` phrase. Readiness failures and observation gaps remain distinct; that phrase does not by itself establish the cause of every failure.

Automatic evidence excludes environment values, raw manifests, credentials, Terraform state, and raw application logs. Private command outputs and the operation's kubeconfig are removed when the operation finishes. Raw application logs require an explicit operator request because their content can contain secrets. Publishing any evidence is a separate action.

Cleanup checks both runtime ownership and observed resource identity. Workloads are removed before preparation resources. Foreign or unknown namespace contents, replaced identities, failed workload deletion, and unavailable inventory block destructive namespace fallback. Repeated cleanup distinguishes absence from lookup failure, and shared clusters and consumer source/configuration remain outside cleanup scope.

The operation timeout defaults to 120 seconds and accepts an explicit value from 1 through 3600 seconds. Timeout, cancellation, and incomplete observations cannot produce a successful startup or a complete-cleanup claim. Interrupted effects may require a subsequent inspection and explicit cleanup.

## Verification scope

The package's public CLI fixtures exercise disposable consumer projects with controlled Terraform, Kubernetes, kind, and Docker executables. They verify coordination, target checks, native-input boundaries, failure reporting, ownership, and evidence handling. They do not demonstrate real cluster connectivity, image availability, readiness, quota enforcement, or actual Terraform cleanup. The owner deferred real Docker validation beyond this delivery. A later local pilot is required for those observations; no production readiness or economic result follows from these fixtures.

## Explicit access and recovery

Use `logs UNIT` for bounded logs from pods whose controller UID chain leads through a ReplicaSet to a recorded owned Deployment. The CLI checks each selected pod before and after collecting its logs and withholds buffered output if its identity changes. Native content is sent to the caller and excluded from retained summaries. `connect UNIT LOCAL_PORT SERVICE_PORT` verifies the declared owned Service and forwards only on `127.0.0.1`, in the foreground until exit, cancellation, or the operation deadline. Port selection remains explicit. A successful command exit is not a production endpoint guarantee.

Use `run HOOK --effects none|runtime [-- ARGS...]` only for a declared consumer `.sh` hook. `none` is the caller's assertion of no Kubernetes/Terraform effects. `runtime` permits effects only on the declared owned Deployment/Service set, captures intent before execution, and reconciles identities and namespace contents afterward. Hooks inherit process permissions; declarations do not enforce a sandbox. Unsupported effects remain retained and failed. Terraform changes from hooks are unsupported. No hook runs automatically during initialization, validation, inspection, or startup. Hook output is limited to 64 KiB per stream; native operation capture is limited to 4 MiB per stream, and truncation fails the operation. Argument/environment values and log content are not retained in summaries.

`down --recover` explicitly reconciles pending mutation intents and may release an expired lock only when its recorded parent and child are no longer live. A live or reused PID, missing evidence, corrupt state, changed target, or mismatched UID prevents automatic recovery. The CLI does not kill an old PID merely because a lock names it. Inspect before recovery; authored configuration changes do not erase the previous ledger's resource identities. Preserve state and prior run records until cleanup is complete. State and sanitized records have operator-controlled retention; interrupted raw captures may remain private for manual inspection/removal.

A short acquisition guard serializes normal mutation locking and stale-lock recovery. If interruption leaves that guard, or child process ownership is uncertain after timeout, inspect and reconcile the recorded processes before manually releasing the retained boundary. The CLI refuses competing mutation until that uncertainty is resolved.

Interrupted preparation can recover a missing ledger namespace UID only from matching retained Terraform identity, target, and prior operation evidence. Successful cleanup archives the completed ledger and releases the recognized preparation source/target snapshot after confirming namespace absence and empty native state. State backups and prior run evidence remain available; a corrected native configuration can then start a new journey.

The pinned Terraform provider's namespace deletion lacks an atomic UID precondition. This pilot requires exclusive namespace mutation during cleanup. Inventory and ownership rechecks reduce mistakes but cannot protect against a concurrent external writer between the final check and namespace deletion. Workload deletion uses UID preconditions. Shared clusters are never implicitly removed.
