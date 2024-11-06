package kube

helmRelease: prowlarr: spec: {
	_appTemplate: true
	values: {
		defaultPodOptions: securityContext: {
			runAsUser:           568
			runAsGroup:          568
			fsGroup:             568
			fsGroupChangePolicy: "OnRootMismatch"
		}
		controllers: main: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/prowlarr"
					tag:        "1.25.4.4818@sha256:c37fca7efa03fef40f0227103946713512cf4e609dd2d98202ce1320053219ed"
					pullPolicy: "IfNotPresent"
				}
				env: {
					TZ:                          "${TIMEZONE}"
					PROWLARR__INSTANCE_NAME:     "prowlarr"
					PROWLARR__PORT:              9696
					PROWLARR__APPLICATION_URL:   "https://prowlarr.${SECRET_DOMAIN}"
					PROWLARR__LOG_LEVEL:         "info"
					PROWLARR__ANALYTICS_ENABLED: "False"
				}
				resources: {
					requests: {
						cpu:    "20m"
						memory: "100Mi"
					}
					limits: memory: "250Mi"
				}
			}
		}
		service: app: {
			controller: "main"
			ports: http: port: 9696
		}
		ingress: app: {
			enabled:   true
			className: "internal"
			annotations: {
				"hajimari.io/enable": "true"
				"hajimari.io/icon":   "mdi:movie-search"
			}
			hosts: [{
				host: "prowlarr.${SECRET_DOMAIN}"
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
			enabled:       true
			existingClaim: "prowlarr-config"
		}
	}
}
