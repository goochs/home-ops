package kube

#kustomization & {
	_config: name: "prometheus-operator-crds"
	spec: {
		targetNamespace: "observability"
		prune:           false
	}
}
