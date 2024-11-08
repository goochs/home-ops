package kube

#helmRelease & {
	_config: name: "csi-driver-nfs"
	spec: {
		chart: spec: {
			chart:   "csi-driver-nfs"
			version: "v4.9.0"
			sourceRef: name: "csi-driver-nfs"
		}
		values: externalSnapshotter: enabled: false
	}
}
