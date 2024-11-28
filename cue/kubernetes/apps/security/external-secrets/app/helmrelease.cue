package kube

#helmRelease & {
	_config: name: "external-secrets"
	spec: {
		chart: spec: {
			chart:   "external-secrets"
			version: "0.10.7"
			sourceRef: name: "external-secrets"
		}
		values: serviceMonitor: enabled: true
	}
}
