// Package commands presents use cases through a scriptable Cobra command tree.
// Native process execution and domain ownership rules live below this boundary.
package commands

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/jonatassales/exphere/packages/cli/src/internal/core/agent"
	"github.com/jonatassales/exphere/packages/cli/src/internal/core/cluster"
	"github.com/jonatassales/exphere/packages/cli/src/internal/core/project"
	"github.com/jonatassales/exphere/packages/cli/src/internal/kernel"
	"github.com/spf13/cobra"
)

// Options supplies process resources explicitly, allowing command reuse without globals.
type Options struct {
	Runner              kernel.Runner
	Version             string
	Directory           string
	Input               io.Reader
	Output, Diagnostics io.Writer
}

type application struct {
	options Options
	root    string
	json    bool
	timeout time.Duration
}
type usageError struct{ err error }

func (e usageError) Error() string { return e.err.Error() }
func (e usageError) Unwrap() error { return e.err }

// Execute builds a fresh command tree and maps errors once at the process boundary.
// It never exits the host process and keeps diagnostic output separate from results.
func Execute(ctx context.Context, args []string, options Options) int {
	if options.Input == nil {
		options.Input = strings.NewReader("")
	}
	if options.Output == nil {
		options.Output = io.Discard
	}
	if options.Diagnostics == nil {
		options.Diagnostics = io.Discard
	}
	out := &checkedWriter{Writer: options.Output}
	options.Output = out
	a := &application{options: options}
	root := a.command()
	root.SetArgs(args)
	root.SetIn(options.Input)
	root.SetOut(out)
	root.SetErr(options.Diagnostics)
	_, err := root.ExecuteContextC(ctx)
	if out.err != nil {
		err = fmt.Errorf("write output: %w", out.err)
	}
	if err == nil {
		return 0
	}
	code := 1
	var u usageError
	if errors.As(err, &u) || strings.HasPrefix(err.Error(), "unknown command") {
		code = 2
	}
	if ctx.Err() != nil || errors.Is(err, context.Canceled) {
		code = 130
	}
	if a.json {
		_ = json.NewEncoder(options.Diagnostics).Encode(map[string]any{"error": err.Error(), "exitCode": code})
	} else {
		fmt.Fprintf(options.Diagnostics, "ex: %v\n", err)
	}
	return code
}

type checkedWriter struct {
	io.Writer
	err error
}

