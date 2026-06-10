# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${module.naming.virtual_network.name}-core"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]

  tags = var.tags
}

# Private Endpoint Subnet
resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["10.0.1.0/24"]

  private_endpoint_network_policies = "Disabled"
}