terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    helm = {
      source  = "hashicorp/helm"
    }
  }
}
resource "helm_release" "open-policy-agent" {
    name                = var.name
    namespace           = var.namespace
    create_namespace    = var.create_namespace
    repository          = var.repository
    chart               = var.chart
  
}