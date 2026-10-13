// Package cluster manages one explicitly owned kind cluster per consumer project.
// Mutations share a project-wide lock with microruntime operations. Observation
// can report drift, but never silently adopts an unrecorded infrastructure target.
package cluster

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	kindadapter "github.com/jonatassales/exphere/packages/ex/src/internal/adapters/kind"
	"github.com/jonatassales/exphere/packages/ex/src/internal/core/project"
	"github.com/jonatassales/exphere/packages/ex/src/internal/kernel"
)

// State binds a private kubeconfig and observed cluster UID to project ownership.
// Status describes the last recorded operation, not an assertion of readiness.
// Baseline namespaces protect deletion from erasing namespaces created elsewhere.
type State struct {
	ProjectID        string                    `json:"projectId"`
	Name             string                    `json:"name"`
	Context          string                    `json:"context"`
	Kubeconfig       string                    `json:"kubeconfig"`
	UID              string                    `json:"uid"`
	Status           string                    `json:"status"`
	NamespaceUIDs    map[string]string         `json:"namespaceUIDs,omitempty"`
	InventoryVersion int                       `json:"inventoryVersion"`
	Bootstrap        map[string]ObjectIdentity `json:"bootstrap,omitempty"`
	ResourceTypes    []string                  `json:"resourceTypes,omitempty"`
	UpdatedAt        string                    `json:"updatedAt"`
	Error            string                    `json:"error,omitempty"`
}

// Service coordinates kind operations and Kubernetes ownership observations.
type Service struct{ Runner kernel.Runner }

type object struct {
	Kind     string `json:"kind"`
	Metadata struct {
		Name      string `json:"name"`
		UID       string `json:"uid"`
		Namespace string `json:"namespace"`
	} `json:"metadata"`
}

type list struct {
	Items []object `json:"items"`
}

// Read returns the persisted cluster identity without making tool or network calls.
func Read(p *project.Project) (*State, error) {
	path, err := project.SafePath(p.Root, ".exphere/state/cluster.json")
	if err != nil {
		return nil, err
	}
	var state State
	if err := kernel.ReadJSON(path, &state); err != nil {
		return nil, err
	}
	if state.ProjectID != p.ID || state.Name != "ex-"+p.ID[:12] || state.Context != "kind-"+state.Name {
		return nil, errors.New("cluster ownership metadata does not match the project")
	}
	expected, err := project.SafePath(p.Root, ".exphere/state/cluster.kubeconfig")
	if err != nil {
		return nil, err
	}
	if state.Kubeconfig != expected {
		return nil, errors.New("cluster kubeconfig must be the recorded private project file")
	}
	return &state, nil
}

// Read returns the persisted state without inspecting the infrastructure.
func (s Service) Read(p *project.Project) (*State, error) { return Read(p) }

func save(p *project.Project, state *State) error {
	state.UpdatedAt = time.Now().UTC().Format(time.RFC3339Nano)
	return kernel.AtomicJSON(filepath.Join(p.StateDir(), "cluster.json"), state)
}

func recordFailure(p *project.Project, state *State, operation error) error {
	if errors.Is(operation, context.Canceled) || errors.Is(operation, context.DeadlineExceeded) {
		state.Status = "interrupted"
	} else {
		state.Status = "failed"
	}
	state.Error = operation.Error()
	if err := save(p, state); err != nil {
		return errors.Join(operation, fmt.Errorf("record cluster failure: %w", err))
	}
	return operation
}

