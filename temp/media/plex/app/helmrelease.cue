package kube

helmRelease: plex: spec: {
	_appTemplate: true
	_longhorn:    true
	_nfs:         true
	_probes:      true
	_appName:     "helmRelease.[_]"
	_appPort:     32400

	values: {
		defaultPodOptions: {
			nodeSelector: "intel.feature.node.kubernetes.io/gpu": "true"
			securityContext: supplementalGroups: [
				44,
				109,
			]
		}
		controllers: plex: {
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
					requests: cpu: "100m"
					limits: {
						memory:               "10Gi"
						"gpu.intel.com/i915": 1
					}
				}
				probes: {
					liveness: spec: httpGet: {
						path: "/identity"
						port: (_appPort)
					}
					readiness: spec: httpGet: {
						path: "/identity"
						port: (_appPort)
					}
					startup: {
						enabled: true
						spec: {
							failureThreshold: 30
							periodSeconds:    10
						}
					}
				}
			}
		}
		service: app: {
			type:                  "LoadBalancer"
			externalTrafficPolicy: "Cluster"
			annotations: "io.cilium/lb-ipam-ips": "10.20.30.45"
			ports: http: port: (_appPort)
		}
		ingress: app: className: "external"
		persistence: transcode: {
			type: "emptyDir"
			globalMounts: [{path: "/transcode"}]
		}
	}
}
