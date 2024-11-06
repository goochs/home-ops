package kube

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
	_name:      ID
	apiVersion: "helm.toolkit.fluxcd.io/v2"
	kind:       "HelmRelease"
	metadata: name: ID
	spec: {
		_appTemplate: *false | bool
		interval:     *"30m" | string
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
			}
		}
		if _appTemplate {
			chart: spec: {
				chart:   "app-template"
				version: "3.5.1"
				sourceRef: name: "bjw-s"
			}
		}
	}
}
