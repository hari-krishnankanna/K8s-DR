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
  source = "../../modules/terraform-azure-vnet"
  vnet_name             = var.vnet_name
  address_space         = var.address_space
  location              = var.location
  resource_group_name   = azurerm_resource_group.dr.name #var.resource_group_name
  aks_subnet_name       = var.aks_subnet_name
  aks_subnet_prefix     = var.aks_subnet_prefix
  acr_subnet_name       = var.acr_subnet_name
  acr_subnet_prefix     = var.acr_subnet_prefix
  storage_subnet_name   = var.storage_subnet_name
  storage_subnet_prefix = var.storage_subnet_prefix
}

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
  source = "../../modules/terraform-azure-aks-cluster"
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
module "bastion" {
   source              = "../../modules/terraform-azure-bastion-server"
   resource_group_name = azurerm_resource_group.dr.name #var.resource_group_name
   bastion_name        = var.vm_name
   bastionNI_name      = var.networkinterface_name
   bastionip_name      = var.pubip_name
   location            = var.location
#  vnet_id             = module.vnet.vnet_id
   acr_subnet_id       = module.vnet.acr_subnet_id
}

data "azurerm_storage_account" "prod" {
  name                = var.storage_name
  resource_group_name = var.acr_resource_group_name
}

 resource "azurerm_private_dns_zone" "storagedr" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.dr.name #var.resource_group_name #azurerm_resource_group.example.name
}
resource "azurerm_private_endpoint" "storagedr" {
  name                = "storage-private-endpoint"
  location            = var.location #azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.dr.name #var.resource_group_name #azurerm_resource_group.example.name
  subnet_id           = module.vnet.storage_subnet_id #var.storage_subnet_id

  private_service_connection {
    name                           = "storage-privateserviceconnection"
    private_connection_resource_id = data.azurerm_storage_account.prod.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storagedr.id]
   }
}

#resource "azurerm_private_dns_zone" "storage" {
 # name                = "privatelink.blob.core.windows.net"
 # resource_group_name = azurerm_resource_group.dr.name #var.resource_group_name #azurerm_resource_group.example.name
#}

resource "azurerm_private_dns_zone_virtual_network_link" "storagedr" {
  name                  = "storage-dns-zone-link"
  resource_group_name   = azurerm_resource_group.dr.name #var.resource_group_name #azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.storagedr.name
  virtual_network_id    = module.vnet.vnet_id
}

resource "azurerm_private_dns_a_record" "storagedr" {
  name                = data.azurerm_storage_account.prod.name
  zone_name           = azurerm_private_dns_zone.storagedr.name
  resource_group_name = azurerm_resource_group.dr.name #var.resource_group_name #azurerm_resource_group.example.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storagedr.private_service_connection[0].private_ip_address]
}