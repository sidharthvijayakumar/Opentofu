module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "vpc-750ffb1e"

  #ingress_cidr_blocks = ["58.84.62.172/32"]
  ingress_rules = {
      ssh = {
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = "58.84.61.235/32"
      description = "SSH access"
    }
  }
  egress_rules = {
      all = {
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
  }
  #depends_on          = ["vpc-750ffb1e"]
}

module "ec2_instance" {
  source                        = "../../modules/ec2"
  name                          = "single-instance"
  ami                           = "ami-01a00762f46d584a1"
  instance_type                 = "t2.micro"
  subnet_id                     = "subnet-48236104"
  availability_zone             = "ap-south-1b"
  vpc_security_group_ids        = [module.web_server_sg.id]
  associate_public_ip_address   = true
  key_name                      = "demo-key-pair"
  create_spot_instance          = false
  create_iam_instance_profile   = true
  monitoring                    = true
  #user_data                     = file("./scripts/user-data.sh")
  ebs_volumes = {
      "/dev/xvdi"   = {
        size        = 3
        type        = "gp3"
      }
  }
  volume_tags = {
    Name = "single-instance"
  }

  iam_role_policies = {
    SSM                  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    SecretsManagerAccess = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}