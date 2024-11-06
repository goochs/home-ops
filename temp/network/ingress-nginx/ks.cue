package kube

kustomization: "ingress-nginx-certificates": spec: {
	targetNamespace: "network"
	dependsOn: [{name: "cert-manager-issuers"}]
	path: "./kubernetes/apps/network/ingress-nginx/certificates"
	wait: true
}
kustomization: "ingress-nginx-internal": spec: {
	targetNamespace: "network"
	dependsOn: [{name: "ingress-nginx-certificates"}]
	path: "./kubernetes/apps/network/ingress-nginx/internal"
}
kustomization: "ingress-nginx-external": spec: {
	targetNamespace: "network"
	dependsOn: [{name: "ingress-nginx-certificates"}]
	path: "./kubernetes/apps/network/ingress-nginx/external"
}
