package kube

#kustomization & {
	_config: name: "ingress-nginx-certificates"
	spec: {
		targetNamespace: "network"
		dependsOn: [{name: "cert-manager-issuers"}]
		path: "./kubernetes/apps/network/ingress-nginx/certificates"
		wait: true
	}
}
