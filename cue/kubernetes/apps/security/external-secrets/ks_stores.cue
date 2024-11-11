package kube

#kustomization & {
	_config: name: "external-secrets-stores"
	spec: {
		targetNamespace: "security"
		dependsOn: [{name: "external-secrets"}, {name: "onepass-connect"}]
		path: "./kubernetes/apps/security/external-secrets/stores"
		wait: true
	}
}
