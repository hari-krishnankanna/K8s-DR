variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_subnet_prefix" {
  type = string
}

#variable "acr_subnet_name" {
 # type = string
#}

#variable "acr_subnet_prefix" {
# type = string
#}

