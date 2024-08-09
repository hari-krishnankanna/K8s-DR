resource "azurerm_storage_account" "storagefile" {
  name                     = var.storagefile_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "fileshare" {
  name                 = var.fileshare_name
  storage_account_name = azurerm_storage_account.storagefile.name
  quota                = 100
}

resource "azurerm_private_dns_zone" "fileshare_zone" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "virtuallink_files" {
  name                  = var.virtuallink_files_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.fileshare_zone.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "private_endpoint_files" {
  name                = var.private_endpoint_files_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.storage_subnet_id

  private_service_connection {
    name                           = var.service_connection_file_name
    private_connection_resource_id = azurerm_storage_account.storagefile.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = var.zone_group_files_name
    private_dns_zone_ids = [azurerm_private_dns_zone.fileshare_zone.id]
  }
}

resource "azurerm_private_dns_a_record" "dnsrecord_files" {
  name                = azurerm_storage_account.storagefile.name
  zone_name           = azurerm_private_dns_zone.fileshare_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint_files.private_service_connection[0].private_ip_address]
}
