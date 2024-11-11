package kube

#kustomization & {
	_config: name: "cert-manager"
	spec: {
		targetNamespace: "cert-manager"
		wait:            true
	}
}
