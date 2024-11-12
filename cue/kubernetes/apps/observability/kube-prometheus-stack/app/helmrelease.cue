package kube

#helmRelease & {
	_config: name: "kube-prometheus-stack"
	spec: {
		timeout: "15m"
		chart: spec: {
			chart:   "kube-prometheus-stack"
			version: "66.0.0"
			sourceRef: name: "prometheus-community"
		}
		install: crds: "Skip"
		upgrade: crds: "Skip"
		dependsOn: [{
			name:      "prometheus-operator-crds"
			namespace: "observability"
		}, {
			name:      "longhorn"
			namespace: "longhorn-system"
		}]
		values: {
			crds: enabled: false
			cleanPrometheusOperatorObjectNames: true
			alertmanager: {
				ingress: {
					enabled:          true
					ingressClassName: "internal"
					pathType:         "Prefix"
					hosts: ["alertmanager.goochs.us"]
				}
				alertmanagerSpec: storage: volumeClaimTemplate: spec: {
					storageClassName: "longhorn"
					resources: requests: storage: "5Gi"
				}
			}
			"kube-state-metrics": {
				fullnameOverride: "kube-state-metrics"
				metricLabelsAllowlist: [
					"deployments=[*]",
					"persistentvolumeclaims=[*]",
					"pods=[*]",
				]
				prometheus: monitor: {
					enabled: true
					relabelings: [{
						action: "replace"
						sourceLabels: ["__meta_kubernetes_pod_node_name"]
						regex:       "(.*)"
						replacement: "$1"
						targetLabel: "kubernetes_node"
					}]
				}
			}
			kubeApiServer: serviceMonitor: selector: "k8s-app":  "kube-apiserver"
			kubeControllerManager: service: selector: "k8s-app": "kube-controller-manager"
			kubeEtcd: kubeControllerManager
			kubeScheduler: service: selector: "k8s-app": "kube-scheduler"
			kubeProxy: enabled: false // Disabled due to eBPF
			prometheus: {
				ingress: {
					enabled:          true
					ingressClassName: "internal"
					pathType:         "Prefix"
					hosts: ["prometheus.goochs.us"]
				}
				prometheusSpec: {
					scrapeInterval:                          "1m"
					ruleSelectorNilUsesHelmValues:           false
					serviceMonitorSelectorNilUsesHelmValues: false
					podMonitorSelectorNilUsesHelmValues:     false
					probeSelectorNilUsesHelmValues:          false
					scrapeConfigSelectorNilUsesHelmValues:   false
					enableAdminAPI:                          true
					walCompression:                          true
					enableFeatures: ["auto-gomemlimit", "memory-snapshot-on-shutdown", "new-service-discovery-manager"]
					retention:     "14d"
					retentionSize: "50GB"
					storageSpec: volumeClaimTemplate: spec: {
						storageClassName: "longhorn"
						resources: requests: storage: "60Gi"
					}
				}
			}
			grafana: {
				enabled:               false
				forceDeployDashboards: true
			}
			"prometheus-node-exporter": {
				fullnameOverride: "node-exporter"
				prometheus: monitor: {
					enabled: true
					relabelings: [{
						action: "replace"
						sourceLabels: ["__meta_kubernetes_pod_node_name"]
						regex:       "(.*)"
						replacement: "$1"
						targetLabel: "kubernetes_node"
					}]
				}

			}
			additionalPrometheusRulesMap: {
				"dockerhub-rules": groups: [{
					name: "dockerhub"
					rules: [{
						alert: "DockerHubRateLimitRisk"
						expr:  "count(time() - container_last_seen{image=~\"(docker.io).*\",container!=\"\"} < 30) > 100"
						labels: severity:     "critical"
						annotations: summary: "Kubernetes cluster Dockerhub rate limit risk"
					}]
				}]
				"oom-rules": groups: [{
					name: "oom"
					rules: [{
						alert: "OomKilled"
						expr:  "(kube_pod_container_status_restarts_total - kube_pod_container_status_restarts_total offset 10m >= 1) and ignoring (reason) min_over_time(kube_pod_container_status_last_terminated_reason{reason=\"OOMKilled\"}[10m]) == 1"
						labels: severity:     "critical"
						annotations: summary: "Container {{ $labels.container }} in pod {{ $labels.namespace }}/{{ $labels.pod }} has been OOMKilled {{ $value }} times in the last 10 minutes."
					}]
				}]
			}
		}
	}
}
