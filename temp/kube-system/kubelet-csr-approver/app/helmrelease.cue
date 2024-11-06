package kube

helmRelease: "kubelet-csr-approver": spec: {
	chart: spec: {
		chart:   "kubelet-csr-approver"
		version: "1.2.3"
		sourceRef: name: "postfinance"
	}
	values: {
		providerRegex:       "^(kmaster1|kmaster2|kmaster3|kworker1|kworker2|kworker3)$"
		bypassDnsResolution: true
		metrics: {
			enable: true
			serviceMonitor: enabled: true
		}
	}
}
