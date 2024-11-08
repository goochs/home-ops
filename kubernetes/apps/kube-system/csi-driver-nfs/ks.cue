package kube

#kustomization & {
	_name: "csi-driver-nfs"
	spec: {
		targetNamespace: "kube-system"
		wait:            true
	}
}
