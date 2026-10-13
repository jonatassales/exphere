// Package kernel defines the small execution boundary shared by CLI use cases.
// Domain configuration and infrastructure types stay with their owning packages.
package kernel

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"syscall"
)

// Command describes one direct executable invocation. Args are never shell text.
// Env adds explicit overrides to the inherited environment. Optional output
// writers receive streamed output; captured results remain size-bounded.
type Command struct {
	Name   string
	Args   []string
	Dir    string
	Env    []string
	Stdin  io.Reader
	Stdout io.Writer
	Stderr io.Writer
}

// Result records a completed process. A negative ExitCode means it did not exit
// normally. Captured streams may be truncated when a streaming writer is used.
type Result struct {
	Stdout   string
	Stderr   string
	ExitCode int
}

// Runner executes a command and waits for owned process resources to terminate.
// Cancellation must reach the executable rather than only cancel its caller.
type Runner interface {
	Run(context.Context, Command) (Result, error)
}

// RandomID returns an opaque 128-bit identity for persisted ownership records.
func RandomID() (string, error) {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		return "", fmt.Errorf("generate identity: %w", err)
	}
	return hex.EncodeToString(b[:]), nil
}

// ReadJSON reads one bounded JSON document from a regular, non-symlink file.
// Unknown fields remain allowed so operational records can evolve additively.
func ReadJSON(path string, value any) error {
	if err := safeParents(filepath.Dir(path)); err != nil {
		return err
	}
	info, err := os.Lstat(path)
	if err != nil {
		return err
	}
	if !info.Mode().IsRegular() {
		return fmt.Errorf("expected regular file: %s", path)
	}
	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()
	const limit = 4 << 20
	data, err := io.ReadAll(io.LimitReader(f, limit+1))
	if err != nil {
		return err
	}
	if len(data) > limit {
		return fmt.Errorf("json document exceeds %d bytes: %s", limit, path)
	}
	if err := json.Unmarshal(data, value); err != nil {
		return fmt.Errorf("read %s: %w", path, err)
	}
	return nil
}

// AtomicJSON replaces a private state document after syncing its complete data.
// The containing directory is synced after rename so completed state transitions
// do not depend solely on a buffered directory entry. Existing links are refused.
func AtomicJSON(path string, value any) error {
	dir := filepath.Dir(path)
	if err := safeParents(dir); err != nil {
		return err
	}
	if err := os.MkdirAll(dir, 0700); err != nil {
		return err
	}
	if err := safeParents(dir); err != nil {
		return err
	}
	if info, err := os.Lstat(path); err == nil {
		if !info.Mode().IsRegular() {
			return fmt.Errorf("refuse non-regular state file: %s", path)
		}
	} else if !errors.Is(err, os.ErrNotExist) {
		return err
	}
	data, err := json.MarshalIndent(value, "", "  ")
	if err != nil {
		return err
	}
	data = append(data, '\n')
	f, err := os.CreateTemp(dir, ".state-*")
	if err != nil {
		return err
	}
	tmp := f.Name()
	defer os.Remove(tmp)
	if err = f.Chmod(0600); err == nil {
		_, err = f.Write(data)
	}
	if err == nil {
		err = f.Sync()
	}
	closeErr := f.Close()
	if err != nil {
		return err
	}
	if closeErr != nil {
		return closeErr
	}
	if err := os.Rename(tmp, path); err != nil {
		return err
	}
	d, err := os.Open(dir)
	if err != nil {
		return err
	}
	defer d.Close()
	return d.Sync()
}

// AcquireLock obtains an advisory, nonblocking process lock. The lock file stays
// present after release; the kernel releases ownership on crashes and exit.
// All Exphere writers to the protected state must use the same lock path.
func AcquireLock(path string) (func(), error) {
	if err := safeParents(filepath.Dir(path)); err != nil {
		return nil, err
	}
	if err := os.MkdirAll(filepath.Dir(path), 0700); err != nil {
		return nil, err
	}
	fd, err := syscall.Open(path, syscall.O_CREAT|syscall.O_RDWR|syscall.O_CLOEXEC|syscall.O_NOFOLLOW, 0600)
	if err != nil {
		return nil, fmt.Errorf("open lock: %w", err)
	}
	f := os.NewFile(uintptr(fd), path)
	if err := syscall.Flock(fd, syscall.LOCK_EX|syscall.LOCK_NB); err != nil {
		f.Close()
		return nil, fmt.Errorf("another operation holds %s: %w", filepath.Base(path), err)
	}
	released := false
	return func() {
		if released {
			return
		}
		released = true
		_ = syscall.Flock(fd, syscall.LOCK_UN)
		_ = f.Close()
	}, nil
}

// safeParents rejects existing symlink path components. Private operational
// files are not a hostile-filesystem sandbox; callers must own the workspace.
func safeParents(path string) error {
	path, err := filepath.Abs(path)
	if err != nil {
		return err
	}
	for current := path; ; current = filepath.Dir(current) {
		info, err := os.Lstat(current)
		if err == nil && info.Mode()&os.ModeSymlink != 0 {
			return fmt.Errorf("symlink path is not allowed: %s", current)
		}
		if err != nil && !errors.Is(err, os.ErrNotExist) {
			return err
		}
		if current == filepath.Dir(current) {
			return nil
		}
	}
}
