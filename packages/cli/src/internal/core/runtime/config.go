// Package runtime owns microruntime descriptors and their local execution lifecycle.
// Native Terraform and Kubernetes files retain authority over infrastructure settings.
package runtime

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"unicode"
)

// Descriptor identifies a runtime and references consumer-owned native configuration.
// Resource values deliberately belong to Kubernetes files rather than this descriptor.
type Descriptor struct {
	Version     int               `json:"version"`
	ID          string            `json:"id"`
	Environment string            `json:"environment"`
	Owner       string            `json:"owner"`
	Units       map[string]Unit   `json:"units"`
	Terraform   TerraformConfig   `json:"terraform"`
	Kubernetes  KubernetesConfig  `json:"kubernetes"`
	Hooks       map[string]string `json:"hooks,omitempty"`
}

// TerraformConfig locates one Terraform root relative to the runtime directory.
type TerraformConfig struct {
	Directory string `json:"directory"`
}

// KubernetesConfig selects the exact context and namespace; no ambient target is used.
type KubernetesConfig struct {
	Context   string `json:"context"`
	Namespace string `json:"namespace"`
}

// Unit references existing component source and its execution configuration.
type Unit struct {
	Component  string         `json:"component"`
	Kubernetes UnitKubernetes `json:"kubernetes"`
}

// UnitKubernetes locates native manifests relative to the runtime directory.
type UnitKubernetes struct {
	Manifests string `json:"manifests"`
}

// Config is a validated descriptor with canonical project and runtime directories.
type Config struct {
	Root       string
	Dir        string
	Descriptor Descriptor
}

var identifier = regexp.MustCompile(`^[a-z0-9]([a-z0-9-]*[a-z0-9])?$`)

// IDValid reports whether an identifier can also serve as a Kubernetes label value.
func IDValid(value string) bool {
	return len(value) > 0 && len(value) <= 63 && identifier.MatchString(value)
}

func validText(value string) bool {
	return strings.TrimSpace(value) != "" && strings.IndexFunc(value, unicode.IsControl) == -1
}

// StrictJSON rejects duplicate keys, unknown struct fields, and trailing documents.
// Input must be bounded by the caller before decoding.
func StrictJSON(data []byte, target any) error {
	scan := json.NewDecoder(bytes.NewReader(data))
	var walk func(int) error
	walk = func(depth int) error {
		if depth > 64 {
			return errors.New("JSON nesting exceeds 64 levels")
		}
		token, err := scan.Token()
		if err != nil {
			return err
		}
		delimiter, ok := token.(json.Delim)
		if !ok {
			return nil
		}
		switch delimiter {
		case '{':
			keys := make(map[string]bool)
			for scan.More() {
				token, err := scan.Token()
				if err != nil {
					return err
				}
				key, ok := token.(string)
				if !ok {
					return errors.New("expected JSON object key")
				}
				if keys[key] {
					return fmt.Errorf("duplicate JSON key %q", key)
				}
				keys[key] = true
				if err := walk(depth + 1); err != nil {
					return err
				}
			}
		case '[':
			for scan.More() {
				if err := walk(depth + 1); err != nil {
					return err
				}
			}
		default:
			return errors.New("unexpected JSON delimiter")
		}
		_, err = scan.Token()
		return err
	}
	if err := walk(0); err != nil {
		return err
	}
	if _, err := scan.Token(); !errors.Is(err, io.EOF) {
		return errors.New("expected one JSON document")
	}
	decoder := json.NewDecoder(bytes.NewReader(data))
	decoder.DisallowUnknownFields()
	return decoder.Decode(target)
}

func descriptorKeys(data []byte) error {
	var root map[string]json.RawMessage
	if err := json.Unmarshal(data, &root); err != nil {
		return err
	}
	check := func(raw map[string]json.RawMessage, required, optional []string) error {
		allowed := make(map[string]bool)
		for _, name := range required {
			allowed[name] = true
			if value, ok := raw[name]; !ok || bytes.Equal(bytes.TrimSpace(value), []byte("null")) {
				return fmt.Errorf("required descriptor field %q is missing or null", name)
			}
		}
		for _, name := range optional {
			allowed[name] = true
		}
		for name := range raw {
			if !allowed[name] {
				return fmt.Errorf("unknown descriptor field %q", name)
			}
		}
		return nil
	}
	if err := check(root, []string{"version", "id", "environment", "owner", "units", "terraform", "kubernetes"}, []string{"hooks"}); err != nil {
		return err
	}
	nested := func(data json.RawMessage, required []string) error {
		var object map[string]json.RawMessage
		if err := json.Unmarshal(data, &object); err != nil {
			return err
		}
		return check(object, required, nil)
	}
	if err := nested(root["terraform"], []string{"directory"}); err != nil {
		return err
	}
	if err := nested(root["kubernetes"], []string{"context", "namespace"}); err != nil {
		return err
	}
	var units map[string]map[string]json.RawMessage
	if err := json.Unmarshal(root["units"], &units); err != nil {
		return err
	}
	for name, unit := range units {
		if err := check(unit, []string{"component", "kubernetes"}, nil); err != nil {
			return fmt.Errorf("unit %s: %w", name, err)
		}
		if err := nested(unit["kubernetes"], []string{"manifests"}); err != nil {
			return fmt.Errorf("unit %s: %w", name, err)
		}
	}
	if raw, ok := root["hooks"]; ok && bytes.Equal(bytes.TrimSpace(raw), []byte("null")) {
		return errors.New("hooks must be an object")
	}
	return nil
}

