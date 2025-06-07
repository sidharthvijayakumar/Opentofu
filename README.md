# Opentofu
#This appies the Open policy agent module
tofu apply -target=module.open-policy-agent --auto-approve

#This applies the Open policy agenet templates
tofu apply -target=module.opa-templates --auto-approve

#This applies the Open policy agent contraints and other modules
tofu apply --auto-approve

# Terraform Modules Deployment Guide

This repository contains modular Terraform code to deploy various components like EC2, VPC, Prometheus, OPA (Open Policy Agent), etc., using providers like AWS, Kubernetes, and Helm.

---

## ✅ Prerequisites

- Terraform installed
- AWS credentials configured
- Kubernetes cluster access set in your kubeconfig file (`~/.kube/config`)

---

## 📦 Providers

Make sure the following providers are configured in `main.tf`:

```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
```hcl
Module to create VPC
Creates a VPC with public and private subnets, route tables, and optional NAT Gateway.

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
  ```hcl