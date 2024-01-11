#After mg-companyname
management_groups_tier2 = [
  # Tier 2 MG's
  {
    name                          = "mg-landingzones",
    management_group_display_name = "Landing Zones"
    parent_management_group_name  = "mg-companyname"
  },
  {
    name                          = "mg-platform",
    management_group_display_name = "Platform"
    parent_management_group_name  = "mg-companyname"
  },
  {
    name                          = "mg-decommission",
    management_group_display_name = "Decommission"
    parent_management_group_name  = "mg-companyname"
  },
]

#tier 3 mg's
management_groups = [
  #Landing Zones
  {
    name                          = "mg-production",
    management_group_display_name = "Production"
    parent_management_group_name  = "mg-landingzones"
  },
  {
    name                          = "mg-sandpit",
    management_group_display_name = "Sandpit"
    parent_management_group_name  = "mg-landingzones"
  },
  {
    name                          = "mg-nonproduction",
    management_group_display_name = "Non Production"
    parent_management_group_name  = "mg-landingzones"
  },

  #Platform MG
  {
    name                          = "mg-sharedservices",
    management_group_display_name = "Shared Services"
    parent_management_group_name  = "mg-platform"
  },
  {
    name                          = "mg-connectivity",
    management_group_display_name = "Connectivity"
    parent_management_group_name  = "mg-platform"
  },
  {
    name                          = "mg-management",
    management_group_display_name = "Management"
    parent_management_group_name  = "mg-platform"
  },
]


# AAD groups are used here to control the permissions given to the deployment princpals (SPNs)
aad_groups = [
  {
    name               = "AZ-Role-SVC-DPLevel0"
    description        = "Group for assigning Level 0 deployment agent permissions."
    assignable_to_role = true
    owners             = [""]
  },
  {
    name               = "AZ-Role-SVC-DPLevel1"
    description        = "Group for assigning Level 1 deployment agent permissions."
    assignable_to_role = true
    owners             = [""]
  },
  {
    name               = "AZ-Role-SVC-DPLevel2"    
    description        = "Group for assigning Level 2 deployment agent permissions."
    assignable_to_role = true
    owners             = [""]
  },
  {
    name               = "AZ-Role-SVC-DPLevel3"    
    description        = "Group for assigning Level 3 deployment agent permissions."
    assignable_to_role = true
    owners             = [""]
  }
  ,
  {
    name               = "AZ-Role-SVC-DPLevel3CoreLZ"    
    description        = "Group for assigning Level 3 Core deployment agent permissions."
    assignable_to_role = true
    owners             = [""]
  }
]
