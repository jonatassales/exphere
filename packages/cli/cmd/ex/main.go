// Command ex is the Go scaffold for the future Exphere CLI.
package main

import (
	"fmt"
	"io"
	"os"
)

const version = "0.0.0-dev"

func usage(w io.Writer) {
	fmt.Fprintln(w, "Exphere CLI (Go scaffold)")
	fmt.Fprintln(w)
	fmt.Fprintln(w, "Usage: ex <command>")
	fmt.Fprintln(w, "Commands:")
	fmt.Fprintln(w, "  help        Show this help")
	fmt.Fprintln(w, "  version     Print scaffold version")
	fmt.Fprintln(w, "  init        Reserved for a future implementation (not available)")
}

func run(args []string, stdout, stderr io.Writer) int {
	if len(args) == 0 {
		usage(stdout)
		return 0
	}

	switch args[0] {
	case "help", "-h", "--help":
		if len(args) != 1 {
			fmt.Fprintln(stderr, "ex: help does not accept arguments")
			return 2
		}
		usage(stdout)
		return 0
	case "version", "-V", "--version":
		if len(args) != 1 {
			fmt.Fprintln(stderr, "ex: version does not accept arguments")
			return 2
		}
		fmt.Fprintf(stdout, "ex %s (Go scaffold)\n", version)
		return 0
	case "init":
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
