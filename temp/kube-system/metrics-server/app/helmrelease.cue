package kube

#helmRelease & {
	_config: name: "metrics-server"
	spec: {
		chart: spec: {
			chart:   "metrics-server"
			version: "3.12.2"
			sourceRef: name: "metrics-server"
		}
		values: {
			args: [
				"--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
				"--kubelet-use-node-status-port",
				"--metric-resolution=15s",
			]
			metrics: enabled:        true
			serviceMonitor: enabled: true
		}
	}
}
