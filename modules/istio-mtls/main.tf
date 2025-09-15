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
resource "kubernetes_manifest" "peer_auth_strict" {
  manifest = {
    "apiVersion" = "security.istio.io/v1beta1"
    "kind"       = "PeerAuthentication"
    "metadata" = {
      "name"      = "default"
      "namespace" = "default"
    }
    "spec" = {
      "mtls" = {
        "mode" = "STRICT"
      }
    }
  }
  
}