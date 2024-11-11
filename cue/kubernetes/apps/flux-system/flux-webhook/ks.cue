package kube

#kustomization & {
	_config: name: "flux-webhook"
	spec: {
		targetNamespace: "flux-system"
		wait:            true
	}
}
