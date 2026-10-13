package main

import (
	"bytes"
	"errors"
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
		{name: "unexpected init flags", args: []string{"init", "--force"}, status: 2, stderr: "does not accept arguments or flags"},
		{name: "unexpected init arguments", args: []string{"init", "project"}, status: 2, stderr: "does not accept arguments or flags"},
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

type failingWriter struct{}

func (failingWriter) Write([]byte) (int, error) {
	return 0, errors.New("output unavailable")
}

func TestOutputFailure(t *testing.T) {
	for _, command := range []string{"help", "version"} {
		t.Run(command, func(t *testing.T) {
			var diagnostics bytes.Buffer
			if status := run([]string{command}, failingWriter{}, &diagnostics); status != 1 {
				t.Fatalf("failed output returned status %d, want 1", status)
			}
			if !strings.Contains(diagnostics.String(), "output unavailable") {
				t.Fatalf("missing output failure diagnostic: %q", diagnostics.String())
			}
		})
	}
}
