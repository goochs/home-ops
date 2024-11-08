package kube

#helmRelease & {
	_config: name: "cert-manager"
	spec: {
		chart: spec: {
			chart:   "cert-manager"
			version: "v1.16.1"
			sourceRef: name: "jetstack"
		}
		values: {
			installCRDs:                   true
			dns01RecursiveNameservers:     "1.1.1.1:53,9.9.9.9:53"
			dns01RecursiveNameserversOnly: true
			podDnsPolicy:                  "None"
			podDnsConfig: nameservers: [
				"1.1.1.1",
				"9.9.9.9",
			]
			prometheus: {
				enabled: true
				servicemonitor: enabled: true
			}
		}
	}
}
