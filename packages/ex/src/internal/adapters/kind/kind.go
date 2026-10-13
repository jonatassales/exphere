// Package kind invokes the consumer-installed kind executable. It never installs
// tools, builds images, or changes the user's ambient kubeconfig.
package kind

import (
	"context"
	"fmt"
	"strings"

	"github.com/jonatassales/exphere/packages/ex/src/internal/kernel"
)

// Client sends explicit cluster operations through the supplied process runner.
type Client struct{ Runner kernel.Runner }

// Clusters lists the existing local kind cluster names.
func (c Client) Clusters(ctx context.Context) ([]string, error) {
	result, err := c.Runner.Run(ctx, kernel.Command{Name: "kind", Args: []string{"get", "clusters"}})
	if err != nil {
		return nil, fmt.Errorf("list kind clusters: %w: %s", err, strings.TrimSpace(result.Stderr))
	}
	return strings.Fields(result.Stdout), nil
}

// Create writes credentials only to kubeconfig, a private project-owned path.
// A partially created cluster may remain when the operation fails.
func (c Client) Create(ctx context.Context, name, kubeconfig string) error {
	result, err := c.Runner.Run(ctx, kernel.Command{Name: "kind", Args: []string{"create", "cluster", "--name", name, "--kubeconfig", kubeconfig, "--wait", "120s"}})
	if err != nil {
		return fmt.Errorf("create kind cluster: %w: %s", err, strings.TrimSpace(result.Stderr))
	}
	return nil
}

// LoadImage imports an already-built local Docker image into the selected cluster.
func (c Client) LoadImage(ctx context.Context, name, image string) error {
	result, err := c.Runner.Run(ctx, kernel.Command{Name: "kind", Args: []string{"load", "docker-image", image, "--name", name}})
	if err != nil {
		return fmt.Errorf("load image: %w: %s", err, strings.TrimSpace(result.Stderr))
	}
	return nil
}

// Delete requests deletion of the named cluster. Ownership is the caller's
// responsibility; this adapter does not discover or infer a deletion target.
func (c Client) Delete(ctx context.Context, name string) error {
	result, err := c.Runner.Run(ctx, kernel.Command{Name: "kind", Args: []string{"delete", "cluster", "--name", name}})
	if err != nil {
		return fmt.Errorf("delete kind cluster: %w: %s", err, strings.TrimSpace(result.Stderr))
	}
	return nil
}
