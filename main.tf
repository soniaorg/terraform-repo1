provider "azurerm" {
  features {}
}

variable  prefix_name{
  default= "MYRG"
}

resource "azurerm_resource_group" "main"{
  name = "${var.prefix_name}-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "main"{
  name  = "${var.prefix_name}-network"
  address_space=["10.0.0.0/16"]
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}


resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource  "azurerm_network_interface"  "main"{
  name = "${var.prefix_name}-nic"
  location= azurerm_resource_group.main.location
  resource_group_name=azurerm_resource_group.main.name
   
   ip_configuration{
  name= "configiration"
  subnet_id= azurerm_subnet.internal.id
  private_ip_address_allocation = "Dynamic"
}
}

resource "azurerm_virtual_machine" "virtualm"{
  name="${var.prefix_name}-vm"
  location=azurerm_resource_group.main.location
  resource_group_name=azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  
 storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}


module "mylb" {
  source              = "Azure/loadbalancer/azurerm"
  resource_group_name = azurerm_resource_group.main.name
  name                = "lb-terraform-test"
  pip_name            = "pip-terraform-test"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http = ["80", "Tcp", "80"]
  }

  lb_probe = {
    http = ["Tcp", "80", ""]
  }

  depends_on = [azurerm_resource_group.main]
}

resource "azurerm_network_interface_backend_address_pool_association" "vault" {
  network_interface_id    = "${azurerm_network_interface.main.id}"
  ip_configuration_name   = "configiration"
  backend_address_pool_id = "${azurerm_virtual_machine.virtualm.name}"
}


