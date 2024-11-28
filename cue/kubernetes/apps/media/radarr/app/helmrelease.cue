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
					tag:        "5.15.1@sha256:6f511f96f4e0c683e2f0b7e1c1a1669f63c757989cac33eed0bb5c69112cd61b"
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
