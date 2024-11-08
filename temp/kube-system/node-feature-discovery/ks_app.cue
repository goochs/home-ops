package kube

#kustomization & {
	_name: "node-feature-discovery"
	spec: {
		targetNamespace: "kube-system"
		wait:            true
	}

}
