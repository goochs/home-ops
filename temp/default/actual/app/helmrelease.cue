package kube

helmRelease: actual: spec: {
	_appTemplate: true
	_longhorn:    true
	values: {
		controllers: actual: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/actualbudget/actual-server"
					tag:        "24.11.0"
				}
				env: ACTUAL_PORT: 5006
				resources: {
					requests: {
						cpu:    "100m"
						memory: "100Mi"
					}
					limits: memory: "500Mi"
				}
				probes: readiness: spec: httpGet: {
					path: "/"
					port: 5006
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
		service: app: ports: http: port: 5006
		ingress: app: hosts: [{
			host: "{{ .Release.Name }}.${SECRET_DOMAIN}"
		}]
		persistence: config: {
			existingClaim: "actual-config"
			advancedMounts: actual: app: [{path: "/data"}]
		}
	}
}
