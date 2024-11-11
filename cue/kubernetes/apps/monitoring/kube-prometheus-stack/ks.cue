package kube

#kustomization & {
	_config: name: "kube-prometheus-stack"
	spec: {
		targetNamespace: "monitoring"
		wait:            true
	}
}
