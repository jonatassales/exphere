package cli

import (
	"github.com/exphere/ex/src/internal/presentation/cli/catalog"

	"github.com/spf13/cobra"
)

// agentCommand registers all agent-related CLI commands.
func (cliApplication *application) agentCommand() *cobra.Command {
	agentRoot := &cobra.Command{
		Use:   "agent",
		Short: "Manage editable agent scaffolds",
		Args:  validateGroupArguments,
		RunE:  requireSubcommand,
	}

	agentRoot.AddCommand(
		catalog.NewAgentInitCommand(cliApplication.useCases.AgentInit, &cliApplication.globals),
	)

	return agentRoot
}
