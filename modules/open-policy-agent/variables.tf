variable "opa_release_name" {
  description = "The name of the Helm release"
  type        = string
}

variable "opa_namespace" {
  description = "The namespace to deploy the Helm release"
  type        = string
}

variable "opa_repository" {
  description = "The Helm repository URL"
  type        = string
}

variable "opa_chart_name" {
  description = "The name of the Helm chart"
  type        = string
}
variable "opa_create_namespace" {
  description = "Flag to create the namespace"
  type        = bool
}