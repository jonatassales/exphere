package cluster_test

import (
	"errors"
	"maps"
	"testing"

	"github.com/exphere/ex/src/internal/domain/cluster"
)

// bootstrapInventory is what a fresh cluster holds: a controller chain in
// kube-system and one cluster-scoped object.
func bootstrapInventory() cluster.Inventory {
	return cluster.Inventory{
		Objects: map[string]cluster.ObjectIdentity{
			"true/deployments.apps/kube-system/coredns":     {UID: "uid-deployment"},
			"true/replicasets.apps/kube-system/coredns-6f6": {UID: "uid-replicaset", Controllers: []string{"uid-deployment"}},
			"true/pods/kube-system/coredns-6f6-abcde":       {UID: "uid-pod", Controllers: []string{"uid-replicaset"}},
			"false/nodes//ex-control-plane":                 {UID: "uid-node"},
		},
		ResourceTypes: []string{"true/deployments.apps", "true/replicasets.apps", "true/pods", "false/nodes"},
	}
}

// observation copies the bootstrap so each case can change it independently.
func observation() (map[string]string, cluster.Inventory) {
	bootstrap := bootstrapInventory()

	return map[string]string{"kube-system": "uid-kube-system", "default": "uid-default"},
		cluster.Inventory{Objects: maps.Clone(bootstrap.Objects), ResourceTypes: append([]string(nil), bootstrap.ResourceTypes...)}
}

func TestRecord_AuthorizeDeletion(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name    string
		edit    func(record *cluster.Record, namespaces map[string]string, observed *cluster.Inventory)
		wantErr bool
	}{
		{
			name: "unchanged bootstrap",
			edit: func(*cluster.Record, map[string]string, *cluster.Inventory) {},
		},
		{
			name: "deleted bootstrap object",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				delete(observed.Objects, "true/pods/kube-system/coredns-6f6-abcde")
			},
		},
		{
			name: "pod recreated by a bootstrap controller",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				delete(observed.Objects, "true/pods/kube-system/coredns-6f6-abcde")
				observed.Objects["true/pods/kube-system/coredns-6f6-fghij"] = cluster.ObjectIdentity{
					UID: "uid-new-pod", Controllers: []string{"uid-replicaset"},
				}
			},
		},
		{
			name: "rollout below a bootstrap controller, child listed before parent",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				observed.Objects["true/pods/kube-system/coredns-7a7-abcde"] = cluster.ObjectIdentity{
					UID: "uid-rollout-pod", Controllers: []string{"uid-rollout-replicaset"},
				}
				observed.Objects["true/replicasets.apps/kube-system/coredns-7a7"] = cluster.ObjectIdentity{
					UID: "uid-rollout-replicaset", Controllers: []string{"uid-deployment"},
				}
			},
		},
		{
			name: "new resource API without objects",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				observed.ResourceTypes = append(observed.ResourceTypes, "true/widgets.example.com")
			},
		},
		{
			name: "foreign object",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				observed.Objects["true/configmaps/default/consumer"] = cluster.ObjectIdentity{UID: "uid-foreign"}
			},
			wantErr: true,
		},
		{
			name: "object controlled by a foreign object",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				observed.Objects["true/pods/default/consumer"] = cluster.ObjectIdentity{
					UID: "uid-foreign-pod", Controllers: []string{"uid-foreign-controller"},
				}
			},
			wantErr: true,
		},
		{
			name: "replaced bootstrap object",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				observed.Objects["true/deployments.apps/kube-system/coredns"] = cluster.ObjectIdentity{UID: "uid-replacement"}
			},
			wantErr: true,
		},
		{
			name: "replaced child that a bootstrap controller recreated",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				observed.Objects["true/replicasets.apps/kube-system/coredns-6f6"] = cluster.ObjectIdentity{
					UID: "uid-recreated-replicaset", Controllers: []string{"uid-deployment"},
				}
				observed.Objects["true/pods/kube-system/coredns-6f6-abcde"] = cluster.ObjectIdentity{
					UID: "uid-recreated-pod", Controllers: []string{"uid-recreated-replicaset"},
				}
			},
		},
		{
			name: "vanished resource API",
			edit: func(_ *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				observed.ResourceTypes = observed.ResourceTypes[:len(observed.ResourceTypes)-1]
			},
			wantErr: true,
		},
		{
			name: "foreign namespace",
			edit: func(_ *cluster.Record, namespaces map[string]string, _ *cluster.Inventory) {
				namespaces["consumer"] = "uid-consumer"
			},
			wantErr: true,
		},
		{
			name: "foreign namespace without a UID",
			edit: func(_ *cluster.Record, namespaces map[string]string, _ *cluster.Inventory) {
				namespaces["consumer"] = ""
			},
			wantErr: true,
		},
		{
			name: "baseline namespace recorded without a UID",
			edit: func(record *cluster.Record, _ map[string]string, _ *cluster.Inventory) {
				record.Baseline.Namespaces["consumer"] = ""
			},
			wantErr: true,
		},
		{
			name: "objects without UIDs vouching for each other",
			edit: func(record *cluster.Record, _ map[string]string, observed *cluster.Inventory) {
				record.Baseline.Inventory.Objects["true/configmaps/default/unidentified"] = cluster.ObjectIdentity{}
				observed.Objects["true/configmaps/default/unidentified"] = cluster.ObjectIdentity{}
				observed.Objects["true/configmaps/default/consumer"] = cluster.ObjectIdentity{}
				observed.Objects["true/pods/default/consumer"] = cluster.ObjectIdentity{UID: "uid-foreign-pod", Controllers: []string{""}}
			},
			wantErr: true,
		},
		{
			name: "replaced namespace",
			edit: func(_ *cluster.Record, namespaces map[string]string, _ *cluster.Inventory) {
				namespaces["default"] = "uid-replacement"
			},
			wantErr: true,
		},
		{
			name: "missing baseline namespace",
			edit: func(_ *cluster.Record, namespaces map[string]string, _ *cluster.Inventory) {
				delete(namespaces, "default")
			},
			wantErr: true,
		},
		{
			name: "no namespace baseline",
			edit: func(record *cluster.Record, _ map[string]string, _ *cluster.Inventory) {
				record.Baseline.Namespaces = nil
			},
			wantErr: true,
		},
		{
			name: "record without versioned inventory proof",
			edit: func(record *cluster.Record, _ map[string]string, _ *cluster.Inventory) {
				record.Baseline.InventoryVersion = 0
			},
			wantErr: true,
		},
		{
			name: "empty bootstrap objects",
			edit: func(record *cluster.Record, _ map[string]string, _ *cluster.Inventory) {
				record.Baseline.Inventory.Objects = nil
			},
			wantErr: true,
		},
		{
			name: "empty bootstrap resource types",
			edit: func(record *cluster.Record, _ map[string]string, _ *cluster.Inventory) {
				record.Baseline.Inventory.ResourceTypes = nil
			},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			record := readyRecord(t)
			namespaces, observed := observation()
			tt.edit(&record, namespaces, &observed)

			err := record.AuthorizeDeletion(namespaces, observed)

			if tt.wantErr != errors.Is(err, cluster.ErrUnsafeDeletion) || (!tt.wantErr && err != nil) {
				t.Fatalf("AuthorizeDeletion() error = %v, want refusal %t", err, tt.wantErr)
			}
		})
	}
}
