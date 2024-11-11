package kube

#kustomization & {
	_config: name: "cert-manager-issuers"
	spec: {
		targetNamespace: "cert-manager"
		dependsOn: [{name: "cert-manager"}]
		path: "./kubernetes/apps/cert-manager/cert-manager/issuers"
		wait: true
	}
}
