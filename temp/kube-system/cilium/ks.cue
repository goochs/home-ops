package kube

kustomization: cilium: spec: {
	targetNamespace: "kube-system"
	prune:           false // never should be deleted
	wait:            true
}
kustomization: "cilium-config": spec: {
	targetNamespace: "kube-system"
	dependsOn: [{name: "cilium"}]
	path:  "./kubernetes/apps/kube-system/cilium/config"
	prune: false // never should be deleted
}
