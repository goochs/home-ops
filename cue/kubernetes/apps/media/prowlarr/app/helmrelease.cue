package kube

#helmRelease & {
	_config: {
		name: "prowlarr"
		appTemplate: {
			port:    9696
			ingress: "internal"
		}
	}
	spec: {
		upgrade: remediation: strategy: "uninstall"

		values: {
			controllers: prowlarr: {
				annotations: "reloader.stakater.com/auto": "true"
				containers: app: {
					image: {
						repository: "ghcr.io/onedr0p/prowlarr"
						tag:        "1.27.0.4852@sha256:b3d18fd3350cf8d8058389b1bff91ee96606cce8bf2b74aba7701d8b7236a479"
						pullPolicy: "IfNotPresent"
					}
					env: {
						PROWLARR__INSTANCE__NAME:    "prowlarr"
						PROWLARR__PORT:              (_config.appTemplate.port)
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
			persistence: {
				config: existingClaim: "prowlarr-config"
				tmp: type:             "emptyDir"
			}
		}
	}
}
