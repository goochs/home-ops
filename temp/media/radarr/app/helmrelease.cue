package kube

helmRelease: radarr: spec: {
	_appTemplate: true
	dependsOn: [{
		name:      "longhorn"
		namespace: "longhorn-system"
	}]
	values: {
		controllers: radarr: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/radarr"
					tag:        "5.14.0@sha256:48e094d0eb3e78a88a2fe1f4b41f9eb2356d19bd01a3f95d701455097db8d5ff"
				}
				env: {
					TZ:                        "${TIMEZONE}"
					RADARR__APP__INSTANCENAME: "Radarr"
					RADARR__APP__THEME:        "dark"
					RADARR__LOG__LEVEL:        "info"
					RADARR__SERVER__PORT:      7878
				}
				resources: {
					requests: cpu:  "100m"
					limits: memory: "4Gi"
				}
				securityContext: {
					allowPrivilegeEscalation: false
					readOnlyRootFilesystem:   true
					capabilities: drop: ["ALL"]
				}
				probes: {
					liveness: {
						enabled: true
						custom:  true
						spec: {
							httpGet: {
								path: "/ping"
								port: 7878
							}
							initialDelaySeconds: 0
							periodSeconds:       10
							timeoutSeconds:      1
							failureThreshold:    3
						}
					}
					readiness: {
						enabled: true
						custom:  true
						spec: {
							httpGet: {
								path: "/ping"
								port: 7878
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
		defaultPodOptions: securityContext: {
			runAsNonRoot:        true
			runAsUser:           568
			runAsGroup:          568
			fsGroup:             568
			fsGroupChangePolicy: "OnRootMismatch"
			seccompProfile: type: "RuntimeDefault"
		}
		service: app: {
			controller: "radarr"
			ports: http: port: 7878
		}
		ingress: app: {
			className: "internal"
			hosts: [{
				host: "radarr.${SECRET_DOMAIN}"
				paths: [{
					path: "/"
					service: {
						identifier: "app"
						port:       "http"
					}
				}]
			}]
		}
		persistence: {
			config: existingClaim: "radarr-config"
			tmp: type:             "emptyDir"
			hoard: {
				type:   "nfs"
				server: "${STORAGE_ADDR}"
				path:   "/mnt/storage/hoard"
				globalMounts: [{path: "/hoard"}]
			}
		}
	}
}
