module "vpc" {
  source = "./modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.default_vpc_id

  ingress_cidr_blocks = ["10.10.0.0/16"]
  depends_on = [ module.vpc ]
}

module "ec2_instance" {
  source = "./modules/ec2"

  for_each = var.ec2_instances

  name                        = each.value.name
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id
  availability_zone           = each.value.availability_zone
  vpc_security_group_ids      = [module.web_server_sg.security_group_id]
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
  depends_on = [ module.vpc , module.web_server_sg ]
}