package kube

#kustomization & {
	_name: "flux-webhook"
	spec: {
		targetNamespace: "flux-system"
		wait:            true
	}
}
