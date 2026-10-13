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
// destination exclusively. A handled failure removes only this invocation's output.
// An abrupt process termination may leave staging or a reserved empty directory;
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
	if err := os.Rename(staging, target); err != nil {
		cleanup := os.Remove(target)
		return errors.Join(fmt.Errorf("publish scaffold: %w", err), cleanup)
	}
	return nil
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
