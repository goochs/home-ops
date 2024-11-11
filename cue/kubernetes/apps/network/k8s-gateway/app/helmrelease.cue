package kube

#helmRelease & {
	_config: name: "k8s-gateway"
	spec: {
		chart: spec: {
			chart:   "k8s-gateway"
			version: "2.4.0"
			sourceRef: name: "k8s-gateway"
		}
		values: {
			fullnameOverride: "k8s-gateway"
			domain:           "goochs.us"
			ttl:              1
			service: {
				type: "LoadBalancer"
				port: 53
				annotations: "io.cilium/lb-ipam-ips": "10.20.30.40"
				externalTrafficPolicy: "Cluster"
			}
			watchedResources: ["Ingress", "Service"]
		}
	}
}
