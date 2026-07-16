
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = data.azurerm_subscription.current.tags
}

resource "azurerm_storage_account" "devopssa" {
  name                            = local.storage_account_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS" # For state file disaster scenario
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
     ip_rules = [
      "137.132.202.32"
    ]
  }

  
  tags = data.azurerm_subscription.current.tags
}

resource "azurerm_private_endpoint" "devopssa_blob" {
  name                = local.private_endpoint_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.devopssa.name}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.devopssa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = data.azurerm_subscription.current.tags
}

resource "azurerm_storage_container" "devopsbootstrap_container" {
  name                  = "devopsbootstrap"
  container_access_type = "private"
  storage_account_id    = azurerm_storage_account.devopssa.id
}

resource "azurerm_storage_container" "prd_tools_container" {
  name                  = "prdtools"
  container_access_type = "private"
  storage_account_id    = azurerm_storage_account.devopssa.id
}

resource "azurerm_storage_container" "stg_container" {
  name                  = "stg"
  container_access_type = "private"
  storage_account_id    = azurerm_storage_account.devopssa.id

}

resource "azurerm_storage_container" "qa_container" {
  name                  = "qat"
  container_access_type = "private"
  storage_account_id    = azurerm_storage_account.devopssa.id
}


resource "azurerm_role_assignment" "blob_data_contributor_initial_user_admin" {
  principal_id         = "209a972e-25ff-44c7-b631-261a594409f8"
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.devopssa.id
}