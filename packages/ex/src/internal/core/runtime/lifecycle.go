package runtime

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"time"

	kube "github.com/jonatassales/exphere/packages/ex/src/internal/adapters/kubernetes"
	tf "github.com/jonatassales/exphere/packages/ex/src/internal/adapters/terraform"
	"github.com/jonatassales/exphere/packages/ex/src/internal/core/cluster"
	"github.com/jonatassales/exphere/packages/ex/src/internal/core/project"
	"github.com/jonatassales/exphere/packages/ex/src/internal/kernel"
)

// State records ownership obligations independently of editable configuration.
// Settled means owned subprocesses have returned, not that resources are healthy.
type State struct {
	Version      int                    `json:"version"`
	ProjectID    string                 `json:"projectId"`
	ID           string                 `json:"id"`
	Status       string                 `json:"status"`
	Settled      bool                   `json:"settled"`
	Token        string                 `json:"token"`
	ClusterUID   string                 `json:"clusterUid"`
	Context      string                 `json:"context"`
	Namespace    string                 `json:"namespace"`
	NamespaceUID string                 `json:"namespaceUid,omitempty"`
	ConfigHash   string                 `json:"configHash"`
	ToolVersions map[string]ToolVersion `json:"toolVersions"`
	Images       []ContainerObservation `json:"images,omitempty"`
	RunID        string                 `json:"runId"`
	Operation    string                 `json:"operation"`
	UpdatedAt    time.Time              `json:"updatedAt"`
	Resources    []kube.Resource        `json:"resources"`
	Units        map[string]string      `json:"units"`
}

// Service coordinates local operations. Native configuration remains consumer-owned.
type Service struct{ Runner kernel.Runner }

func statePath(p *project.Project, id string) string {
	return filepath.Join(p.StateDir(), "runtimes", id, "state.json")
}
func readState(p *project.Project, id string) (*State, error) {
	if !IDValid(id) {
		return nil, fmt.Errorf("invalid runtime id")
	}
	var state State
	if e := kernel.ReadJSON(statePath(p, id), &state); e != nil {
		return nil, e
	}
	if state.Version != 1 || state.ID != id || state.ProjectID != p.ID || state.Token == "" || !IDValid(state.Namespace) || state.ClusterUID == "" {
		return nil, fmt.Errorf("runtime state identity is inconsistent")
	}
	for _, resource := range state.Resources {
		expectedAPI := map[string]string{"Deployment": "apps/v1", "Service": "v1", "Job": "batch/v1"}[resource.Kind]
		if expectedAPI == "" || resource.APIVersion != expectedAPI || !IDValid(resource.Name) || resource.Namespace != state.Namespace || !IDValid(resource.Unit) {
			return nil, fmt.Errorf("runtime resource state contains an unsupported or inconsistent target")
		}
	}
	return &state, nil
}
func saveState(p *project.Project, s *State) error {
	s.UpdatedAt = time.Now().UTC()
	return kernel.AtomicJSON(statePath(p, s.ID), s)
}

func (s Service) target(ctx context.Context, p *project.Project, c *Config) (*cluster.State, kube.Client, error) {
	cs, e := (cluster.Service{Runner: s.Runner}).Inspect(ctx, p)
	if e != nil {
		return nil, kube.Client{}, e
	}
	if cs.Status != "ready" {
		return nil, kube.Client{}, fmt.Errorf("project cluster is not ready")
	}
	if c.Descriptor.Kubernetes.Context != cs.Context {
		return nil, kube.Client{}, fmt.Errorf("runtime context must equal the managed project context %q", cs.Context)
	}
	return cs, kube.Client{Runner: s.Runner, Kubeconfig: cs.Kubeconfig, Context: cs.Context, Namespace: c.Descriptor.Kubernetes.Namespace}, nil
}
func preparation(s Service, c *Config, cs *cluster.State, p *project.Project, st *State, dir string) tf.Client {
	return tf.Client{Runner: s.Runner, Directory: dir, StateDir: filepath.Dir(statePath(p, st.ID)), Context: st.Context, Namespace: st.Namespace, Kubeconfig: cs.Kubeconfig, Owner: c.Descriptor.Owner, Token: st.Token}
}

