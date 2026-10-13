// Command ex manages developer-owned local microruntimes.
package main

import (
	"context"
	"io"
	"os"
	"os/signal"
	"syscall"

	"github.com/jonatassales/exphere/packages/cli/src/internal/adapters/process"
	"github.com/jonatassales/exphere/packages/cli/src/internal/commands"
)

// version can be injected at build time; an unversioned build remains explicit.
var version = "0.0.0-dev"

func run(args []string, stdout, stderr io.Writer) int {
	return commands.Execute(context.Background(), args, commands.Options{Version: version, Runner: process.Runner{}, Input: os.Stdin, Output: stdout, Diagnostics: stderr})
}
func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	code := commands.Execute(ctx, os.Args[1:], commands.Options{Version: version, Runner: process.Runner{}, Input: process.Input{Context: ctx, File: os.Stdin}, Output: os.Stdout, Diagnostics: os.Stderr})
	stop()
	os.Exit(code)
}
