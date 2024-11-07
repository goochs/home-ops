package kube

helmRelease: actual: spec: {
	_appTemplate: true
	_longhorn:    true

	_appName: "helmRelease.[_]"
	_appPort: 5006

	values: {
		controllers: actual: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/actualbudget/actual-server"
					tag:        "24.11.0"
				}
				env: ACTUAL_PORT: (_appPort)
				resources: {
					requests: {
						cpu:    "100m"
						memory: "100Mi"
					}
					limits: memory: "500Mi"
				}
				probes: readiness: spec: httpGet: {
					path: "/"
					port: (_appPort)
				}
			}
		}
		DefaultPodOptions: securityContext: {
			runAsNonRoot:        true
			runAsUser:           568
			runAsGroup:          568
			fsGroup:             568
			fsGroupChangePolicy: "OnRootMismatch"
			seccompProfile: type: "RuntimeDefault"
		}
		service: app: ports: http: port: (_appPort)
		ingress: app: hosts: [{
			host: "{{ .Release.Name }}.${SECRET_DOMAIN}"
		}]
		persistence: config: {
			existingClaim: "actual-config"
			advancedMounts: actual: app: [{path: "/data"}]
		}
	}
}
