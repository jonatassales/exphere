package main

import (
	"bytes"
	"strings"
	"testing"
)

func TestCommand(t *testing.T) {
	tests := []struct {
		name   string
		args   []string
		status int
		stdout string
		stderr string
	}{
		{name: "help on no args", status: 0, stdout: "Exphere CLI (Go scaffold)"},
		{name: "explicit help", args: []string{"--help"}, status: 0, stdout: "Usage: ex"},
		{name: "version", args: []string{"version"}, status: 0, stdout: "ex 0.0.0-dev (Go scaffold)"},
		{name: "init unsupported", args: []string{"init"}, status: 2, stderr: "init is not implemented"},
		{name: "invalid command", args: []string{"runtime"}, status: 2, stderr: "unknown command"},
		{name: "unexpected version arguments", args: []string{"version", "extra"}, status: 2, stderr: "does not accept arguments"},
		{name: "unexpected help arguments", args: []string{"help", "extra"}, status: 2, stderr: "does not accept arguments"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			var out, err bytes.Buffer
			status := run(tt.args, &out, &err)
			if status != tt.status || !strings.Contains(out.String(), tt.stdout) || !strings.Contains(err.String(), tt.stderr) {
				t.Fatalf("run(%q) = (%d, %q, %q), want status %d and substrings %q, %q", tt.args, status, out.String(), err.String(), tt.status, tt.stdout, tt.stderr)
			}
			if tt.status == 0 && err.Len() != 0 {
				t.Errorf("unexpected stderr: %s", err.String())
			}
			if tt.status != 0 && out.Len() != 0 {
				t.Errorf("unexpected stdout: %s", out.String())
			}
		})
	}
}
