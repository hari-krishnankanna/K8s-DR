data "azurerm_resource_group" "main" {
  name =  var.acr_resource_group_name
}
data "azurerm_container_registry" "acrprod" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}
resource "azurerm_private_dns_zone" "dns_zone_acr_dr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link_acr_dr" {
  name                  = var.acr_virtual_network_link_dr_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone_acr_dr.name
  virtual_network_id    = var.vnet_id
}


resource "azurerm_private_endpoint" "private_endpoint_prod_acr_dr" {
  name                = var.private_endpoint_prod_acr_dr_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.aks_subnet_id

  private_service_connection {
    name                           = var.dracr_service_connection_dr_name
    private_connection_resource_id = data.azurerm_container_registry.acrprod.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
}
 private_dns_zone_group {
    name                 = var.private_dns_zone_groupacr_dr_name
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone_acr_dr.id]
   }

}
resource "azurerm_private_dns_a_record" "dns_a_record_acr_dr" {
  name                = var.private_dns_a_record_acr_dr_name
  zone_name           = azurerm_private_dns_zone.dns_zone_acr_dr.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint_prod_acr_dr.private_service_connection[0].private_ip_address]
}
