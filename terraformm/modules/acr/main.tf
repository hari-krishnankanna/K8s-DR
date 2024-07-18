resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "example-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_container_registry" "acr" {
  name                     = "exampleacrharitest"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "Premium"
  admin_enabled            = true

network_rule_set {
    default_action = "Deny"
  }
# georeplications {
 #   location = "East US"
  #  zone_redundancy_enabled = false
  #}

  georeplications {
    location = "West US"
    zone_redundancy_enabled = false
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


resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "example-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.acr_subnet_id

  private_service_connection {
    name                           = "example-privatelink-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
}
 private_dns_zone_group {
    name                 = "example-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone.id]
   }
}

resource "azurerm_private_dns_a_record" "dns_a_record" {
  name                = "acr"
  zone_name           = azurerm_private_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint.private_service_connection[0].private_ip_address]
}

