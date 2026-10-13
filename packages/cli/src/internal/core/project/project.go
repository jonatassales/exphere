// Package project owns consumer project identity and its private state boundary.
// Initialization never installs tools, starts infrastructure, or replaces harness files.
package project

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/jonatassales/exphere/packages/cli/src/internal/kernel"
)

// Project identifies a consumer workspace by its canonical root and stable ID.
type Project struct {
	Root string `json:"root"`
	ID   string `json:"id"`
}

type metadata struct {
	Version int    `json:"version"`
	ID      string `json:"id"`
}

// StateDir locates private operational records required for ownership and cleanup.
// These records are not source artifacts and must survive until cleanup succeeds.
func (p *Project) StateDir() string { return filepath.Join(p.Root, ".exphere", "state") }

// ClusterLock is shared by cluster and runtime mutations so deletion cannot race
// namespace preparation or workload application in another Exphere process.
func (p *Project) ClusterLock() string { return filepath.Join(p.StateDir(), "cluster.lock") }

// Init creates project metadata and a local state ignore file. Existing valid
// metadata is reused. Existing harness content is preserved without adoption.
func Init(root string) (*Project, error) {
	canonical, err := canonicalRoot(root)
	if err != nil {
		return nil, err
	}
	config, err := SafePath(canonical, ".exphere/config.json")
	if err != nil {
		return nil, err
	}
	if err := os.MkdirAll(filepath.Dir(config), 0755); err != nil {
		return nil, err
	}
	stateDir, err := SafePath(canonical, ".exphere/state")
	if err != nil {
		return nil, err
	}
	if err := os.MkdirAll(stateDir, 0700); err != nil {
		return nil, err
	}
	release, err := kernel.AcquireLock(filepath.Join(stateDir, "init.lock"))
	if err != nil {
		return nil, err
	}
	defer release()
	if _, err := os.Lstat(config); err == nil {
		return Open(canonical)
	} else if !errors.Is(err, os.ErrNotExist) {
		return nil, err
	}
	id, err := kernel.RandomID()
	if err != nil {
		return nil, err
	}
	// The ignore file is inside private state, preserving the consumer's root rules.
	ignore := filepath.Join(stateDir, ".gitignore")
	f, err := os.OpenFile(ignore, os.O_WRONLY|os.O_CREATE|os.O_EXCL, 0600)
	if err == nil {
		_, err = f.WriteString("*\n")
		closeErr := f.Close()
		if err != nil {
			return nil, err
		}
		if closeErr != nil {
			return nil, closeErr
		}
	} else if !errors.Is(err, os.ErrExist) {
		return nil, err
	} else {
		info, statErr := os.Lstat(ignore)
		if statErr != nil {
			return nil, statErr
		}
		if !info.Mode().IsRegular() {
			return nil, errors.New("state ignore file must be a regular file")
		}
		contents, readErr := os.ReadFile(ignore)
		if readErr != nil {
			return nil, readErr
		}
		if strings.TrimSpace(string(contents)) != "*" {
			return nil, errors.New("existing state ignore file must ignore all private operational files")
		}
	}
	if err := kernel.AtomicJSON(config, metadata{Version: 1, ID: id}); err != nil {
		return nil, err
	}
	return &Project{Root: canonical, ID: id}, nil
}

// Open reads a project only at the supplied root. Unsupported metadata fails
// explicitly rather than being silently migrated or treated as an empty project.
func Open(root string) (*Project, error) {
	canonical, err := canonicalRoot(root)
	if err != nil {
		return nil, err
	}
	path, err := SafePath(canonical, ".exphere/config.json")
	if err != nil {
		return nil, err
	}
	var m metadata
	if err := kernel.ReadJSON(path, &m); err != nil {
		return nil, fmt.Errorf("open project: %w", err)
	}
	if m.Version != 1 || len(m.ID) != 32 || strings.Trim(m.ID, "0123456789abcdef") != "" {
		return nil, errors.New("unsupported or invalid project metadata")
	}
	if _, err := SafePath(canonical, ".exphere/state"); err != nil {
		return nil, err
	}
	return &Project{Root: canonical, ID: m.ID}, nil
}

// Discover walks upward to the nearest project metadata. Invalid nearest
// metadata stops discovery rather than accidentally selecting an ancestor.
func Discover(start string) (*Project, error) {
	root, err := canonicalRoot(start)
	if err != nil {
		return nil, err
	}
	for {
		if _, err := os.Lstat(filepath.Join(root, ".exphere", "config.json")); err == nil {
			return Open(root)
		} else if !errors.Is(err, os.ErrNotExist) {
			return nil, err
		}
		parent := filepath.Dir(root)
		if parent == root {
			return nil, errors.New("no Exphere project found; run ex init at the project root")
		}
		root = parent
	}
}

// SafePath resolves a relative path below base without accepting traversal or
// symlink components. Nonexistent final components are allowed for generation.
// Consumers must not modify the workspace concurrently with an operation.
func SafePath(base, relative string) (string, error) {
	if relative == "" || filepath.IsAbs(relative) {
		return "", fmt.Errorf("expected nonempty relative path: %q", relative)
	}
	clean := filepath.Clean(relative)
	if clean == ".." || strings.HasPrefix(clean, ".."+string(filepath.Separator)) {
		return "", fmt.Errorf("path escapes its owner: %q", relative)
	}
	root, err := filepath.Abs(base)
	if err != nil {
		return "", err
	}
	// Check base ancestors as well, including generated state locations.
	for current := root; ; current = filepath.Dir(current) {
		info, err := os.Lstat(current)
		if err == nil && info.Mode()&os.ModeSymlink != 0 {
			return "", fmt.Errorf("symlink path is not allowed: %s", current)
		}
		if err != nil && !errors.Is(err, os.ErrNotExist) {
			return "", err
		}
		if current == filepath.Dir(current) {
			break
		}
	}
	result := root
	if clean != "." {
		for _, part := range strings.Split(clean, string(filepath.Separator)) {
			result = filepath.Join(result, part)
			info, err := os.Lstat(result)
			if err == nil && info.Mode()&os.ModeSymlink != 0 {
				return "", fmt.Errorf("symlink path is not allowed: %s", result)
			}
			if err != nil && !errors.Is(err, os.ErrNotExist) {
				return "", err
			}
		}
	}
	return result, nil
}

func canonicalRoot(root string) (string, error) {
	absolute, err := filepath.Abs(root)
	if err != nil {
		return "", err
	}
	canonical, err := filepath.EvalSymlinks(absolute)
	if err != nil {
		return "", err
	}
	info, err := os.Stat(canonical)
	if err != nil {
		return "", err
	}
	if !info.IsDir() {
		return "", errors.New("project root must be a directory")
	}
	return canonical, nil
}
