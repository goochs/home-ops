package kube

persistentVolumeClaim: "actual-config": {
	apiVersion: "v1"
	kind:       "PersistentVolumeClaim"
	metadata: name: "actual-config"
	spec: {
		accessModes: ["ReadWriteOnce"]
		resources: requests: storage: "10Gi"
		storageClassName: "longhorn"
	}
}
