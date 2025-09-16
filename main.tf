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
  subnet_id                   = each.value.subnet_id
  availability_zone           = each.value.availability_zone
  vpc_security_group_ids      = each.value.vpc_security_group_ids
  associate_public_ip_address = each.value.associate_public_ip_address
  key_name                    = var.key_name
  create_spot_instance        = var.create_spot_instance
  create_iam_instance_profile = var.create_iam_instance_profile
  monitoring                  = var.monitoring
  user_data                   = file(var.user_data)

  iam_role_policies = {
    SSM                  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    SecretsManagerAccess = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = each.key
  }
}