package kube

#helmRelease & {
	_config: name: "hajimari"
	spec: {
		chart: spec: {
			chart:   "hajimari"
			version: "2.0.2"
			sourceRef: name: "hajimari"
		}
		values: {
			hajimari: {
				title:               "Hajimari"
				darkTheme:           "espresso"
				alwaysTargetBlank:   true
				showGreeting:        false
				showAppGroups:       true
				showAppStatus:       true
				showBookmarkGroups:  false
				showGlobalBookmarks: false
				showAppUrls:         false
				defaultEnable:       false
			}
			ingress: main: {
				enabled:          true
				ingressClassName: "internal"
				annotations: "hajimari.io/enable": "false"
				hosts: [{
					host: "dash.${SECRET_DOMAIN}"
					paths: [{
						path:     "/"
						pathType: "Prefix"
					}]
				}]
			}
			podAnnotations: "configmap.reloader.stakater.com/reload": "hajimari-settings"
			persistence: data: {
				enabled: true
				type:    "emptyDir"
			}
			resources: requests: {
				cpu:    "100m"
				memory: "128M"
			}
		}
	}
}
