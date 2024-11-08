package kube

#kustomization & {
	_name: "flux-webhooks"
	spec: {
		targetNamespace: "flux-system"
		wait:            true
	}
}
