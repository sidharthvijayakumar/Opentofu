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
resource "kubernetes_manifest" "privileged_template" {
  manifest = {
    apiVersion = "templates.gatekeeper.sh/v1beta1"
    kind       = "ConstraintTemplate"
    metadata = {
      name = "k8sdisallowprivileged"
    }
    spec = {
      crd = {
        spec = {
          names = {
            kind = "K8sDisallowPrivileged"
          }
        }
      }
      targets = [
        {
          target = "admission.k8s.gatekeeper.sh"
          rego   = <<-REGO
            package k8sdisallowprivileged

            violation[{"msg": msg}] {
              container := input.review.object.spec.containers[_]
              container.securityContext.privileged == true
              msg := sprintf("Privileged container is not allowed: %s", [container.name])
            }
          REGO
        }
      ]
    }
  }
}