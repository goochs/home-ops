package kube

#kustomization & {
	_name: "longhorn"
	spec: {
		targetNamespace: "longhorn-system"
		timeout:         "15m"
	}
}
