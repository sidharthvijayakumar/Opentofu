terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.17.0"
    }
  }
}