package kube

#kustomization & {
	_config: name: "external-secrets"
	spec: {
		targetNamespace: "security"
		wait:            true
	}
}
