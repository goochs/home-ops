package kube

#kustomization & {
	_config: name: "longhorn"
	spec: {
		targetNamespace: "longhorn-system"
		timeout:         "15m"
	}
}
