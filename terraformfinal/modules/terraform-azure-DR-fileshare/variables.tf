variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "storage_subnet_id" {
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
variable "acr_resource_group_name" {
type = string
}

