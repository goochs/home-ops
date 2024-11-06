package kube

kustomization: "kubelet-csr-approver": spec: {
	targetNamespace: "kube-system"
	prune:           false // never should be deleted
}