// Up validates all selected units, prepares their namespace, and waits for each
// workload. It preserves partial effects for explicit inspection and recovery.
func (s Service) Up(ctx context.Context, p *project.Project, id string) (st *State, err error) {
	unlock, e := kernel.AcquireLock(p.ClusterLock())
	if e != nil {
		return nil, e
	}
	defer unlock()
	c, e := Load(p.Root, id)
	if e != nil {
		return nil, e
	}
	items, hash, e := manifests(c)
	if e != nil {
		return nil, e
	}
	dir, e := terraformConfig(c)
	if e != nil {
		return nil, e
	}
	hash, e = configurationHash(hash, dir)
	if e != nil {
		return nil, e
	}
	cs, kc, e := s.target(ctx, p, c)
	if e != nil {
		return nil, e
	}
	if e = s.imagesReady(ctx, cs, items); e != nil {
		return nil, e
	}
	old, e := readState(p, id)
	if e != nil && !errors.Is(e, os.ErrNotExist) {
		return nil, e
	}
	if old != nil && (old.Status != "down" || !old.Settled || len(old.Resources) != 0 || old.NamespaceUID != "") {
		return old, fmt.Errorf("runtime has existing obligations (%s); inspect and down before a new up", old.Status)
	}
	ns, e := kc.Object(ctx, "namespace", c.Descriptor.Kubernetes.Namespace)
	if e != nil {
		return nil, e
	}
	if ns != nil {
		return nil, fmt.Errorf("namespace already exists; refusing adoption")
	}
	token, e := kernel.RandomID()
	if e != nil {
		return nil, e
	}
	run, e := kernel.RandomID()
	if e != nil {
		return nil, e
	}
	st = &State{Version: 1, ProjectID: p.ID, ID: id, Token: token, ClusterUID: cs.UID, Context: cs.Context, Namespace: c.Descriptor.Kubernetes.Namespace, ConfigHash: hash, RunID: run, Operation: "up", Status: "preparing", Units: map[string]string{}}
	st.ToolVersions = s.toolVersions(ctx)
	st.Images = configuredContainers(items)
	for _, m := range items {
		annotate(m, id, token, run, st.Namespace)
		r := kube.Reference(m.Object, m.Unit)
		st.Resources = append(st.Resources, r)
		st.Units[m.Unit] = "not-attempted"
	}
	if e = saveState(p, st); e != nil {
		return st, e
	}
	defer func() {
		// Keep configured image references even if preparation or readiness fails.
		// Best-effort enrichment uses the same live context and never hides the
		// original outcome or fabricates image IDs when observation is unavailable.
		if err != nil && ctx.Err() == nil && st.NamespaceUID != "" {
			if observed, _, observationErr := observeContainers(ctx, kc, st); observationErr == nil {
				st.Images = mergeContainers(st.Images, observed)
			}
		}
		if err != nil {
			st.Status = "failed"
			for unit, status := range st.Units {
				if status == "running" {
					st.Units[unit] = "failed"
				}
			}
			if ctx.Err() != nil {
				st.Status = "interrupted"
			}
		}
		st.Settled = true
		err = errors.Join(err, saveState(p, st), writeEvidence(p, st))
	}()
	if err = preparation(s, c, cs, p, st, dir).Apply(ctx, false); err != nil {
		return st, err
	}
	ns, e = kc.Object(ctx, "namespace", st.Namespace)
	if e != nil {
		return st, e
	}
	if ns == nil {
		return st, fmt.Errorf("Terraform did not create the runtime namespace")
	}
	st.NamespaceUID = kube.Text(kube.Metadata(ns), "uid")
	if !kube.Owned(ns, st.NamespaceUID, st.Token) {
		return st, fmt.Errorf("namespace ownership missing")
	}
	if err = saveState(p, st); err != nil {
		return st, err
	}
	// Validate all objects against the live namespace before creating workloads.
	for _, m := range items {
		if _, err = kc.Apply(ctx, m.Object, true); err != nil {
			st.Units[m.Unit] = "failed"
			return st, err
		}
	}
	st.Status = "applying"
	if err = saveState(p, st); err != nil {
		return st, err
	}
	for i, m := range items {
		existing, e := kc.Object(ctx, kube.Text(m.Object, "kind"), kube.Text(kube.Metadata(m.Object), "name"))
		if e != nil {
			return st, e
		}
		if existing != nil {
			return st, fmt.Errorf("workload name occupied before apply; refusing adoption")
		}
		st.Units[m.Unit] = "running"
		if err = saveState(p, st); err != nil {
			return st, err
		}
		obj, e := kc.Apply(ctx, m.Object, false)
		if e != nil {
			st.Units[m.Unit] = "failed"
			return st, e
		}
		st.Resources[i] = kube.Reference(obj, m.Unit)
		if !kube.Owned(obj, st.Resources[i].UID, token) {
			return st, fmt.Errorf("workload ownership not observed")
		}
		if err = saveState(p, st); err != nil {
			return st, err
		}
	}
	pending := map[string]int{}
	for _, resource := range st.Resources {
		pending[resource.Unit]++
	}
	for _, r := range st.Resources {
		if err = waitReady(ctx, kc, r); err != nil {
			st.Units[r.Unit] = "failed"
			return st, err
		}
		pending[r.Unit]--
		if pending[r.Unit] == 0 {
			st.Units[r.Unit] = "completed"
			if err = saveState(p, st); err != nil {
				return st, err
			}
		}
	}
	images, _, imageErr := observeContainers(ctx, kc, st)
	if imageErr != nil {
		return st, fmt.Errorf("workloads became ready but image observation failed: %w", imageErr)
	}
	st.Images = mergeContainers(st.Images, images)
	st.Status = "running"
	return st, nil
}

