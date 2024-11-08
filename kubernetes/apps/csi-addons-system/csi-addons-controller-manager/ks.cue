package kube

#kustomization & {
	_name: "csi-addons-controller-manager"
	spec: {
		targetNamespace: "csi-addons-system"
		path:            "./deploy/controller"
		sourceRef: name: "kubernetes-csi-addons"
		wait: true
	}
}