// SafePath resolves an existing project-relative path without following symlinks.
// Every segment must remain inside the boundary, including referenced directories.
func SafePath(boundary, relative string) (string, error) {
	if !validText(relative) || filepath.IsAbs(relative) || strings.Contains(relative, "\\") || filepath.ToSlash(filepath.Clean(relative)) != relative || relative == "." {
		return "", fmt.Errorf("invalid relative path %q", relative)
	}
	for _, part := range strings.Split(relative, "/") {
		if part == ".." || part == "." {
			return "", fmt.Errorf("path escapes its boundary: %s", relative)
		}
	}
	base, err := filepath.EvalSymlinks(boundary)
	if err != nil {
		return "", err
	}
	base, err = filepath.Abs(base)
	if err != nil {
		return "", err
	}
	current := base
	for _, part := range strings.Split(relative, "/") {
		current = filepath.Join(current, part)
		info, err := os.Lstat(current)
		if err != nil {
			return "", fmt.Errorf("reference %s: %w", relative, err)
		}
		if info.Mode()&os.ModeSymlink != 0 {
			return "", fmt.Errorf("symlink references are unsupported: %s", relative)
		}
	}
	return current, nil
}

// Resolve returns an existing path relative to this runtime's configuration boundary.
func (c *Config) Resolve(reference string) (string, error) { return SafePath(c.Dir, reference) }

// ComponentPath resolves the source directory selected by a named unit.
func (c *Config) ComponentPath(name string) (string, error) {
	unit, ok := c.Descriptor.Units[name]
	if !ok {
		return "", fmt.Errorf("unknown unit %q", name)
	}
	return SafePath(c.Root, unit.Component)
}

func canonicalRoot(root string) (string, error) {
	path, err := filepath.Abs(root)
	if err != nil {
		return "", err
	}
	return filepath.EvalSymlinks(path)
}

func rejectLegacy(root, id string) error {
	for _, relative := range []string{".micro-runtime/" + id, ".micro-runtimes/" + id} {
		if _, err := os.Lstat(filepath.Join(root, relative)); err == nil {
			return fmt.Errorf("legacy runtime %s exists; migration is explicit, and this command does not modify it", relative)
		} else if !os.IsNotExist(err) {
			return err
		}
	}
	return nil
}

// Load validates the descriptor and local references without executing tools or hooks.
// Legacy locations and versions are refused; no fallback or migration is performed.
func Load(root, id string) (*Config, error) {
	if !IDValid(id) {
		return nil, fmt.Errorf("invalid runtime ID %q: use 1–63 lowercase DNS-label characters", id)
	}
	root, err := canonicalRoot(root)
	if err != nil {
		return nil, err
	}
	if err := rejectLegacy(root, id); err != nil {
		return nil, err
	}
	dir, err := SafePath(root, ".exphere/runtimes/"+id)
	if err != nil {
		return nil, err
	}
	path, err := SafePath(dir, "schema.json")
	if err != nil {
		return nil, err
	}
	info, err := os.Stat(path)
	if err != nil || !info.Mode().IsRegular() {
		return nil, errors.New("schema.json must be a regular file")
	}
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	data, err := io.ReadAll(io.LimitReader(file, 4*1024*1024+1))
	if err != nil {
		return nil, err
	}
	if len(data) > 4*1024*1024 {
		return nil, errors.New("descriptor exceeds 4 MiB")
	}
	var descriptor Descriptor
	if err := StrictJSON(data, &descriptor); err != nil {
		return nil, fmt.Errorf("schema.json: %w", err)
	}
	if err := descriptorKeys(data); err != nil {
		return nil, err
	}
	config := &Config{Root: root, Dir: dir, Descriptor: descriptor}
	if descriptor.ID != id {
		return nil, errors.New("descriptor ID must match the runtime directory")
	}
	if err := validateConfig(config); err != nil {
		return nil, err
	}
	return config, nil
}

