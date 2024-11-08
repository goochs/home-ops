package kube

persistentVolumeClaim: "radarr-config": {
	apiVersion: "v1"
	kind:       "PersistentVolumeClaim"
	metadata: name: "radarr-config"
	spec: {
		accessModes: ["ReadWriteOnce"]
		resources: requests: storage: "5Gi"
		storageClassName: "longhorn"
	}
}