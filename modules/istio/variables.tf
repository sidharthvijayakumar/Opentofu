variable "istio_release_version" {
  type        = string
  description = "The version of Istio to be installed."
}

variable "istio_release_namespace" {
  type        = string
  description = "The Kubernetes namespace where Istio will be installed."
}

variable "istio_mesh_id" {
  type        = string
  description = "The ID of the Istio mesh."
  default     = null
  nullable    = true
}

variable "istio_network" {
  type        = string
  description = "The network for the Istio mesh."
  default     = null
  nullable    = true
}

variable "istio_multi_cluster" {
  type        = bool
  description = "Enable multi-cluster support for Istio."
  default     = false
}

variable "istio_cluster_name" {
  type        = string
  description = "The name of the cluster."
  default     = null
  nullable    = true
}