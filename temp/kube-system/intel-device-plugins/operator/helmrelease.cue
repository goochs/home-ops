package kube

helmRelease: "intel-device-plugin-operator": spec: {
	chart: spec: {
		chart:   "intel-device-plugins-operator"
		version: "0.31.1"
		sourceRef: name: "intel"
	}
	install: crds: "CreateReplace"
	upgrade: crds: "CreateReplace"
	dependsOn: [{
		name:      "node-feature-discovery"
		namespace: "kube-system"
	}]
}
