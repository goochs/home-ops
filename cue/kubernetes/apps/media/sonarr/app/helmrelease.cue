package kube

#helmRelease & {
	_config: {
		name:     "sonarr"
		longhorn: true
		appTemplate: {
			nfs:     true
			probes:  true
			port:    8989
			ingress: "internal"
		}
	}
	spec: values: {
		controllers: sonarr: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/sonarr"
					tag:        "4.0.11@sha256:f2545b368ca83e1c7e52ef1a923ed3cac4f7b4bb64a40f07bc28d2d80f159898"
				}
				env: {
					SONARR__APP__INSTANCENAME: "Sonarr"
					SONARR__APP__THEME:        "dark"
					SONARR__LOG__LEVEL:        "info"
					SONARR__SERVER__PORT:      _config.appTemplate.port
				}
				resources: {
					requests: cpu:  "100m"
					limits: memory: "4Gi"
				}
				probes: {
					liveness: spec: httpGet: path:  "/ping"
					readiness: spec: httpGet: path: "/ping"
				}
			}
		}
		persistence: {
			config: existingClaim: "sonarr-config"
			tmp: type:             "emptyDir"
		}
	}
}
