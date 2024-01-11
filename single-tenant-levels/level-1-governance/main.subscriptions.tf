# todo: use the modules!

data "azurerm_billing_enrollment_account_scope" "subscription_billing_scope" {
  billing_account_name    = var.billing_account_name
  enrollment_account_name = var.enrollment_account_name
}

resource "azurerm_subscription" "subscriptions" {
  for_each = {
    for index, subscription in var.platform_subscriptions : subscription.alias => subscription
  }
  subscription_name = each.value.subscription_name
  #alias             = try(each.value.alias, null) # DO NOT USE THE ALIAS, it is for terraform reference only.
  billing_scope_id = data.azurerm_billing_enrollment_account_scope.subscription_billing_scope.id
  workload         = try(var.subscription_workload, null)
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
  }, each.value.tags)
}


resource "azurerm_management_group_subscription_association" "sub_shared_services" {
  management_group_id = data.terraform_remote_state.level0.outputs.management_groups["mg-sharedservices"].id
  subscription_id     = "/subscriptions/${azurerm_subscription.subscriptions["sharedservicesprod01"].subscription_id}" #worksround for the /subscriptions/ prefix missing?
  #    subscription_id     = resource.azurerm_subscription.subscriptions["Shared-Services"].subscription_id     # this gets parsed without the /subscriptions/ prefix for some reason
  depends_on = [
    azurerm_subscription.subscriptions
  ]
}

resource "azurerm_management_group_subscription_association" "sub_connectivity01" {
  management_group_id = data.terraform_remote_state.level0.outputs.management_groups["mg-connectivity"].id
  subscription_id     = "/subscriptions/${azurerm_subscription.subscriptions["connectivity01"].subscription_id}"
  depends_on = [
    azurerm_subscription.subscriptions
  ]
}

resource "azurerm_management_group_subscription_association" "management" {
  management_group_id = data.terraform_remote_state.level0.outputs.management_groups["mg-management"].id
  subscription_id     = "/subscriptions/${azurerm_subscription.subscriptions["management01"].subscription_id}"
  depends_on = [
    azurerm_subscription.subscriptions
  ]
}

##########################################################
## Management subscription resource provider registrations
provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id            = azurerm_subscription.subscriptions["management01"].subscription_id
  alias                      = "management"
}

# The resource provider registrations for management
resource "azurerm_resource_provider_registration" "management_registrations" {
  for_each = toset([
    "Microsoft.OperationalInsights",  # Azure Monitor (LAW)
    "Microsoft.AlertsManagement",     # Azure Monitor 
    "Microsoft.OperationsManagement", # Azure Monitor
    "Microsoft.Storage",              # Storage 
    "Microsoft.EventGrid",            # Event Grid
    "Microsoft.EventHub",             # Event Hub
    "Microsoft.Security"              # For cloud defender
  ])
  name     = each.value
  provider = azurerm.management
  depends_on = [
    azurerm_subscription.subscriptions
  ]
}
##########################################################

#These providers are used for the subscription provider registration below.
provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id            = azurerm_subscription.subscriptions["sharedservicesprod01"].subscription_id
  alias                      = "shared-services"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id            = azurerm_subscription.subscriptions["connectivity01"].subscription_id
  alias                      = "connectivity"
}

# Sigh, this provider registration is a real work around. Bleh.
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
resource "azurerm_resource_provider_registration" "resource_provider_registration_shared_services" {
  for_each = toset(var.resource_provider_registrations)
  name     = each.value
  provider = azurerm.shared-services
  depends_on = [
    azurerm_subscription.subscriptions
  ]
}

resource "azurerm_resource_provider_registration" "resource_provider_registration_connectivity" {
  for_each = toset(var.resource_provider_registrations)
  name     = each.value
  provider = azurerm.connectivity
  depends_on = [
    azurerm_subscription.subscriptions
  ]
}


# resource "azurerm_management_group_subscription_association" "sub_identity" {
#   management_group_id = data.terraform_remote_state.level0.outputs.management_groups["mg-sharedservices"].id
#   subscription_id     = data.azurerm_subscription.identity.id
#   depends_on = [
#     azurerm_subscription.subscriptions
#   ]
# }
