package kube

kustomization: "node-feature-discovery": spec: {
	targetNamespace: "kube-system"
	wait:            true
}
kustomization: "node-feature-discovery-rules": spec: {
	targetNamespace: "kube-system"
	path:            "./kubernetes/apps/kube-system/node-feature-discovery/rules"
	wait:            true
}
