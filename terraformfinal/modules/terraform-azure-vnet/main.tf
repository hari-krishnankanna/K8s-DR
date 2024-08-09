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

resource "azurerm_subnet" "acr_subnet" {
  name                 = var.acr_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.acr_subnet_prefix]
}

resource "azurerm_subnet" "storage_subnet" {
  name                 = var.storage_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.storage_subnet_prefix]
}
#resource "azurerm_network_security_group" "aks_nsg" {
# name                = "${var.aks_subnet_name}-nsg"
# location            = var.location
# resource_group_name = var.resource_group_name
#}

resource "azurerm_network_security_group" "acr_nsg" {
  name                = "${var.acr_subnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "storage_nsg" {
  name                = "${var.storage_subnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Define a security rule to allow port 22
resource "azurerm_network_security_rule" "acr_allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.acr_nsg.name
}
#resource "azurerm_subnet_network_security_group_association" "aks_nsg_association" {
#  subnet_id                 = azurerm_subnet.aks_subnet.id
#  network_security_group_id = azurerm_network_security_group.aks_nsg.id
#}

resource "azurerm_subnet_network_security_group_association" "acr_nsg_association" {
  subnet_id                 = azurerm_subnet.acr_subnet.id
  network_security_group_id = azurerm_network_security_group.acr_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "storage_nsg_association" {
  subnet_id                 = azurerm_subnet.storage_subnet.id
  network_security_group_id = azurerm_network_security_group.storage_nsg.id
}