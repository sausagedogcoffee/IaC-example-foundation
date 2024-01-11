
# Create AAD groups and assign roles for the SPNs. 
# The groups are created at this level to avoid giving SPN's higher permissions than required.
resource "azuread_group" "aad_groups" {
  for_each     = { for index, value in var.aad_groups : value.name => value }
  display_name            = each.value.name
  mail_enabled            = false  
  security_enabled        = true 
  assignable_to_role      = true
  prevent_duplicate_names = true  
  visibility = "Public" 
}


# Assign permissions to the groups.
resource "azuread_directory_role" "cloud_application_administrator_add_groups" {
  display_name = "Cloud Application Administrator" #or any other directory role
}

# Assign cloud app admin role to allow the lower levels to create SPNs.
resource "azuread_directory_role_assignment" "aad_group_cloudapp_admin_assignment" {
  for_each            = { for index, group in azuread_group.aad_groups : index => group }
  role_id             = azuread_directory_role.cloud_application_administrator.template_id
  principal_object_id = each.value.object_id
  depends_on          = [azuread_group.aad_groups]
}

locals {
  # Create a map from the aad_groups so that we can index by display_name
  aad_groups = { for group in azuread_group.aad_groups : group.display_name => group }
}

resource "azuread_directory_role" "cloud_application_administrator" {
  display_name = "Cloud Application Administrator" #or any other directory role
}


# Owner access on mg-platform
resource "azurerm_role_assignment" "aad_group_rbac_level_1" {
  scope                = azurerm_management_group.management_groups_tier2["mg-platform"].id
  principal_id         = local.aad_groups["AA-AZR-Role-SVC-DPLevel1"].object_id
  role_definition_name = "Owner" #Id apparently doesn't work.  
  depends_on           = [azuread_group.aad_groups]
}


# ---- LEVEL 2 ----- 
# Reader access for platform MG, for service connection setup.
resource "azurerm_role_assignment" "aad_group_rbac_level_2_reader" {
  scope                = azurerm_management_group.management_groups_tier2["mg-platform"].id
  principal_id         = local.aad_groups["AA-AZR-Role-SVC-DPLevel2"].object_id
  role_definition_name = "Reader" #Id apparently doesn't work.  
  depends_on           = [azuread_group.aad_groups]
}
resource "azurerm_role_assignment" "aad_group_rbac_level_2_owner" {
  for_each             = toset(["mg-sharedservices", "mg-connectivity", "mg-management"])
  scope                = azurerm_management_group.management_groups[each.key].id
  principal_id         = local.aad_groups["AA-AZR-Role-SVC-DPLevel2"].object_id
  role_definition_name = "Owner" #Id apparently doesn't work.  
  depends_on           = [azuread_group.aad_groups]
}

# ---- LEVEL 3 ----- 

# owner access for landing zones MG, for subscription creation.
# to replace when possible with subscription creator
resource "azurerm_role_assignment" "lvl3_assignment_landingzone_mg" {
  scope                = azurerm_management_group.management_groups_tier2["mg-landingzones"].id
  principal_id         = local.aad_groups["AA-AZR-Role-SVC-DPLevel3"].object_id
  role_definition_name = "Owner" #Id apparently doesn't work.  
  depends_on           = [azuread_group.aad_groups]
}

# To Allow vnet connections to the hub. TODO: Check a lower RBAC can be used.
resource "azurerm_role_assignment" "lvl3_assignment_connectivity_mg" {
  scope                = azurerm_management_group.management_groups["mg-connectivity"].id
  principal_id         = local.aad_groups["AA-AZR-Role-SVC-DPLevel3"].object_id
  role_definition_name = "Contributor" #Id apparently doesn't work.  
  depends_on           = [azuread_group.aad_groups]
}


resource "azuread_directory_role" "group_admin" {
  display_name = "Groups Administrator"
}

resource "azuread_directory_role_assignment" "lv1_lv2_group_admin_role_assignment" {
  for_each            = toset(["AA-AZR-Role-SVC-DPLevel1", "AA-AZR-Role-SVC-DPLevel2", "AA-AZR-Role-SVC-DPLevel3"])
  role_id             = azuread_directory_role.group_admin.template_id
  principal_object_id = local.aad_groups[each.key].object_id
  depends_on          = [azuread_group.aad_groups]
}


# Azure RBAC permissions in Azure Policy:  https://learn.microsoft.com/en-us/azure/governance/policy/overview#azure-rbac-permissions-in-azure-policy

# Many built-in roles grant permission to Azure Policy resources. The Resource Policy Contributor role includes most Azure Policy operations. Owner has full rights. Both Contributor and Reader have access to all read Azure Policy operations.
# Contributor may trigger resource remediation, but can't create or update definitions and assignments.
# User Access Administrator is necessary to grant the managed identity on deployIfNotExists or modify assignments necessary permissions.

# Based on this we need minimum two permission, Resource Policy Contributor and User Access Admin
resource "azurerm_role_assignment" "service_principal_policy_contributor" {
  for_each             = toset(["AA-AZR-Role-SVC-DPLevel1", "AA-AZR-Role-SVC-DPLevel2"])
  scope                = azurerm_management_group.mg_root.id
  principal_id         = local.aad_groups[each.key].object_id
  role_definition_name = "Resource Policy Contributor"
  depends_on = [
    azuread_group.aad_groups,
    azurerm_management_group.mg_root
  ]
}
resource "azurerm_role_assignment" "service_principal_policy_access_admin" {
  for_each             = toset(["AA-AZR-Role-SVC-DPLevel1", "AA-AZR-Role-SVC-DPLevel2"])
  scope                = azurerm_management_group.mg_root.id
  principal_id         = local.aad_groups[each.key].object_id
  role_definition_name = "User Access Administrator"
  depends_on = [
    azuread_group.aad_groups,
    azurerm_management_group.mg_root
  ]
}
