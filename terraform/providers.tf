terraform {
  required_version = ">= 1.14.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.61.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~> 2.4.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  storage_use_azuread = true
}

provider "azuread" {}

provider "azapi" {}
