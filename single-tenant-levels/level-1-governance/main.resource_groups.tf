# NetworkWatcher resource group needs to exist in every single subscription
module "common" {
  source  = "app.terraform.io/companyname/azure_common/azurerm"
  version = ">= 0.4.0"
}

locals {  
  # Policy: All tags applied to a resource group will be inherited by the resources in the resource groups
  tags = merge(var.tags)
}


resource "azurerm_resource_group" "resource_groups_sharedservices" {
  for_each = { for index, value in toset(var.resource_groups["shared-services"]) : value.name => value }
  name     = each.value.name
  location = try(each.value.location, var.primary_location)
  tags = merge({
    # "TerraformModifiedAt"    = "${timestamp()}"
    "CreatedBy"              = ""
    "CreatedDate"            = ""
    "Platform"               = ""
    "Owner"                  = ""
    "Environment"            = ""
    "DataClassification"     = ""
    "SecurityClassification" = ""
    "Criticality"            = ""
    "CostCenter"             = ""
    }, try(each.value.tags, {})
  )
  provider = azurerm.shared-services
  depends_on = [
    azurerm_subscription.subscriptions
  ]
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "azurerm_resource_group" "resource_groups_connectivity" {
  for_each = { for index, value in toset(var.resource_groups["connectivity"]) : value.name => value }
  name     = each.value.name
  location = try(each.value.location, var.primary_location)
  tags = merge({
    # "TerraformModifiedAt"    = "${timestamp()}"
    "CreatedBy"              = ""
    "CreatedDate"            = ""
    "Platform"               = ""
    "Owner"                  = ""
    "Environment"            = ""
    "DataClassification"     = ""
    "SecurityClassification" = ""
    "Criticality"            = ""
    "CostCenter"             = ""
    }, try(each.value.tags, {})
  )
  provider = azurerm.connectivity
  depends_on = [
    azurerm_subscription.subscriptions
  ]
  lifecycle {
    ignore_changes = [
      tags,
    ]

  }

}

