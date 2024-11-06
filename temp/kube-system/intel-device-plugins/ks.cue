package kube

kustomization: "intel-device-plugin-operator": spec: {
	targetNamespace: "kube-system"
	path:            "./kubernetes/apps/kube-system/intel-device-plugins/operator"
}
kustomization: "intel-device-plugin-gpu": spec: {
	targetNamespace: "kube-system"
	path:            "./kubernetes/apps/kube-system/intel-device-plugins/gpu"
}
