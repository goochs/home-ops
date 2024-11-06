package kube

helmRelease: "cloudnative-pg": spec: {
	chart: spec: {
		chart:   "cloudnative-pg"
		version: "0.22.1"
		sourceRef: name: "cloudnative-pg"
	}
	dependsOn: [{
		name:      "longhorn"
		namespace: "longhorn-system"
	}]
	values: {
		crds: create: true
		monitoring: {
			podMonitorEnabled: false
			grafanaDashboard: create: true
		}
	}
}
