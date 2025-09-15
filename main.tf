provider "helm" {
  kubernetes {
    config_path = "/Users/sidharth/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "/Users/sidharth/.kube/config"
}

module "istio" {
  source                                          = "./modules/istio"
  istio_release_namespace                         = var.istio_release_namespace
  istio_release_version                           = var.istio_release_version
  istio_enable_internal_gateway                   = var.istio_enable_internal_gateway
  internal_gateway_scaling_target_cpu_utilization = var.internal_gateway_scaling_target_cpu_utilization
  internal_gateway_scaling_max_replicas           = var.internal_gateway_scaling_max_replicas

}

module "istio_mtls" {
  source = "./modules/istio-mtls"
}

