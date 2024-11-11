package kube

#kustomization & {
	_name: "cilium"
	spec: {
		targetNamespace: "kube-system"
		prune:           false // never should be deleted
		wait:            true
	}
}
