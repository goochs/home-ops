package kube

import (
	corev1 "k8s.io/api/core/v1"
	helmv2 "github.com/fluxcd/helm-controller/api/v2"
	kustomizev1b2 "github.com/fluxcd/kustomize-controller/api/v1beta2"
)

// _spec: {
// 	_name:      string
// 	apiVersion: string
// 	kind:       string
// 	metadata: name: _name
// }

#kustomization: kustomizev1b2.#Kustomization & {
	_name:      string
	apiVersion: "kustomize.toolkit.fluxcd.io/v1beta2"
	kind:       "Kustomization"
	metadata: {
		namespace: "flux-system"
		name:      _name
	}
	spec: {
		// define alias for targetNamespace
		NS=targetNamespace: *"default" | string
		commonMetadata: labels: "app.kubernetes.io/name": _name

		// generate path for fluxtomization
		path:  *"./kubernetes/apps/\(NS)/\(_name)/app" | string
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

#helmRelease: helmv2.#HelmRelease & {
	// variables for templating later
	_config: {
		name!:    string
		longhorn: *false | bool
		appTemplate?: {
			port:   number
			nfs:    *false | bool
			probes: *false | bool
		}
	}

	apiVersion: "helm.toolkit.fluxcd.io/v2"
	kind:       "HelmRelease"
	metadata: name: _config.name
	spec: {
		// set defaults for the helm release, check types
		interval: *"30m" | string
		chart: spec: {
			chart:   string
			version: string
			sourceRef: {
				name:      string
				kind:      "HelmRepository"
				namespace: "flux-system"
			}
			if _config.appTemplate != _|_ {
				chart:   "app-template"
				version: "3.5.1"
				sourceRef: name: "bjw-s"
			}
		}
		install: remediation: retries: *3 | number
		upgrade: {
			cleanupOnFail: *true | bool
			remediation: {
				strategy: *"rollback" | string
				retries:  *3 | number
			}
		}
		if _config.longhorn {
			dependsOn: [{
				name:      "longhorn"
				namespace: "longhorn-system"
			}]
		}

		// set app template specific values
		if _config.appTemplate != _|_ {
			values: {
				defaultPodOptions: {
					securityContext: {
						runAsNonRoot:        *true | bool
						runAsUser:           *568 | number
						runAsGroup:          *568 | number
						fsGroup:             *568 | number
						fsGroupChangePolicy: "OnRootMismatch"
						seccompProfile: type: "RuntimeDefault"
						...
					}
					...
				}
				controllers: (_config.name): {
					containers: app: {
						env: {
							TZ: "${TIMEZONE}"
							...
						}
						securityContext: {
							allowPrivilegeEscalation: *false | bool
							readOnlyRootFilesystem:   *true | bool
							capabilities: drop: ["ALL"]
						}
						if _config.appTemplate.probes {
							for type in ["liveness", "readiness"] {
								probes: "\(type)": {
									enabled: *true | bool
									custom:  *true | bool
									spec: {
										httpGet: {
											path: string
											port: *_config.appTemplate.port | number
										}
										initialDelaySeconds: 0
										periodSeconds:       10
										timeoutSeconds:      1
										failureThreshold:    3
									}
									...
								}
								...
							}
							...
						}
						...
					}
					...
				}

				service: app: {
					controller: _config.name
					ports: http: port: _config.appTemplate.port
					...
				}
				ingress: app: {
					className: *"internal" | "external"
					hosts: {
						host: *"\(_config.name).${SECRET_DOMAIN}" | string
						paths: {
							path: *"/" | string
							service: {
								identifier: *"app" | string
								port:       *"http" | string
							}
						}
					}
				}
				if _config.appTemplate.nfs {
					persistence: {
						hoard: {
							type:   "nfs"
							server: "${STORAGE_ADDR}"
							path:   "/mnt/storage/hoard"
							globalMounts: [{path: "/hoard"}]
						}
						...
					}
					...
				}
				...
			}
			...
		}
		...
	}
	...
}

#namespace: corev1.#Namespace & {
	_name:      string
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name: _name
		labels: "kustomize.toolkit.fluxcd.io/prune": *"disabled" | "enabled"
	}
}
