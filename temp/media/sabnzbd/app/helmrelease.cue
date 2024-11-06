package kube

helmRelease: sabnzbd: spec: {
	_appTemplate: true
	values: {
		controllers: main: {
			type: "statefulset"
			statefulset: volumeClaimTemplates: [{
				name:         "config"
				accessMode:   "ReadWriteOnce"
				size:         "5Gi"
				storageClass: "longhorn"
				globalMounts: [{path: "/config"}]
			}]
			annotations: "reloader.stakater.com/auto": "true"
			containers: main: {
				image: {
					repository: "ghcr.io/onedr0p/sabnzbd"
					tag:        "4.3.3@sha256:86c645db93affcbf01cc2bce2560082bfde791009e1506dba68269b9c50bc341"
					pullPolicy: "IfNotPresent"
				}
				env: {
					TZ:                              "${TIMEZONE}"
					SABNZBD__PORT:                   8080
					SABNZBD__HOST_WHITELIST_ENTRIES: "sabnzbd, sabnzbd.media, sabnzbd.media.svc, sabnzbd.media.svc.cluster, sabnzbd.media.svc.cluster.local, sabnzbd.${SECRET_DOMAIN}"
				}
				resources: {
					requests: {
						cpu:    "50m"
						memory: "1000Mi"
					}
					limits: memory: "8000Mi"
				}
			}
			pod: securityContext: {
				runAsUser:           568
				runAsGroup:          568
				fsGroup:             568
				fsGroupChangePolicy: "OnRootMismatch"
			}
		}
		service: main: ports: http: port: 8080
		ingress: main: {
			enabled:   true
			className: "internal"
			annotations: {
				"hajimari.io/enable": "true"
				"hajimari.io/icon":   "mdi:download"
			}
			hosts: [{
				host: "sabnzbd.${SECRET_DOMAIN}"
				paths: [{
					path: "/"
					service: {
						name: "main"
						port: "http"
					}
				}]
			}]
		}
		persistence: hoard: {
			existingClaim: "hoard-nfs"
			globalMounts: [{path: "/hoard"}]
		}
	}
}
