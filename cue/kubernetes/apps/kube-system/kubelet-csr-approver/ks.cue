package kube

#kustomization & {
	_config: name: "kubelet-csr-approver"
	spec: {
		targetNamespace: "kube-system"
		prune:           false // never should be deleted
	}
}
