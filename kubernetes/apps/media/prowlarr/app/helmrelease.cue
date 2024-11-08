package kube

#helmRelease & {
	_config: {
		name: "prowlarr"
		appTemplate: port: 9696
	}
	spec: values: {
		controllers: prowlarr: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/prowlarr"
					tag:        "1.25.4.4818@sha256:c37fca7efa03fef40f0227103946713512cf4e609dd2d98202ce1320053219ed"
					pullPolicy: "IfNotPresent"
				}
				env: {
					PROWLARR__INSTANCE__NAME:    "prowlarr"
					PROWLARR__PORT:              (_config.appTemplate.port)
					PROWLARR__APPLICATION_URL:   "https://prowlarr.${SECRET_DOMAIN}"
					PROWLARR__LOG_LEVEL:         "info"
					PROWLARR__ANALYTICS_ENABLED: "False"
				}
				resources: {
					requests: {
						cpu:    "20m"
						memory: "100Mi"
					}
					limits: memory: "250Mi"
				}
			}
		}
		persistence: config: existingClaim: "prowlarr-config"
	}
}
