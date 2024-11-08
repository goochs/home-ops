package kube

#kustomization & {
	_name: "node-feature-discovery-rules"
	spec: {
		targetNamespace: "kube-system"
		path:            "./kubernetes/apps/kube-system/node-feature-discovery/rules"
		wait:            true
	}
}