func (s Service) imagesReady(ctx context.Context, cs *cluster.State, items []Manifest) error {
	r, e := s.Runner.Run(ctx, kernel.Command{Name: "kind", Args: []string{"get", "nodes", "--name", cs.Name}})
	if e != nil {
		return e
	}
	nodes := strings.Fields(r.Stdout)
	if len(nodes) == 0 {
		return fmt.Errorf("kind cluster has no nodes")
	}
	images := map[string]bool{}
	for _, m := range items {
		if kube.Text(m.Object, "kind") == "Service" {
			continue
		}
		spec, _ := m.Object["spec"].(map[string]any)
		template, _ := spec["template"].(map[string]any)
		pod, _ := template["spec"].(map[string]any)
		for _, v := range append(asSlice(pod["containers"]), asSlice(pod["initContainers"])...) {
			c, _ := v.(map[string]any)
			images[kube.Text(c, "image")] = true
		}
	}
	for image := range images {
		for _, node := range nodes {
			if _, e = s.Runner.Run(ctx, kernel.Command{Name: "docker", Args: []string{"exec", node, "crictl", "inspecti", image}}); e != nil {
				return fmt.Errorf("image %q is unavailable on %s; use ex cluster load-image: %w", image, node, e)
			}
		}
	}
	return nil
}
func waitReady(ctx context.Context, kc kube.Client, r kube.Resource) error {
	if r.Kind == "Service" {
		return nil
	}
	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()
	for {
		obj, e := kc.Object(ctx, r.Kind, r.Name)
		if e != nil {
			return e
		}
		if obj == nil {
			return fmt.Errorf("workload disappeared during readiness")
		}
		if kube.Text(kube.Metadata(obj), "uid") != r.UID {
			return fmt.Errorf("workload was replaced during readiness")
		}
		status, _ := obj["status"].(map[string]any)
		spec, _ := obj["spec"].(map[string]any)
		if r.Kind == "Job" {
			for _, v := range asSlice(status["conditions"]) {
				cond, _ := v.(map[string]any)
				if cond["status"] == "True" {
					if cond["type"] == "Complete" {
						return nil
					}
					if cond["type"] == "Failed" {
						return fmt.Errorf("Job %s failed: %s", r.Name, kube.Text(cond, "reason"))
					}
				}
			}
		} else {
			desired := number(spec["replicas"])
			if spec["replicas"] == nil {
				desired = 1
			}
			generation := number(kube.Metadata(obj)["generation"])
			if number(status["observedGeneration"]) >= generation && number(status["updatedReplicas"]) == desired && number(status["availableReplicas"]) == desired && number(status["replicas"]) == desired {
				return nil
			}
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-ticker.C:
		}
	}
}
func number(v any) float64 { n, _ := v.(float64); return n }

