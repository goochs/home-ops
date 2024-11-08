package kube

#untemplated & {
	apiVersion: "cilium.io/v2alpha1"
	kind:       "CiliumLoadBalancerIPPool"
	metadata: name: "l3-pool"
	spec: {
		allowFirstLastIPs: "Yes"
		blocks: [{cidr: "${BGP_ADVERTISED_CIDR}"}]
	}
}
