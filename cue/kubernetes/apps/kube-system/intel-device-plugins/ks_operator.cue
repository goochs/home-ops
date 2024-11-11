package kube

#kustomization & {
	_config: name: "intel-device-plugin-operator"
	spec: {
		targetNamespace: "kube-system"
		path:            "./kubernetes/apps/kube-system/intel-device-plugins/operator"
	}
}
