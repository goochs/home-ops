package kube

#kustomization & {
	_name: "cilium-config"
	spec: {
		targetNamespace: "kube-system"
		dependsOn: [{name: "cilium"}]
		path:  "./kubernetes/apps/kube-system/cilium/config"
		prune: false // never should be deleted
	}
}
