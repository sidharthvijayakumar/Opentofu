variable "name" {
    description = "Name of the helm release to be installed"
    type = string
}

variable "namespace" {
    description = "Name of the "
    type = string
}

variable "create_namespace" {
    description = "Boolean to create namespace"
    type = bool
}

variable "repository" {
  description = "The URL fromwhere OPA must be installed"
}

variable "chart" {
  description = "Chart name which must be installed"
}