// Create starts a new kind cluster only after recording intent and ensuring its
// generated name is unused. Repeated calls reuse a verified ready record. A
// partially created target without an observed UID requires manual recovery.
func (s Service) Create(ctx context.Context, p *project.Project) error {
	release, err := kernel.AcquireLock(p.ClusterLock())
	if err != nil {
		return err
	}
	defer release()
	prior, err := Read(p)
	if err == nil && prior.Status != "deleted" {
		if prior.Status == "ready" {
			return s.verify(ctx, prior)
		}
		return fmt.Errorf("cluster has unresolved state %q; inspect it before recovery", prior.Status)
	}
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		return err
	}
	client := kindadapter.Client{Runner: s.Runner}
	names, err := client.Clusters(ctx)
	if err != nil {
		return err
	}
	name := "ex-" + p.ID[:12]
	for _, existing := range names {
		if existing == name {
			return errors.New("a cluster already uses the project name; refusing to adopt it")
		}
	}
	kubeconfig, err := project.SafePath(p.Root, ".exphere/state/cluster.kubeconfig")
	if err != nil {
		return err
	}
	// A previous deleted record may leave credentials; remove only the owned file.
	if _, err := os.Lstat(kubeconfig); err == nil {
		if prior == nil || prior.Status != "deleted" {
			return errors.New("unrecorded private kubeconfig exists; refusing to overwrite it")
		}
		if err := os.Remove(kubeconfig); err != nil {
			return err
		}
	} else if !errors.Is(err, os.ErrNotExist) {
		return err
	}
	state := &State{ProjectID: p.ID, Name: name, Context: "kind-" + name, Kubeconfig: kubeconfig, Status: "creating"}
	if err := save(p, state); err != nil {
		return err
	}
	operationCtx, cancel := context.WithTimeout(ctx, 5*time.Minute)
	defer cancel()
	if err := client.Create(operationCtx, name, kubeconfig); err != nil {
		return recordFailure(p, state, err)
	}
	if err := os.Chmod(kubeconfig, 0600); err != nil {
		return recordFailure(p, state, err)
	}
	namespaces, err := s.namespaces(operationCtx, state)
	if err != nil {
		return recordFailure(p, state, err)
	}
	uid := namespaces["kube-system"]
	if uid == "" {
		return recordFailure(p, state, errors.New("cluster did not return a kube-system UID"))
	}
	state.UID, state.NamespaceUIDs = uid, namespaces
	// Persist the observed identity before any optional inventory could fail.
	if err := save(p, state); err != nil {
		return err
	}
	baseline, resources, err := s.inventory(operationCtx, state)
	if err != nil {
		return recordFailure(p, state, err)
	}
	state.Bootstrap, state.ResourceTypes, state.InventoryVersion = baseline, resources, 1
	state.Status, state.Error = "ready", ""
	return save(p, state)
}

// Inspect verifies identity without updating the ownership ledger or adopting
// resources. A missing or changed target is returned as an explicit error.
func (s Service) Inspect(ctx context.Context, p *project.Project) (*State, error) {
	state, err := Read(p)
	if err != nil {
		return nil, err
	}
	if state.Status == "deleted" {
		return state, nil
	}
	if err := s.verify(ctx, state); err != nil {
		return state, err
	}
	return state, nil
}

// LoadImage imports a consumer-built local image after verifying cluster identity.
// It does not build an application or contact a remote registry intentionally.
func (s Service) LoadImage(ctx context.Context, p *project.Project, image string) error {
	if strings.TrimSpace(image) == "" || strings.HasPrefix(image, "-") || strings.ContainsAny(image, "\r\n\t ") {
		return errors.New("provide one explicit local image reference")
	}
	release, err := kernel.AcquireLock(p.ClusterLock())
	if err != nil {
		return err
	}
	defer release()
	state, err := Read(p)
	if err != nil {
		return err
	}
	if state.Status != "ready" {
		return fmt.Errorf("cluster is not ready: %s", state.Status)
	}
	if err := s.verify(ctx, state); err != nil {
		return err
	}
	operationCtx, cancel := context.WithTimeout(ctx, 5*time.Minute)
	defer cancel()
	return (kindadapter.Client{Runner: s.Runner}).LoadImage(operationCtx, state.Name, image)
}

