package runtime

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/jonatassales/exphere/packages/cli/src/internal/templates"
)

// GuidedInput contains consumer choices used once to create editable native files.
// These values are not duplicated in the generated descriptor.
type GuidedInput struct {
	Owner, Context, Namespace string
	Units                     []UnitInput
	Quotas                    map[string]string
}

// UnitInput describes the initial workload; subsequent edits belong to Kubernetes.
type UnitInput struct {
	Name, Component, Image, Kind                     string
	Port                                             int
	CPURequest, CPULimit, MemoryRequest, MemoryLimit string
	Replicas                                         int
	ReadinessPath                                    string
}

func runtimeDestination(root, id string) (string, error) {
	if !IDValid(id) {
		return "", fmt.Errorf("invalid runtime ID %q", id)
	}
	root, err := canonicalRoot(root)
	if err != nil {
		return "", err
	}
	if err := rejectLegacy(root, id); err != nil {
		return "", err
	}
	return root, nil
}

// Init writes an intentionally incomplete v2 descriptor and instructions.
// It refuses existing output and never initializes Terraform or starts a workload.
func Init(root, id string) error {
	root, err := runtimeDestination(root, id)
	if err != nil {
		return err
	}
	return templates.Publish(root, ".exphere/runtimes/"+id, func(stage string) error {
		descriptor := Descriptor{Version: 2, ID: id, Environment: "local", Units: map[string]Unit{}, Terraform: TerraformConfig{Directory: "terraform"}}
		if err := writeJSON(stage, "schema.json", descriptor); err != nil {
			return err
		}
		return templates.Write(stage, "README.md", []byte("# "+id+"\n\nThis manual scaffold is deliberately incomplete. Set owner, Kubernetes context and namespace, and at least one unit in schema.json. Each unit name must match its existing component directory; component paths are relative to the project. Terraform and manifest references are relative to this runtime. Add native Terraform .tf.json namespace/quota configuration and unit Kubernetes manifests, then run `ex runtime validate "+id+"`.\n\nNative Kubernetes files own image, resources, replicas, probes, volumes, and scheduling. Terraform owns namespace and quotas with the context, namespace, kubeconfig, owner, and ownership_token input variables. Only the hashicorp/kubernetes provider with namespace and quota resources is supported; modules, provisioners, data sources, and remote backends are rejected. Use a local backend; operational state belongs to .exphere/state, never this configuration directory. Quotas limit resources, not monetary spend. Application and agent source remain outside this runtime. Hooks are optional explicit .sh references and never run implicitly. Only stateless Deployments, ClusterIP Services, and finite Jobs are supported.\n\nNo legacy migration, dependency installation, image build, or infrastructure execution was performed.\n"))
	})
}

var quantity = regexp.MustCompile(`^(?:[0-9]+(?:\.[0-9]+)?|\.[0-9]+)(?:[eE][+-]?[0-9]+|[numkMGTPE]|[KMGTPE]i)?$`)

