package kube

#helmRelease & {
	_config: name: "prometheus-operator-crds"
	spec: chart: spec: {
		chart:   "prometheus-operator-crds"
		version: "16.0.1"
		sourceRef: name: "prometheus-community"
	}
}
