package kube

#helmRelease & {
	_config: name: "reloader"
	spec: {
		chart: spec: {
			chart:   "reloader"
			version: "1.2.0"
			sourceRef: name: "stakater"
		}
		values: {
			fullnameOverride: "reloader"
			reloader: {
				readOnlyRootFileSystem: true
				podMonitor: {
					enabled:   true
					namespace: "{{ .Release.Namespace }}"
				}
			}
		}
	}
}
