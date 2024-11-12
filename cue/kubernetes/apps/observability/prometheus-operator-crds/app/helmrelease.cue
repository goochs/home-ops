package kube

#helmRelease & {
	_config: name: "kube-prometheus-stack"
	spec: chart: spec: {
		chart:   "prometheus-operator-crds"
		version: "16.0.0"
		sourceRef: name: "prometheus-community"
	}
}
