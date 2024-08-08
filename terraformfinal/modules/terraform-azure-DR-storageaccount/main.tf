data "azurerm_resource_group" "main" {
 name =  var.acr_resource_group_name
}

data "azurerm_storage_account" "prod" {
  name                = var.storage_name
  resource_group_name = var.acr_resource_group_name
}
resource "azurerm_private_dns_zone" "storage_dr" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
}
resource "azurerm_private_endpoint" "storage_dr" {
  name                = var.private_endpoint_storage_dr_name
  location            = var.location #azurerm_resource_group.example.location
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
  subnet_id           = var.storage_subnet_id

  private_service_connection {
    name                           = var.dr_storage_service_conn_name
    private_connection_resource_id = data.azurerm_storage_account.prod.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
private_dns_zone_group {
    name                 = var.storage_dns_zonegrp_name
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_dr.id]
   }
}

#resource "azurerm_private_dns_zone" "storage_dr" {
 # name                = "privatelink.blob.core.windows.net"
 # resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
#}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_dr" {
  name                  = var.storage_virtual_link_name
  resource_group_name   = var.resource_group_name #azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_dr.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "storage_dr" {
  name                = var.storage_dns_record_name
  zone_name           = azurerm_private_dns_zone.storage_dr.name
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storage_dr.private_service_connection[0].private_ip_address]
}
