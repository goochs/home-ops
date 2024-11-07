package kube

helmRelease: sonarr: spec: {
	_appTemplate: true
	dependsOn: [{
		name:      "longhorn"
		namespace: "longhorn-system"
	}]
	values: {
		controllers: sonarr: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/sonarr"
					tag:        "4.0.10@sha256:17b05e619b07854182bc47295efca2348fadde0a927de1797b55dc01dcd5f58c"
				}
				env: {
					TZ:                        "${TIMEZONE}"
					SONARR__APP__INSTANCENAME: "Sonarr"
					SONARR__APP__THEME:        "dark"
					SONARR__LOG__LEVEL:        "info"
					SONARR__SERVER__PORT:      8989
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
								port: 8989
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
								port: 8989
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
			controller: "sonarr"
			ports: http: port: 8989
		}
		ingress: app: {
			className: "internal"
			hosts: [{
				host: "sonarr.${SECRET_DOMAIN}"
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
			config: existingClaim: "sonarr-config"
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
