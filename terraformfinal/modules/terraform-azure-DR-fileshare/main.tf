

data "azurerm_resource_group" "main" {
  name = var.acr_resource_group_name
}

data "azurerm_storage_account" "storagefile" {
  name                = var.storagefile_name
  resource_group_name = var.acr_resource_group_name
}

data "azurerm_storage_share" "fileshare" {
  name                 = var.fileshare_name
  storage_account_name = var.storagefile_name
  #resource_group_name = var.acr_resource_group_name
}

resource "azurerm_private_dns_zone" "fileshare_zone_DR" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "virtuallink_files_DR" {
  name                  = var.virtuallink_files_DR_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.fileshare_zone_DR.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "private_endpoint_files_DR" {
  name                = var.private_endpoint_files_DR_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.storage_subnet_id

  private_service_connection {
    name                           = var.service_connection_file_DR_name
    private_connection_resource_id = data.azurerm_storage_account.storagefile.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = var.zone_group_files_DR_name
    private_dns_zone_ids = [azurerm_private_dns_zone.fileshare_zone_DR.id]
  }
}

resource "azurerm_private_dns_a_record" "dnsrecord_files_DR" {
  name                = var.private_dnsfiles_DR_name
  zone_name           = azurerm_private_dns_zone.fileshare_zone_DR.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint_files_DR.private_service_connection[0].private_ip_address]
}
