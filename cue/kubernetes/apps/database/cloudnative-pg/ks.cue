package kube

#kustomization & {
	_config: name: "cloudnative-pg"
	spec: {
		targetNamespace: "database"
		wait:            true
	}
}
