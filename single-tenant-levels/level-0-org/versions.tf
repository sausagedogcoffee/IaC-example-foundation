terraform {
  required_version = "<= 1.5.7"

  cloud {
    organization = "companyname"
    workspaces {
      name = "azure-level-0" #azure-$(env)-level-0
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.54.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.37.2"
    }
  }

}

# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
  skip_provider_registration = true #Otherwise it registers all the available resources in the subscription.
}

provider "azuread" {
}


