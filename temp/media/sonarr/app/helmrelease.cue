package kube

helmRelease: sonarr: spec: {
	_appTemplate: true
	values: {
		controllers: main: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: main: {
				image: {
					repository: "ghcr.io/onedr0p/sonarr"
					tag:        "4.0.10@sha256:17b05e619b07854182bc47295efca2348fadde0a927de1797b55dc01dcd5f58c"
					pullPolicy: "IfNotPresent"
				}
				env: {
					TZ:                      "${TIMEZONE}"
					SONARR__INSTANCE_NAME:   "Sonarr"
					SONARR__PORT:            8989
					SONARR__APPLICATION_URL: "https://sonarr.${SECRET_DOMAIN}"
					SONARR__LOG_LEVEL:       "info"
					SONARR__THEME:           "dark"
				}
				resources: {
					requests: {
						cpu:    "20m"
						memory: "500Mi"
					}
					limits: memory: "1000Mi"
				}
			}
			pod: securityContext: {
				runAsUser:           568
				runAsGroup:          568
				fsGroup:             568
				fsGroupChangePolicy: "OnRootMismatch"
			}
		}
		service: main: ports: http: port: 8989
		ingress: main: {
			enabled:   true
			className: "internal"
			annotations: {
				"hajimari.io/enable": "true"
				"hajimari.io/icon":   "mdi:filmstrip"
			}
			hosts: [{
				host: "sonarr.${SECRET_DOMAIN}"
				paths: [{
					path: "/"
					service: {
						name: "main"
						port: "http"
					}
				}]
			}]
		}
		persistence: {
			config: {
				enabled:       true
				existingClaim: "sonarr-config"
			}
			hoard: {
				existingClaim: "hoard-nfs"
				globalMounts: [{path: "/hoard"}]
			}
		}
	}
}
