terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
 features {
   
 }
}

variable "appPrefix" {
  type = string
  default = "alert"
}


resource "azurerm_resource_group" "alertservice" {
  name = "alertservice"
  location = "eastus2"
}

resource "azurerm_network_security_group" "alertsg" {
  name                = "alertsg"
  location            = azurerm_resource_group.alertservice.location
  resource_group_name = azurerm_resource_group.alertservice.name
}

resource "azurerm_virtual_network" "main" {
  name = "${var.appPrefix}-vnet"
  location = azurerm_resource_group.alertservice.location
  address_space = [ "10.0.0.0/16" ]
  resource_group_name = azurerm_resource_group.alertservice.name
  subnet {
    name           = "01"
    address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_storage_account" "alertstore" {
  name = "${var.appPrefix}store"
  location = azurerm_resource_group.alertservice.location
  resource_group_name = azurerm_resource_group.alertservice.name
  access_tier = "Hot"
  account_kind = "StorageV2"
  account_tier = "Standard"
  identity {
    type = "SystemAssigned"
  }
  account_replication_type = "LRS"
}