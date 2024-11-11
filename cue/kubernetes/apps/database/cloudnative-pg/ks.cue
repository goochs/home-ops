package kube

#kustomization & {
	_name: "cloudnative-pg"
	spec: {
		targetNamespace: "database"
		wait:            true
	}
}
