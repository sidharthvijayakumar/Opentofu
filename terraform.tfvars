

##########################################
#OpenPolicyAgent
#########################################
opa_release_name     = "opa"
opa_namespace        = "opa-system"
opa_create_namespace = true
opa_repository       = "https://open-policy-agent.github.io/gatekeeper/charts"
opa_chart_name       = "gatekeeper"
########################################
#ISTIO Service Mesh
########################################
istio_release_namespace                         = "istio-system"
istio_release_version                           = "1.27.0"
istio_enable_internal_gateway                   = true
internal_gateway_scaling_max_replicas           = 3
internal_gateway_scaling_target_cpu_utilization = 80

