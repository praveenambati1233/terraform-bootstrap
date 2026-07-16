
data "azapi_client_config" "current" {}


provider "azurerm" {
  features {

    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id     = data.azapi_client_config.current.subscription_id
  storage_use_azuread = true


}

terraform {

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.8"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.60"
    }
  }
  backend "azurerm" {
  resource_group_name  = "rg-ccpt-prd-devops-01"
  storage_account_name = "stccptprdintrtfs"
  container_name       = "devopsbootstrap"
  key                  = "terraform.tfstate"
  use_azuread_auth = true
  }

}


provider "azuread" {
  # authentication:
  # - For local dev: az login (CLI) and use default credentials
  # - For automation: configure client_id/client_secret/tenant_id or use managed identity



}