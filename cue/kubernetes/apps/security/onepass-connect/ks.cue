package kube

#kustomization & {
	_config: name: "onepass-connect"
	spec: {
		targetNamespace: "security"
		wait:            true
	}
}
