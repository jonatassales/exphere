package main

import (
	"github.com/exphere/ex/src/internal/application"
	"github.com/exphere/ex/src/internal/infrastructure/configuration"
	"github.com/exphere/ex/src/internal/infrastructure/hooks"
	"github.com/exphere/ex/src/internal/infrastructure/kind"
	"github.com/exphere/ex/src/internal/infrastructure/kubectl"
	"github.com/exphere/ex/src/internal/infrastructure/process"
	"github.com/exphere/ex/src/internal/infrastructure/scaffold"
	"github.com/exphere/ex/src/internal/infrastructure/storage"
	"github.com/exphere/ex/src/internal/infrastructure/terraform"
	"github.com/exphere/ex/src/internal/infrastructure/toolchain"
	"github.com/exphere/ex/src/internal/presentation/cli"
)

// useCases is the composition root: the only place that knows every concrete
// adapter. It builds each adapter once and hands every use case exactly the
// ports it declares.
func useCases() cli.UseCases {
	runner := process.Local{}

	var (
		projects    = storage.Projects{}
		locks       = storage.Locker{}
		clusters    = storage.Clusters{}
		executions  = storage.Executions{}
		evidence    = storage.Evidence{}
		files       = configuration.Files{}
		scaffolder  = configuration.Scaffolder{}
		agents      = scaffold.Agents{}
		kubernetes  = kubectl.Client{Runner: runner}
		provisioner = kind.Provisioner{Runner: runner}
		preparation = terraform.Preparation{Runner: runner}
		tools       = toolchain.Toolchain{Runner: runner}
		extensions  = hooks.Executor{Runner: runner}
	)

	return cli.UseCases{
		ProjectInit: application.InitializeProject{
			Projects: projects,
			Creator:  projects,
		},
		Doctor: application.Diagnose{
			Prerequisites: tools,
			Projects:      projects,
			Clusters:      clusters,
			Observer:      kubernetes,
		},
		RuntimeInit: application.InitializeRuntime{
			Projects:   projects,
			Scaffolder: scaffolder,
		},
		RuntimeValidate: application.ValidateRuntime{
			Projects:      projects,
			Configuration: files,
		},
		RuntimeUp: application.StartRuntime{
			Projects:      projects,
			Locks:         locks,
			Configuration: files,
			Clusters:      clusters,
			Observer:      kubernetes,
			Images:        provisioner,
			Executions:    executions,
			Objects:       kubernetes,
			Preparation:   preparation,
			Evidence:      evidence,
			Tools:         tools,
		},
		RuntimeDown: application.StopRuntime{
			Projects:      projects,
			Locks:         locks,
			Configuration: files,
			Clusters:      clusters,
			Observer:      kubernetes,
			Executions:    executions,
			Objects:       kubernetes,
			Preparation:   preparation,
			Evidence:      evidence,
			Tools:         tools,
		},
		RuntimeInspect: application.InspectRuntime{
			Projects:   projects,
			Clusters:   clusters,
			Observer:   kubernetes,
			Executions: executions,
			Objects:    kubernetes,
			Evidence:   evidence,
			Tools:      tools,
		},
		RuntimeLogs: application.ReadRuntimeLogs{
			Projects: projects, Locks: locks, Configuration: files,
			Clusters: clusters, Observer: kubernetes, Executions: executions,
			Objects: kubernetes, Logs: kubernetes,
		},
		RuntimeForward: application.ForwardRuntime{
			Projects: projects, Locks: locks, Configuration: files,
			Clusters: clusters, Observer: kubernetes, Executions: executions,
			Objects: kubernetes, Forwarder: kubernetes,
		},
		RuntimeHook: application.RunRuntimeHook{
			Projects: projects, Locks: locks, Configuration: files,
			Scripts: files, Executor: extensions, Evidence: evidence,
		},
		ClusterCreate: application.CreateCluster{
			Projects:    projects,
			Locks:       locks,
			Clusters:    clusters,
			Credentials: clusters,
			Provisioner: provisioner,
			Observer:    kubernetes,
		},
		ClusterDelete: application.DeleteCluster{
			Projects:    projects,
			Locks:       locks,
			Clusters:    clusters,
			Credentials: clusters,
			Executions:  executions,
			Provisioner: provisioner,
			Observer:    kubernetes,
		},
		ClusterInspect: application.InspectCluster{
			Projects: projects,
			Clusters: clusters,
			Observer: kubernetes,
		},
		ClusterLoadImage: application.LoadClusterImage{
			Projects: projects,
			Locks:    locks,
			Clusters: clusters,
			Observer: kubernetes,
			Images:   provisioner,
		},
		AgentInit: application.InitializeAgent{
			Projects: projects,
			Agents:   agents,
		},
	}
}
