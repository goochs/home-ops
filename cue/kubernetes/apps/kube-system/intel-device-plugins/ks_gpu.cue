package kube

#kustomization & {
	_config: name: "intel-device-plugin-gpu"
	spec: {
		targetNamespace: "kube-system"
		path:            "./kubernetes/apps/kube-system/intel-device-plugins/gpu"
	}
}
