
output "root_management_group" {
  value = azurerm_management_group.mg_root.id
}

# Merge together the outputs of azurerm_management_group resource
output "management_groups" {
  value = merge(
    azurerm_management_group.management_groups,
    azurerm_management_group.management_groups_tier2
  )
  sensitive   = false
  description = "Level0 management groups."
}

output "groups" {
  value       = module.aad_groups
  sensitive   = false
  description = "Level0 management groups."
}
