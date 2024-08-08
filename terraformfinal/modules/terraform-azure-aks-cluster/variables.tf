variable "aks_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "node_count" {
  type = number
}

variable "vm_size" {
  type = string
}

variable "aks_subnet_id" {
  type = string
}

variable "additional_node_pools" {
  type = list(object({
    name       = string
    node_count = number
    vm_size    = string
  }))
}

variable "acr_id" {
  type = string
}