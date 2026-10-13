package commands

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"path/filepath"
	"strconv"
	"strings"

	runtimecore "github.com/jonatassales/exphere/packages/cli/src/internal/core/runtime"
	"github.com/spf13/cobra"
)

func (a *application) runtimeCommands() *cobra.Command {
	root := &cobra.Command{Use: "runtime", Short: "Generate and operate project-local microruntimes", RunE: missingCommand}
	svc := runtimecore.Service{Runner: a.options.Runner}
	var guided bool
	init := &cobra.Command{Use: "init <id>", Short: "Generate editable runtime configuration without executing it", Args: exact(1), RunE: func(c *cobra.Command, args []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		if guided {
			input, e := a.guided(c.Context(), c.InOrStdin(), c.ErrOrStderr())
			if e != nil {
				return e
			}
			e = runtimecore.Generate(p.Root, args[0], input)
			if e != nil {
				return e
			}
		} else {
			if e = runtimecore.Init(p.Root, args[0]); e != nil {
				return e
			}
		}
		status := "incomplete; fill the descriptor and native files before validation"
		if guided {
			status = "generated; infrastructure has not been started"
		}
		return a.print(map[string]any{"runtime": args[0], "guided": guided, "status": status})
	}}
	init.Flags().BoolVar(&guided, "guided", false, "collect explicit component and resource inputs")
	root.AddCommand(init)
	root.AddCommand(&cobra.Command{Use: "validate <id>", Short: "Validate descriptor and native files without provisioning", Args: exact(1), RunE: func(_ *cobra.Command, args []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		if e = runtimecore.Validate(p.Root, args[0]); e != nil {
			return e
		}
		return a.print(map[string]string{"runtime": args[0], "status": "valid configuration; execution unverified"})
	}})
	root.AddCommand(&cobra.Command{Use: "up <id>", Short: "Prepare and execute every configured unit", Args: exact(1), RunE: func(c *cobra.Command, args []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx, cancel := a.finite(c)
		defer cancel()
		st, e := svc.Up(ctx, p, args[0])
		if e != nil {
			return e
		}
		return a.print(runtimecore.Outcome(st))
	}})
	root.AddCommand(&cobra.Command{Use: "inspect <id>", Short: "Inspect ownership, workload status and resource observations", Args: exact(1), RunE: func(c *cobra.Command, args []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx, cancel := a.finite(c)
		defer cancel()
		result, e := svc.Inspect(ctx, p, args[0])
		if e != nil {
			return e
		}
		return a.print(result)
	}})
	var recover bool
	down := &cobra.Command{Use: "down <id>", Short: "Remove owned resources; preserve source, configuration and cluster", Args: exact(1), RunE: func(c *cobra.Command, args []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx, cancel := a.finite(c)
		defer cancel()
		st, e := svc.Down(ctx, p, args[0], recover)
		if e != nil {
			return e
		}
		return a.print(runtimecore.Outcome(st))
	}}
	down.Flags().BoolVar(&recover, "recover", false, "reconcile a settled failed or interrupted operation")
	root.AddCommand(down)
	var logUnit string
	var follow bool
	logs := &cobra.Command{Use: "logs <id>", Short: "Read the selected workload's logs", Args: exact(1), RunE: func(c *cobra.Command, args []string) error {
		if logUnit == "" {
			return usageError{fmt.Errorf("--unit is required")}
		}
		if a.json {
			return usageError{fmt.Errorf("logs emit native text; --json is unsupported")}
		}
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx := c.Context()
		cancel := func() {}
		if !follow {
			ctx, cancel = a.finite(c)
		}
		defer cancel()
		return svc.Logs(ctx, p, args[0], logUnit, follow, a.options.Output, a.options.Diagnostics)
	}}
	logs.Flags().StringVar(&logUnit, "unit", "", "selected runtime unit")
	logs.Flags().BoolVar(&follow, "follow", false, "stream until interrupted")
	root.AddCommand(logs)
	var forwardUnit string
	var port, remote int
	forward := &cobra.Command{Use: "forward <id>", Short: "Forward a service to localhost until interrupted", Args: exact(1), RunE: func(c *cobra.Command, args []string) error {
		if forwardUnit == "" {
			return usageError{fmt.Errorf("--unit is required")}
		}
		p, e := a.project()
		if e != nil {
			return e
		}
		return svc.Forward(c.Context(), p, args[0], forwardUnit, port, remote, a.options.Diagnostics)
	}}
	forward.Flags().StringVar(&forwardUnit, "unit", "", "selected runtime unit")
	forward.Flags().IntVar(&port, "port", 8080, "local TCP port")
	forward.Flags().IntVar(&remote, "remote-port", 0, "service port (required when ambiguous)")
	root.AddCommand(forward)
	root.AddCommand(&cobra.Command{Use: "hook <id> <name>", Short: "Explicitly run a declared trusted .sh extension", Args: exact(2), RunE: func(c *cobra.Command, args []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx, cancel := a.finite(c)
		defer cancel()
		result, e := svc.Hook(ctx, p, args[0], args[1])
		if e != nil {
			return e
		}
		return a.print(result)
	}})
	return root
}