// Down removes recorded workloads before their preparation resources. It never
// removes the project cluster, authored files, or retained execution evidence.
func (s Service) Down(ctx context.Context, p *project.Project, id string, recover bool) (st *State, err error) {
	unlock, e := kernel.AcquireLock(p.ClusterLock())
	if e != nil {
		return nil, e
	}
	defer unlock()
	st, e = readState(p, id)
	if e != nil {
		return nil, e
	}
	if st.Status == "down" {
		return st, nil
	}
	if !st.Settled {
		return st, fmt.Errorf("previous operation did not settle; reconcile any surviving processes before cleanup")
	}
	if st.Status != "running" && !recover {
		return st, fmt.Errorf("partial operation requires down --recover after inspection")
	}
	c, e := Load(p.Root, id)
	if e != nil {
		return st, e
	}
	dir, e := terraformConfig(c)
	if e != nil {
		return st, e
	}
	_, currentHash, e := manifests(c)
	if e != nil {
		return st, e
	}
	currentHash, e = configurationHash(currentHash, dir)
	if e != nil {
		return st, e
	}
	if currentHash != st.ConfigHash {
		return st, fmt.Errorf("configuration changed since execution; restore the recorded configuration before cleanup")
	}
	cs, kc, e := s.target(ctx, p, c)
	if e != nil {
		return st, e
	}
	if cs.UID != st.ClusterUID || kc.Context != st.Context || kc.Namespace != st.Namespace {
		return st, fmt.Errorf("cleanup target differs from recorded ownership")
	}
	run, e := kernel.RandomID()
	if e != nil {
		return st, e
	}
	st.RunID = run
	st.Operation = "down"
	st.ToolVersions = s.toolVersions(ctx)
	st.Status = "cleaning"
	for unit := range st.Units {
		st.Units[unit] = "not-attempted"
	}
	st.Settled = false
	if e = saveState(p, st); e != nil {
		return st, e
	}
	defer func() {
		if err != nil {
			st.Status = "failed"
			for unit, status := range st.Units {
				if status == "running" {
					st.Units[unit] = "failed"
				}
			}
			if ctx.Err() != nil {
				st.Status = "interrupted"
			}
		}
		st.Settled = true
		err = errors.Join(err, saveState(p, st), writeEvidence(p, st))
	}()
	ns, e := kc.Object(ctx, "namespace", st.Namespace)
	if e != nil {
		return st, e
	}
	if ns != nil {
		observedUID := kube.Text(kube.Metadata(ns), "uid")
		if st.NamespaceUID == "" && kube.Owned(ns, observedUID, st.Token) {
			st.NamespaceUID = observedUID
		}
		if !kube.Owned(ns, st.NamespaceUID, st.Token) {
			return st, fmt.Errorf("namespace ownership changed")
		}
		for i, r := range st.Resources {
			obj, e := kc.Object(ctx, r.Kind, r.Name)
			if e != nil {
				return st, e
			}
			if obj == nil {
				continue
			}
			if r.UID == "" {
				observedUID := kube.Text(kube.Metadata(obj), "uid")
				if !kube.Owned(obj, observedUID, st.Token) {
					return st, fmt.Errorf("unrecorded object does not carry runtime ownership")
				}
				r.UID = observedUID
				st.Resources[i] = r
			}
			if !kube.Owned(obj, r.UID, st.Token) {
				return st, fmt.Errorf("ownership changed for %s/%s", r.Kind, r.Name)
			}
		}
		if e = saveState(p, st); e != nil {
			return st, e
		}
		if e = checkInventory(ctx, kc, st, false); e != nil {
			return st, e
		}
		pending := map[string]int{}
		for _, resource := range st.Resources {
			pending[resource.Unit]++
		}
		for _, r := range st.Resources {
			st.Units[r.Unit] = "running"
			if e = saveState(p, st); e != nil {
				return st, e
			}
			if r.UID != "" {
				obj, e := kc.Object(ctx, r.Kind, r.Name)
				if e != nil {
					return st, e
				}
				if obj != nil {
					if !kube.Owned(obj, r.UID, st.Token) {
						return st, fmt.Errorf("resource replaced before cleanup")
					}
					if e = deleteObject(ctx, kc, r); e != nil {
						return st, e
					}
				}
			}
			pending[r.Unit]--
			if pending[r.Unit] == 0 {
				st.Units[r.Unit] = "completed"
			}
			if e = saveState(p, st); e != nil {
				return st, e
			}
		}
		if e = checkInventory(ctx, kc, st, true); e != nil {
			return st, e
		}
		ns, e = kc.Object(ctx, "namespace", st.Namespace)
		if e != nil {
			return st, e
		}
		if ns != nil && !kube.Owned(ns, st.NamespaceUID, st.Token) {
			return st, fmt.Errorf("namespace replaced before Terraform cleanup")
		}
		if ns != nil {
			if e = deleteNamespace(ctx, kc, st.Namespace, st.NamespaceUID); e != nil {
				return st, e
			}
			ns = nil
		}
	}
	if _, e = os.Stat(filepath.Join(filepath.Dir(statePath(p, id)), "terraform.tfstate")); e == nil {
		if e = preparation(s, c, cs, p, st, dir).Apply(ctx, true); e != nil {
			return st, e
		}
	} else if !errors.Is(e, os.ErrNotExist) {
		return st, e
	} else if ns != nil {
		return st, fmt.Errorf("namespace remains but Terraform state is absent; manual reconciliation required")
	}
	ns, e = kc.Object(ctx, "namespace", st.Namespace)
	if e != nil {
		return st, e
	}
	if ns != nil {
		return st, fmt.Errorf("namespace still exists after cleanup")
	}
	st.Resources = nil
	st.NamespaceUID = ""
	for unit := range st.Units {
		st.Units[unit] = "completed"
	}
	st.Status = "down"
	return st, nil
}

func deleteObject(ctx context.Context, kc kube.Client, r kube.Resource) error {
	plural := map[string]string{"Deployment": "deployments", "Service": "services", "Job": "jobs"}[r.Kind]
	if plural == "" {
		return fmt.Errorf("unsupported recorded resource")
	}
	base := "/api/v1"
	if r.APIVersion != "v1" {
		base = "/apis/" + r.APIVersion
	}
	body, _ := json.Marshal(map[string]any{"apiVersion": "v1", "kind": "DeleteOptions", "preconditions": map[string]string{"uid": r.UID}, "propagationPolicy": "Foreground"})
	if _, e := kc.Run(ctx, strings.NewReader(string(body)), "delete", "--raw", base+"/namespaces/"+r.Namespace+"/"+plural+"/"+r.Name, "-f", "-"); e != nil {
		return e
	}
	tick := time.NewTicker(time.Second)
	defer tick.Stop()
	for {
		obj, e := kc.Object(ctx, r.Kind, r.Name)
		if e != nil {
			return e
		}
		if obj == nil {
			return nil
		}
		if kube.Text(kube.Metadata(obj), "uid") != r.UID {
			return fmt.Errorf("resource name reused during cleanup")
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-tick.C:
		}
	}
}

