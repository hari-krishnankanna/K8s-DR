 resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_prefix]
}

#resource "azurerm_subnet" "acr_subnet" {
 # name                 = var.acr_subnet_name
 # resource_group_name  = var.resource_group_name
 # virtual_network_name = azurerm_virtual_network.vnet.name
 # address_prefixes     = [var.acr_subnet_prefix]
#}
# delegation {
 #   name = "example-delegation"

  #  service_delegation {
  #    name = "Microsoft.ContainerInstance/containerGroups"
#      actions = [ "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
   # }
 # }
#}

