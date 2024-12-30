terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4"
    }
  }
}

provider "azurerm" {
  subscription_id = "9d39a7ed-ade3-48a7-b015-5490cae4f9c5"
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "North Europe"
}

resource "azurerm_service_plan" "basic" {
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  name     = "basic_plan"
  os_type  = "Linux"
  sku_name = "B1"
}

resource "azurerm_storage_account" "example" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  name                     = "sa01faosku"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_linux_function_app" "api" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  name                = "go-function-app"

  service_plan_id            = azurerm_service_plan.basic.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "custom"
  }


  site_config {
    always_on         = true
    use_32_bit_worker = false
  }
}
