variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_subnet_prefix" {
  type = string
}

variable "acr_subnet_name" {
  type = string
}

variable "acr_subnet_prefix" {
  type = string
}

variable "aks_name" {
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

variable "additional_node_pools" {
  type = list(object({
    name       = string
    node_count = number
    vm_size    = string
  }))
}


