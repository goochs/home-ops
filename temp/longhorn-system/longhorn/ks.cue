package kube

kustomization: longhorn: spec: {
	targetNamespace: "longhorn-system"
	timeout:         "15m"
}
