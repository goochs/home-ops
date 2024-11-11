package kube

#untemplated & {
	apiVersion: "storage.k8s.io/v1"
	kind:       "StorageClass"
	metadata: name: "longhorn-local"
	provisioner:          "driver.longhorn.io"
	allowVolumeExpansion: true
	reclaimPolicy:        "Delete"
	volumeBindingMode:    "Immediate"
	parameters: {
		numberOfReplicas:    "1"
		dataLocality:        "strict-local"
		staleReplicaTimeout: "30"
		fromBackup:          ""
	}
}
