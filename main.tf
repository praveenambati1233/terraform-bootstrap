module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix  = ["nusitccp"]

}

resource "azurerm_resource_group" "rg" {
  name     = "${module.naming.resource_group.name}-devops"
  location = var.location
  tags     = var.tags
}

# Private DNS Zone for Blob Storage
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}

# Link DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "${azurerm_storage_account.devopssa.name}-blob-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  tags = var.tags
}

resource "azurerm_storage_account" "devopssa" {
  name                            = "${module.naming.storage_account.name}tfstate"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS" # For state file disaster scenario
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  network_rules {
    default_action = "Deny"
    ip_rules       = [trimspace(data.http.my_ip.body)] # Use the IP address obtained from the HTTP data source
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "devopssa_blob" {
  name                = "${azurerm_storage_account.devopssa.name}-blob-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "${azurerm_storage_account.devopssa.name}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.devopssa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "qa-myaces" {
  name                  = "qa-myaces"
  container_access_type = "private"
  storage_account_id    = azurerm_storage_account.devopssa.id

}

resource "azurerm_storage_container" "aces" {
  name                  = "qa-aces"
  container_access_type = "private"
  storage_account_id    = azurerm_storage_account.devopssa.id
}


resource "azurerm_role_assignment" "blob_data_contributor_initial_user_admin" {
  principal_id         = "eac1c79d-59e6-44b2-80b1-12e829f54017"
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.devopssa.id
}