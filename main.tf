provider "helm" {
  kubernetes {
    config_path = "/Users/sidharth/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "/Users/sidharth/.kube/config"
}

module "ec2_instance" {
  source = "./modules/ec2"
  
  for_each = var.ec2_instances
  name                        = each.value.name
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  tags = {
    Name   = "aws-test-ec2"
  }
}

