package kube

kustomization: "flux-webhooks": spec: {
	targetNamespace: "flux-system"
	path:            "./kubernetes/apps/flux-system/webhooks/app"
	wait:            true
}
