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

# Install the OPA policy agent using Helm
resource "helm_release" "opa" {

  name              = var.opa_release_name
  namespace         = var.opa_namespace
  create_namespace  = var.opa_create_namespace
  repository        = var.opa_repository
  chart             = var.opa_chart_name

  set {
    name  = "replicaCount"
    value = "1"
  }
}