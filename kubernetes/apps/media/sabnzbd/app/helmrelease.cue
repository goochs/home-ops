package kube

#helmRelease & {
	_config: {
		name:     "sabnzbd"
		longhorn: true
		appTemplate: {
			nfs:    true
			probes: true
			port:   8080
		}
	}

	spec: values: {
		controllers: sabnzbd: {
			annotations: "reloader.stakater.com/auto": "true"
			containers: app: {
				image: {
					repository: "ghcr.io/onedr0p/sabnzbd"
					tag:        "4.3.3@sha256:86c645db93affcbf01cc2bce2560082bfde791009e1506dba68269b9c50bc341"
				}
				env: {
					SABNZBD__PORT:                   _config.appTemplate.port
					SABNZBD__HOST_WHITELIST_ENTRIES: "sabnzbd, sabnzbd.media, sabnzbd.media.svc, sabnzbd.media.svc.cluster, sabnzbd.media.svc.cluster.local, sabnzbd.goochs.us"
				}
				resources: {
					requests: cpu:  "50m"
					limits: memory: "8Gi"
				}
				probes: {
					liveness: spec: httpGet: path:  "/api?mode=version"
					readiness: spec: httpGet: path: "/api?mode=version"
				}
			}
		}
		persistence: {
			config: existingClaim: "sabnzbd-config"
			tmp: type:             "emptyDir"
		}
	}
}
