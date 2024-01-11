
# ---------  LEVEL 1 SPN ------
# Create level 1 service principal application
# https://learn.microsoft.com/en-us/graph/permissions-reference
resource "azuread_application" "level_1_service_principal_app" {
  display_name = "spn-azure-level-1"
  description  = "This SPN is created by terraform for use in level 1 pipeline actions. It is created by the Level 0 SPN."

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61" # Directory.Read.All
      type = "Role"
    }
  }
}

# Create level 1 service principal
resource "azuread_service_principal" "level_1_service_principal" {
  application_id               = azuread_application.level_1_service_principal_app.application_id
  app_role_assignment_required = true
}

# ---------  LEVEL 2 SPN ------

resource "azuread_application" "level_2_service_principal_app" {
  display_name = "spn-azure-level-2"

  # Graph API permissions for the spn.
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "62a82d76-70ea-41e2-9197-370581804d09" #Group.ReadWrite.All
      type = "Role"
    }
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61" # Directory.Read.All
      type = "Role"
    }

    resource_access {
      id   = "19dbc75e-c2e2-444c-a770-ec69d8559fc7" #Directory.ReadWrite.All
      type = "Role"
    }
    resource_access {
      id   = "dbaae8cf-10b5-4b86-a4a1-f871c94c6695" #GroupMember.ReadWrite.All
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "level_2_service_principal" {
  application_id               = azuread_application.level_2_service_principal_app.application_id
  app_role_assignment_required = true
}

# ---------  LEVEL 3 SPN ------
# Requires Group.ReadWrite.All to create groups and manage membership https://learn.microsoft.com/en-us/graph/permissions-reference#delegated-permissions-39
# Requires RoleManagement.ReadWrite.Directory as groups being created will have the flag `assignable_to_role` enabled
resource "azuread_application" "level_3_service_principal_app" {
  display_name = "spn-azure-level-3"
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    # Group.ReadWrite.All to create Custom Landing Zone Groups 
    resource_access {
      id   = "62a82d76-70ea-41e2-9197-370581804d09" #Group.ReadWrite.All
      type = "Role"
    }
    resource_access {
      id   = "9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8" #RoleManagement.ReadWrite.Directory
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "level_3_service_principal" {
  application_id               = azuread_application.level_3_service_principal_app.application_id
  app_role_assignment_required = true
}


# Add SPN's to group membership
# Add Level 1 Service Principal to the Level 1 AAD Group
resource "azuread_group_member" "l1_membership" {
  group_object_id  = local.aad_groups["AA-AZR-Role-SVC-DPLevel1"].object_id
  member_object_id = azuread_service_principal.level_1_service_principal.object_id
  depends_on = [
    azuread_service_principal.level_1_service_principal,
    module.aad_groups
  ]
}

# Add Level 2 Service Principal to the Level 2 AAD Group
resource "azuread_group_member" "l2_membership" {
  group_object_id  = local.aad_groups["AA-AZR-Role-SVC-DPLevel2"].object_id
  member_object_id = azuread_service_principal.level_2_service_principal.object_id
  depends_on = [
    azuread_service_principal.level_2_service_principal,
    module.aad_groups
  ]
}

# Add Level 3 Service Principal to the Level 3 AAD Group
resource "azuread_group_member" "l3_membership" {
  group_object_id  = local.aad_groups["AA-AZR-Role-SVC-DPLevel3"].object_id
  member_object_id = azuread_service_principal.level_3_service_principal.object_id
  depends_on = [
    azuread_service_principal.level_3_service_principal,
    module.aad_groups
  ]
}
