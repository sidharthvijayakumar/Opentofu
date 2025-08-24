provider "helm" {
  kubernetes {
    config_path = "/Users/sidharth/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "/Users/sidharth/.kube/config"
}

module "istio" {
  source                  = "./modules/istio"
  istio_release_namespace = var.istio_release_namespace
  istio_release_version   = var.istio_release_version
}