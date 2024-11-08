package kube

#kustomization & {
	_name: "ingress-nginx-external"
	spec: {
		targetNamespace: "network"
		dependsOn: [{name: "ingress-nginx-certificates"}]
		path: "./kubernetes/apps/network/ingress-nginx/external"
	}
}
