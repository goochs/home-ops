package kube

persistentVolumeClaim: "sonarr-config": {
	apiVersion: "v1"
	kind:       "PersistentVolumeClaim"
	metadata: name: "sonarr-config"
	spec: {
		accessModes: ["ReadWriteOnce"]
		resources: requests: storage: "5Gi"
		storageClassName: "longhorn"
	}
}