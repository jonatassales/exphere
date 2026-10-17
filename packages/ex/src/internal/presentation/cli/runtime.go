package cli

import (
	"github.com/exphere/ex/src/internal/presentation/cli/catalog"

	"github.com/spf13/cobra"
)

// runtimeCommand registers all runtime-related CLI commands.
func (cliApplication *application) runtimeCommand() *cobra.Command {
	runtimeRoot := &cobra.Command{
		Use:   "runtime",
		Short: "Generate and operate project-local microruntimes",
		Args:  validateGroupArguments,
		RunE:  requireSubcommand,
	}

	useCases, globals := cliApplication.useCases, &cliApplication.globals

	runtimeRoot.AddCommand(
		catalog.NewRuntimeInitCommand(useCases.RuntimeInit, globals),
		catalog.NewRuntimeValidateCommand(useCases.RuntimeValidate, globals),
		catalog.NewRuntimeUpCommand(useCases.RuntimeUp, globals),
		catalog.NewRuntimeDownCommand(useCases.RuntimeDown, globals),
		catalog.NewRuntimeInspectCommand(useCases.RuntimeInspect, globals),
		catalog.NewRuntimeLogsCommand(useCases.RuntimeLogs, globals),
		catalog.NewRuntimeForwardCommand(useCases.RuntimeForward, globals),
		catalog.NewRuntimeHookCommand(useCases.RuntimeHook, globals),
	)

	return runtimeRoot
}
