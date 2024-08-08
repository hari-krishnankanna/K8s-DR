variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "aks_subnet_id" {
  type = string
}

#variable "retention_days" {
 # description = "The number of days after which untagged manifests should be deleted"
 # type        = number
 # default     = 7
#}
variable "private_endpoint_prod_acr_dr_name" {
type = string
}

variable "acr_virtual_network_link_dr_name" {
type = string
}
variable "private_dns_a_record_acr_dr_name" {
type = string
}
variable "dracr_service_connection_dr_name" {
type = string
}
variable "private_dns_zone_groupacr_dr_name" {
type = string
}
variable "acr_name" {
type = string
}
variable "acr_resource_group_name" {
type = string
}

