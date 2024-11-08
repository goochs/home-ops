package kube

#kustomization & {
	_name: "intel-device-plugin-operator"
	spec: {
		targetNamespace: "kube-system"
		path:            "./kubernetes/apps/kube-system/intel-device-plugins/operator"
	}
}
