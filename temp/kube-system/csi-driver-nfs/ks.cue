package kube

kustomization: "csi-driver-nfs": spec: {
	targetNamespace: "kube-system"
	wait:            true
}
