 resource "azurerm_storage_account" "prod" {
  name                     = "productionanddrvelero"
  resource_group_name      = var.resource_group_name # azurerm_resource_group.example.name
  location                 = var.location #azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}


resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
}
resource "azurerm_private_endpoint" "storage" {
  name                = "storage-private-endpoint"
  location            = var.location #azurerm_resource_group.example.location
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
  subnet_id           = var.storage_subnet_id

  private_service_connection {
    name                           = "storage-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.prod.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
   }
}

#resource "azurerm_private_dns_zone" "storage" {
 # name                = "privatelink.blob.core.windows.net"
 # resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
#}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = "storage-dns-zone-link"
  resource_group_name   = var.resource_group_name #azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "storage" {
  name                = azurerm_storage_account.prod.name
  zone_name           = azurerm_private_dns_zone.storage.name
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storage.private_service_connection[0].private_ip_address]
}
