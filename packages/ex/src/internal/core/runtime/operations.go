package runtime

import (
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"time"

	kube "github.com/jonatassales/exphere/packages/ex/src/internal/adapters/kubernetes"
	"github.com/jonatassales/exphere/packages/ex/src/internal/core/project"
	"github.com/jonatassales/exphere/packages/ex/src/internal/kernel"
)

func (s Service) recordedTarget(ctx context.Context, p *project.Project, id, unit, kind string) (kube.Client, kube.Resource, error) {
	st, e := readState(p, id)
	if e != nil {
		return kube.Client{}, kube.Resource{}, e
	}
	c, e := Load(p.Root, id)
	if e != nil {
		return kube.Client{}, kube.Resource{}, e
	}
	cs, kc, e := s.target(ctx, p, c)
	if e != nil {
		return kc, kube.Resource{}, e
	}
	if cs.UID != st.ClusterUID || st.Namespace != kc.Namespace {
		return kc, kube.Resource{}, fmt.Errorf("target differs from recorded runtime")
	}
	var matches []kube.Resource
	for _, r := range st.Resources {
		if r.Unit == unit && ((kind == "workload" && (r.Kind == "Deployment" || r.Kind == "Job")) || r.Kind == kind) {
			matches = append(matches, r)
		}
	}
	if len(matches) != 1 {
		return kc, kube.Resource{}, fmt.Errorf("unit %q must have exactly one %s for this operation", unit, kind)
	}
	r := matches[0]
	obj, e := kc.Object(ctx, r.Kind, r.Name)
	if e != nil {
		return kc, r, e
	}
	if obj == nil || !kube.Owned(obj, r.UID, st.Token) {
		return kc, r, fmt.Errorf("recorded resource is absent or has changed ownership")
	}
	return kc, r, nil
}

// Logs streams only the selected owned workload. Follow is explicit and ends on cancellation.
func (s Service) Logs(ctx context.Context, p *project.Project, id, unit string, follow bool, output, diagnostics io.Writer) error {
	unlock, e := kernel.AcquireLock(p.ClusterLock())
	if e != nil {
		return e
	}
	defer unlock()
	kc, r, e := s.recordedTarget(ctx, p, id, unit, "workload")
	if e != nil {
		return e
	}
	args := []string{"--kubeconfig", kc.Kubeconfig, "--context", kc.Context, "--namespace", kc.Namespace, "logs", strings.ToLower(r.Kind) + "/" + r.Name, "--all-containers=true", "--tail=500", "--timestamps=true"}
	if follow {
		args = append(args, "--follow=true")
	} else {
		args = append(args, "--limit-bytes=1048576")
	}
	_, e = s.Runner.Run(ctx, kernel.Command{Name: "kubectl", Args: args, Stdout: output, Stderr: diagnostics})
	return e
}

// Forward owns a foreground localhost-only tunnel; no detached helper survives exit.
func (s Service) Forward(ctx context.Context, p *project.Project, id, unit string, port, remote int, diagnostics io.Writer) error {
	if port < 1 || port > 65535 || remote < 0 || remote > 65535 {
		return fmt.Errorf("ports must be between 1 and 65535")
	}
	unlock, e := kernel.AcquireLock(p.ClusterLock())
	if e != nil {
		return e
	}
	defer unlock()
	kc, r, e := s.recordedTarget(ctx, p, id, unit, "Service")
	if e != nil {
		return e
	}
	if remote == 0 {
		obj, e := kc.Object(ctx, "Service", r.Name)
		if e != nil {
			return e
		}
		spec, _ := obj["spec"].(map[string]any)
		ports := asSlice(spec["ports"])
		if len(ports) != 1 {
			return fmt.Errorf("select --remote-port for a service with multiple ports")
		}
		v, _ := ports[0].(map[string]any)
		remote = int(number(v["port"]))
	}
	if remote < 1 || remote > 65535 {
		return fmt.Errorf("invalid service port")
	}
	_, e = s.Runner.Run(ctx, kernel.Command{Name: "kubectl", Args: []string{"--kubeconfig", kc.Kubeconfig, "--context", kc.Context, "--namespace", kc.Namespace, "port-forward", "service/" + r.Name, fmt.Sprintf("%d:%d", port, remote), "--address=127.0.0.1"}, Stdout: diagnostics, Stderr: diagnostics})
	return e
}

// Hook executes a declared trusted extension through sh. Hooks are not sandboxed
// and are never invoked implicitly by validation, preparation, or cleanup.
// The caller deadline applies with an additional five-minute maximum lifetime.
func (s Service) Hook(ctx context.Context, p *project.Project, id, name string) (kernel.Result, error) {
	unlock, e := kernel.AcquireLock(p.ClusterLock())
	if e != nil {
		return kernel.Result{}, e
	}
	defer unlock()
	c, e := Load(p.Root, id)
	if e != nil {
		return kernel.Result{}, e
	}
	path, ok := c.Descriptor.Hooks[name]
	if !ok {
		return kernel.Result{}, fmt.Errorf("hook %q is not declared", name)
	}
	script, e := c.Resolve(path)
	if e != nil {
		return kernel.Result{}, e
	}
	if filepath.Ext(script) != ".sh" {
		return kernel.Result{}, fmt.Errorf("hooks must be .sh files")
	}
	info, e := os.Stat(script)
	if e != nil {
		return kernel.Result{}, e
	}
	if !info.Mode().IsRegular() {
		return kernel.Result{}, fmt.Errorf("hook must be a regular file")
	}
	hookCtx, cancel := context.WithTimeout(ctx, 5*time.Minute)
	defer cancel()
	run, e := kernel.RandomID()
	if e != nil {
		return kernel.Result{}, e
	}
	file := filepath.Join(p.Root, ".audits", "evidence", "runs", run, "hook.json")
	record := map[string]any{"runtime": id, "runId": run, "hook": name, "status": "running"}
	if e = kernel.AtomicJSON(file, record); e != nil {
		return kernel.Result{}, e
	}
	result, opErr := s.Runner.Run(hookCtx, kernel.Command{Name: "sh", Args: []string{script}, Dir: c.Dir, Env: []string{"EXPHERE_RUNTIME_ID=" + id, "EXPHERE_RUN_ID=" + run, "EXPHERE_PROJECT_ROOT=" + p.Root}})
	record["status"] = "completed"
	if opErr != nil {
		record["status"] = "failed"
		if errors.Is(opErr, context.Canceled) || errors.Is(opErr, context.DeadlineExceeded) {
			record["status"] = "interrupted"
		}
	}
	record["exitCode"] = result.ExitCode
	if e = kernel.AtomicJSON(file, record); e != nil {
		return result, errors.Join(opErr, fmt.Errorf("record hook outcome: %w", e))
	}
	return result, opErr
}
