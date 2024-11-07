package kube

helmRelease: "echo-server": spec: {
	_appTemplate: true
	values: {
		controllers: "echo-server": {
			strategy: "RollingUpdate"
			containers: app: {
				image: {
					repository: "ghcr.io/mendhak/http-https-echo"
					tag:        35
				}
				env: {
					HTTP_PORT:           8080
					LOG_WITHOUT_NEWLINE: true
					LOG_IGNORE_PATH:     "/healthz"
					PROMETHEUS_ENABLED:  true
				}
				probes: {
					liveness: spec: httpGet: {
						path: "/healthz"
						port: 8080
					}
					readiness: spec: httpGet: {
						path: "/healthz"
						port: 8080
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
		service: app: ports: http: port: 8080
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
