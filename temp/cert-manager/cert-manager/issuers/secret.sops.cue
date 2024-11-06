package kube

secret: "cert-manager-secret": {
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:      "cert-manager-secret"
		namespace: "cert-manager"
	}
	stringData: "api-token": "ENC[AES256_GCM,data:cb1RAaEurWN1Qm4yPMFB422GjyjSHhJS0h+TqsGJzjhZZlbJaudYtQ==,iv:deZwfCVHsW4XpMlQLO3lC6PLBACL5pDbU/ib/QrxQG0=,tag:d7Qo2YxDvVkUp1jNTtls6g==,type:str]"
	sops: {
		kms: []
		gcp_kms: []
		azure_kv: []
		hc_vault: []
		age: [{
			recipient: "age17yhdxmw884lyl8m022pfqlh5c8j4e5ljcr7k7qugy63xnptkmvysdm345w"
			enc: """
				-----BEGIN AGE ENCRYPTED FILE-----
				YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSA5ZU5qZDNkOWdmZUtZSzB6
				TzZXbG00bnc0aXpIS0RJREZSdXVJaUZBTEZrCmtSN2FsMzhPZzRpaEwzUG9hamFu
				cTgxQlFDalpjRXYvRFd5RE5MSUxJUmMKLS0tIHRTdEV2bEMrQ0sxR1dGQkZ3SFV4
				eSsrNmFodHZZZ2N4UmxyU2NFREpZMVkKGNQcUFTKDMJfQKlNZGzqybljmEaoOCPY
				s1yi1vKvCEWfdlpyolGrdbPSbYnESH76nzdazh1LU0VCNkOs6XLGYQ==
				-----END AGE ENCRYPTED FILE-----

				"""
		}]
		lastmodified: "2023-09-20T22:15:49Z"
		mac:          "ENC[AES256_GCM,data:naZoaWhWOle4IexDeBX4P7puiOC5kMzM77z62AUQMuBqBDz0czYJ4G6fq9RDeO4ILuZJ0lzGlvtb0lVOQUPAldmq7cYuj4U9sf67q+2AUT3rsrHn8uj+/hNvr/LjlGFaL4/11IqPYMriHrVoYgvTWckn8BzYUzdKJrtqnvwkJzc=,iv:TJibuh5y+93xrTeumv4LqV6MBq+JvraUs/klGzfvIHQ=,tag:FW9EtI7Vj5mknT3WEwxLdA==,type:str]"
		pgp: []
		encrypted_regex: "^(data|stringData)$"
		version:         "3.8.0"
	}
}
