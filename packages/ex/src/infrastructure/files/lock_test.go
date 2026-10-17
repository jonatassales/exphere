package files_test

import (
	"path/filepath"
	"strings"
	"testing"

	"github.com/exphere/ex/src/infrastructure/files"
)

func TestLock(t *testing.T) {
	t.Parallel()

	path := filepath.Join(tempDir(t), "state", "cluster.lock")

	unlock, err := files.Lock(path)
	if err != nil {
		t.Fatal(err)
	}

	if _, err := files.Lock(path); err == nil || !strings.Contains(err.Error(), "another operation holds cluster.lock") {
		t.Fatalf("second Lock() error = %v, want the held lock reported", err)
	}

	unlock()
	unlock()

	again, err := files.Lock(path)
	if err != nil {
		t.Fatalf("Lock() after release error = %v", err)
	}
	defer again()

	assertMode(t, path, 0o600)
	assertMode(t, filepath.Dir(path), 0o700)
}

func TestLock_RefusesLinks(t *testing.T) {
	t.Parallel()

	root := tempDir(t)
	target := writeFile(t, filepath.Join(root, "target"), "")

	if _, err := files.Lock(symlink(t, target, filepath.Join(root, "cluster.lock"))); err == nil {
		t.Error("Lock followed a symlinked lock file")
	}

	linked := symlink(t, mkdir(t, filepath.Join(root, "real")), filepath.Join(root, "linked"))
	if _, err := files.Lock(filepath.Join(linked, "cluster.lock")); err == nil {
		t.Error("Lock used a symlinked directory")
	}
}
