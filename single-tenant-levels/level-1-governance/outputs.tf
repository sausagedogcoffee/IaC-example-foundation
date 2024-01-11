# output "management_groups" {

#   value       = azurerm_management_group.management_groups
#   sensitive   = false
#   description = "Level-1 management groups."
# }


output "subscriptions" {
  value       = azurerm_subscription.subscriptions
  sensitive   = false
  description = "Level-1 subscriptions."
}

output "resource_groups" {
  value = merge(
    azurerm_resource_group.resource_groups_connectivity,
    azurerm_resource_group.resource_groups_sharedservices
  )
  description = "Resource groups created"

}
