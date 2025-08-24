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

resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_release_version
  namespace        = var.istio_release_namespace
  create_namespace = true
  set {
    name  = "defaultRevision"
    value = "default"
  }
}

resource "helm_release" "istio_discovery" {
  name             = "istio-discovery"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = var.istio_release_version
  namespace        = var.istio_release_namespace
  create_namespace = true
  values = [
    templatefile("${path.module}/values/istiod.tftpl", {
      istio_mesh_id       = var.istio_mesh_id
      istio_network       = var.istio_network
      istio_multi_cluster = var.istio_multi_cluster
      istio_cluster_name  = var.istio_cluster_name
    })
  ]
  depends_on = [helm_release.istio_base]
}