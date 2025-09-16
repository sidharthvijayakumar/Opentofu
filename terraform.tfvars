##########################################
#Prometheus
#########################################
prometheus_release_name        = "kube-prometheus-stackr"
prometheus_namespace           = "prometheus"
prometheus_chart_version       = "70.3.0"
prometheus_repository          = "https://prometheus-community.github.io/helm-charts"
prometheus_chart_name          = "kube-prometheus-stack"
prometheus_create_namespace    = true
prometheus_scrape_timeout      = "15s"
prometheus_evaluation_interval = "15s"
prometheus_scrape_interval     = "15s"

##########################################
#OpenPolicyAgent
#########################################
opa_release_name     = "opa"
opa_namespace        = "opa-system"
opa_create_namespace = true
opa_repository       = "https://open-policy-agent.github.io/gatekeeper/charts"
opa_chart_name       = "gatekeeper"
########################################
#EC2
########################################
ec2_instances = {
  "aws-test-ec2" = {
    region                      = "ap-south-1"
    name                        = "aws-test-ec2"
    ami                         = "ami-0d0ad8bb301edb745"
    instance_type               = "t3.micro"
    availability_zone           = "ap-south-1b"
    subnet_id                   = "subnet-48236104"
    vpc_security_group_ids      = ["sg-0ce1d2c130ab72345"]
    associate_public_ip_address = true
  }
}
########################################
#ISTIO Service Mesh
########################################
istio_release_namespace                         = "istio-system"
istio_release_version                           = "1.27.0"
istio_enable_internal_gateway                   = true
internal_gateway_scaling_max_replicas           = 3
internal_gateway_scaling_target_cpu_utilization = 80

