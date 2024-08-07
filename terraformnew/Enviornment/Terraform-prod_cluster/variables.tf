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

variable "storage_subnet_name" {
  type = string
}

variable "storage_subnet_prefix" {
  type = string
}

variable "allocation_method"{
type = string
}

variable "vm_name" {
  type = string
}

variable "networkinterface_name"{
  type = string
}

variable "pubip_name"{
  type = string
 }

variable "storagefile_name" {
type = string
}
variable "fileshare_name" {
type = string
}

variable "virtuallink_name"{
type = string
}

variable "private_endpoint_name"{
type = string
}

variable "acr_virtual_network_link_name" {
type = string
}
variable "acrprod_name" {
type = string
}
variable "prodacr_service_connection_name" {
type = string
}
variable "private_endpoint_prod_acr_name" {
type = string
}
variable "private_dns_zone_groupacr_name" {
type = string
}
variable "private_dns_a_record_acr_name" {
type = string
}

