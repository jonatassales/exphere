package runtime

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"sort"
	"strings"

	kube "github.com/jonatassales/exphere/packages/cli/src/internal/adapters/kubernetes"
	"go.yaml.in/yaml/v3"
)

// Manifest binds one native object to its source unit without copying application code.
type Manifest struct {
	Unit   string
	Object map[string]any
}

func manifests(c *Config) ([]Manifest, string, error) {
	var out []Manifest
	keys := make([]string, 0, len(c.Descriptor.Units))
	for k := range c.Descriptor.Units {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	seen := map[string]bool{}
	hash := sha256.New()
	b, _ := json.Marshal(c.Descriptor)
	hash.Write(b)
	for _, unit := range keys {
		path, e := c.Resolve(c.Descriptor.Units[unit].Kubernetes.Manifests)
		if e != nil {
			return nil, "", e
		}
		count := 0
		e = filepath.WalkDir(path, func(path string, d fs.DirEntry, e error) error {
			if e != nil {
				return e
			}
			if d.Type()&os.ModeSymlink != 0 {
				return fmt.Errorf("manifest symlink rejected: %s", path)
			}
			if d.IsDir() {
				return nil
			}
			ext := filepath.Ext(path)
			if ext != ".json" && ext != ".yaml" && ext != ".yml" {
				return nil
			}
			b, e := os.ReadFile(path)
			if e != nil {
				return e
			}
			if len(b) > 1<<20 {
				return fmt.Errorf("manifest exceeds 1 MiB: %s", path)
			}
			hash.Write(b)
			dec := yaml.NewDecoder(bytes.NewReader(b))
			for {
				var obj map[string]any
				e = dec.Decode(&obj)
				if e == io.EOF {
					break
				}
				if e != nil {
					return fmt.Errorf("decode %s: %w", path, e)
				}
				if len(obj) == 0 {
					continue
				}
				if e = validateManifest(obj, c.Descriptor.Kubernetes.Namespace); e != nil {
					return fmt.Errorf("unit %s: %w", unit, e)
				}
				key := kube.Text(obj, "kind") + "/" + kube.Text(kube.Metadata(obj), "name")
				if seen[key] {
					return fmt.Errorf("duplicate workload %s", key)
				}
				seen[key] = true
				out = append(out, Manifest{unit, obj})
				count++
			}
			return nil
		})
		if e != nil {
			return nil, "", e
		}
		if count == 0 {
			return nil, "", fmt.Errorf("unit %s has no supported manifests", unit)
		}
	}
	return out, hex.EncodeToString(hash.Sum(nil)), nil
}

func validateManifest(obj map[string]any, namespace string) error {
	kind := kube.Text(obj, "kind")
	api := kube.Text(obj, "apiVersion")
	m := kube.Metadata(obj)
	name := kube.Text(m, "name")
	if !IDValid(name) || len(name) > 63 {
		return fmt.Errorf("invalid explicit resource name %q", name)
	}
	if ns := kube.Text(m, "namespace"); ns != "" && ns != namespace {
		return fmt.Errorf("manifest namespace %q differs from descriptor", ns)
	}
	if kube.Text(m, "generateName") != "" || kube.Text(m, "uid") != "" {
		return fmt.Errorf("generated names and authored UIDs are unsupported")
	}
	spec, _ := obj["spec"].(map[string]any)
	switch kind {
	case "Service":
		if api != "v1" {
			return fmt.Errorf("Service apiVersion must be v1")
		}
		if t := kube.Text(spec, "type"); t != "" && t != "ClusterIP" {
			return fmt.Errorf("only ClusterIP Services are supported")
		}
		if lenSlice(spec["externalIPs"]) > 0 || kube.Text(spec, "externalName") != "" {
			return fmt.Errorf("external service targets are unsupported")
		}
		return nil
	case "Deployment":
		if api != "apps/v1" {
			return fmt.Errorf("Deployment apiVersion must be apps/v1")
		}
	case "Job":
		if !positiveInteger(spec["activeDeadlineSeconds"]) {
			return fmt.Errorf("finite Jobs require positive activeDeadlineSeconds")
		}
		if api != "batch/v1" {
			return fmt.Errorf("Job apiVersion must be batch/v1")
		}
		if v, ok := spec["suspend"].(bool); ok && v {
			return fmt.Errorf("suspended Jobs cannot complete")
		}
	default:
		return fmt.Errorf("unsupported resource kind %q", kind)
	}
	template, _ := spec["template"].(map[string]any)
	pod, _ := template["spec"].(map[string]any)
	for _, key := range []string{"hostNetwork", "hostPID", "hostIPC"} {
		if v, _ := pod[key].(bool); v {
			return fmt.Errorf("host sharing is unsupported")
		}
	}
	if value := pod["volumes"]; value != nil {
		if _, ok := value.([]any); !ok {
			return fmt.Errorf("pod volumes must be an array")
		}
	}
	for _, value := range asSlice(pod["volumes"]) {
		volume, ok := value.(map[string]any)
		if !ok || !IDValid(kube.Text(volume, "name")) {
			return fmt.Errorf("pod volumes require an explicit valid name")
		}
		sources := 0
		// A source allowlist excludes generic ephemeral PVCs and inline network
		// storage as well as the obvious persistent-volume and host-path cases.
		for key, source := range volume {
			switch key {
			case "name":
				continue
			case "emptyDir", "configMap", "secret", "projected", "downwardAPI":
				if _, ok := source.(map[string]any); !ok {
					return fmt.Errorf("volume source %s must be an object", key)
				}
				sources++
			default:
				return fmt.Errorf("volume source %s is outside the stateless pilot", key)
			}
		}
		if sources != 1 {
			return fmt.Errorf("pod volumes require exactly one supported source")
		}
	}
	containers := asSlice(pod["containers"])
	if len(containers) == 0 {
		return fmt.Errorf("workload requires containers")
	}
	for _, value := range append(containers, asSlice(pod["initContainers"])...) {
		c, _ := value.(map[string]any)
		if strings.TrimSpace(kube.Text(c, "image")) == "" {
			return fmt.Errorf("container image is required")
		}
		security, _ := c["securityContext"].(map[string]any)
		if v, _ := security["privileged"].(bool); v {
			return fmt.Errorf("privileged containers are unsupported")
		}
		if kube.Text(c, "imagePullPolicy") != "Never" {
			return fmt.Errorf("prebuilt local images require imagePullPolicy: Never")
		}
	}
	return nil
}
func asSlice(v any) []any { s, _ := v.([]any); return s }
func lenSlice(v any) int  { return len(asSlice(v)) }

func annotate(m Manifest, id, token, runID, namespace string) {
	meta := kube.Metadata(m.Object)
	m.Object["metadata"] = meta
	meta["namespace"] = namespace
	addLabels(meta, id, token, m.Unit)
	if kube.Text(m.Object, "kind") == "Service" {
		return
	}
	spec, _ := m.Object["spec"].(map[string]any)
	template, _ := spec["template"].(map[string]any)
	tm, _ := template["metadata"].(map[string]any)
	if tm == nil {
		tm = map[string]any{}
		template["metadata"] = tm
	}
	addLabels(tm, id, token, m.Unit)
	if kube.Text(m.Object, "kind") == "Job" {
		pod, _ := template["spec"].(map[string]any)
		for _, v := range asSlice(pod["containers"]) {
			c, _ := v.(map[string]any)
			env := []any{}
			for _, v := range asSlice(c["env"]) {
				item, _ := v.(map[string]any)
				if item["name"] != "EXPHERE_RUNTIME_ID" && item["name"] != "EXPHERE_RUN_ID" {
					env = append(env, v)
				}
			}
			c["env"] = append(env, map[string]any{"name": "EXPHERE_RUNTIME_ID", "value": id}, map[string]any{"name": "EXPHERE_RUN_ID", "value": runID})
		}
	}
}
func addLabels(meta map[string]any, id, token, unit string) {
	labels, _ := meta["labels"].(map[string]any)
	if labels == nil {
		labels = map[string]any{}
		meta["labels"] = labels
	}
	labels["exphere.dev/runtime"] = id
	labels["exphere.dev/ownership-token"] = token
	labels["exphere.dev/unit"] = unit
}

func terraformConfig(c *Config) (string, error) {
	dir, e := c.Resolve(c.Descriptor.Terraform.Directory)
	if e != nil {
		return "", e
	}
	entries, e := os.ReadDir(dir)
	if e != nil {
		return "", e
	}
	found := false
	providerCount := 0
	for _, entry := range entries {
		name := entry.Name()
		if entry.Type()&os.ModeSymlink != 0 {
			return "", fmt.Errorf("Terraform symlinks are unsupported")
		}
		if entry.IsDir() {
			if name == ".terraform" {
				continue
			}
			return "", fmt.Errorf("Terraform module directories are unsupported")
		}
		if strings.HasSuffix(name, ".tf") {
			return "", fmt.Errorf("pilot accepts native .tf.json only: %s", name)
		}
		if strings.Contains(name, ".tfvars") {
			return "", fmt.Errorf("Terraform variable files are unsupported; use explicit runtime inputs")
		}
		if !strings.HasSuffix(name, ".tf.json") {
			continue
		}
		found = true
		b, e := os.ReadFile(filepath.Join(dir, name))
		if e != nil {
			return "", e
		}
		var doc map[string]any
		if e = StrictJSON(b, &doc); e != nil {
			return "", e
		}
		for key := range doc {
			if key != "terraform" && key != "provider" && key != "variable" && key != "resource" && key != "output" && key != "locals" {
				return "", fmt.Errorf("unsupported Terraform block %q", key)
			}
		}
		if forbiddenTF(doc) {
			return "", fmt.Errorf("provisioners, imports, external data and functions are unsupported in Terraform preparation")
		}
		providers, providerObject := doc["provider"].(map[string]any)
		if _, exists := doc["provider"]; exists && !providerObject {
			return "", fmt.Errorf("Terraform provider blocks must use the supported object form")
		}
		for name, v := range providers {
			if name != "kubernetes" {
				return "", fmt.Errorf("unsupported provider %q", name)
			}
			providerCount++
			if providerCount > 1 {
				return "", fmt.Errorf("exactly one explicit Kubernetes provider is required across the Terraform root")
			}
			p, ok := v.(map[string]any)
			if !ok {
				return "", fmt.Errorf("Kubernetes provider must be one unaliased configuration object")
			}
			if p["config_path"] != "${var.kubeconfig}" || p["config_context"] != "${var.context}" {
				return "", fmt.Errorf("provider must use explicit kubeconfig/context variables")
			}
			for k := range p {
				if k != "config_path" && k != "config_context" {
					return "", fmt.Errorf("unsupported provider option %s", k)
				}
			}
		}
		tf, _ := doc["terraform"].(map[string]any)
		if tf["cloud"] != nil {
			return "", fmt.Errorf("remote Terraform execution is unsupported")
		}
		backend, _ := tf["backend"].(map[string]any)
		for k := range backend {
			if k != "local" {
				return "", fmt.Errorf("only local Terraform state is supported")
			}
		}
		req, _ := tf["required_providers"].(map[string]any)
		for key, v := range req {
			r, _ := v.(map[string]any)
			if key != "kubernetes" || r["source"] != "hashicorp/kubernetes" {
				return "", fmt.Errorf("only hashicorp/kubernetes provider is supported")
			}
		}
		resources, resourceObject := doc["resource"].(map[string]any)
		if _, exists := doc["resource"]; exists && !resourceObject {
			return "", fmt.Errorf("Terraform resources must use the supported object form")
		}
		for kind, declarations := range resources {
			if kind != "kubernetes_namespace_v1" && kind != "kubernetes_resource_quota_v1" {
				return "", fmt.Errorf("unsupported Terraform preparation resource %s", kind)
			}
			named, ok := declarations.(map[string]any)
			if !ok {
				return "", fmt.Errorf("Terraform %s declarations must be named objects", kind)
			}
			for name, declaration := range named {
				resource, ok := declaration.(map[string]any)
				if !ok {
					return "", fmt.Errorf("Terraform resource %s.%s must be an object", kind, name)
				}
				// Terraform JSON represents provider references as literal strings.
				// An omitted reference uses the sole explicit default provider.
				if reference, exists := resource["provider"]; exists {
					if reference != "kubernetes" {
						return "", fmt.Errorf("Terraform resource %s.%s must use the default Kubernetes provider; aliases are unsupported", kind, name)
					}
				}
			}
		}
	}
	if !found {
		return "", fmt.Errorf("no native .tf.json preparation configuration")
	}
	// Terraform otherwise synthesizes a default provider whose target can come
	// from ambient environment variables. Never permit that implicit fallback.
	if providerCount != 1 {
		return "", fmt.Errorf("exactly one explicit Kubernetes provider using runtime kubeconfig/context variables is required")
	}
	return dir, nil
}
func forbiddenTF(v any) bool {
	switch v := v.(type) {
	case map[string]any:
		for k, x := range v {
			if k == "provisioner" || k == "connection" || k == "exec" {
				return true
			}
			if forbiddenTF(x) {
				return true
			}
		}
	case []any:
		for _, x := range v {
			if forbiddenTF(x) {
				return true
			}
		}
	case string:
		for _, s := range []string{"file(", "filebase64(", "templatefile(", "data.", "provider::"} {
			if strings.Contains(v, s) {
				return true
			}
		}
	}
	return false
}

// positiveInteger accepts the numeric representations produced by JSON and YAML.
func positiveInteger(v any) bool {
	switch n := v.(type) {
	case int:
		return n > 0
	case int64:
		return n > 0
	case uint64:
		return n > 0
	case float64:
		return n > 0 && n == float64(int64(n))
	}
	return false
}
