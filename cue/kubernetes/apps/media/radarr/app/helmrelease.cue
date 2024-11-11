package kube

#helmRelease & {
	_config: {
		name:     "radarr"
		longhorn: true
		appTemplate: {
			port:    7878
			nfs:     true
			probes:  true
			ingress: "internal"
		}
	}
	spec: values: {
		controllers: radarr: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/radarr"
					tag:        "5.14.0@sha256:48e094d0eb3e78a88a2fe1f4b41f9eb2356d19bd01a3f95d701455097db8d5ff"
				}
				env: {
					RADARR__APP__THEME:   "dark"
					RADARR__LOG__LEVEL:   "info"
					RADARR__SERVER__PORT: _config.appTemplate.port
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
			config: existingClaim: "radarr-config"
			tmp: type:             "emptyDir"
		}
	}
}
