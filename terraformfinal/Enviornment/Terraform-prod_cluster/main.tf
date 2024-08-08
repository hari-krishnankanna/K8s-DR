terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.25.0"
    }
  }

  backend "azurerm" {
    subscription_id      = "40120347-0aa3-4761-a7ea-a1b9151412a4"
    resource_group_name  = "ArgoCD"
    storage_account_name = "mystatefileterraform"
    container_name       = "prod"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "40120347-0aa3-4761-a7ea-a1b9151412a4"
  features {}
}
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
tags = {
    Environment  = "prod"
    Resource_type = "resource_group"
    Terraform = "true"
}
}

module "vnet" {
  source = "../../modules/terraform-azure-vnet"
  vnet_name             = var.vnet_name
  address_space         = var.address_space
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name #var.resource_group_name
  aks_subnet_name       = var.aks_subnet_name
  aks_subnet_prefix     = var.aks_subnet_prefix
  acr_subnet_name       = var.acr_subnet_name
  acr_subnet_prefix     = var.acr_subnet_prefix
  storage_subnet_name   = var.storage_subnet_name
  storage_subnet_prefix = var.storage_subnet_prefix
}

module "acr" {
  source              = "../../modules/terraform-azure-acr"
  resource_group_name = azurerm_resource_group.main.name #var.resource_group_name
  location            = var.location
  vnet_id             = module.vnet.vnet_id
  acr_subnet_id       = module.vnet.acr_subnet_id
  acrprod_name        = var.acrprod_name
  private_endpoint_prod_acr_name =  var.private_endpoint_prod_acr_name
 prodacr_service_connection_name = var.prodacr_service_connection_name
 private_dns_zone_groupacr_name = var.private_dns_zone_groupacr_name
 private_dns_a_record_acr_name = var.private_dns_a_record_acr_name
 acr_virtual_network_link_name = var.acr_virtual_network_link_name 
}

module "bastion" {
  source              = "../../modules/terraform-azure-bastion-server"
  resource_group_name = azurerm_resource_group.main.name #var.resource_group_name
   vm_name        = var.vm_name
  
   networkinterface_name      = var.networkinterface_name
   pubip_name     = var.pubip_name
  location            = var.location
#  vnet_id             = module.vnet.vnet_id
  acr_subnet_id       = module.vnet.acr_subnet_id
}
module "aks" {
  source = "../../modules/terraform-azure-aks-cluster"
  aks_name                = var.aks_name
  location                = var.location
  resource_group_name     = azurerm_resource_group.main.name #var.resource_group_name
  dns_prefix              = var.dns_prefix
  node_count              = var.node_count
  vm_size                 = var.vm_size
  aks_subnet_id           = module.vnet.aks_subnet_id
  additional_node_pools   = var.additional_node_pools
  acr_id                  = module.acr.acr_id
}

module "storage" {
  source              = "../../modules/terraform-azure-storageaccount"
  resource_group_name = azurerm_resource_group.main.name #var.resource_group_name
  storage_name = "productionanddrvelero"
  location            = var.location
  vnet_id             = module.vnet.vnet_id
  storage_subnet_id   = module.vnet.storage_subnet_id
}

module "fileshare" {
 source              = "../../modules/terraform-azure-fileshare"
  location            = var.location
  vnet_id             = module.vnet.vnet_id
  storage_subnet_id   = module.vnet.storage_subnet_id
  resource_group_name = azurerm_resource_group.main.name
  storagefile_name  = var.storagefile_name
  fileshare_name   =  var.fileshare_name
  virtuallink_files_name = var.virtuallink_files_name
  zone_group_files_name = var.zone_group_files_name
  service_connection_file_name = var.service_connection_file_name
  private_endpoint_files_name =  var.private_endpoint_files_name 

}
