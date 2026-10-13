// Package agent scaffolds consumer-owned agent source without executing it.
package agent

import (
	"fmt"

	"github.com/jonatassales/exphere/packages/ex/src/internal/core/runtime"
	"github.com/jonatassales/exphere/packages/ex/src/internal/templates"
)

// Init generates an isolated, editable TypeScript LangGraph project.
// It never installs dependencies, builds images, invokes models, or changes runtimes.
func Init(root, name string) error {
	if !runtime.IDValid(name) {
		return fmt.Errorf("invalid agent name %q: use 1–63 lowercase DNS-label characters", name)
	}
	return templates.Publish(root, ".exphere/agents/"+name, templates.CopyAgent)
}
