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

###############################
#Istio Internal gateway
###############################
variable "istio_enable_internal_gateway" {
  type        = bool
  default     = false
  description = "Controls the enabling of an internal gateway for Istio, which manages traffic within the Kubernetes cluster."
}

variable "internal_gateway_scaling_max_replicas" {
  type = string
  description = "Max scaling replicas"
}

variable "internal_gateway_scaling_target_cpu_utilization" {
  type = string
  description = "scaling target cpu utilisation"
}
