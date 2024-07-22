output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "acr_subnet_id" {
  value = azurerm_subnet.acr_subnet.id
}
output "storage_subnet_id" {
  value = azurerm_subnet.acr_subnet.id
}
