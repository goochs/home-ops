package kube

kustomization: "cert-manager": spec: {
	targetNamespace: "cert-manager"
	wait:            true
}
kustomization: "cert-manager-issuers": spec: {
	targetNamespace: "cert-manager"
	dependsOn: [{name: "cert-manager"}]
	path: "./kubernetes/apps/cert-manager/cert-manager/issuers"
	wait: true
}
