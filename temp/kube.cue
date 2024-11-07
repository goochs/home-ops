package kube)

_spec: {
	_name: string

	apiVersion: string
	kind:       string
	metadata: name: _name
}

kustomization: [ID=_]: _spec & {
	_name:      ID
	apiVersion: "kustomize.toolkit.fluxcd.io/v1"
	kind:       "Kustomization"
	metadata: {
		name:      ID
		namespace: "flux-system"
	}
	spec: {
		// define alias for targetNamespace
		NS=targetNamespace: string
		commonMetadata: labels: "app.kubernetes.io/name": ID

		// generate path for fluxtomization
		path:  *"./kubernetes/apps/\(NS)/\(ID)/app" | string
		prune: *true | bool
		sourceRef: {
			kind: *"GitRepository" | string
			name: *"home-kubernetes" | string
		}
		wait:          *false | bool
		interval:      *"30m" | string
		retryInterval: *"1m" | string
		timeout:       *"5m" | string
	}
}

namespace: [ID=_]: _spec & {
	_name:      ID
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name: ID
		labels: "kustomize.toolkit.fluxcd.io/prune": "disabled"
	}
}

helmRelease: [ID=_]: _spec & {
	_name: ID

	apiVersion: "helm.toolkit.fluxcd.io/v2"
	kind:       "HelmRelease"
	metadata: name: ID
	spec: {
		// set variables for templating later
		_appTemplate: *false | bool
		_longhorn:    *false | bool
		_nfs:         *false | bool

		// set defaults for the helm release, check types
		interval: *"30m" | string
		chart: spec: {
			chart:   string
			version: string
			sourceRef: {
				name:      string
				kind:      "HelmRepository"
				namespace: *"flux-system" | string
			}}
		install: remediation: retries: *3 | number
		upgrade: {
			cleanupOnFail: *true | bool
			remediation: {
				strategy: *"rollback" | string
				retries:  *3 | number
			}}

		// set app template specific values
		if _appTemplate {
			// required values
			_appName!: string
			_appPort!: number
			_probes:   *false | bool

			// assumed defaults for app template
			chart: spec: {
				chart:   "app-template"
				version: "3.5.1"
				sourceRef: name: "bjw-s"
			}
			values: {
				defaultPodOptions: securityContext: {
					runAsNonRoot:        *true | bool
					runAsUser:           *568 | number
					runAsGroup:          *568 | number
					fsGroup:             *568 | number
					fsGroupChangePolicy: "OnRootMismatch"
					seccompProfile: type: "RuntimeDefault"
				}
				controllers: (ID): containers: app: {
					env: TZ: "${TIMEZONE}"
					securityContext: {
						allowPrivilegeEscalation: *false | bool
						readOnlyRootFilesystem:   *true | bool
						capabilities: drop: ["ALL"]
					}
					if _probes {
						for type in ["liveness", "readiness"] {
							probes: "\(type)": {
								enabled: *true | bool
								custom:  *true | bool
								spec: {
									httpGet: {
										path: string
										port: *_appPort | number
									}
									initialDelaySeconds: 0
									periodSeconds:       10
									timeoutSeconds:      1
									failureThreshold:    3
								}
							}
						}
					}
				}
				service: app: {
					controller: ID
					ports: http: port: number
				}
				ingress: app: {
					className: *"internal" | "external"
					hosts: [...{
						host: *"\(ID).${SECRET_DOMAIN}" | string
						paths: [...{
							path: *"/" | string
							service: {
								identifier: *"app" | string
								port:       *"http" | string
							}
						}]
					}]
				}

			}
			if _longhorn {
				dependsOn: [{
					name:      "longhorn"
					namespace: "longhorn-system"
				}]
			}
			if _nfs {
				values: persistence: hoard: {
					type:   "nfs"
					server: "${STORAGE_ADDR}"
					path:   "/mnt/storage/hoard"
					globalMounts: [{path: "/hoard"}]
				}
			}
		}
	}
}
