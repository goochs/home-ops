package kube

helmRelease: reloader: spec: {
	chart: spec: {
		chart:   "reloader"
		version: "1.1.0"
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
