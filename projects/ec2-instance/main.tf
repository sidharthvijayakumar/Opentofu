module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "vpc-750ffb1e"

  ingress_cidr_blocks = ["58.84.62.172/32"]
  ingress_rules = ["ssh-tcp"]
  #depends_on          = ["vpc-750ffb1e"]
}

module "ec2_instance" {
  source = "../../modules/ec2"
  name                        = "single-instance"
  ami                         = "ami-0f1dcc636b69a6438"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-48236104"
  availability_zone           = "ap-south-1b"
  vpc_security_group_ids      = [module.web_server_sg.security_group_id]
  associate_public_ip_address = true
  key_name                    = "demo-key-pair"
  create_spot_instance        = false
  create_iam_instance_profile = true
  monitoring                  = true
  # user_data                   = file("./scripts/user-data.sh")
  ebs_volumes = {
      "/dev/xvdf"   = {
        size        = 10
        type        = "gp3"
      }
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