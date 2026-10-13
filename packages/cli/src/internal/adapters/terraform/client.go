// Package terraform prepares only runtime-owned namespaces and resource quotas.
package terraform

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/jonatassales/exphere/packages/cli/src/internal/kernel"
)

// Client isolates Terraform's data, plan, and state from authored configuration.
type Client struct {
	Runner                                                            kernel.Runner
	Directory, StateDir, Context, Namespace, Kubeconfig, Owner, Token string
}

func (c Client) command(ctx context.Context, args ...string) (kernel.Result, error) {
	env := []string{"TF_IN_AUTOMATION=1", "TF_INPUT=0", "TF_DATA_DIR=" + filepath.Join(c.StateDir, "terraform-data"), "TF_CLI_ARGS=", "TF_CLI_ARGS_init=", "TF_CLI_ARGS_plan=", "TF_CLI_ARGS_apply=", "TF_CLI_ARGS_show=", "TF_WORKSPACE=default", "TF_LOG=", "TF_LOG_PATH=", "TF_LOG_CORE=", "TF_LOG_PROVIDER=", "KUBECONFIG=", "KUBERNETES_MASTER="}
	// Provider environment overrides must not redirect the explicit kubeconfig
	// and context selected for this owned local runtime.
	for _, entry := range os.Environ() {
		name, _, _ := strings.Cut(entry, "=")
		if strings.HasPrefix(name, "KUBE_") {
			env = append(env, name+"=")
		}
	}
	result, err := c.Runner.Run(ctx, kernel.Command{Name: "terraform", Args: args, Dir: c.Directory, Env: env})
	if err != nil {
		return result, fmt.Errorf("terraform %s did not complete; raw provider output is withheld because it may contain sensitive values: %w", args[0], err)
	}
	return result, nil
}

// Apply inspects the saved plan before applying; native failures preserve local state.
func (c Client) Apply(ctx context.Context, destroy bool) error {
	if e := os.MkdirAll(c.StateDir, 0700); e != nil {
		return e
	}
	if _, e := c.command(ctx, "init", "-input=false", "-no-color", "-reconfigure", "-backend-config=path="+filepath.Join(c.StateDir, "terraform.tfstate")); e != nil {
		return e
	}
	plan := filepath.Join(c.StateDir, "operation.tfplan")
	defer os.Remove(plan) // Plans may contain sensitive provider values.
	// A private var file has higher precedence than authored auto.tfvars while
	// keeping operational values out of the command line and inherited environment.
	variables := filepath.Join(c.StateDir, "operation.tfvars.json")
	if e := kernel.AtomicJSON(variables, map[string]string{"context": c.Context, "namespace": c.Namespace, "kubeconfig": c.Kubeconfig, "owner": c.Owner, "ownership_token": c.Token}); e != nil {
		return e
	}
	defer os.Remove(variables)
	args := []string{"plan", "-input=false", "-no-color", "-out=" + plan, "-var-file=" + variables}
	if destroy {
		args = append(args, "-destroy")
	}
	if _, e := c.command(ctx, args...); e != nil {
		return e
	}
	r, e := c.command(ctx, "show", "-json", plan)
	if e != nil {
		return e
	}
	if e = validatePlan([]byte(r.Stdout), c.Namespace, c.Token); e != nil {
		return e
	}
	_, e = c.command(ctx, "apply", "-input=false", "-no-color", plan)
	return e
}

// validatePlan prevents a runtime preparation root from managing unrelated resources.
func validatePlan(data []byte, namespace, token string) error {
	var plan struct {
		Changes []struct {
			Type   string `json:"type"`
			Mode   string `json:"mode"`
			Change struct {
				Before, After map[string]any
				Actions       []string
			} `json:"change"`
		} `json:"resource_changes"`
	}
	if e := json.Unmarshal(data, &plan); e != nil {
		return fmt.Errorf("decode Terraform plan: %w", e)
	}
	for _, r := range plan.Changes {
		if r.Mode != "managed" {
			return fmt.Errorf("unsupported Terraform data resource %s", r.Type)
		}
		if r.Type != "kubernetes_namespace_v1" && r.Type != "kubernetes_resource_quota_v1" {
			return fmt.Errorf("unsupported Terraform resource %s", r.Type)
		}
		values := r.Change.After
		if values == nil {
			values = r.Change.Before
		}
		meta, ok := values["metadata"].([]any)
		if !ok || len(meta) != 1 {
			return fmt.Errorf("unknown Terraform resource metadata")
		}
		m, ok := meta[0].(map[string]any)
		if !ok {
			return fmt.Errorf("invalid Terraform metadata")
		}
		labels, _ := m["labels"].(map[string]any)
		if labels["exphere.dev/ownership-token"] != token {
			return fmt.Errorf("Terraform resource lacks runtime ownership token")
		}
		if r.Type == "kubernetes_namespace_v1" {
			if m["name"] != namespace {
				return fmt.Errorf("Terraform namespace differs from runtime target")
			}
		} else if m["namespace"] != namespace {
			return fmt.Errorf("Terraform quota differs from runtime target")
		}
		if r.Change.Before != nil && r.Change.After != nil {
			for _, a := range r.Change.Actions {
				if a == "delete" {
					return fmt.Errorf("namespace/quota replacement requires explicit runtime cleanup first")
				}
			}
		}
	}
	return nil
}
