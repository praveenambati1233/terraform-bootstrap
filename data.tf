data "azurerm_resource_group" "network" {
  name = "rg-ccpt-prd-network"
}

data "azurerm_virtual_network" "network" {
  name                = "vnet-ccpt-prd-hybrid"
  resource_group_name = data.azurerm_resource_group.network.name
}

data "azurerm_subnet" "pe_subnet" {
  name                 = "subnet-ccpm-prd-intr-priv-01"
  virtual_network_name = data.azurerm_virtual_network.network.name
  resource_group_name  = data.azurerm_resource_group.network.name
}

data "azurerm_subscription" "current" {}