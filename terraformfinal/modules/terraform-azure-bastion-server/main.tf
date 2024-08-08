 resource "azurerm_public_ip" "bastionip" {
  name                = var.pubip_name
  location            =  var.location #azurerm_resource_group.example.location
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "bastionNI" {
  name                = var.networkinterface_name
  location            = var.location #azurerm_resource_group.example.location
  resource_group_name = var.resource_group_name #azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.acr_subnet_id #azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastionip.id
  }
}

resource "azurerm_virtual_machine" "bastion" {
  name                  = var.vm_name
  location              = var.location #azurerm_resource_group.example.location
  resource_group_name   = var.resource_group_name  #azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.bastionNI.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "prod-os-dis"
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
  # admin_password = "Harikrishnan123#"
  }

os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/hari/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
}

}
