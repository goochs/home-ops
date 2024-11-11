package kube

#helmRelease & {
	_config: name: "argocd"
	spec: {
		chart: spec: {
			chart:   "argo-cd"
			version: "7.7.1"
			sourceRef: name: "argocd"
		}
		values: {
			"redis-ha": enabled:      true
			controller: replicas:     1
			server: replicas:         2
			repoServer: replicas:     2
			applicationSet: replicas: 2
			global: domain:           "argocd.goochs.us"

			configs: params: "server.insecure": true

			server: {
				ingress: {
					enabled:          true
					ingressClassName: "internal"
					annotations: {
						"nginx.ingress.kubernetes.io/force-ssl-redirect": "true"
						"nginx.ingress.kubernetes.io/backend-protocol":   "HTTP"
					}
				}
				ingressGrpc: {
					enabled:          true
					ingressClassName: "internal"
					annotations: "nginx.ingress.kubernetes.io/backend-protocol": "GRPC"
				}
			}
		}
	}
}