// Delete removes the owned project cluster only when runtime records are fully
// closed and baseline namespace identities remain unchanged. Foreign namespaces
// or unrecognized persisted objects anywhere in the cluster block deletion.
// Configuration and evidence stay.
func (s Service) Delete(ctx context.Context, p *project.Project) error {
	release, err := kernel.AcquireLock(p.ClusterLock())
	if err != nil {
		return err
	}
	defer release()
	state, err := Read(p)
	if err != nil {
		return err
	}
	if state.Status == "deleted" {
		return nil
	}
	if err := runtimeRecordsClosed(p); err != nil {
		return err
	}
	client := kindadapter.Client{Runner: s.Runner}
	names, err := client.Clusters(ctx)
	if err != nil {
		return err
	}
	found := false
	for _, name := range names {
		if name == state.Name {
			found = true
			break
		}
	}
	if !found {
		// Reconcile a failed create cleaned up by kind, or an interrupted delete.
		// No Kubernetes request or infrastructure deletion occurs in this branch.
		state.Status, state.Error = "deleted", ""
		if err := save(p, state); err != nil {
			return err
		}
		if err := os.Remove(state.Kubeconfig); err != nil && !errors.Is(err, os.ErrNotExist) {
			return err
		}
		return nil
	}
	if err := s.verify(ctx, state); err != nil {
		return err
	}
	namespaces, err := s.namespaces(ctx, state)
	if err != nil {
		return err
	}
	if len(state.NamespaceUIDs) == 0 {
		return errors.New("cluster baseline is missing; automatic deletion is unsafe")
	}
	for name, uid := range namespaces {
		if state.NamespaceUIDs[name] != uid {
			return fmt.Errorf("namespace %q is foreign or was replaced; refusing cluster deletion", name)
		}
	}
	for name, uid := range state.NamespaceUIDs {
		if namespaces[name] != uid {
			return fmt.Errorf("baseline namespace %q is missing or changed; refusing cluster deletion", name)
		}
	}
	objects, resources, err := s.inventory(ctx, state)
	if err != nil {
		return err
	}
	if state.InventoryVersion != 1 || len(state.Bootstrap) == 0 || len(state.ResourceTypes) == 0 {
		return errors.New("complete cluster bootstrap inventory is missing; refusing cluster deletion")
	}
	available := map[string]bool{}
	for _, resource := range resources {
		available[resource] = true
	}
	for _, resource := range state.ResourceTypes {
		if !available[resource] {
			return fmt.Errorf("resource API %q disappeared; cluster inventory is incomplete", resource)
		}
	}
	known := map[string]bool{}
	for key, observed := range objects {
		original, exists := state.Bootstrap[key]
		if exists && original.UID == observed.UID {
			known[observed.UID] = true
		}
	}
	// Newly created descendants are accepted only through a controller UID chain
	// rooted in an unchanged bootstrap object that is still present in inventory.
	for pass := 0; pass < len(objects); pass++ {
		changed := false
		for _, observed := range objects {
			if known[observed.UID] {
				continue
			}
			for _, owner := range observed.Controllers {
				if known[owner] {
					known[observed.UID] = true
					changed = true
					break
				}
			}
		}
		if !changed {
			break
		}
	}
	for key, observed := range objects {
		if !known[observed.UID] {
			return fmt.Errorf("resource %q is foreign or changed; refusing cluster deletion", key)
		}
	}
	state.Status, state.Error = "deleting", ""
	if err := save(p, state); err != nil {
		return err
	}
	operationCtx, cancel := context.WithTimeout(ctx, 5*time.Minute)
	defer cancel()
	if err := client.Delete(operationCtx, state.Name); err != nil {
		return recordFailure(p, state, err)
	}
	names, err = client.Clusters(operationCtx)
	if err != nil {
		return recordFailure(p, state, err)
	}
	for _, name := range names {
		if name == state.Name {
			return recordFailure(p, state, errors.New("kind still reports the cluster after deletion"))
		}
	}
	state.Status = "deleted"
	if err := save(p, state); err != nil {
		return err
	}
	if err := os.Remove(state.Kubeconfig); err != nil && !errors.Is(err, os.ErrNotExist) {
		return err
	}
	return nil
}

func (s Service) verify(ctx context.Context, state *State) error {
	if state.UID == "" {
		return errors.New("cluster UID was not recorded; automatic adoption or deletion is unsafe")
	}
	namespaces, err := s.namespaces(ctx, state)
	if err != nil {
		return err
	}
	if namespaces["kube-system"] != state.UID {
		return errors.New("cluster identity changed; refusing to operate on a replacement target")
	}
	return nil
}

func (s Service) query(ctx context.Context, state *State, args ...string) (string, error) {
	queryCtx, cancel := context.WithTimeout(ctx, 30*time.Second)
	defer cancel()
	command := []string{"--kubeconfig", state.Kubeconfig, "--context", state.Context, "--request-timeout=20s"}
	command = append(command, args...)
	result, err := s.Runner.Run(queryCtx, kernel.Command{Name: "kubectl", Args: command})
	if err != nil {
		return "", fmt.Errorf("inspect cluster: %w: %s", err, strings.TrimSpace(result.Stderr))
	}
	return result.Stdout, nil
}

func (s Service) namespaces(ctx context.Context, state *State) (map[string]string, error) {
	raw, err := s.query(ctx, state, "get", "namespaces", "-o", "json")
	if err != nil {
		return nil, err
	}
	var items list
	if err := json.Unmarshal([]byte(raw), &items); err != nil {
		return nil, fmt.Errorf("decode namespace inventory: %w", err)
	}
	result := make(map[string]string, len(items.Items))
	for _, item := range items.Items {
		if item.Metadata.Name == "" || item.Metadata.UID == "" {
			return nil, errors.New("namespace inventory lacks observed identity")
		}
		result[item.Metadata.Name] = item.Metadata.UID
	}
	return result, nil
}

// ObjectIdentity is a persisted object identity without object payloads or secrets.
// Controllers contains only owner-reference UIDs explicitly marked controller=true.
type ObjectIdentity struct {
	UID         string   `json:"uid"`
	Controllers []string `json:"controllers,omitempty"`
}

