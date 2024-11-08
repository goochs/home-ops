package kube

#helmRelease & {
	_config: {
		name:     "cloudnative-pg"
		longhorn: true
	}
	spec: {
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
}
