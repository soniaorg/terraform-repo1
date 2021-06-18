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
