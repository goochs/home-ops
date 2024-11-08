package kube

#kustomization & {
	_name: "kube-prometheus-stack"
	spec: {
		targetNamespace: "monitoring"
		wait:            true
	}
}
