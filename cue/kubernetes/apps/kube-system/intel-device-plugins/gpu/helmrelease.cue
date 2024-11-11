package kube

#helmRelease & {
	_config: name: "intel-device-plugin-gpu"
	spec: {
		chart: spec: {
			chart:   "intel-device-plugins-gpu"
			version: "0.31.1"
			sourceRef: name: "intel"
		}
		dependsOn: [{
			name:      "intel-device-plugin-operator"
			namespace: "kube-system"
		}]
		values: {
			name:            "intel-device-plugin-gpu"
			sharedDevNum:    3
			nodeFeatureRule: false
		}
	}
}
