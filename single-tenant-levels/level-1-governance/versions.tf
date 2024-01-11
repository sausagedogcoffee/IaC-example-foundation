terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.54.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.37.2"
    }
  }
  cloud {
    organization = "companyname"

    workspaces {
      name = "azure-level-1" #azure-$(env)-level-1
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  #subscription_id            = var.launchpad_subscription_id # remove me when committing to source
  #tenant_id                  = var.tenant_id                 # remove me when committing to source
  #client_id                  = var.client_id                 # remove me when committing to source
  #client_secret              = var.client_secret             # remove me when committing to source
  #alias = ""
}

provider "azuread" {
  #tenant_id     = var.tenant_id     # remove me when committing to source
  #client_id     = var.client_id     # remove me when committing to source
  #client_secret = var.client_secret # remove me when committing to source
  #alias = ""
}
