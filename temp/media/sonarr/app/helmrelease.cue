package kube

helmRelease: sonarr: spec: {
	_appTemplate: true
	_longhorn:    true
	_nfs:         true
	values: {
		controllers: sonarr: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/sonarr"
					tag:        "4.0.10@sha256:17b05e619b07854182bc47295efca2348fadde0a927de1797b55dc01dcd5f58c"
				}
				env: {
					SONARR__APP__INSTANCENAME: "Sonarr"
					SONARR__APP__THEME:        "dark"
					SONARR__LOG__LEVEL:        "info"
					SONARR__SERVER__PORT:      8989
				}
				resources: {
					requests: cpu:  "100m"
					limits: memory: "4Gi"
				}
				probes: {
					liveness: spec: httpGet: {
						path: "/ping"
						port: 8989
					}
					readiness: spec: httpGet: {
						path: "/ping"
						port: 8989
					}
				}
			}
		}
		service: app: ports: http: port: 8989
		persistence: {
			config: existingClaim: "sonarr-config"
			tmp: type:             "emptyDir"
		}
	}
}
