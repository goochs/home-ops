package kube

secret: "grafana-admin-secret": {
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:      "grafana-admin-secret"
		namespace: "monitoring"
	}
	stringData: {
		"admin-password": "ENC[AES256_GCM,data:1r0MjAG9rf1WRXQT,iv:7Na8MCnq6Pww8DUpvqHZnm3LD0NB2l02F++oYJKsAgY=,tag:hjOrSlQHmKm96u4kDmFZkw==,type:str]"
		"admin-user":     "ENC[AES256_GCM,data:KgOhrA==,iv:BIdKPXb1RJ8MlfeJhgiVWvJUZEHzGCVrhM5prBoI7yk=,tag:nnej+Giv14vN8T1ulxnHUg==,type:str]"
	}
	sops: {
		kms: []
		gcp_kms: []
		azure_kv: []
		hc_vault: []
		age: [{
			recipient: "age17yhdxmw884lyl8m022pfqlh5c8j4e5ljcr7k7qugy63xnptkmvysdm345w"
			enc: """
				-----BEGIN AGE ENCRYPTED FILE-----
				YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSAvSGZwcTVnRmdQZnJOYWhC
				aWF3ekVoL1dxQW1HOURGTmZBbENWR0tTOVRjClFucmpHbEptS0NpQ1FOZ3NoR082
				RVRDUTlsK0ZOQVhTcVp2Y1NwU2xoWHcKLS0tIHZyaldRSXNxZ3JZcFZxZDFPRmpT
				cGZUU1BzRkZLYjRNdkxIWW5CNFNSVVEKTphhL/u1fbmtLslLIe/8P0uWZ5a/+MjC
				Ocif3VMxZn/Z8Avbp6h9oKxf2H4RLKlYwcCHMvb5foJuajUflajJIA==
				-----END AGE ENCRYPTED FILE-----

				"""
		}]
		lastmodified: "2024-02-01T17:49:25Z"
		mac:          "ENC[AES256_GCM,data:mAtg2El0O5+9/HAoJATAuTcmnMwFd9k6VEfvtD6g/zejnyji7HPFHZwY8jWLPB+cWDTnRMJLopKqBiofZeipIyiceW0+zrtBaMLZJQjvNzlp6L9J5GGPxpfbXnl+FZzavwbYz7ZEt+pe6MjHszNBI39oiDfdc3oK7fgheGl4KDI=,iv:MzGUu4t6JGL+alPRvOdk8gJNq6MrjIMEYW2W85/ka9I=,tag:f0H8OTqMQ45h9Ms+J/UZ4g==,type:str]"
		pgp: []
		encrypted_regex: "^(data|stringData)$"
		version:         "3.8.1"
	}
}