func checkInventory(ctx context.Context, kc kube.Client, st *State, after bool) error {
	all, e := kc.Inventory(ctx)
	if e != nil {
		return e
	}
	known := map[string]bool{}
	for _, r := range st.Resources {
		if r.UID != "" {
			known[r.UID] = true
		}
	}
	// Descendants are accepted only through an owner UID chain rooted in recorded workloads.
	for pass := 0; pass < len(all); pass++ {
		for _, obj := range all {
			m := kube.Metadata(obj)
			for _, v := range asSlice(m["ownerReferences"]) {
				ref, _ := v.(map[string]any)
				if known[kube.Text(ref, "uid")] {
					known[kube.Text(m, "uid")] = true
				}
			}
		}
	}
	for _, obj := range all {
		m := kube.Metadata(obj)
		kind := kube.Text(obj, "kind")
		name := kube.Text(m, "name")
		if (kind == "ServiceAccount" && name == "default") || (kind == "ConfigMap" && name == "kube-root-ca.crt") {
			continue
		}
		if kind == "ResourceQuota" {
			labels, _ := m["labels"].(map[string]any)
			if labels["exphere.dev/ownership-token"] == st.Token {
				continue
			}
		}
		if known[kube.Text(m, "uid")] && !after {
			continue
		}
		return fmt.Errorf("cleanup blocked by remaining or foreign %s/%s", kind, name)
	}
	return nil
}

// UnitNames returns stable display order without changing consumer configuration.
func UnitNames(c *Config) []string {
	names := make([]string, 0, len(c.Descriptor.Units))
	for n := range c.Descriptor.Units {
		names = append(names, n)
	}
	sort.Strings(names)
	return names
}

// ToolVersion distinguishes observed versions from unavailable metadata.
type ToolVersion struct {
	Version string `json:"version,omitempty"`
	Status  string `json:"status"`
}

// ContainerObservation reports a configured image separately from the immutable
// image identity reported by a live pod. Empty ImageID means it was not observed.
// It intentionally excludes container arguments, environment, and raw logs.
type ContainerObservation struct {
	Pod         string `json:"pod"`
	PodUID      string `json:"podUid"`
	Unit        string `json:"unit"`
	Workload    string `json:"workload"`
	Container   string `json:"container"`
	Image       string `json:"configuredImage"`
	ImageID     string `json:"observedImageId,omitempty"`
	ImageStatus string `json:"imageStatus"`
	Ready       bool   `json:"ready"`
	Restarts    int    `json:"restarts"`
	Phase       string `json:"podPhase"`
}

// Inspection contains only allowlisted diagnostic fields suitable for evidence.
// Missing metrics and missing image observations are never interpreted as zero.
type Inspection struct {
	RuntimeID      string                 `json:"runtimeId"`
	ExecutionRunID string                 `json:"executionRunId"`
	ObservationID  string                 `json:"observationId"`
	ObservedAt     time.Time              `json:"observedAt"`
	State          any                    `json:"state"`
	Resources      []map[string]any       `json:"resources"`
	Containers     []ContainerObservation `json:"containers"`
	Quotas         []map[string]any       `json:"quotas"`
	Events         []map[string]any       `json:"events"`
	Usage          any                    `json:"usage"`
	ToolVersions   map[string]ToolVersion `json:"toolVersions"`
	Cost           string                 `json:"cost"`
}

