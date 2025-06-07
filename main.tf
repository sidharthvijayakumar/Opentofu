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

#################
#EC2 using for-each
#################
# module "ec2_instance" {
#   source = "./modules/ec2"

#   for_each = var.ec2_instances

#   name                         = each.value.name
#   ami                          = each.value.ami
#   instance_type                = each.value.instance_type
#   subnet_id                    = each.value.subnet_id
#   availability_zone            = each.value.availability_zone
#   vpc_security_group_ids       = each.value.vpc_security_group_ids
#   associate_public_ip_address  = each.value.associate_public_ip_address
#   key_name                     = var.key_name
#   create_spot_instance         = var.create_spot_instance
#   create_iam_instance_profile  = var.create_iam_instance_profile
#   monitoring                   = var.monitoring
#   user_data                    = file(var.user_data)
  
#   iam_role_policies = {
#     SSM = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#     SecretsManagerAccess = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
#   }

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#     Name        = each.key
#   }
# }

#####################
#EC2 without for_each
#####################
# module "ec2_instance" {
#   source = "./modules/ec2"

#   name = "single-instance"
#   create_spot_instance   = true 
#   iam_role_policies = {
#     SSM = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#     SecretsManagerAccess = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
#   }
#   ami = "ami-0f1dcc636b69a6438"
#   create_iam_instance_profile = true
#   instance_type          = "t2.micro"
#   key_name               = "demo-key-pair"
#   monitoring             = true
#   vpc_security_group_ids = ["sg-b38c3dca"]
#   subnet_id              = "subnet-48236104"
#   associate_public_ip_address  = true
#   availability_zone      = "ap-south-1b"
#   user_data              = file("user-data.sh")
#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

##########################
#VPC
##########################
#This creates ends to end network setup like vpc,subnet,routable,nat and internat gw
# module "vpc" {
#     source = "./modules/vpc"

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = false
#   enable_vpn_gateway = false

#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#   }
# }