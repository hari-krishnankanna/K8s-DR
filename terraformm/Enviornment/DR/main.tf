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
    container_name       = "testdr"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "c0812314-9889-42e6-8d45-4b13cfa76c0a"
  features {}
}
resource "azurerm_resource_group" "dr" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source = "../../modules/vnetDR"
  vnet_name             = var.vnet_name
  address_space         = var.address_space
  location              = var.location
  resource_group_name   = azurerm_resource_group.dr.name #var.resource_group_name
  aks_subnet_name       = var.aks_subnet_name
  aks_subnet_prefix     = var.aks_subnet_prefix
 # acr_subnet_name       = var.acr_subnet_name
 # acr_subnet_prefix     = var.acr_subnet_prefix
}

#module "acr" {
 # source              = "../modules/acr"
 # resource_group_name = azurerm_resource_group.dr.name #var.resource_group_name
 # location            = var.location
 # vnet_id             = module.vnet.vnet_id
 # acr_subnet_id       = module.vnet.acr_subnet_id
#}
data "azurerm_resource_group" "main" {
  name =  var.acr_resource_group_name
}
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}

resource "azurerm_private_dns_zone" "acr_private_zone" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.dr.name
}
 # Create a private endpoint for the ACR
resource "azurerm_private_endpoint" "acr_private_endpointdr" {
  name                = "acr-private-endpointdr"
  location            = var.location #data.azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.dr.name # data.azurerm_resource_group.acr_rg.name
  subnet_id           = module.vnet.aks_subnet_id

  private_service_connection {
    name                           = "acr-private-connectiondr"
    private_connection_resource_id = data.azurerm_container_registry.acr.id #data.azurerm_container_registry.acr.id 
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
  private_dns_zone_group {
    name                 = "example-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_private_zone.id]
   }
}

# Create a private DNS zone for the ACR
#resource "azurerm_private_dns_zone" "acr_private_zone" {
 # name                = "privatelink.azurecr.io"
 # resource_group_name = azurerm_resource_group.dr.name
#}

# Link the virtual network to the private DNS zone
resource "azurerm_private_dns_zone_virtual_network_link" "acr_vnet_linkdr" {
  name                  = "acr-vnet-linkdr"
  resource_group_name   = azurerm_resource_group.dr.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_private_zone.name
  virtual_network_id    = module.vnet.vnet_id
}

# Create DNS records for the ACR private endpoint
resource "azurerm_private_dns_a_record" "acr_dns_record" {
  name                = "acrdr"
  zone_name           = azurerm_private_dns_zone.acr_private_zone.name
  resource_group_name = azurerm_resource_group.dr.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.acr_private_endpointdr.private_service_connection[0].private_ip_address]
}

module "aks" {
  source = "../../modules/aksDR"
  aks_name                = var.aks_name
  location                = var.location
  resource_group_name     = azurerm_resource_group.dr.name #var.resource_group_name
  dns_prefix              = var.dns_prefix
  node_count              = var.node_count
  vm_size                 = var.vm_size
  aks_subnet_id           = module.vnet.aks_subnet_id
  additional_node_pools   = var.additional_node_pools
  acr_id                  = data.azurerm_container_registry.acr.id #data.azurerm_container_registry.acr.id
}