// Inspect collects bounded, sanitized observations and writes a separate evidence
// record. It never updates the execution ledger or mutates infrastructure.
func (s Service) Inspect(ctx context.Context, p *project.Project, id string) (*Inspection, error) {
	st, err := readState(p, id)
	if err != nil {
		return nil, err
	}
	c, err := Load(p.Root, id)
	if err != nil {
		return nil, err
	}
	cs, kc, err := s.target(ctx, p, c)
	if err != nil {
		return nil, err
	}
	if cs.UID != st.ClusterUID || kc.Namespace != st.Namespace || kc.Context != st.Context {
		return nil, errors.New("inspection target differs from recorded target")
	}
	observationID, err := kernel.RandomID()
	if err != nil {
		return nil, err
	}
	out := &Inspection{RuntimeID: id, ExecutionRunID: st.RunID, ObservationID: observationID, ObservedAt: time.Now().UTC(), State: Outcome(st), ToolVersions: s.toolVersions(ctx), Cost: "unavailable: no billing source", Usage: map[string]any{"status": "unavailable", "reason": "metrics API not observed"}}
	ns, err := kc.Object(ctx, "namespace", st.Namespace)
	if err != nil {
		return nil, err
	}
	if ns == nil {
		for _, resource := range st.Resources {
			out.Resources = append(out.Resources, map[string]any{"resource": resource, "observed": "absent"})
		}
		return out, writeInspection(p, out)
	}
	observedNamespaceUID := kube.Text(kube.Metadata(ns), "uid")
	expectedNamespaceUID := st.NamespaceUID
	if expectedNamespaceUID == "" {
		expectedNamespaceUID = observedNamespaceUID
	}
	if !kube.Owned(ns, expectedNamespaceUID, st.Token) {
		return nil, errors.New("namespace ownership differs from the recorded runtime")
	}
	for _, resource := range st.Resources {
		obj, err := kc.Object(ctx, resource.Kind, resource.Name)
		if err != nil {
			return nil, err
		}
		if obj == nil {
			out.Resources = append(out.Resources, map[string]any{"resource": resource, "observed": "absent"})
			continue
		}
		expectedUID := resource.UID
		if expectedUID == "" {
			expectedUID = kube.Text(kube.Metadata(obj), "uid")
		}
		if !kube.Owned(obj, expectedUID, st.Token) {
			return nil, errors.New("resource ownership differs from recorded state")
		}
		spec, _ := obj["spec"].(map[string]any)
		template, _ := spec["template"].(map[string]any)
		pod, _ := template["spec"].(map[string]any)
		containers := []any{}
		for _, value := range append(asSlice(pod["containers"]), asSlice(pod["initContainers"])...) {
			container, _ := value.(map[string]any)
			containers = append(containers, map[string]any{"name": container["name"], "configuredImage": container["image"], "resources": container["resources"]})
		}
		status, _ := obj["status"].(map[string]any)
		safeStatus := map[string]any{}
		for _, key := range []string{"replicas", "readyReplicas", "availableReplicas", "updatedReplicas", "observedGeneration", "active", "succeeded", "failed", "startTime", "completionTime"} {
			if value, exists := status[key]; exists {
				safeStatus[key] = value
			}
		}
		out.Resources = append(out.Resources, map[string]any{"resource": resource, "status": safeStatus, "containers": containers, "configuredReplicas": spec["replicas"], "observedUID": kube.Text(kube.Metadata(obj), "uid")})
	}
	var descendantUIDs map[string]bool
	out.Containers, descendantUIDs, err = observeContainers(ctx, kc, st)
	if err != nil {
		return nil, err
	}
	quotas, err := readObjects(ctx, kc, "resourcequotas")
	if err != nil {
		return nil, err
	}
	for _, quota := range quotas {
		uid := kube.Text(kube.Metadata(quota), "uid")
		if !kube.Owned(quota, uid, st.Token) {
			return nil, errors.New("foreign resource quota prevents trusted inspection")
		}
		spec, _ := quota["spec"].(map[string]any)
		status, _ := quota["status"].(map[string]any)
		out.Quotas = append(out.Quotas, map[string]any{"name": kube.Text(kube.Metadata(quota), "name"), "configuredHard": spec["hard"], "observedHard": status["hard"], "observedUsed": status["used"]})
	}
	events, err := readObjects(ctx, kc, "events")
	if err != nil {
		return nil, err
	}
	ownedUIDs := descendantUIDs
	if st.NamespaceUID != "" {
		ownedUIDs[st.NamespaceUID] = true
	}
	for _, resource := range st.Resources {
		if resource.UID != "" {
			ownedUIDs[resource.UID] = true
		}
	}
	for _, container := range out.Containers {
		ownedUIDs[container.PodUID] = true
	}
	for _, event := range events {
		involved, _ := event["involvedObject"].(map[string]any)
		if !ownedUIDs[kube.Text(involved, "uid")] {
			continue
		}
		// Free-form event messages can echo environment values or admission details.
		// Keep event classification and object identity; raw messages stay in Kubernetes.
		out.Events = append(out.Events, map[string]any{"name": kube.Text(kube.Metadata(event), "name"), "reason": event["reason"], "type": event["type"], "count": event["count"], "firstTimestamp": event["firstTimestamp"], "lastTimestamp": event["lastTimestamp"], "object": map[string]any{"kind": involved["kind"], "name": involved["name"], "uid": involved["uid"]}})
	}
	// Metrics-server is optional. An absent API remains explicit unavailable data.
	metrics, metricsErr := kc.Run(ctx, nil, "get", "--raw", "/apis/metrics.k8s.io/v1beta1/namespaces/"+st.Namespace+"/pods")
	if metricsErr == nil {
		var data struct {
			Items []map[string]any `json:"items"`
		}
		if err := json.Unmarshal([]byte(metrics.Stdout), &data); err == nil {
			ownedPods := map[string]bool{}
			for _, container := range out.Containers {
				ownedPods[container.Pod] = true
			}
			measurements := []any{}
			for _, item := range data.Items {
				name := kube.Text(kube.Metadata(item), "name")
				if !ownedPods[name] {
					continue
				}
				containers := []any{}
				for _, value := range asSlice(item["containers"]) {
					measurement, _ := value.(map[string]any)
					containers = append(containers, map[string]any{"name": measurement["name"], "usage": measurement["usage"]})
				}
				measurements = append(measurements, map[string]any{"pod": name, "timestamp": item["timestamp"], "window": item["window"], "containers": containers})
			}
			out.Usage = map[string]any{"status": "observed", "pods": measurements}
		}
	}
	return out, writeInspection(p, out)
}

