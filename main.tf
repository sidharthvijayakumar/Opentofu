provider "helm" {
  kubernetes {
    config_path = "/Users/sidharth/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "/Users/sidharth/.kube/config"
}

# module "opa-templates" {

#   depends_on = [ module.open-policy-agent ]
#   source = "./modules/opa-templates"
#   providers = {
#     helm       = helm
#     kubernetes = kubernetes
#   }
# }

# module "open-policy-agent" {
#   source = "./modules/open-policy-agent"
#   opa_release_name              = var.opa_release_name
#   opa_namespace                 = var.opa_namespace
#   opa_create_namespace          = var.opa_create_namespace
#   opa_repository                = var.opa_repository
#   opa_chart_name                = var.opa_chart_name

# }

# module "prometheus" {
#   source                                    = "./modules/prometheus"
#   prometheus_release_name                   = var.prometheus_release_name
#   prometheus_namespace                      = var.prometheus_namespace
#   prometheus_chart_version                  = var.prometheus_chart_version
#   prometheus_repository                     = var.prometheus_repository
#   prometheus_chart_name                     = var.prometheus_chart_name
#   prometheus_create_namespace               = var.prometheus_create_namespace
#   prometheus_scrape_interval                = var.prometheus_scrape_interval
#   prometheus_evaluation_interval            = var.prometheus_evaluation_interval
#   prometheus_scrape_timeout                 = var.prometheus_scrape_timeout
# }

module "ec2_instance" {
  source = "./modules/ec2"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "user"
  monitoring             = true
  vpc_security_group_ids = ["sg-b38c3dca"]
  subnet_id              = "subnet-48236104"
  associate_public_ip_address  = false
  availability_zone      = "ap-south-1b"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}