package kube

#kustomization & {
	_name: "ingress-nginx-internal"
	spec: {
		targetNamespace: "network"
		dependsOn: [{name: "ingress-nginx-certificates"}]
		path: "./kubernetes/apps/network/ingress-nginx/internal"
	}
}
