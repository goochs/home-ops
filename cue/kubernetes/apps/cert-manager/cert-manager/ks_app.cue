package kube

#kustomization & {
	_name: "cert-manager"
	spec: {
		targetNamespace: "cert-manager"
		wait:            true
	}
}
