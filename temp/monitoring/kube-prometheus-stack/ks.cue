package kube

kustomization: "kube-prometheus-stack": spec: {
	targetNamespace: "monitoring"
	wait:            true
}
