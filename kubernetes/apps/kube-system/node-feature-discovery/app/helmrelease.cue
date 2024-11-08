package kube

#helmRelease & {
	_config: name: "node-feature-discovery"
	{
		metadata: namespace: "kube-system"
		spec: {
			chart: spec: {
				chart:   "node-feature-discovery"
				version: "0.16.6"
				sourceRef: name: "node-feature-discovery"
			}
			install: crds: "CreateReplace"
			upgrade: crds: "CreateReplace"
			values: prometheus: enabled: true
		}
	}
}
