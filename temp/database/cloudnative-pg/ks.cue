package kube

kustomization: "cloudnative-pg": spec: {
	targetNamespace: "database"
	wait:            true
}
