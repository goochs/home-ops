package kube

#kustomization & {
	_config: name: "node-feature-discovery"
	spec: {
		targetNamespace: "kube-system"
		wait:            true
	}

}
