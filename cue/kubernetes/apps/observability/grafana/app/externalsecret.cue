package kube

#externalSecret & {
	_config: name: "grafana-admin-secret"
	spec: data: [
		{
			secretKey: "admin-user"
			remoteRef: {
				key:      "admin-login"
				property: "username"
			}},
		{
			secretKey: "admin-password"
			remoteRef: {
				key:      "admin-login"
				property: "password"
			}}]
}