// guided collects decisions only. Generation starts after every answer is validated.
func (a *application) guided(ctx context.Context, input io.Reader, diagnostics io.Writer) (runtimecore.GuidedInput, error) {
	reader := bufio.NewReader(input)
	ask := func(label string) (string, error) {
		if e := ctx.Err(); e != nil {
			return "", e
		}
		if _, e := fmt.Fprintf(diagnostics, "%s: ", label); e != nil {
			return "", e
		}
		line, e := reader.ReadString('\n')
		if e != nil && e != io.EOF {
			return "", e
		}
		line = strings.TrimSpace(line)
		if line == "" {
			return "", usageError{fmt.Errorf("%s is required (guidance canceled without writing files)", label)}
		}
		return line, nil
	}
	integer := func(label string) (int, error) {
		s, e := ask(label)
		if e != nil {
			return 0, e
		}
		v, e := strconv.Atoi(s)
		if e != nil {
			return 0, usageError{fmt.Errorf("%s must be an integer", label)}
		}
		return v, nil
	}
	var in runtimecore.GuidedInput
	var e error
	if in.Owner, e = ask("Owner reference"); e != nil {
		return in, e
	}
	if in.Context, e = ask("Explicit managed Kubernetes context"); e != nil {
		return in, e
	}
	if in.Namespace, e = ask("Runtime namespace"); e != nil {
		return in, e
	}
	components, e := ask("Project-relative component paths (comma-separated)")
	if e != nil {
		return in, e
	}
	for _, component := range strings.Split(components, ",") {
		component = strings.TrimSpace(component)
		u := runtimecore.UnitInput{Component: component, Name: filepath.Base(component)}
		if _, e = fmt.Fprintf(diagnostics, "Configure %s\n", u.Name); e != nil {
			return in, e
		}
		if u.Kind, e = ask("Workload kind (Deployment or Job)"); e != nil {
			return in, e
		}
		if u.Kind != "Deployment" && u.Kind != "Job" {
			return in, usageError{fmt.Errorf("workload kind must be Deployment or Job")}
		}
		if u.Image, e = ask("Prebuilt image reference"); e != nil {
			return in, e
		}
		if u.CPURequest, e = ask("CPU request (for example 100m)"); e != nil {
			return in, e
		}
		if u.CPULimit, e = ask("CPU limit"); e != nil {
			return in, e
		}
		if u.MemoryRequest, e = ask("Memory request (for example 128Mi)"); e != nil {
			return in, e
		}
		if u.MemoryLimit, e = ask("Memory limit"); e != nil {
			return in, e
		}
		if u.Kind == "Deployment" {
			if u.Port, e = integer("Application port"); e != nil {
				return in, e
			}
			if u.Replicas, e = integer("Replicas"); e != nil {
				return in, e
			}
			if u.ReadinessPath, e = ask("HTTP readiness path"); e != nil {
				return in, e
			}
		}
		in.Units = append(in.Units, u)
	}
	in.Quotas = map[string]string{}
	for _, key := range []string{"requests.cpu", "limits.cpu", "requests.memory", "limits.memory", "pods"} {
		v, e := ask("Namespace quota " + key)
		if e != nil {
			return in, e
		}
		in.Quotas[key] = v
	}
	return in, nil
}
