provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main"{
  name = var.resource_grp
  location = "West Europe"
}
