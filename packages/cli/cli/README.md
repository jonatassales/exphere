# ex — Exphere CLI

The private, versioned `@exphere/cli` package owns `ex`. The separate SDK TypeScript API remains empty. Consumer applications keep their source; microruntimes reference their directories and native configuration.

## Installation

The root `postinstall` links this checkout under `~/.local/share/exphere/`, adds its command directory to the supported zsh/bash profiles, and configures repository hooks. Existing unrelated files/links are preserved. `EXPHERE_SKIP_USER_SETUP=1` skips personal setup while retaining repository hooks. CI skips personal setup; `pnpm install --ignore-scripts` skips both. Explicit setup remains `pnpm ex setup`. Dependency installation of this private package does not run the monorepo's root hook.

## Version 2 configuration

```text
ex [--root DIR] runtime list
ex [--root DIR] runtime ID init
ex [--root DIR] runtime ID init --guided
ex [--root DIR] runtime ID validate
```

Configuration needs `sh` and `jq`. Project discovery recognizes `.exphere`, `.micro-runtime`, `pnpm-workspace.yaml`, and `.git`; `--root` selects a consumer explicitly. New output goes to `.exphere/runtimes/<id>/`. Both entry points refuse existing output, including partial configuration and an ID present in the legacy location. They never execute hooks or infrastructure tools.

Manual `init` creates a descriptor with identity and empty units, deliberately invalid until the consumer fills in owner, target, and references. It creates no placeholder Terraform, units, or hooks directories. Guided initialization gathers owner, explicit context/namespace, native quota values, component paths, prebuilt images, container/service ports, replicas, resources, and readiness probes. It collects all input before publishing. Empty component input ends unit selection; optional hook selection copies only supplied `.sh` files. Interrupted publication removes only its own new output and reports failed recovery.

Example descriptor (the referenced files/directories must exist):

```json
{
  "version": 2,
  "id": "demo",
  "environment": "local",
  "owner": "consumer-team",
  "units": {
    "website": {
      "component": "apps/website",
      "kubernetes": { "manifests": "units/website/kubernetes" }
    }
  },
  "terraform": { "directory": "terraform" },
  "kubernetes": { "context": "kind-pilot", "namespace": "demo" }
}
```

The packaged [JSON Schema](schemas/runtime-v2.schema.json) describes structural constraints. The CLI additionally checks identities, component basenames, canonical containment, symlinks, and existing references. Unit keys equal their component directory basenames. Component references are project-relative; native and optional hook references are runtime-relative. Unknown fields, ambiguous IDs, duplicate JSON keys, unsupported versions, invalid paths, and unresolved references fail with diagnostics. Validation reads data; it never sources descriptor values as shell code.

Kubernetes files own images, ports, requests/limits, replicas, and probes. Terraform owns namespace and quotas. Guided output uses native JSON forms, a pinned Terraform 1.16.5 / Kubernetes provider 3.2.1 namespace/quota root, and Deployment/ClusterIP Service workloads with consumer values. The root's four variables bind the selected context, namespace, private kubeconfig, and runtime owner token during later operation. Generated images use `Never`, so a consumer must explicitly preload them for the local pilot. Native files remain editable; validation does not regenerate or overwrite edits. The descriptor carries references and target selection without duplicating those settings.

Configuration validation does not check native tool schemas, image availability, access, readiness, resource enforcement, or cleanup. Those checks belong to `SPEC-MICRORUNTIME-LIFECYCLE`. A generated runtime is not evidence of an executed journey.

## Legacy transition

Existing `.micro-runtime/<id>/schema.json` version 1 files are never moved or rewritten automatically. `init --legacy` explicitly creates their identity and empty `components` map. `list` reports both versions and locations; selecting an ID present in both locations fails before mutation. There is no implicit migration or announced v1 removal date.

Only v1 exposes the earlier raw adapters:

```text
ex runtime ID terraform COMMAND [--] [ARGS...]
ex runtime ID kubernetes diff|apply|delete|status
ex runtime ID run HOOK [--] [ARGS...]
```

Terraform forwards supported native commands and arguments in the declared directory, preserving native exit codes and inherited backend/workspace/environment behavior. Kubernetes uses explicit context, namespace, and manifest path. These adapters do not acquire the v2 lifecycle's scope controls. A namespace flag is not a sandbox.

V1 `run` executes only the named declared `.sh` script, in its runtime directory, preserving arguments and process environment. It exports `EX_PROJECT_ROOT`, `EX_RUNTIME_DIR`, `EX_RUNTIME_ID`, `EX_RUNTIME_SCHEMA`, and `EX_CLI_PATH`. Hooks are trusted consumer code running with process permissions. V2 raw Terraform/Kubernetes forwarding is rejected; optional hooks remain explicit and follow the separate lifecycle contract.

## Verification boundary

Package-owned `.sh` fixtures invoke public CLI commands in disposable consumer directories. They cover manual/guided equivalence, legacy compatibility, path protection, native-file preservation, collisions, failure, and cancellation. Controlled tools and harmless hooks do not demonstrate a real cluster, provider, workload, production integration, or measured economic benefit. No deployable consumer runtime is bundled.