func (s Service) inventory(ctx context.Context, state *State) (map[string]ObjectIdentity, []string, error) {
	// Non-deletable virtual API views (for example ComponentStatus and metrics) do
	// not represent persisted resources destroyed with the cluster. Discover all
	// listable/deletable types; Events are the only ignored persisted objects.
	inventory := map[string]ObjectIdentity{}
	resources := []string{}
	const projection = `{{range .items}}{{if .metadata.namespace}}{{.metadata.namespace}}{{end}}{{"\t"}}{{.metadata.name}}{{"\t"}}{{.metadata.uid}}{{"\t"}}{{range .metadata.ownerReferences}}{{if .controller}}{{.uid}}{{","}}{{end}}{{end}}{{"\n"}}{{end}}`
	for _, scope := range []string{"true", "false"} {
		raw, err := s.query(ctx, state, "api-resources", "--namespaced="+scope, "--verbs=list,delete", "-o", "name")
		if err != nil {
			return nil, nil, err
		}
		kinds := strings.Fields(raw)
		if len(kinds) == 0 {
			return nil, nil, errors.New("empty API discovery cannot establish complete cluster ownership")
		}
		sort.Strings(kinds)
		for _, resource := range kinds {
			if resource == "events" || resource == "events.events.k8s.io" {
				continue
			}
			resources = append(resources, scope+"/"+resource)
			args := []string{"get", resource, "-o", "go-template=" + projection}
			if scope == "true" {
				args = append(args, "--all-namespaces")
			}
			raw, err := s.query(ctx, state, args...)
			if err != nil {
				return nil, nil, fmt.Errorf("incomplete cluster inventory (%s): %w", resource, err)
			}
			for _, line := range strings.Split(strings.TrimSuffix(raw, "\n"), "\n") {
				if line == "" {
					continue
				}
				parts := strings.Split(line, "\t")
				if len(parts) != 4 || parts[1] == "" || parts[2] == "" || parts[2] == "<no value>" || (scope == "true" && parts[0] == "") {
					return nil, nil, fmt.Errorf("resource %s lacks an observable persisted identity", resource)
				}
				key := resource + "/" + parts[0] + "/" + parts[1]
				if _, duplicate := inventory[key]; duplicate {
					return nil, nil, fmt.Errorf("duplicate identity in cluster inventory: %s", key)
				}
				identity := ObjectIdentity{UID: parts[2]}
				for _, owner := range strings.Split(strings.TrimSuffix(parts[3], ","), ",") {
					if owner != "" && owner != "<no value>" {
						identity.Controllers = append(identity.Controllers, owner)
					}
				}
				inventory[key] = identity
			}
		}
	}
	if len(inventory) == 0 {
		return nil, nil, errors.New("empty object inventory cannot establish cluster ownership")
	}
	return inventory, resources, nil
}

func runtimeRecordsClosed(p *project.Project) error {
	dir, err := project.SafePath(p.Root, ".exphere/state/runtimes")
	if err != nil {
		return err
	}
	entries, err := os.ReadDir(dir)
	if errors.Is(err, os.ErrNotExist) {
		return nil
	}
	if err != nil {
		return err
	}
	for _, entry := range entries {
		if entry.Type()&os.ModeSymlink != 0 || !entry.IsDir() {
			return fmt.Errorf("unexpected runtime state entry %q; refusing cluster deletion", entry.Name())
		}
		path, err := project.SafePath(dir, filepath.Join(entry.Name(), "state.json"))
		if err != nil {
			return err
		}
		var record map[string]json.RawMessage
		if err := kernel.ReadJSON(path, &record); err != nil {
			return fmt.Errorf("runtime %q has incomplete state: %w", entry.Name(), err)
		}
		var identity string
		if err := json.Unmarshal(record["projectId"], &identity); err != nil || identity != p.ID {
			return fmt.Errorf("runtime %q has inconsistent project ownership", entry.Name())
		}
		var settled bool
		if err := json.Unmarshal(record["settled"], &settled); err != nil || !settled {
			return fmt.Errorf("runtime %q has an unresolved operation; refusing cluster deletion", entry.Name())
		}
		var namespaceUID string
		if value, ok := record["namespaceUid"]; ok {
			if err := json.Unmarshal(value, &namespaceUID); err != nil || namespaceUID != "" {
				return fmt.Errorf("runtime %q still owns a namespace; refusing cluster deletion", entry.Name())
			}
		}
		var status string
		if err := json.Unmarshal(record["status"], &status); err != nil {
			return fmt.Errorf("runtime %q has invalid status", entry.Name())
		}
		if status != "down" && status != "absent" {
			return fmt.Errorf("runtime %q is %q; clean it up before deleting the cluster", entry.Name(), status)
		}
		// Domain-owned runtime details can evolve, but remaining recorded resources
		// must never be ignored just because a status string says "down".
		for _, field := range []string{"resources", "inventory"} {
			if value, ok := record[field]; ok && string(value) != "null" && string(value) != "[]" && string(value) != "{}" {
				return fmt.Errorf("runtime %q still records %s; refusing cluster deletion", entry.Name(), field)
			}
		}
	}
	return nil
}
