package kube

helmRelease: plex: spec: {
	_appTemplate: true
	values: {
		defaultPodOptions: {
			enableServiceLinks: false
			nodeSelector: "intel.feature.node.kubernetes.io/gpu": "true"
			securityContext: {
				runAsUser:           568
				runAsGroup:          568
				fsGroup:             568
				fsGroupChangePolicy: "OnRootMismatch"
				supplementalGroups: [
					44,
					109,
				]
			}
		}
		controllers: main: {
			type: "statefulset"
			statefulset: volumeClaimTemplates: [{
				name:         "config"
				accessMode:   "ReadWriteOnce"
				size:         "50Gi"
				storageClass: "longhorn"
				globalMounts: [{path: "/config"}]
			}]
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/plex"
					tag:        "1.41.1.9057-af5eaea7a@sha256:2793002837580e0004ba436ae8aa291573d4631d3571ac6d02960d7fbc7fa94d"
				}
				resources: {
					requests: {
						cpu:                  1
						memory:               "1Gi"
						"gpu.intel.com/i915": 1
					}
					limits: {
						cpu:                  4
						memory:               "10Gi"
						"gpu.intel.com/i915": 1
					}
				}
			}
		}
		service: app: {
			controller:            "main"
			type:                  "LoadBalancer"
			externalTrafficPolicy: "Cluster"
			annotations: "io.cilium/lb-ipam-ips": "10.20.30.45"
			ports: http: port: 32400
		}
		ingress: app: {
			enabled:   true
			className: "external"
			annotations: {
				"hajimari.io/enable": "true"
				"hajimari.io/icon":   "mdi:plex"
			}
			hosts: [{
				host: "plex.${SECRET_DOMAIN}"
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
			hoard: {
				existingClaim: "hoard-nfs"
				globalMounts: [{path: "/hoard"}]
			}
			transcode: {
				type: "emptyDir"
				globalMounts: [{path: "/transcode"}]
			}
		}
	}
}
