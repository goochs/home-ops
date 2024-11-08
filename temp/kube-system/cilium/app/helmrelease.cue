package kube

#helmRelease & {
	_config: name: "cilium"
	spec: {
		chart: spec: {
			chart:   "cilium"
			version: "1.16.3"
			sourceRef: name: "cilium"
		}
		values: {
			autoDirectNodeRoutes: true
			bgpControlPlane: enabled: true
			bpf: masquerade:          false
			cgroup: {
				automount: enabled: false
				hostRoot: "/sys/fs/cgroup"
			}
			cluster: {
				id:   1
				name: "homeprod"
			}
			cni: exclusive: false
			// NOTE: devices might need to be set if you have more than one active NIC on your hosts
			// devices: eno+ eth+
			endpointRoutes: {
				enabled: true
			}
			hubble: {
				enabled: true
				metrics: {
					enabled: [
						"dns:query",
						"drop",
						"tcp",
						"flow",
						"port-distribution",
						"icmp",
						"http",
					]
					serviceMonitor: enabled: true
					dashboards: {
						enabled: true
						annotations: grafana_folder: "Cilium"
					}
				}
				relay: {
					enabled:     true
					rollOutPods: true
					prometheus: serviceMonitor: enabled: true
				}
				ui: {
					enabled:     true
					rollOutPods: true
					ingress: {
						enabled:   true
						className: "internal"
						hosts: ["hubble.${SECRET_DOMAIN}"]
					}
				}
			}
			ipam: mode: "kubernetes"
			ipv4NativeRoutingCIDR:               "${CLUSTER_CIDR}"
			k8sServiceHost:                      "127.0.0.1"
			k8sServicePort:                      7445
			kubeProxyReplacement:                true
			kubeProxyReplacementHealthzBindAddr: "0.0.0.0:10256"
			l2announcements: enabled: false // https://github.com/cilium/cilium/issues/28985
			loadBalancer: {
				algorithm: "maglev"
				mode:      "snat"
			}
			localRedirectPolicy: true
			operator: {
				replicas:    1
				rollOutPods: true
				prometheus: {
					enabled: true
					serviceMonitor: enabled: true
				}
				dashboards: {
					enabled: true
					annotations: grafana_folder: "Cilium"
				}
			}
			prometheus: {
				enabled: true
				serviceMonitor: {
					enabled:        true
					trustCRDsExist: true
				}
			}
			dashboards: {
				enabled: true
				annotations: grafana_folder: "Cilium"
			}
			rollOutCiliumPods: true
			routingMode:       "native"
			securityContext: capabilities: {
				ciliumAgent: [
					"CHOWN",
					"KILL",
					"NET_ADMIN",
					"NET_RAW",
					"IPC_LOCK",
					"SYS_ADMIN",
					"SYS_RESOURCE",
					"DAC_OVERRIDE",
					"FOWNER",
					"SETGID",
					"SETUID",
				]
				cleanCiliumState: [
					"NET_ADMIN",
					"SYS_ADMIN",
					"SYS_RESOURCE",
				]
			}
		}
	}
}
