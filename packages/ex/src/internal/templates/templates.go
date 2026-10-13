// Package templates embeds versioned scaffold inputs and publishes new consumer directories.
// It never merges generated content into an existing directory.
package templates

import (
	"embed"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

// Assets contains the editable TypeScript runner template shipped with this CLI.
//
//go:embed assets
var Assets embed.FS

// Publish builds and validates a scaffold in a staging directory, then reserves its
// destination exclusively and publishes staged entries without overwriting. Publication is not
// atomic. A handled failure removes only entries whose recorded identity still
// belongs to this invocation, and reports output that cannot be safely removed.
// An abrupt process termination may leave staging or a partially populated directory;
// later calls refuse that destination rather than overwriting it.
func Publish(root, relative string, build func(string) error) (resultErr error) {
	root, err := filepath.Abs(root)
	if err != nil {
		return err
	}
	root, err = filepath.EvalSymlinks(root)
	if err != nil {
		return err
	}
	if filepath.IsAbs(relative) || filepath.Clean(relative) != relative || strings.Contains(relative, "\\") {
		return errors.New("scaffold destination must be a clean relative path")
	}
	parts := strings.Split(filepath.ToSlash(relative), "/")
	for _, part := range parts {
		if part == ".." || part == "." || part == "" {
			return errors.New("invalid scaffold destination")
		}
	}
	parent := root
	for _, part := range parts[:len(parts)-1] {
		parent = filepath.Join(parent, part)
		if err := os.Mkdir(parent, 0755); err != nil && !os.IsExist(err) {
			return err
		}
		info, err := os.Lstat(parent)
		if err != nil {
			return err
		}
		if !info.IsDir() || info.Mode()&os.ModeSymlink != 0 {
			return fmt.Errorf("scaffold parent must be a real directory: %s", parent)
		}
	}
	target := filepath.Join(parent, parts[len(parts)-1])
	if _, err := os.Lstat(target); err == nil {
		return fmt.Errorf("destination already exists: %s", target)
	} else if !os.IsNotExist(err) {
		return err
	}
	staging, err := os.MkdirTemp(parent, ".exphere-stage-")
	if err != nil {
		return err
	}
	defer func() {
		if cleanupErr := os.RemoveAll(staging); cleanupErr != nil {
			resultErr = errors.Join(resultErr, fmt.Errorf("retained scaffold staging directory %s: %w", staging, cleanupErr))
		}
	}()
	if err := build(staging); err != nil {
		return err
	}
	if err := os.Chmod(staging, 0755); err != nil {
		return err
	}
	if err := os.Mkdir(target, 0755); err != nil {
		return fmt.Errorf("reserve scaffold destination: %w", err)
	}
	targetInfo, err := os.Lstat(target)
	if err != nil {
		return fmt.Errorf("inspect reserved scaffold destination %s: %w", target, err)
	}
	owned := []scaffoldEntry{{path: target, info: targetInfo, mode: 0755}}
	defer func() {
		if resultErr != nil {
			resultErr = errors.Join(resultErr, removeOwned(owned))
		}
	}()
	if err := filepath.WalkDir(staging, func(source string, _ fs.DirEntry, walkErr error) error {
		if walkErr != nil {
			return fmt.Errorf("read staged scaffold entry %s: %w", source, walkErr)
		}
		if source == staging {
			return nil
		}
		info, err := os.Lstat(source)
		if err != nil {
			return fmt.Errorf("inspect staged scaffold entry %s: %w", source, err)
		}
		if !info.IsDir() && !info.Mode().IsRegular() {
			return fmt.Errorf("unsupported staged scaffold entry: %s", source)
		}
		relative, err := filepath.Rel(staging, source)
		if err != nil {
			return fmt.Errorf("resolve staged scaffold entry %s: %w", source, err)
		}
		destination := filepath.Join(target, relative)
		if err := checkAncestors(owned, destination); err != nil {
			return fmt.Errorf("publish scaffold entry %s: %w", destination, err)
		}
		if info.IsDir() {
			if err := os.Mkdir(destination, 0755); err != nil {
				return fmt.Errorf("reserve scaffold directory %s: %w", destination, err)
			}
			directoryInfo, err := os.Lstat(destination)
			if err != nil {
				return fmt.Errorf("inspect reserved scaffold directory %s: %w", destination, err)
			}
			owned = append(owned, scaffoldEntry{path: destination, info: directoryInfo, mode: info.Mode().Perm()})
			return nil
		}
		// Sibling staging shares the target filesystem. Link atomically refuses
		// an existing destination and retains file permissions; deleting staging
		// later removes only its link, leaving the published file intact.
		if err := os.Link(source, destination); err != nil {
			return fmt.Errorf("publish scaffold file %s: %w", destination, err)
		}
		owned = append(owned, scaffoldEntry{path: destination, info: info})
		return nil
	}); err != nil {
		return fmt.Errorf("publish scaffold from %s: %w", staging, err)
	}
	// Set directory permissions after their children have been published so a
	// read-only staged directory can still be populated without losing its mode.
	for i := len(owned) - 1; i >= 0; i-- {
		entry := owned[i]
		if entry.info.IsDir() {
			if err := checkAncestors(owned[:i], entry.path); err != nil {
				return fmt.Errorf("finalize scaffold directory %s: %w", entry.path, err)
			}
			if err := checkIdentity(entry); err != nil {
				return fmt.Errorf("finalize scaffold directory: %w", err)
			}
			if err := os.Chmod(entry.path, entry.mode); err != nil {
				return fmt.Errorf("set scaffold directory permissions %s: %w", entry.path, err)
			}
		}
	}
	return nil
}

type scaffoldEntry struct {
	path string
	info fs.FileInfo
	mode fs.FileMode
}

func checkIdentity(entry scaffoldEntry) error {
	info, err := os.Lstat(entry.path)
	if err != nil {
		return fmt.Errorf("inspect scaffold ownership %s: %w", entry.path, err)
	}
	if !os.SameFile(entry.info, info) {
		return fmt.Errorf("scaffold ownership changed: %s", entry.path)
	}
	return nil
}

// checkAncestors refuses replaced parents, including symlinks, even when a
// descendant happens to retain its original identity through another path.
func checkAncestors(entries []scaffoldEntry, path string) error {
	for _, parent := range entries {
		if parent.info.IsDir() && strings.HasPrefix(path, parent.path+string(filepath.Separator)) {
			if err := checkIdentity(parent); err != nil {
				return fmt.Errorf("check scaffold parent: %w", err)
			}
		}
	}
	return nil
}

// removeOwned removes children before their parents. Remove, rather than
// RemoveAll, preserves unrecorded files added to an otherwise owned directory.
func removeOwned(entries []scaffoldEntry) error {
	var result error
	for i := len(entries) - 1; i >= 0; i-- {
		entry := entries[i]
		if err := checkAncestors(entries[:i], entry.path); err != nil {
			return errors.Join(result, fmt.Errorf("retained scaffold output: %w", err))
		}
		if err := checkIdentity(entry); err != nil {
			if !errors.Is(err, fs.ErrNotExist) {
				result = errors.Join(result, fmt.Errorf("retained scaffold output: %w", err))
			}
			continue
		}
		if err := os.Remove(entry.path); err != nil {
			result = errors.Join(result, fmt.Errorf("retained scaffold output %s: %w", entry.path, err))
		}
	}
	return result
}

// Write creates a new file beneath a staging directory with normal source permissions.
func Write(dir, relative string, data []byte) error {
	if !fs.ValidPath(relative) || relative == "." || strings.Contains(relative, "\\") {
		return fmt.Errorf("invalid scaffold file path %q", relative)
	}
	if err := os.MkdirAll(filepath.Dir(filepath.Join(dir, relative)), 0755); err != nil {
		return err
	}
	file, err := os.OpenFile(filepath.Join(dir, relative), os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0644)
	if err != nil {
		return err
	}
	_, writeErr := file.Write(data)
	return errors.Join(writeErr, file.Close())
}

// CopyAgent copies embedded agent files; no package installation or code execution occurs.
func CopyAgent(destination string) error {
	return fs.WalkDir(Assets, "assets/agent", func(path string, entry fs.DirEntry, walkErr error) error {
		if walkErr != nil {
			return walkErr
		}
		if entry.IsDir() {
			return nil
		}
		data, err := Assets.ReadFile(path)
		if err != nil {
			return err
		}
		relative := strings.TrimSuffix(strings.TrimPrefix(path, "assets/agent/"), ".tmpl")
		if relative == "gitignore" || relative == "dockerignore" {
			relative = "." + relative
		}
		return Write(destination, relative, data)
	})
}
