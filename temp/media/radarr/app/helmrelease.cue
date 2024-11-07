package kube

_appName: "radarr"
_appPort: 7878

helmRelease: (_appName): spec: {
	_appTemplate: true
	_longhorn:    true
	_nfs:         true
	_probes:      true
	values: {
		controllers: radarr: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/\(_appName)"
					tag:        "5.14.0@sha256:48e094d0eb3e78a88a2fe1f4b41f9eb2356d19bd01a3f95d701455097db8d5ff"
				}
				env: {
					RADARR__APP__THEME:   "dark"
					RADARR__LOG__LEVEL:   "info"
					RADARR__SERVER__PORT: _appPort
				}
				resources: {
					requests: cpu:  "100m"
					limits: memory: "4Gi"
				}
				probes: {
					liveness: spec: httpGet: {
						path: "/ping"
						port: _appPort
					}
					readiness: spec: httpGet: {
						path: "/ping"
						port: _appPort
					}
				}
			}
		}
		service: app: ports: http: port: 7878
		persistence: {
			config: existingClaim: "radarr-config"
			tmp: type:             "emptyDir"
		}
	}
}
