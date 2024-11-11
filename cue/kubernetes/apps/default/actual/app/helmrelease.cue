package kube

#helmRelease & {
	_config: {
		name:     "actual"
		longhorn: true
		appTemplate: {
			port:    5006
			ingress: "internal"
		}
	}
	spec: values: {
		controllers: actual: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/actualbudget/actual-server"
					tag:        "24.11.0"
				}
				env: ACTUAL_PORT: _config.appTemplate.port
				resources: {
					requests: {
						cpu:    "100m"
						memory: "100Mi"
					}
					limits: memory: "500Mi"
				}
				probes: readiness: spec: httpGet: {
					path: "/"
					port: _config.appTemplate.port
				}
			}
		}
		persistence: config: {
			existingClaim: "actual-config"
			advancedMounts: actual: app: [{path: "/data"}]
		}
	}
}
