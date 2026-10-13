// Command ex is the Go scaffold for the future Exphere CLI.
package main

import (
	"fmt"
	"io"
	"os"
)

const version = "0.0.0-dev"

func usage(w io.Writer) error {
	_, err := fmt.Fprintln(w, `Exphere CLI (Go scaffold)

Usage: ex <command>
Commands:
  help        Show this help
  version     Print scaffold version
  init        Reserved for a future implementation (not available)`)
	return err
}

func run(args []string, stdout, stderr io.Writer) int {
	if len(args) == 0 {
		args = []string{"help"}
	}

	switch args[0] {
	case "help", "-h", "--help":
		if len(args) != 1 {
			fmt.Fprintln(stderr, "ex: help does not accept arguments")
			return 2
		}
		if err := usage(stdout); err != nil {
			fmt.Fprintf(stderr, "ex: write help: %v\n", err)
			return 1
		}
		return 0
	case "version", "-V", "--version":
		if len(args) != 1 {
			fmt.Fprintln(stderr, "ex: version does not accept arguments")
			return 2
		}
		if _, err := fmt.Fprintf(stdout, "ex %s (Go scaffold)\n", version); err != nil {
			fmt.Fprintf(stderr, "ex: write version: %v\n", err)
			return 1
		}
		return 0
	case "init":
		if len(args) != 1 {
			fmt.Fprintln(stderr, "ex: init does not accept arguments or flags in the Go scaffold")
			return 2
		}
		fmt.Fprintln(stderr, "ex: init is not implemented in the Go scaffold; no project files were changed")
		return 2
	default:
		fmt.Fprintf(stderr, "ex: unknown command %q; run 'ex --help'\n", args[0])
		return 2
	}
}

func main() {
	os.Exit(run(os.Args[1:], os.Stdout, os.Stderr))
}