func readObjects(ctx context.Context, client kube.Client, kind string) ([]map[string]any, error) {
	result, err := client.Run(ctx, nil, "get", kind, "-o", "json")
	if err != nil {
		return nil, err
	}
	var data struct {
		Items []map[string]any `json:"items"`
	}
	if err := json.Unmarshal([]byte(result.Stdout), &data); err != nil {
		return nil, fmt.Errorf("decode %s observation: %w", kind, err)
	}
	return data.Items, nil
}

func observeContainers(ctx context.Context, client kube.Client, state *State) ([]ContainerObservation, map[string]bool, error) {
	pods, err := readObjects(ctx, client, "pods")
	if err != nil {
		return nil, nil, err
	}
	replicas, err := readObjects(ctx, client, "replicasets")
	if err != nil {
		return nil, nil, err
	}
	roots := map[string]bool{}
	workloads := map[string]string{}
	for _, resource := range state.Resources {
		if resource.UID != "" {
			roots[resource.UID] = true
			workloads[resource.UID] = resource.Kind + "/" + resource.Name
		}
	}
	for _, replica := range replicas {
		metadata := kube.Metadata(replica)
		for _, ref := range asSlice(metadata["ownerReferences"]) {
			owner, _ := ref.(map[string]any)
			if controlled, _ := owner["controller"].(bool); controlled && roots[kube.Text(owner, "uid")] && kube.Owned(replica, kube.Text(metadata, "uid"), state.Token) {
				roots[kube.Text(metadata, "uid")] = true
				workloads[kube.Text(metadata, "uid")] = workloads[kube.Text(owner, "uid")]
			}
		}
	}
	observations := []ContainerObservation{}
	for _, pod := range pods {
		metadata := kube.Metadata(pod)
		uid := kube.Text(metadata, "uid")
		if !kube.Owned(pod, uid, state.Token) {
			continue
		}
		isOwned := false
		workload := ""
		for _, ref := range asSlice(metadata["ownerReferences"]) {
			owner, _ := ref.(map[string]any)
			if controlled, _ := owner["controller"].(bool); controlled && roots[kube.Text(owner, "uid")] {
				isOwned = true
				workload = workloads[kube.Text(owner, "uid")]
			}
		}
		if !isOwned {
			continue
		}
		roots[uid] = true
		labels, _ := metadata["labels"].(map[string]any)
		spec, _ := pod["spec"].(map[string]any)
		status, _ := pod["status"].(map[string]any)
		statuses := map[string]map[string]any{}
		for _, value := range append(asSlice(status["containerStatuses"]), asSlice(status["initContainerStatuses"])...) {
			value, _ := value.(map[string]any)
			statuses[kube.Text(value, "name")] = value
		}
		for _, value := range append(asSlice(spec["containers"]), asSlice(spec["initContainers"])...) {
			container, _ := value.(map[string]any)
			name := kube.Text(container, "name")
			observed := statuses[name]
			ready, _ := observed["ready"].(bool)
			imageID := kube.Text(observed, "imageID")
			imageStatus := "unavailable"
			if imageID != "" {
				imageStatus = "observed"
			}
			observations = append(observations, ContainerObservation{Workload: workload, Pod: kube.Text(metadata, "name"), PodUID: uid, Unit: kube.Text(labels, "exphere.dev/unit"), Container: name, Image: kube.Text(container, "image"), ImageID: imageID, ImageStatus: imageStatus, Ready: ready, Restarts: int(number(observed["restartCount"])), Phase: kube.Text(status, "phase")})
		}
	}
	return observations, roots, nil
}

// Outcome exposes execution results without the private ownership token.
func Outcome(state *State) any {
	return struct {
		ID           string                 `json:"id"`
		Status       string                 `json:"status"`
		Settled      bool                   `json:"settled"`
		ClusterUID   string                 `json:"clusterUid"`
		Context      string                 `json:"context"`
		Namespace    string                 `json:"namespace"`
		NamespaceUID string                 `json:"namespaceUid,omitempty"`
		ConfigHash   string                 `json:"configHash"`
		RunID        string                 `json:"runId"`
		Operation    string                 `json:"operation"`
		UpdatedAt    time.Time              `json:"updatedAt"`
		Resources    []kube.Resource        `json:"resources"`
		Units        map[string]string      `json:"units"`
		ToolVersions map[string]ToolVersion `json:"toolVersions"`
		Images       []ContainerObservation `json:"images,omitempty"`
	}{state.ID, state.Status, state.Settled, state.ClusterUID, state.Context, state.Namespace, state.NamespaceUID, state.ConfigHash, state.RunID, state.Operation, state.UpdatedAt, state.Resources, state.Units, state.ToolVersions, state.Images}
}

func writeEvidence(p *project.Project, state *State) error {
	record := struct {
		State        any    `json:"operation"`
		Billing      string `json:"billing"`
		Verification string `json:"verification"`
	}{Outcome(state), "unavailable", "observations are local; no production or savings claim"}
	return kernel.AtomicJSON(filepath.Join(p.Root, ".audits", "evidence", "runs", state.RunID, "runtime.json"), record)
}

