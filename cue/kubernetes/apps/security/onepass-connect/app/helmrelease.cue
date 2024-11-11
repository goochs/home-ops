package kube

#helmRelease & {
	_config: {
		name: "onepass-connect"
		appTemplate: {
			port:      8080
			syncPort:  8081
			probes:    true
			runAs:     999
			configDir: "/config"
		}
	}
	spec: values: {
		persistence: config: {
			type: "emptyDir"
			globalMounts: [{path: _config.appTemplate.configDir}]
		}

		controllers: "onepass-connect": {
			strategy: "RollingUpdate"
			annotations: "reloader.stakater.com/auto": "true"
			containers: {
				api: {
					image: {
						repository: "docker.io/1password/connect-api"
						tag:        "1.7.3"
					}
					env: {
						XDG_DATA_HOME: _config.appTemplate.configDir
						OP_HTTP_PORT:  *_config.appTemplate.port | int
						OP_BUS_PORT:   *11220 | int
						OP_BUS_PEERS:  *"localhost:11221" | string
						OP_SESSION: valueFrom: secretKeyRef: {
							name: "onepass-connect-secret"
							key:  "1password-credentials.json"
						}
					}
					probes: liveness: spec: {
						httpGet: path: "/heartbeat"
						initialDelaySeconds: 15
						periodSeconds:       30
					}
					probes: readiness: spec: {
						httpGet: path: "/health"
						initialDelaySeconds: 15
					}
					resources: {
						requests: cpu:  "10m"
						limits: memory: "250Mi"
					}
				}
				sync: api & {
					env: {
						OP_HTTP_PORT: _config.appTemplate.syncPort
						OP_BUS_PORT:  11221
						OP_BUS_PEERS: "localhost:11220"
					}
					probes: liveness: spec: httpGet: port:  _config.appTemplate.syncPort
					probes: readiness: spec: httpGet: port: _config.appTemplate.syncPort
				}
			}
		}
	}
}
