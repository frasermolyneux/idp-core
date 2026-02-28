resource "azurerm_user_assigned_identity" "idp_web" {
  name                = format("uami-idp-web-%s-%s", var.environment, var.location)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}

resource "azurerm_user_assigned_identity" "idp_agents" {
  name                = format("uami-idp-agents-%s-%s", var.environment, var.location)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}
