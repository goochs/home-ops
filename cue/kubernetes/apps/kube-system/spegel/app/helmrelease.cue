package kube

#helmRelease & {
	_config: name: "spegel"
	spec: {
		chart: spec: {
			chart:   "spegel"
			version: "v0.0.27"
			sourceRef: name: "spegel"
		}
		values: {
			spegel: {
				containerdSock:               "/run/containerd/containerd.sock"
				containerdRegistryConfigPath: "/etc/cri/conf.d/hosts"
			}
			service: registry: hostPort: 29999
			serviceMonitor: enabled: true
		}
	}
}
