package kube

#helmRelease & {
	_config: {
		name: "echo-server"
		appTemplate: {
			probes:  true
			port:    8080
			ingress: "external"
		}
	}
	spec: values: {
		controllers: "echo-server": {
			strategy: "RollingUpdate"
			containers: app: {
				image: {
					repository: "ghcr.io/mendhak/http-https-echo"
					tag:        35
				}
				env: {
					HTTP_PORT:           _config.appTemplate.port
					LOG_WITHOUT_NEWLINE: true
					LOG_IGNORE_PATH:     "/healthz"
					PROMETHEUS_ENABLED:  true
				}
				probes: {
					liveness: spec: httpGet: path:  "/healthz"
					readiness: spec: httpGet: path: "/healthz"
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
	}
}
