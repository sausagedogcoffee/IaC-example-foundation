
variable "management_groups_tier2" {
  type = list(object({
    name                          = string
    management_group_display_name = string
    parent_management_group_name  = string
  }))
  description = "(Required) Management groups to be deployed for level0. Parent is mg-companyname"
}

variable "management_groups" {
  type = list(object({
    name                          = string
    management_group_display_name = string
    #subscription_ids              = list(string)
    parent_management_group_name = string
  }))
  description = "(Required) Management groups to be deployed for level0."
}

variable "management_group_root" {
  description = "(Required) Root management group to be created."
  default = {
    name = "mg-companyname"
    # "(Optional) The name or UUID for this Management Group, which needs to be unique across your tenant. A new UUID will be generated if not provided. Changing this forces a new resource to be created."
    management_group_display_name = "companyname"
    # "(Optional) A friendly name for this Management Group. If not specified, this will be the same as the [management_group_name]."
  }
  type = map(any)
}

variable "aad_groups" {
  type = list(object({
    group_type         = string
    aad_group_type     = string
    platform_type      = string
    information        = string
    right              = string
    description        = string
    assignable_to_role = bool
    owners             = list(string)
  }))
  description = "(Optional) SPN aad groups for creation."
  default     = []
}
