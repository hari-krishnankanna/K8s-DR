resource "azurerm_private_dns_zone" "dns_zone_acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link_acr" {
  name                  = var.acr_virtual_network_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone_acr.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_container_registry" "acrprod" {
  name                     = var.acrprod_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "Premium"
  admin_enabled            = false
  #zone_redundancy          = "Enabled"
  public_network_access_enabled = false
network_rule_set {
    default_action = "Deny"
  }

georeplications {
    location = "West US"
    #zone_redundancy   = "Enabled"
}
retention_policy {
 enabled = true
 days    = var.retention_days
  }
}

#resource "azurerm_container_registry_replication" "replication_eastus" {
 # name                     = "eastus-replication"
 # resource_group_name      = var.resource_group_name
 # registry_name            = azurerm_container_registry.acr.name
 # location                 = "East US"
#}

#resource "azurerm_container_registry_replication" "replication_westus" {
 # name                     = "westus-replication"
 # resource_group_name      = var.resource_group_name
 # registry_name            = azurerm_container_registry.acr.name
 # location                 = "West US"
#}


resource "azurerm_private_endpoint" "private_endpoint_prod_acr" {
  name                = var.private_endpoint_prod_acr_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.acr_subnet_id

  private_service_connection {
    name                           = var.prodacr_service_connection_name
    private_connection_resource_id = azurerm_container_registry.acrprod.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
}
 private_dns_zone_group {
    name                 = var.private_dns_zone_groupacr_name
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone_acr.id]
   }

}
resource "azurerm_private_dns_a_record" "dns_a_record_acr" {
  name                = var.private_dns_a_record_acr_name
  zone_name           = azurerm_private_dns_zone.dns_zone_acr.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint_prod_acr.private_service_connection[0].private_ip_address]
}
