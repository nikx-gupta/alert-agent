terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.1.0"
    }
  }
  cloud {
    organization = "nikxgupta"

    workspaces {
      name = "alert-agent"
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


resource "azurerm_resource_group" "storerg" {
  name = "storerg"
  location = "eastus2"
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
  location = azurerm_resource_group.storerg.location
  resource_group_name = azurerm_resource_group.storerg.name
  access_tier = "Hot"
  account_kind = "StorageV2"
  account_tier = "Standard"
  identity {
    type = "SystemAssigned"
  }
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "alert_func_plan" {
  name                = "${var.appPrefix}-func-plan"
  location            = azurerm_resource_group.alertservice.location
  resource_group_name = azurerm_resource_group.alertservice.name
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "alert_func_app" {
  name = "${var.appPrefix}-func-app"
  location = azurerm_resource_group.alertservice.location
  resource_group_name = azurerm_resource_group.alertservice.name
  storage_account_name = azurerm_storage_account.alertstore.name
  storage_account_access_key = azurerm_storage_account.alertstore.primary_access_key
  app_service_plan_id = azurerm_app_service_plan.alert_func_plan.id
}


