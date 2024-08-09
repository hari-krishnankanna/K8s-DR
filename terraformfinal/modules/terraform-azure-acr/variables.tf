variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "acr_subnet_id" {
  type = string
}

variable "retention_days" {
  description = "The number of days after which untagged manifests should be deleted"
  type        = number
  default     = 7
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
