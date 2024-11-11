package kube

#untemplated & {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ClusterSecretStore"
	metadata: name: "onepass-connect"
	spec: provider: onepassword: {
		connectHost: "http://onepass-connect.security.svc.cluster.local:8080"
		vaults: "home-k8s": 1
		auth: secretRef: connectTokenSecretRef: {
			name:      "onepass-connect-secret"
			key:       "token"
			namespace: "security"
		}
	}

}
