// Package process executes native tools directly with bounded capture and
// cancellation propagated to the owned Unix process group.
package process

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"sync"
	"syscall"
	"time"

	"github.com/jonatassales/exphere/packages/cli/src/internal/kernel"
)

// Runner executes tools on the supported macOS and Linux hosts. Its zero value
// captures up to one MiB per stream and bounds pipe draining to two seconds.
type Runner struct{}

const captureLimit = 1 << 20

type capture struct {
	mu       sync.Mutex
	data     bytes.Buffer
	overflow bool
	stream   io.Writer
}

func (c *capture) Write(p []byte) (int, error) {
	c.mu.Lock()
	defer c.mu.Unlock()
	n := len(p)
	remaining := captureLimit - c.data.Len()
	if remaining > 0 {
		_, _ = c.data.Write(p[:min(remaining, n)])
	}
	if n > remaining {
		c.overflow = true
	}
	if c.stream != nil {
		return c.stream.Write(p)
	}
	return n, nil
}

// Run waits for process completion and pipe draining. Cancellation kills the
// owned process group, including subprocesses started by Terraform or hooks.
// Captured-only overflow is an error: callers must never parse truncated JSON as
// complete inventory. Explicit streams may continue while retained output caps.
func (Runner) Run(ctx context.Context, req kernel.Command) (kernel.Result, error) {
	result := kernel.Result{ExitCode: -1}
	if req.Name == "" {
		return result, errors.New("executable name is required")
	}
	if err := ctx.Err(); err != nil {
		return result, err
	}
	out := &capture{stream: req.Stdout}
	diagnostic := &capture{stream: req.Stderr}
	cmd := exec.CommandContext(ctx, req.Name, req.Args...)
	cmd.Dir = req.Dir
	cmd.Env = append(os.Environ(), req.Env...)
	cmd.Stdin, cmd.Stdout, cmd.Stderr = req.Stdin, out, diagnostic
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	cmd.WaitDelay = 2 * time.Second
	cmd.Cancel = func() error {
		if cmd.Process == nil {
			return nil
		}
		err := syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL)
		if errors.Is(err, syscall.ESRCH) {
			return os.ErrProcessDone
		}
		return err
	}
	err := cmd.Run()
	if cmd.Process != nil {
		// A short-lived tool must not leave child processes retaining its pipes.
		_ = syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL)
	}
	result.Stdout, result.Stderr = out.data.String(), diagnostic.data.String()
	if cmd.ProcessState != nil {
		result.ExitCode = cmd.ProcessState.ExitCode()
	}
	if ctx.Err() != nil {
		return result, ctx.Err()
	}
	if err != nil {
		return result, fmt.Errorf("%s failed: %w", req.Name, err)
	}
	if (out.overflow && req.Stdout == nil) || (diagnostic.overflow && req.Stderr == nil) {
		return result, fmt.Errorf("%s output exceeded the %d-byte capture limit", req.Name, captureLimit)
	}
	return result, nil
}
