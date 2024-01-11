# Declare root mg seperate to prevent cycle dependancy.
resource "azurerm_management_group" "mg_root" {
  name         = var.management_group_root.name
  display_name = var.management_group_root.management_group_display_name
}

resource "azurerm_management_group" "management_groups_tier2" {
  for_each                   = { for index, value in var.management_groups_tier2 : value.name => value }
  name                       = each.value.name
  display_name               = each.value.management_group_display_name
  parent_management_group_id = azurerm_management_group.mg_root.id
  depends_on = [
    azurerm_management_group.mg_root
  ]
}

resource "azurerm_management_group" "management_groups" {
  for_each                   = { for index, value in var.management_groups : value.name => value }
  name                       = each.value.name
  display_name               = each.value.management_group_display_name
  parent_management_group_id = azurerm_management_group.management_groups_tier2[each.value.parent_management_group_name].id
  depends_on = [
    azurerm_management_group.management_groups_tier2
  ]
}
