package kube

import (
	corev1 "k8s.io/api/core/v1"
	helmv2 "github.com/fluxcd/helm-controller/api/v2"
	kustomizev1b2 "github.com/fluxcd/kustomize-controller/api/v1beta2"
)

_spec: {
	_name:      string
	apiVersion: string
	kind:       string
	metadata: name: _name
}

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
	_name: string
	// variables for templating later
	_appTemplate: *false | bool
	_longhorn:    *false | bool
	_nfs:         *false | bool

	apiVersion: "helm.toolkit.fluxcd.io/v2"
	kind:       "HelmRelease"
	metadata: name: _name
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
			if _appTemplate {
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
			}}

		// set app template specific values
		if _appTemplate {
			// required values
			_appName!: string
			_appPort!: number
			_probes:   *false | bool

			values: {
				defaultPodOptions: securityContext: {
					runAsNonRoot:        *true | bool
					runAsUser:           *568 | number
					runAsGroup:          *568 | number
					fsGroup:             *568 | number
					fsGroupChangePolicy: "OnRootMismatch"
					seccompProfile: type: "RuntimeDefault"
				}
				controllers: (_name): {
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
						...
					}
					...
				}

				service: app: {
					controller: _name
					ports: http: port: _appPort
				}
				ingress: app: {
					className: *"internal" | "external"
					hosts: [...{
						host: *"\(_name).${SECRET_DOMAIN}" | string
						paths: [...{
							path: *"/" | string
							service: {
								identifier: *"app" | string
								port:       *"http" | string
							}
						}]
					}]
				}
				...
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
#namespace: corev1.#Namespace & {
	_name:      string
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name: _name
		labels: "kustomize.toolkit.fluxcd.io/prune": *"disabled" | "enabled"
	}
}
