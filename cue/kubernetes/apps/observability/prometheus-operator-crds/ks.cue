package kube

#kustomization & {
	_config: name: "prometheus-operator-crds"
	spec: {
		targetNamespace: "observability"
		wait:            false
		prune:           false
	}
}
