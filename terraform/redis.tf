resource "azurerm_redis_cache" "idp" {
  name                = format("redis-idp-core-%s-%s", var.environment, var.location)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  minimum_tls_version = "1.2"
  redis_configuration {}
}
