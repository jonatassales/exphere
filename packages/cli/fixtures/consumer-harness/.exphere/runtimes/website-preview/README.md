# Website preview — synthetic runtime v2

References apps/website. Terraform owns namespace/quota; Kubernetes files own the
workload. Context kind-fixture, namespace website-preview, prebuilt image and
resource values are synthetic inputs. No image, cluster, provider invocation or
readiness is proven. Explicit operations and prerequisites belong to a later
lifecycle. This reference contains no hooks, credentials or Terraform state.
