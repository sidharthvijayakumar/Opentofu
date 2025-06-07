##########################################
#Prometheus
#########################################
prometheus_release_name         = "kube-prometheus-stackr"
prometheus_namespace            = "prometheus"
prometheus_chart_version        = "70.3.0"
prometheus_repository           = "https://prometheus-community.github.io/helm-charts"
prometheus_chart_name           = "kube-prometheus-stack"
prometheus_create_namespace     = true
prometheus_scrape_timeout       = "15s"
prometheus_evaluation_interval  = "15s"
prometheus_scrape_interval      = "15s"

##########################################
#OpenPolicyAgent
#########################################
opa_release_name              = "opa"
opa_namespace                 = "opa-system"
opa_create_namespace          = true
opa_repository                = "https://open-policy-agent.github.io/gatekeeper/charts"
opa_chart_name                = "gatekeeper"
########################################
#EC2
########################################
ec2_instances = {
  vm1 = {
    name                        = "web-server-1"
    ami                         = "ami-0f1dcc636b69a6438"
    instance_type               = "t2.micro"
    subnet_id                   = "subnet-48236104"
    availability_zone           = "ap-south-1b"
    vpc_security_group_ids      = ["sg-b38c3dca"]
    associate_public_ip_address = true
    key_pair                    = "demo-key-pair"
    create_spot_instance        = true
    create_iam_instance_profile = true
    monitoring                  = true
  }
#   vm2 = {
#     name                        = "web-server-2"
#     ami                         = "ami-0f1dcc636b69a6438"
#     instance_type               = "t2.micro"
#     subnet_id                   = "subnet-3224395a"
#     availability_zone           = "ap-south-1a"
#     vpc_security_group_ids      = ["sg-b38c3dca"]
#     key_pair                    = "demo-key-pair"
#     associate_public_ip_address = true
#     create_spot_instance        = true
#     create_iam_instance_profile = true
#     monitoring                  = true
#   }
}