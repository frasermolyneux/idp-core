resource "azurerm_search_service" "idp" {
  name                = format("srch-idp-core-%s-%s", var.environment, var.location)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "free"
}
