package kube

#kustomization & {
	_config: name: "argocd"
	spec: {
		targetNamespace: "argocd"
		wait:            true
	}
}
