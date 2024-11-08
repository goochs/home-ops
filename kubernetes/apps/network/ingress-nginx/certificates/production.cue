package kube

#untemplated & {
	apiVersion: "cert-manager.io/v1"
	kind:       "Certificate"
	metadata: name: "goochs-us-production"
	spec: {
		secretName: "goochs-us-production-tls"
		issuerRef: {
			name: "letsencrypt-production"
			kind: "ClusterIssuer"
		}
		commonName: "goochs.us"
		dnsNames: [
			"goochs.us",
			"*.goochs.us",
		]
	}
}