func validateGuidance(root string, input GuidedInput) error {
	if !validText(input.Owner) || !validText(input.Context) || !IDValid(input.Namespace) {
		return errors.New("owner, context, and a valid namespace are required")
	}
	if len(input.Units) == 0 || len(input.Quotas) == 0 {
		return errors.New("at least one unit and explicit resource quotas are required")
	}
	allowedQuotas := map[string]bool{"requests.cpu": true, "limits.cpu": true, "requests.memory": true, "limits.memory": true, "requests.ephemeral-storage": true, "limits.ephemeral-storage": true, "pods": true, "count/jobs.batch": true, "count/deployments.apps": true, "services": true}
	for key, value := range input.Quotas {
		if !allowedQuotas[key] || !quantity.MatchString(value) {
			return fmt.Errorf("unsupported quota or quantity %s=%s", key, value)
		}
	}
	names := make(map[string]bool)
	for _, unit := range input.Units {
		if !IDValid(unit.Name) || names[unit.Name] {
			return fmt.Errorf("invalid or duplicate unit %q", unit.Name)
		}
		names[unit.Name] = true
		if filepath.Base(unit.Component) != unit.Name {
			return fmt.Errorf("unit %s must match its component directory name", unit.Name)
		}
		path, err := SafePath(root, unit.Component)
		if err != nil {
			return err
		}
		info, err := os.Stat(path)
		if err != nil || !info.IsDir() {
			return fmt.Errorf("component %s must be a directory", unit.Component)
		}
		if strings.HasPrefix(unit.Component, ".exphere/runtimes/") {
			return errors.New("source components must remain outside runtime configuration")
		}
		if !validText(unit.Image) || strings.ContainsAny(unit.Image, " \t") {
			return fmt.Errorf("unit %s requires an existing image reference", unit.Name)
		}
		for _, value := range []string{unit.CPURequest, unit.CPULimit, unit.MemoryRequest, unit.MemoryLimit} {
			if !quantity.MatchString(value) {
				return fmt.Errorf("unit %s requires explicit CPU and memory quantities", unit.Name)
			}
		}
		switch unit.Kind {
		case "Deployment":
			if unit.Port < 1 || unit.Port > 65535 || unit.Replicas < 1 {
				return fmt.Errorf("unit %s requires a valid port and positive replicas", unit.Name)
			}
			parsed, err := url.ParseRequestURI(unit.ReadinessPath)
			if err != nil || !strings.HasPrefix(unit.ReadinessPath, "/") || parsed.IsAbs() || parsed.Host != "" {
				return fmt.Errorf("unit %s requires an HTTP readiness path", unit.Name)
			}
		case "Job":
			if unit.Port != 0 || unit.Replicas != 0 || unit.ReadinessPath != "" {
				return fmt.Errorf("job %s must not specify service port, replicas, or HTTP readiness", unit.Name)
			}
		default:
			return fmt.Errorf("unsupported workload kind %q; use Deployment or Job", unit.Kind)
		}
	}
	return nil
}

// Generate publishes a validated runtime from explicit consumer choices.
// Generation changes local configuration only; native tools are never executed.
func Generate(root, id string, input GuidedInput) error {
	root, err := runtimeDestination(root, id)
	if err != nil {
		return err
	}
	if err := validateGuidance(root, input); err != nil {
		return err
	}
	return templates.Publish(root, ".exphere/runtimes/"+id, func(stage string) error {
		descriptor := Descriptor{Version: 2, ID: id, Environment: "local", Owner: input.Owner, Units: make(map[string]Unit), Terraform: TerraformConfig{Directory: "terraform"}, Kubernetes: KubernetesConfig{Context: input.Context, Namespace: input.Namespace}}
		for _, unit := range input.Units {
			reference := "units/" + unit.Name + "/kubernetes"
			descriptor.Units[unit.Name] = Unit{Component: unit.Component, Kubernetes: UnitKubernetes{Manifests: reference}}
			workload, service := nativeUnit(id, input.Namespace, unit)
			if err := writeJSON(stage, reference+"/workload.json", workload); err != nil {
				return err
			}
			if service != nil {
				if err := writeJSON(stage, reference+"/service.json", service); err != nil {
					return err
				}
			}
		}
		if err := writeJSON(stage, "schema.json", descriptor); err != nil {
			return err
		}
		if err := writeJSON(stage, "terraform/main.tf.json", nativeTerraform(id, input.Quotas)); err != nil {
			return err
		}
		readme := "# " + id + "\n\nGenerated configuration is consumer-owned and editable. Component sources are referenced, never copied. The descriptor owns identity, references, and target selection; Kubernetes owns workload configuration; Terraform owns namespace and quotas.\n\n1. Review native files and run `ex runtime validate " + id + "`.\n2. Use `ex doctor`, create the project kind cluster explicitly, and load your already-built images.\n3. Run `ex runtime up " + id + "`, inspect the result, then `ex runtime down " + id + "`.\n\nTerraform receives explicit context, namespace, kubeconfig, owner, and ownership_token variables from the lifecycle. Do not store secrets here. State lives outside configuration under .exphere/state; it is required for safe cleanup. Deleting configuration is not cleanup. Runtime cleanup preserves the project cluster.\n\nJob defaults are finite: one completion, one worker, no retries, and a 120-second deadline. Review them for your use case. Image pull policy is Never for the local prebuilt-image pilot. Network access and cluster execution have not been verified by generation. Quotas are resource limits; no financial cost or savings is calculated.\n"
		if err := templates.Write(stage, "README.md", []byte(readme)); err != nil {
			return err
		}
		config := &Config{Root: root, Dir: stage, Descriptor: descriptor}
		if err := validateConfig(config); err != nil {
			return err
		}
		return validateNativeConfig(config)
	})
}

