# CODEOWNERS

sidharthvijayakumar7@gmail.com

# Terraform Modules

This repository contains reusable Terraform modules for managing various AWS infrastructure components. Below are examples of how to use each module.

---

## Providers

Ensure the following providers are configured in your Terraform project:

```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

---

## VPC Module

Creates a VPC with public and private subnets, route tables, and optional NAT/VPN gateways.

```hcl
module "vpc" {
  source = "./modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

---

## EC2 Module (with `for_each`)

Creates multiple EC2 instances using a map of configurations.

```hcl
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
```
In terraform.tfvars add
```hcl
ec2_instances = {
  "aws-test-ec2" = {
    region                      = "ap-south-1"
    name                        = "aws-test-ec2"
    ami                         = "ami-0d0ad8bb301edb745"
    instance_type               = "t3.micro"
    availability_zone           = "ap-south-1b"
    subnet_id                   = "subnet-48236104"
    vpc_security_group_ids      = ["sg-05e58cbd868be584e"]
    associate_public_ip_address = true
  }
}

```

---

## EC2 Module (Single Instance)

```hcl
module "ec2_instance" {
  source = "./modules/ec2"

  name                        = "single-instance"
  ami                         = "ami-0f1dcc636b69a6438"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-48236104"
  availability_zone           = "ap-south-1b"
  vpc_security_group_ids      = ["sg-b38c3dca"]
  associate_public_ip_address = true
  key_name                    = "demo-key-pair"
  create_spot_instance        = true
  create_iam_instance_profile = true
  monitoring                  = true
  user_data                   = file("user-data.sh")

  iam_role_policies = {
    SSM                  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    SecretsManagerAccess = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

---

## Prometheus Module

```hcl
module "prometheus" {
  source = "./modules/prometheus"

  prometheus_release_name      = var.prometheus_release_name
  prometheus_namespace         = var.prometheus_namespace
  prometheus_chart_version     = var.prometheus_chart_version
  prometheus_repository        = var.prometheus_repository
  prometheus_chart_name        = var.prometheus_chart_name
  prometheus_create_namespace  = var.prometheus_create_namespace
  prometheus_scrape_interval   = var.prometheus_scrape_interval
  prometheus_evaluation_interval = var.prometheus_evaluation_interval
  prometheus_scrape_timeout    = var.prometheus_scrape_timeout
}
```

---

## Open Policy Agent (OPA) Module
Use the command to install OPA
```
tofu init
tofu plan -target=module.open-policy-agent
tofu apply --auto-approve -target=module.open-policy-agent
```
This is an example of how to install OPA module
```hcl
module "open-policy-agent" {
  source = "./modules/open-policy-agent"

  opa_release_name     = var.opa_release_name
  opa_namespace        = var.opa_namespace
  opa_create_namespace = var.opa_create_namespace
  opa_repository       = var.opa_repository
  opa_chart_name       = var.opa_chart_name
}
```

---

## OPA Templates Module (dependent on OPA)
This is dependent on Open policy agent installation.
```
tofu init
tofu plan -target=module.opa-templates
tofu apply --auto-approve -target=module.opa-templates
```
This is an example how to install OPA Template module
```hcl
module "opa-templates" {
  source = "./modules/opa-templates"

  depends_on = [module.open-policy-agent]

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}
```

---

## OPA constraints Module (dependent on OPA)
This is dependent on OPA templates as it levrages templates to create a constraints which will enforce the policy on kubernetes Object
```
tofu init
tofu plan -target=module.opa-constraints
tofu apply --auto-approve -target=module.opa-constraints
```
This is an example how to install OPA Constraints
```hcl
module "opa-constraints" {
  depends_on = [module.opa-templates]
  source = "./modules/opa-constraints"
  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

```
---
## Istio service mesh

This will be useful in case you need to have mtls, improved secuirty and observablity for your cluster

```
tofu init
tofu plan -target=module.istio
tofu apply --auto-approve -target=module.istio
```
This is an example how to install OPA Constraints
```hcl
module "istio" {
  source                  = "./modules/istio"
  istio_release_namespace = var.istio_release_namespace
  istio_release_version   = var.istio_release_version
}
```
---
## Istio mtls

This install mtls module

```
tofu init
tofu plan -target=module.istio-mtls
tofu apply --auto-approve -target=module.istio-mtls
```
This is an example how to install OPA Constraints
```hcl
module "istio-mtls" {
  source                  = "./modules/istio-mtls"
  istio_release_namespace = var.istio_release_namespace
  istio_release_version   = var.istio_release_version
}
```

To enable istio in a namespace use below command
```
kubectl label namespace default istio-injection=enabled --overwrite
```
---
## 🌐 Terraform AWS Infrastructure

This repository contains Terraform code to provision a **VPC**, **Security Group**, and **EC2 instance(s)** on AWS.  
The project is organized using reusable modules, making it easy to scale and maintain.

---

## 📋 Overview

The infrastructure includes:

- **VPC**  
  - Custom CIDR block (`10.0.0.0/16`)  
  - Public & private subnets across multiple AZs  

- **Web Server Security Group**  
  - Allows HTTP (port 80) traffic  
  - Restricted to a custom CIDR block  

- **EC2 Instances**  
  - Launched from a custom module  
  - Supports on-demand or spot instances  
  - Optional IAM role policies and user data  

Use the below mentioned code in the root main.tf 
```
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
  depends_on          = [module.vpc]
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
  depends_on = [module.vpc, module.web_server_sg]
}
```
Use the command to deploy the infra
```
tofu init
tofu plan -out=aws_infra_plan
tofu apply --auto-approve aws_infra_plan
```
---


---

Feel free to enable or disable specific modules by commenting/uncommenting the respective blocks in your `main.tf` file.
