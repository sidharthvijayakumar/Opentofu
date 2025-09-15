terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}
resource "kubernetes_manifest" "privileged_constraint" {
  manifest = {
    apiVersion = "constraints.gatekeeper.sh/v1beta1"
    kind       = "K8sDisallowPrivileged"
    metadata = {
      name = "disallow-privileged-containers"
    }
    spec = {
      match = {
        kinds = [
          {
            apiGroups = [""]
            kinds     = ["Pod"]
          }
        ]
      }
    }
  }
}