// Validate checks the complete v2 configuration and references without changing files.
func Validate(root, id string) error {
	c, err := Load(root, id)
	if err != nil {
		return err
	}
	return validateNativeConfig(c)
}

// validateNativeConfig is shared by complete manual and staged guided descriptors.
// It inspects files without invoking infrastructure tools or reading live resources.
func validateNativeConfig(c *Config) error {
	if _, _, err := manifests(c); err != nil {
		return err
	}
	_, err := terraformConfig(c)
	return err
}

func validateConfig(c *Config) error {
	d := c.Descriptor
	if d.Version != 2 {
		return fmt.Errorf("descriptor version %d is unsupported; expected version 2 with explicit migration", d.Version)
	}
	if d.Environment != "local" {
		return errors.New("only the local environment is supported")
	}
	if !IDValid(d.ID) || !validText(d.Owner) || !validText(d.Kubernetes.Context) || !IDValid(d.Kubernetes.Namespace) {
		return errors.New("runtime ID, owner, context, and DNS-label namespace are required")
	}
	if len(d.Units) == 0 {
		return errors.New("at least one unit is required")
	}
	terraform, err := c.Resolve(d.Terraform.Directory)
	if err != nil {
		return fmt.Errorf("terraform: %w", err)
	}
	info, err := os.Stat(terraform)
	if err != nil || !info.IsDir() {
		return errors.New("terraform reference must be a directory")
	}
	native, err := os.ReadDir(terraform)
	if err != nil {
		return err
	}
	found := false
	for _, entry := range native {
		if !entry.IsDir() && (strings.HasSuffix(entry.Name(), ".tf") || strings.HasSuffix(entry.Name(), ".tf.json")) {
			found = true
		}
	}
	if !found {
		return errors.New("terraform directory contains no .tf or .tf.json configuration")
	}
	manifestPaths := make(map[string]string)
	for _, name := range sortedUnitNames(d.Units) {
		unit := d.Units[name]
		if !IDValid(name) || filepath.Base(unit.Component) != name {
			return fmt.Errorf("unit %q must be a DNS label matching its component directory name", name)
		}
		component, err := c.ComponentPath(name)
		if err != nil {
			return fmt.Errorf("unit %s: %w", name, err)
		}
		relative, err := filepath.Rel(filepath.Join(c.Root, ".exphere", "runtimes"), component)
		if err != nil {
			return err
		}
		if relative != ".." && !strings.HasPrefix(relative, ".."+string(filepath.Separator)) {
			return fmt.Errorf("unit %s source must remain outside runtime configuration", name)
		}
		info, err := os.Stat(component)
		if err != nil || !info.IsDir() {
			return fmt.Errorf("unit %s component must be a directory", name)
		}
		manifests, err := c.Resolve(unit.Kubernetes.Manifests)
		if err != nil {
			return fmt.Errorf("unit %s: %w", name, err)
		}
		if previous, exists := manifestPaths[manifests]; exists {
			return fmt.Errorf("units %s and %s share the same manifest path", previous, name)
		}
		manifestPaths[manifests] = name
		info, err = os.Stat(manifests)
		if err != nil {
			return err
		}
		if !info.IsDir() && !info.Mode().IsRegular() {
			return fmt.Errorf("unit %s manifests must be a directory or regular file", name)
		}
		if !info.IsDir() && !(strings.HasSuffix(manifests, ".json") || strings.HasSuffix(manifests, ".yaml") || strings.HasSuffix(manifests, ".yml")) {
			return fmt.Errorf("unit %s manifests require JSON or YAML", name)
		}
	}
	for name, hook := range d.Hooks {
		if !IDValid(name) || !strings.HasSuffix(hook, ".sh") {
			return fmt.Errorf("hook %q must reference a .sh file", name)
		}
		path, err := c.Resolve(hook)
		if err != nil {
			return fmt.Errorf("hook %s: %w", name, err)
		}
		info, err := os.Stat(path)
		if err != nil || !info.Mode().IsRegular() {
			return fmt.Errorf("hook %s must be a regular file", name)
		}
	}
	return nil
}

func sortedUnitNames(units map[string]Unit) []string {
	names := make([]string, 0, len(units))
	for name := range units {
		names = append(names, name)
	}
	sort.Strings(names)
	return names
}
