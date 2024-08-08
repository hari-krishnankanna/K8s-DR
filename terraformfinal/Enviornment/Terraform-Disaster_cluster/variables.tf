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
variable "acr_name" {
  type = string
}
variable "acr_resource_group_name" {
  description = "The name of the resource group containing the ACR."
  type        = string
}

variable "storage_subnet_prefix" {
  type = string
}
variable "storage_subnet_name" {
  type = string
}

variable "storage_name" {
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
variable "private_endpoint_prod_acr_dr_name" {
type = string 
}

variable "acr_virtual_network_link_dr_name" {
type = string
}
variable "private_dns_a_record_acr_dr_name" {
type = string
}

variable "private_dns_zone_groupacr_dr_name" {
type = string 
}
variable "dracr_service_connection_dr_name" {
type = string 
}

variable "private_endpoint_storage_dr_name" {
type = string
}
#storagecoount##
variable "storage_dns_zonegrp_name" {
type = string
}
variable "dr_storage_service_conn_name" {
type = string
}
variable "storage_dns_record_name" {
type = string
}
variable "storage_virtual_link_name" {
type = string
}

variable "storagefile_name" {
  type = string
}
variable "fileshare_name" {
type = string
}


variable "virtuallink_files_DR_name"{
type = string
}

variable "private_endpoint_files_DR_name"{
type = string
}
variable "service_connection_file_DR_name" {
type = string
}
variable "zone_group_files_DR_name" {
type = string
}
variable "private_dnsfiles_DR_name" {
type = string
}
#variable "fileshare_name" {
#type = string
#}
#variable "storagefile_name" {
#type = string
#}

