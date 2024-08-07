resource "azurerm_storage_account" "storage" {
  name                     = "var.storagefile_name"
  resource_group_name      =  var.resource_group_name  
  location                 =  var.location 
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "files" {
  name                 = "var.fileshare_name"
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_private_dns_zone" "fileshare" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "virtuallink" {
  name                  = "var.virtuallink_name"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.fileshare.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "var.private_endpoint_name"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.storage_subnet_id

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
private_dns_zone_group {
    name                 = "fileshare"
    private_dns_zone_ids = [azurerm_private_dns_zone.fileshare.id
}
}

resource "azurerm_private_dns_a_record" "dnsrecord" {
  name                = azurerm_storage_account.storage.name
  zone_name           = azurerm_private_dns_zone.fileshare.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.example.private_service_connection[0].private_ip_address]
}
