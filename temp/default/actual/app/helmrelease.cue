package kube

helmRelease: actual: spec: {
	_appTemplate: true
	dependsOn: [{
		name:      "longhorn"
		namespace: "longhorn-system"
	}]
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
				probes: {
					liveness: enabled: true
					readiness: {
						enabled: true
						custom:  true
						spec: {
							httpGet: {
								path: "/"
								port: 5006
							}
							initialDelaySeconds: 0
							periodSeconds:       10
							timeoutSeconds:      1
							failureThreshold:    3
						}
					}
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
		service: app: {
			controller: "actual"
			ports: http: port: 5006
		}
		ingress: app: {
			className: "internal"
			hosts: [{
				host: "{{ .Release.Name }}.${SECRET_DOMAIN}"
				paths: [{
					path: "/"
					service: {
						identifier: "app"
						port:       "http"
					}
				}]
			}]
		}
		persistence: config: {
			existingClaim: "actual-config"
			advancedMounts: actual: app: [{path: "/data"}]
		}
	}
}
