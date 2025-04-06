provider "helm" {
  kubernetes {
    config_path = "/Users/sidharth/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "/Users/sidharth/.kube/config"
}

module "open-policy-agent" {
    source              = "./modules/open-policy-agent"
    name                = var.name
    namespace           = var.namespace
    create_namespace    = var.create_namespace
    repository          = var.repository
    chart               = var.chart
    providers = {
        helm       = helm
        kubernetes = kubernetes
    }
}

module "opa-templates" {

  depends_on = [ module.open-policy-agent ]
  source = "./modules/opa-templates"
  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

#When installing this must be installed once opa-templates is installed
module "opa-constraints" {
  depends_on = [  module.opa-templates ]
  source = "./modules/opa-constraints"
  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}