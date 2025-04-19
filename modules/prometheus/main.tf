
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
resource "helm_release" "kube-prometheus" {
  name       = var.prometheus_release_name
  namespace  = var.prometheus_namespace
  version    = var.prometheus_chart_version
  repository = var.prometheus_repository
  chart      = var.prometheus_chart_name
  create_namespace = var.prometheus_create_namespace
  # Ensure valid scrape interval, evaluation interval, and timeout values
  set {
      name  = "prometheus.prometheusSpec.scrapeInterval"
      value = var.prometheus_scrape_interval
    }

    set {
      name  = "prometheus.prometheusSpec.evaluationInterval"
      value = var.prometheus_evaluation_interval
    }

    set {
      name  = "prometheus.prometheusSpec.scrapeTimeout"
      value = var.prometheus_scrape_timeout
    }
}