func writeInspection(p *project.Project, report *Inspection) error {
	return kernel.AtomicJSON(filepath.Join(p.Root, ".audits", "evidence", "runs", report.ObservationID, "inspection.json"), report)
}

func configurationHash(manifestHash, directory string) (string, error) {
	entries, err := os.ReadDir(directory)
	if err != nil {
		return "", err
	}
	parts := map[string]string{"descriptor-and-manifests": manifestHash}
	for _, entry := range entries {
		if !strings.HasSuffix(entry.Name(), ".tf.json") {
			continue
		}
		path := filepath.Join(directory, entry.Name())
		info, err := os.Lstat(path)
		if err != nil {
			return "", err
		}
		if !info.Mode().IsRegular() || info.Size() > 1<<20 {
			return "", fmt.Errorf("Terraform source must be regular and at most one MiB")
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return "", err
		}
		sum := sha256.Sum256(data)
		parts[entry.Name()] = hex.EncodeToString(sum[:])
	}
	serialized, err := json.Marshal(parts)
	if err != nil {
		return "", err
	}
	sum := sha256.Sum256(serialized)
	return hex.EncodeToString(sum[:]), nil
}

func (s Service) toolVersions(ctx context.Context) map[string]ToolVersion {
	results := map[string]ToolVersion{}
	probes := []struct {
		name    string
		args    []string
		jsonKey string
	}{{"kind", []string{"version"}, ""}, {"kubectl", []string{"version", "--client", "-o", "json"}, "clientVersion"}, {"terraform", []string{"version", "-json"}, "terraform_version"}, {"docker", []string{"version", "--format", "{{.Client.Version}}"}, ""}}
	versionPattern := regexp.MustCompile(`\bv?[0-9]+\.[0-9]+\.[0-9]+(?:[-+][0-9A-Za-z.-]+)?\b`)
	for _, probe := range probes {
		observation := ToolVersion{Status: "unavailable"}
		callCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
		result, err := s.Runner.Run(callCtx, kernel.Command{Name: probe.name, Args: probe.args})
		cancel()
		if err == nil {
			value := result.Stdout
			if probe.jsonKey != "" {
				var document map[string]any
				if json.Unmarshal([]byte(result.Stdout), &document) == nil {
					if probe.jsonKey == "clientVersion" {
						client, _ := document[probe.jsonKey].(map[string]any)
						value = kube.Text(client, "gitVersion")
					} else {
						value = kube.Text(document, probe.jsonKey)
					}
				} else {
					value = ""
				}
			}
			if version := versionPattern.FindString(value); version != "" {
				observation = ToolVersion{Version: version, Status: "observed"}
			}
		}
		results[probe.name] = observation
	}
	return results
}

func deleteNamespace(ctx context.Context, client kube.Client, name, uid string) error {
	if uid == "" {
		return errors.New("namespace deletion requires an observed UID")
	}
	body, _ := json.Marshal(map[string]any{"apiVersion": "v1", "kind": "DeleteOptions", "preconditions": map[string]string{"uid": uid}, "propagationPolicy": "Foreground"})
	if _, err := client.Run(ctx, strings.NewReader(string(body)), "delete", "--raw", "/api/v1/namespaces/"+name, "-f", "-"); err != nil {
		return err
	}
	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()
	for {
		object, err := client.Object(ctx, "namespace", name)
		if err != nil {
			return err
		}
		if object == nil {
			return nil
		}
		if kube.Text(kube.Metadata(object), "uid") != uid {
			return errors.New("namespace replaced during cleanup")
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-ticker.C:
		}
	}
}

func configuredContainers(items []Manifest) []ContainerObservation {
	result := []ContainerObservation{}
	for _, item := range items {
		if kube.Text(item.Object, "kind") == "Service" {
			continue
		}
		spec, _ := item.Object["spec"].(map[string]any)
		template, _ := spec["template"].(map[string]any)
		pod, _ := template["spec"].(map[string]any)
		workload := kube.Text(item.Object, "kind") + "/" + kube.Text(kube.Metadata(item.Object), "name")
		for _, value := range append(asSlice(pod["containers"]), asSlice(pod["initContainers"])...) {
			container, _ := value.(map[string]any)
			result = append(result, ContainerObservation{Workload: workload, Unit: item.Unit, Container: kube.Text(container, "name"), Image: kube.Text(container, "image"), ImageStatus: "not-observed"})
		}
	}
	return result
}

func mergeContainers(configured, observed []ContainerObservation) []ContainerObservation {
	result := append([]ContainerObservation(nil), observed...)
	matched := map[string]bool{}
	key := func(value ContainerObservation) string {
		return value.Unit + "/" + value.Workload + "/" + value.Container
	}
	for _, value := range observed {
		matched[key(value)] = true
	}
	for _, value := range configured {
		if !matched[key(value)] {
			result = append(result, value)
		}
	}
	return result
}