func (w *checkedWriter) Write(p []byte) (int, error) {
	n, e := w.Writer.Write(p)
	if e != nil && w.err == nil {
		w.err = e
	}
	return n, e
}
func exact(n int) cobra.PositionalArgs {
	return func(c *cobra.Command, args []string) error {
		if len(args) != n {
			return usageError{fmt.Errorf("%s requires %d argument(s)", c.CommandPath(), n)}
		}
		return nil
	}
}
func (a *application) command() *cobra.Command {
	root := &cobra.Command{Use: "ex", Short: "Exphere CLI", Long: "Exphere CLI — local microruntimes and agent scaffolds", SilenceErrors: true, SilenceUsage: true, Args: exact(0), RunE: func(c *cobra.Command, _ []string) error { return c.Help() }}
	root.Args = func(_ *cobra.Command, args []string) error {
		if len(args) > 0 {
			return usageError{fmt.Errorf("unknown command %q; run 'ex --help'", args[0])}
		}
		return nil
	}
	root.SetFlagErrorFunc(func(_ *cobra.Command, e error) error { return usageError{e} })
	root.PersistentFlags().StringVar(&a.root, "project", "", "consumer project directory (defaults to discovery from the working directory)")
	root.PersistentFlags().BoolVar(&a.json, "json", false, "emit structured results and diagnostics")
	root.PersistentFlags().DurationVar(&a.timeout, "timeout", 2*time.Minute, "total deadline for a finite operation")
	root.PersistentPreRunE = func(_ *cobra.Command, _ []string) error {
		if a.timeout <= 0 {
			return usageError{fmt.Errorf("--timeout must be positive")}
		}
		return nil
	}
	version := &cobra.Command{Use: "version", Short: "Print the CLI version", Args: exact(0), RunE: func(c *cobra.Command, _ []string) error {
		if a.json {
			return a.print(map[string]string{"version": a.options.Version})
		}
		_, e := fmt.Fprintf(c.OutOrStdout(), "ex %s\n", a.options.Version)
		return e
	}}
	root.AddCommand(version)
	var versionFlag bool
	root.Flags().BoolVarP(&versionFlag, "version", "V", false, "print the CLI version")
	root.RunE = func(c *cobra.Command, _ []string) error {
		if versionFlag {
			return version.RunE(c, nil)
		}
		return c.Help()
	}
	root.AddCommand(&cobra.Command{Use: "init", Short: "Initialize project metadata without starting infrastructure", Args: exact(0), RunE: func(c *cobra.Command, _ []string) error {
		dir, e := a.directory()
		if e != nil {
			return e
		}
		p, e := project.Init(dir)
		if e != nil {
			return e
		}
		return a.print(map[string]string{"project": p.Root, "id": p.ID, "status": "initialized"})
	}})
	root.AddCommand(&cobra.Command{Use: "doctor", Short: "Inspect local prerequisites without installing tools", Args: exact(0), RunE: a.doctor})
	root.AddCommand(a.clusterCommands(), a.runtimeCommands())
	agentRoot := &cobra.Command{Use: "agent", Short: "Manage editable agent scaffolds", RunE: missingCommand}
	agentRoot.AddCommand(&cobra.Command{Use: "init <name>", Short: "Generate a finite TypeScript LangGraph runner", Args: exact(1), RunE: func(c *cobra.Command, args []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		if e = agent.Init(p.Root, args[0]); e != nil {
			return e
		}
		return a.print(map[string]string{"agent": args[0], "path": filepath.Join(p.Root, ".exphere", "agents", args[0]), "status": "generated; image build remains explicit"})
	}})
	root.AddCommand(agentRoot)
	root.SetHelpCommand(&cobra.Command{Use: "help [command]", Short: "Help about any command", RunE: func(c *cobra.Command, args []string) error {
		target, rest, e := root.Find(args)
		if e != nil || len(rest) > 0 {
			return usageError{fmt.Errorf("unknown help command")}
		}
		return target.Help()
	}})

	return root
}
func missingCommand(c *cobra.Command, _ []string) error {
	return usageError{fmt.Errorf("%s requires a subcommand; run '%s --help'", c.CommandPath(), c.CommandPath())}
}
func (a *application) directory() (string, error) {
	if a.root != "" {
		return filepath.Abs(a.root)
	}
	if a.options.Directory != "" {
		return filepath.Abs(a.options.Directory)
	}
	return os.Getwd()
}
func (a *application) project() (*project.Project, error) {
	dir, e := a.directory()
	if e != nil {
		return nil, e
	}
	if a.root != "" {
		return project.Open(dir)
	}
	return project.Discover(dir)
}
func (a *application) print(v any) error {
	enc := json.NewEncoder(a.options.Output)
	if !a.json {
		enc.SetIndent("", "  ")
	}
	return enc.Encode(v)
}
func (a *application) finite(c *cobra.Command) (context.Context, context.CancelFunc) {
	return context.WithTimeout(c.Context(), a.timeout)
}
func (a *application) clusterCommands() *cobra.Command {
	root := &cobra.Command{Use: "cluster", Short: "Manage the project's explicitly owned kind cluster", RunE: missingCommand}
	svc := cluster.Service{Runner: a.options.Runner}
	root.AddCommand(&cobra.Command{Use: "create", Short: "Create a project cluster and private kubeconfig", Args: exact(0), RunE: func(c *cobra.Command, _ []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx, cancel := a.finite(c)
		defer cancel()
		if e = svc.Create(ctx, p); e != nil {
			return e
		}
		st, e := cluster.Read(p)
		if e != nil {
			return e
		}
		return a.print(st)
	}})
	root.AddCommand(&cobra.Command{Use: "inspect", Short: "Inspect recorded cluster identity", Args: exact(0), RunE: func(c *cobra.Command, _ []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx, cancel := a.finite(c)
		defer cancel()
		st, e := svc.Inspect(ctx, p)
		if e != nil {
			return e
		}
		return a.print(st)
	}})
	root.AddCommand(&cobra.Command{Use: "load-image <image>", Short: "Load an existing local image; never build it", Args: exact(1), RunE: func(c *cobra.Command, args []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx, cancel := a.finite(c)
		defer cancel()
		if e = svc.LoadImage(ctx, p, args[0]); e != nil {
			return e
		}
		return a.print(map[string]string{"image": args[0], "status": "loaded"})
	}})
	root.AddCommand(&cobra.Command{Use: "delete", Short: "Remove an empty owned cluster after runtime cleanup", Args: exact(0), RunE: func(c *cobra.Command, _ []string) error {
		p, e := a.project()
		if e != nil {
			return e
		}
		ctx, cancel := a.finite(c)
		defer cancel()
		if e = svc.Delete(ctx, p); e != nil {
			return e
		}
		return a.print(map[string]string{"status": "deleted"})
	}})
	return root
}
func (a *application) doctor(c *cobra.Command, _ []string) error {
	ctx, cancel := a.finite(c)
	defer cancel()
	type entry struct {
		Name    string `json:"name"`
		Path    string `json:"path,omitempty"`
		Version string `json:"version,omitempty"`
		Status  string `json:"status"`
		Install string `json:"install,omitempty"`
	}
	entries := []entry{}
	ready := true
	for _, tool := range []struct {
		name, url string
		args      []string
	}{{"docker", "https://docs.docker.com/get-started/get-docker/", []string{"--version"}}, {"kind", "https://kind.sigs.k8s.io/docs/user/quick-start/", []string{"version"}}, {"kubectl", "https://kubernetes.io/docs/tasks/tools/", []string{"version", "--client=true", "-o", "json"}}, {"terraform", "https://developer.hashicorp.com/terraform/install", []string{"version", "-json"}}} {
		item := entry{Name: tool.name, Install: tool.url}
		path, e := exec.LookPath(tool.name)
		if e != nil {
			item.Status = "missing"
			ready = false
		} else {
			item.Path = path
			r, e := a.options.Runner.Run(ctx, kernel.Command{Name: path, Args: tool.args})
			if e != nil {
				item.Status = "unavailable"
				ready = false
			} else {
				item.Version = strings.TrimSpace(r.Stdout)
				item.Status = "available"
			}
		}
		entries = append(entries, item)
	}
	engine := "unavailable"
	if _, e := exec.LookPath("docker"); e == nil {
		if _, e = a.options.Runner.Run(ctx, kernel.Command{Name: "docker", Args: []string{"info", "--format", "{{.ServerVersion}}"}}); e == nil {
			engine = "reachable"
		}
	}
	target := any("not initialized or no recorded cluster")
	if p, e := a.project(); e == nil {
		if st, e := (cluster.Service{Runner: a.options.Runner}).Inspect(ctx, p); e == nil {
			target = st
		}
	}
	return a.print(map[string]any{"tools": entries, "toolsAvailable": ready, "containerEngine": engine, "cluster": target, "installation": "manual; no tools were installed"})
}
