package kube

#helmRelease & {
	_config: name: "longhorn"
	spec: {
		timeout: "15m"
		chart: spec: {
			chart:   "longhorn"
			version: "1.7.2"
			sourceRef: name: "longhorn"
		}
		values: {
			monitoring: {
				enabled:               true
				createPrometheusRules: true
			}
			ingress: {
				enabled:          true
				ingressClassName: "internal"
				host:             "longhorn.goochs.us"
			}
		}
	}
}
