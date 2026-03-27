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
    associate_public_ip_address = true
  }
}