func writeJSON(dir, name string, value any) error {
	data, err := json.MarshalIndent(value, "", "  ")
	if err != nil {
		return err
	}
	return templates.Write(dir, name, append(data, '\n'))
}

type object = map[string]any

func nativeUnit(id, namespace string, u UnitInput) (object, object) {
	labels := object{"exphere.dev/runtime": id, "exphere.dev/unit": u.Name}
	metadata := object{"name": u.Name, "namespace": namespace, "labels": labels}
	container := object{"name": u.Name, "image": u.Image, "imagePullPolicy": "Never", "resources": object{"requests": object{"cpu": u.CPURequest, "memory": u.MemoryRequest}, "limits": object{"cpu": u.CPULimit, "memory": u.MemoryLimit}}}
	podSpec := object{"automountServiceAccountToken": false, "containers": []any{container}, "terminationGracePeriodSeconds": 30}
	podTemplate := object{"metadata": object{"labels": labels}, "spec": podSpec}
	if u.Kind == "Job" {
		podSpec["restartPolicy"] = "Never"
		return object{"apiVersion": "batch/v1", "kind": "Job", "metadata": metadata, "spec": object{"backoffLimit": 0, "activeDeadlineSeconds": 120, "completions": 1, "parallelism": 1, "template": podTemplate}}, nil
	}
	container["ports"] = []any{object{"name": "http", "containerPort": u.Port}}
	container["readinessProbe"] = object{"httpGet": object{"path": u.ReadinessPath, "port": "http"}, "periodSeconds": 5, "timeoutSeconds": 2, "failureThreshold": 12}
	deployment := object{"apiVersion": "apps/v1", "kind": "Deployment", "metadata": metadata, "spec": object{"replicas": u.Replicas, "selector": object{"matchLabels": labels}, "template": podTemplate}}
	service := object{"apiVersion": "v1", "kind": "Service", "metadata": metadata, "spec": object{"type": "ClusterIP", "selector": labels, "ports": []any{object{"name": "http", "port": u.Port, "targetPort": "http"}}}}
	return deployment, service
}

func nativeTerraform(id string, quotas map[string]string) object {
	variables := object{}
	for _, name := range []string{"context", "namespace", "kubeconfig", "owner", "ownership_token"} {
		variables[name] = object{"type": "string", "nullable": false}
	}
	labels := object{"exphere.dev/runtime": id, "exphere.dev/ownership-token": "${var.ownership_token}"}
	return object{
		"terraform": object{"required_version": ">= 1.6, < 2.0", "required_providers": object{"kubernetes": object{"source": "hashicorp/kubernetes", "version": "3.2.1"}}, "backend": object{"local": object{}}},
		"variable":  variables,
		"provider":  object{"kubernetes": object{"config_path": "${var.kubeconfig}", "config_context": "${var.context}"}},
		"resource": object{
			"kubernetes_namespace_v1":      object{"runtime": object{"metadata": []any{object{"name": "${var.namespace}", "labels": labels, "annotations": object{"exphere.dev/owner": "${var.owner}"}}}}},
			"kubernetes_resource_quota_v1": object{"runtime": object{"metadata": []any{object{"name": "runtime", "namespace": "${kubernetes_namespace_v1.runtime.metadata[0].name}", "labels": labels}}, "spec": []any{object{"hard": quotas}}}},
		},
	}
}
