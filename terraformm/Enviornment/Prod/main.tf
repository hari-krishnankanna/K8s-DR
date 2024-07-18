terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.25.0"
    }
  }

  backend "azurerm" {
    subscription_id      = "c0812314-9889-42e6-8d45-4b13cfa76c0a"
    resource_group_name  = "test"
    storage_account_name = "mystatefileterraform"
    container_name       = "prod"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "c0812314-9889-42e6-8d45-4b13cfa76c0a"
  features {}
}
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source = "../../modules/vnet"
  vnet_name             = var.vnet_name
  address_space         = var.address_space
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name #var.resource_group_name
  aks_subnet_name       = var.aks_subnet_name
  aks_subnet_prefix     = var.aks_subnet_prefix
  acr_subnet_name       = var.acr_subnet_name
  acr_subnet_prefix     = var.acr_subnet_prefix
}

module "acr" {
  source              = "../../modules/acr"
  resource_group_name = azurerm_resource_group.main.name #var.resource_group_name
  location            = var.location
  vnet_id             = module.vnet.vnet_id
  acr_subnet_id       = module.vnet.acr_subnet_id
}

module "aks" {
  source = "../../modules/aks"
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
