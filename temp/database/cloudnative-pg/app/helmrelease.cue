package kube

helmRelease: "cloudnative-pg": spec: {
	_longhorn: true
	chart: spec: {
		chart:   "cloudnative-pg"
		version: "0.22.1"
		sourceRef: name: "cloudnative-pg"
	}
	values: {
		crds: create: true
		monitoring: {
			podMonitorEnabled: false
			grafanaDashboard: create: true
		}
	}
}
