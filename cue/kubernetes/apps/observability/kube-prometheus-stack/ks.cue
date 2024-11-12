package kube

#kustomization & {
	_config: name: "kube-prometheus-stack"
	spec: {
		targetNamespace: "observability"
		wait:            true
		timeout:         "15m"
	}
}
