package kube

helmRelease: "echo-server": spec: {
	_appTemplate: true
	_probes:      true
	_appName:     "helmRelease.[_]"
	_appPort:     8080
	values: {
		controllers: "echo-server": {
			strategy: "RollingUpdate"
			containers: app: {
				image: {
					repository: "ghcr.io/mendhak/http-https-echo"
					tag:        35
				}
				env: {
					HTTP_PORT:           (_appPort)
					LOG_WITHOUT_NEWLINE: true
					LOG_IGNORE_PATH:     "/healthz"
					PROMETHEUS_ENABLED:  true
				}
				probes: {
					liveness: spec: httpGet: {
						path: "/healthz"
						port: (_appPort)
					}
					readiness: spec: httpGet: {
						path: "/healthz"
						port: (_appPort)
					}
				}
				resources: {
					requests: cpu:  "10m"
					limits: memory: "64Mi"
				}
			}
		}
		defaultPodOptions: securityContext: {
			runAsUser:  65534
			runAsGroup: 65534
		}
		service: app: ports: http: port: (_appPort)
		serviceMonitor: app: {
			serviceName: "echo-server"
			endpoints: [{
				port:          "http"
				scheme:        "http"
				path:          "/metrics"
				interval:      "1m"
				scrapeTimeout: "10s"
			}]
		}
		ingress: app: {
			className: "external"
			hosts: [{
				host: "{{ .Release.Name }}.${SECRET_DOMAIN}"
			}]
		}
	}
}
