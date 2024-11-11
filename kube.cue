package kube

import (
	rbacv1 "k8s.io/api/rbac/v1"
	corev1 "k8s.io/api/core/v1"
	helmv2 "github.com/fluxcd/helm-controller/api/v2"
	kustomizev1 "github.com/fluxcd/kustomize-controller/api/v1"
)

#kustomization: kustomizev1.#Kustomization & {
	_config: name!: string
	apiVersion: "kustomize.toolkit.fluxcd.io/v1"
	kind:       "Kustomization"
	metadata: {
		namespace: "flux-system"
		name:      _config.name
	}
	spec: {
		targetNamespace: *"default" | string
		commonMetadata: labels: "app.kubernetes.io/name": _config.name
		path:  *"./kubernetes/apps/\(spec.targetNamespace)/\(_config.name)/app" | string
		prune: *true | bool
		sourceRef: {
			kind: *"GitRepository" | string
			name: *"home-kubernetes" | string
		}
		wait:          *false | bool
		interval:      *"30m" | string
		retryInterval: *"1m" | string
		timeout:       *"5m" | string
		...
	}
}

#helmRelease: helmv2.#HelmRelease & {
	// variables for templating later
	_config: {
		name!:    string
		longhorn: *false | bool
		appTemplate?: {
			port:    int
			runAs:   *568 | int
			nfs:     *false | bool
			probes:  *false | bool
			ingress: string
			...
		}
		...
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
		install: remediation: retries: *3 | int
		upgrade: {
			cleanupOnFail: *true | bool
			remediation: {
				strategy: *"rollback" | string
				retries:  *3 | int
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
						runAsUser:           *_config.appTemplate.runAs | int
						runAsGroup:          *_config.appTemplate.runAs | int
						fsGroup:             *_config.appTemplate.runAs | int
						fsGroupChangePolicy: "OnRootMismatch"
						seccompProfile: type: "RuntimeDefault"
						...
					}
					...
				}

				controllers: (_config.name): {
					containers: {
						for instance, v in containers {
							"\(instance)": {
								env: {
									TZ: "America/New_York"
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
													port: *_config.appTemplate.port | int
												}
												initialDelaySeconds: *0 | int
												periodSeconds:       *10 | int
												timeoutSeconds:      *1 | int
												failureThreshold:    *3 | int
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
					...
				}
				service: app: {
					controller: _config.name
					ports: http: port: _config.appTemplate.port
					...
				}
				if _config.appTemplate.ingress != _|_ {
					ingress: app: {
						className: _config.appTemplate.ingress
						hosts: [{
							host: *"\(_config.name).goochs.us" | string
							paths: [{
								path: *"/" | string
								service: {
									identifier: *"app" | string
									port:       *"http" | string
								}
							}, ...]
						}, ...]
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
	_config: name!: string
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name: _config.name
		labels: "kustomize.toolkit.fluxcd.io/prune": *"disabled" | "enabled"
	}
}

#persistentVolumeClaim: corev1.#PersistentVolumeClaim & {
	_config: name!: string
	apiVersion: "v1"
	kind:       "PersistentVolumeClaim"
	metadata: name: _config.name
	spec: {
		accessModes: ["ReadWriteOnce"]
		resources: {
			requests: storage: *"5Gi" | string
			...
		}
		storageClassName: *"longhorn" | string
		...
	}
	...
}

#clusterRoleBinding: rbacv1.#ClusterRoleBinding & {...}
#clusterRole: rbacv1.#ClusterRole & {...}
#clusterIssuer: {...}
#secret: {...}
#untemplated: {...}
