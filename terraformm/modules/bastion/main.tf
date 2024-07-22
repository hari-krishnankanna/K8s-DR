#  name                  = "example-dns-link"
#  resource_group_name   = var.resource_group_name
#  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
#  virtual_network_id    = var.vnet_id
#resource_group_name      = var.resource_group_name
#location                 = var.location
#subnet_id           = var.acr_subnet_id

 resource "azurerm_public_ip" "prod" {
  name                = "example-prod"
  location            =  var.location #azurerm_resource_group.example.location
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "prod" {
  name                = "example-prod"
  location            = var.location #azurerm_resource_group.example.location
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.acr_subnet_id #azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.prod.id
  }
}

resource "azurerm_virtual_machine" "prod" {
  name                  = "prod-machine"
  location              = var.location #azurerm_resource_group.example.location
  resource_group_name   = var.resource_group_name  #azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.prod.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "prod-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "hari"
    admin_password = "Harikrishnan123#"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}




