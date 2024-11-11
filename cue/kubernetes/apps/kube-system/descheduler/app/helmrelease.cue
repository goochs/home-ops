package kube

#helmRelease & {
	_config: name: "descheduler"
	spec: {
		chart: spec: {
			chart:   "descheduler"
			version: "0.31.0"
			sourceRef: name: "descheduler"
		}
		values: {
			replicas:                    2
			kind:                        "Deployment"
			deschedulerPolicyAPIVersion: "descheduler/v1alpha2"
			deschedulingInterval:        "1m"
			deschedulerPolicy: profiles: [{
				name: "Default"
				pluginConfig: [{
					name: "DefaultEvictor"
					args: {
						evictFailedBarePods:     true
						evictLocalStoragePods:   true
						evictSystemCriticalPods: true
						nodeFit:                 true
					}
				}, {
					name: "RemovePodsViolatingInterPodAntiAffinity"
				}, {
					name: "RemovePodsViolatingNodeAffinity"
					args: nodeAffinityType: ["requiredDuringSchedulingIgnoredDuringExecution"]
				}, {
					name: "RemovePodsViolatingNodeTaints"
				}, {
					name: "RemovePodsViolatingTopologySpreadConstraint"
					args: constraints: [
						"DoNotSchedule",
						"ScheduleAnyway",
					]
				}]
				plugins: {
					balance: enabled: ["RemovePodsViolatingTopologySpreadConstraint"]
					deschedule: enabled: [
						"RemovePodsViolatingInterPodAntiAffinity",
						"RemovePodsViolatingNodeAffinity",
						"RemovePodsViolatingNodeTaints",
					]
				}
			}]
			service: enabled:        true
			serviceMonitor: enabled: true
			leaderElection: enabled: true
		}
	}
}
