# Historical CLI contracts

This directory retains JSON schemas from the retired experimental Bash CLI and
source-only consumer-harness reference. The Bash executable, setup command,
microruntime commands and infrastructure adapters have been removed.

The [current Go CLI](../README.md) is a scaffold with help and version output;
`init` is explicitly unavailable. These schemas do not establish Go runtime
functionality or compatibility with the former implementation.

The independent [consumer-harness verifier](../scripts/consumer-harness/README.md)
uses these schemas only for source-contract checks in disposable fixtures. It
does not execute the Go CLI, provision infrastructure, or prove readiness.
