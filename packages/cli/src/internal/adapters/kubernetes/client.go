// Package kubernetes adapts explicit local targets to kubectl operations.
package kubernetes

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"strings"
	"time"

	"github.com/jonatassales/exphere/packages/cli/src/internal/kernel"
)

// Client never reads kubectl's ambient current context or default namespace.
type Client struct {
	Runner                         kernel.Runner
	Kubeconfig, Context, Namespace string
}

// Resource identifies one observed API object. UID protects against name reuse.
type Resource struct {
	APIVersion string `json:"apiVersion"`
	Kind       string `json:"kind"`
	Name       string `json:"name"`
	Namespace  string `json:"namespace"`
	UID        string `json:"uid,omitempty"`
	Unit       string `json:"unit,omitempty"`
}

// Run invokes kubectl with an explicit target and bounded API requests.
func (c Client) Run(ctx context.Context, input io.Reader, args ...string) (kernel.Result, error) {
	callCtx, cancel := context.WithTimeout(ctx, 30*time.Second)
	defer cancel()
	base := []string{"--kubeconfig", c.Kubeconfig, "--context", c.Context, "--request-timeout=15s"}
	if c.Namespace != "" {
		base = append(base, "--namespace", c.Namespace)
	}
	return c.Runner.Run(callCtx, kernel.Command{Name: "kubectl", Args: append(base, args...), Stdin: input})
}

// Object reads a named object. Missing objects return nil; API failures remain errors.
func (c Client) Object(ctx context.Context, kind, name string) (map[string]any, error) {
	r, e := c.Run(ctx, nil, "get", kind, name, "--ignore-not-found=true", "-o", "json")
	if e != nil {
		return nil, e
	}
	if strings.TrimSpace(r.Stdout) == "" {
		return nil, nil
	}
	var obj map[string]any
	if e = json.Unmarshal([]byte(r.Stdout), &obj); e != nil {
		return nil, fmt.Errorf("decode %s/%s: %w", kind, name, e)
	}
	return obj, nil
}

// Apply validates one object with server-side dry run, then creates it atomically.
// A live name collision fails instead of adopting a concurrently created object.
func (c Client) Apply(ctx context.Context, obj map[string]any, dry bool) (map[string]any, error) {
	b, e := json.Marshal(obj)
	if e != nil {
		return nil, e
	}
	args := []string{"create", "--field-manager=exphere", "-f", "-", "-o", "json"}
	if dry {
		args = []string{"apply", "--server-side", "--field-manager=exphere", "--dry-run=server", "-f", "-", "-o", "json"}
	}
	r, e := c.Run(ctx, strings.NewReader(string(b)), args...)
	if e != nil {
		return nil, e
	}
	var result map[string]any
	e = json.Unmarshal([]byte(r.Stdout), &result)
	return result, e
}

// Metadata returns the named object's metadata, or an empty map for absent data.
func Metadata(obj map[string]any) map[string]any {
	if v, ok := obj["metadata"].(map[string]any); ok {
		return v
	}
	return map[string]any{}
}

// Text returns a string-valued field without silently coercing other types.
func Text(obj map[string]any, key string) string { v, _ := obj[key].(string); return v }

// Owned checks a recorded UID and ownership token together.
func Owned(obj map[string]any, uid, token string) bool {
	m := Metadata(obj)
	labels, _ := m["labels"].(map[string]any)
	return uid != "" && Text(m, "uid") == uid && Text(labels, "exphere.dev/ownership-token") == token
}

// Reference extracts the identity returned by the API server.
func Reference(obj map[string]any, unit string) Resource {
	m := Metadata(obj)
	return Resource{APIVersion: Text(obj, "apiVersion"), Kind: Text(obj, "kind"), Name: Text(m, "name"), Namespace: Text(m, "namespace"), UID: Text(m, "uid"), Unit: unit}
}

// Inventory lists every listable namespaced resource. An incomplete inventory is an error.
func (c Client) Inventory(ctx context.Context) ([]map[string]any, error) {
	r, e := c.Run(ctx, nil, "api-resources", "--verbs=list", "--namespaced=true", "-o", "name")
	if e != nil {
		return nil, e
	}
	var all []map[string]any
	for _, kind := range strings.Fields(r.Stdout) {
		// Events describe resources; they are not retained workload ownership.
		if kind == "events" || kind == "events.events.k8s.io" {
			continue
		}
		r, e = c.Run(ctx, nil, "get", kind, "-o", "json")
		if e != nil {
			return nil, fmt.Errorf("incomplete inventory (%s): %w", kind, e)
		}
		var list struct {
			Items []map[string]any `json:"items"`
		}
		if e = json.Unmarshal([]byte(r.Stdout), &list); e != nil {
			return nil, e
		}
		all = append(all, list.Items...)
	}
	return all, nil
}
